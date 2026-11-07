import Foundation
import XCTest
@preconcurrency import DeviceKit
@testable import SwiftDeviceKitCore
import SwiftDeviceKitSystem

@MainActor
final class CatalogComparisonTests: XCTestCase {
  private typealias Original = DeviceKit.Device
  private typealias Replacement = SwiftDeviceKitCore.Device

  private struct Corpus: Decodable {
    struct Model: Decodable { let caseName: String; let identifiers: [String] }
    let version: String
    let revision: String
    let sourceSHA256: String
    let models: [Model]
  }

  func testEntireCatalogAgainstOriginalDeviceKit() throws {
    let url = try XCTUnwrap(Bundle.module.url(forResource: "ReferenceIdentifiers", withExtension: "json"))
    let corpus = try JSONDecoder().decode(Corpus.self, from: Data(contentsOf: url))
    XCTAssertEqual(corpus.version, "5.9.0")
    XCTAssertEqual(corpus.revision, "19528aa07e1426626ea9fb2c4a161edf43c4f9e8")

    let originalIDs = corpus.models.flatMap(\.identifiers)
    let replacementIDs = DeviceCatalog.all.flatMap(\.identifiers)
    let allIDs = Set(originalIDs).union(replacementIDs).sorted()
    let excludedIDs = Set(corpus.models
      .filter { ExpectedDifferences.excludedCases.contains($0.caseName) }.flatMap(\.identifiers))
    let unknownIDs = ["", "not-a-device", "iPhone99,1", "iPad99,1", "iPhone11,999", "iPhone19,4 ", "iPhone19,4\n"]

    // Coverage gates are independent of property comparisons: silently skipping IDs must fail.
    XCTAssertEqual(corpus.models.count, 99)
    XCTAssertEqual(originalIDs.count, 171)
    XCTAssertEqual(Set(originalIDs).count, originalIDs.count)
    XCTAssertEqual(Set(replacementIDs).count, replacementIDs.count)
    XCTAssertEqual(excludedIDs.count, 67)
    XCTAssertEqual(Set(originalIDs).subtracting(excludedIDs).count, 104)
    XCTAssertEqual(Set(replacementIDs), Set(originalIDs).subtracting(excludedIDs).union(["iPhone19,4", "iPad19,1", "iPad19,2"]))
    XCTAssertEqual(Set(corpus.models.map(\.caseName)).intersection(ExpectedDifferences.excludedCases),
                   ExpectedDifferences.excludedCases)
    // The extracted switch must cover the executable public model lists too.
    XCTAssertEqual(Set(originalIDs.map { Original.mapToDevice(identifier: $0).description }),
                   Set((Original.allRealDevices + [.homePod]).map(\.description)))
    XCTAssertEqual(Set(replacementIDs.map { Replacement.mapToDevice(identifier: $0).description }),
                   Set(Replacement.allRealDevices.map(\.description)))

    var report = ComparisonReport()
    report.upstreamSourceSHA256 = corpus.sourceSHA256
    report.simulatorModel = ProcessInfo.processInfo.environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "missing"
    report.osVersion = ProcessInfo.processInfo.operatingSystemVersionString
    report.identifiers = allIDs
    report.comparedFields = Snapshots.read(Original.iPhoneXS).fields.keys.sorted()
    report.coverage = [
      "upstream models": corpus.models.count,
      "upstream identifiers": originalIDs.count,
      "replacement models": DeviceCatalog.all.count,
      "replacement identifiers": replacementIDs.count,
      "union hardware identifiers": allIDs.count,
      "shared supported models": corpus.models.count - ExpectedDifferences.excludedCases.count,
      "shared supported identifiers": Set(originalIDs).subtracting(excludedIDs).count,
      "excluded identifiers": excludedIDs.count,
      "new identifiers": Set(replacementIDs).subtracting(originalIDs).count,
      "unknown inputs": unknownIDs.count,
      "hardware and simulator input pairs": (allIDs.count + unknownIDs.count) * 2,
      "fields per input": report.comparedFields.count,
    ]

    for identifier in allIDs + unknownIDs {
      let original = Original.mapToDevice(identifier: identifier)
      let replacement = Replacement.mapToDevice(identifier: identifier)
      let originalReal = Snapshots.read(original)
      for simulator in [false, true] {
        let old = Snapshots.read(simulator ? .simulator(original) : original)
        let new = Snapshots.read(simulator ? .simulator(replacement) : replacement)
        let unknown = Snapshots.read(
          simulator ? Replacement.simulator(.unknown(identifier)) : .unknown(identifier))
        let excluded = excludedIDs.contains(identifier)
        if excluded { XCTAssertEqual(new, unknown, "\(identifier) must resolve to unknown") }
        let duo = identifier == "iPhone19,4"
        let mini = ["iPad19,1", "iPad19,2"].contains(identifier)
        if mini {
          XCTAssertEqual(originalReal.fields["kind"], "unknown")
          XCTAssertEqual(replacement, .iPadMiniA20Pro)
        }
        if duo {
          XCTAssertEqual(originalReal.fields["kind"], "unknown")
          XCTAssertEqual(replacement, .iPhoneDuo)
        }
        report.compare(
          identifier: identifier, variant: simulator ? "simulator" : "hardware",
          original: old, replacement: new, originalReal: originalReal,
          excludedAndUnknown: excluded && new == unknown, addedDuo: duo, addedMini: mini)
      }
    }

    // Exercise actual process environment resolution without mutating global variables.
    for architecture in ["i386", "x86_64", "arm64"] {
      let original = Original.mapToDevice(identifier: architecture)
      let replacement = Replacement.mapToDevice(identifier: architecture)
      XCTAssertEqual(replacement, .simulator(.mapToDevice(identifier: report.simulatorModel)))
      report.compare(
        identifier: architecture, variant: "architecture",
        original: Snapshots.read(original), replacement: Snapshots.read(replacement),
        originalReal: Snapshots.read(original.realDevice),
        addedDuo: report.simulatorModel == "iPhone19,4",
        addedMini: ["iPad19,1", "iPad19,2"].contains(report.simulatorModel))
    }
    XCTAssertEqual(Original.identifier, Replacement.identifier)
    XCTAssertEqual(Replacement.current, .simulator(.mapToDevice(identifier: report.simulatorModel)))
    report.compare(
      identifier: report.simulatorModel, variant: "current",
      original: Snapshots.read(Original.current), replacement: Snapshots.read(Replacement.current),
      originalReal: Snapshots.read(Original.current.realDevice),
      addedDuo: report.simulatorModel == "iPhone19,4",
      addedMini: ["iPad19,1", "iPad19,2"].contains(report.simulatorModel))
    report.coverage["architecture inputs plus current device"] = 4

    compareGroups(corpus: corpus, report: &report)
    let encoder = JSONEncoder()
    encoder.outputFormatting = [.prettyPrinted, .sortedKeys, .withoutEscapingSlashes]
    for (name, data, uti) in [
      ("catalog-comparison.json", try encoder.encode(report), "public.json"),
      ("catalog-comparison.md", Data(report.markdown.utf8), "net.daringfireball.markdown"),
    ] {
      let attachment = XCTAttachment(data: data, uniformTypeIdentifier: uti)
      attachment.name = name
      attachment.lifetime = .keepAlways
      add(attachment)
    }
    print("CATALOG_COMPARISON: \(report.comparisons) fields; \(report.differences.count) differences; \(report.unexpected.count) unexpected")
    XCTAssertTrue(report.unexpected.isEmpty,
      "\(report.unexpected.count) unexpected differences; inspect catalog-comparison.md attachment")
  }

  private func compareGroups(corpus: Corpus, report: inout ComparisonReport) {
    let oldGroups = Snapshots.originalGroups
    let newGroups = Snapshots.replacementGroups
    XCTAssertEqual(Set(oldGroups.keys), Set(newGroups.keys))
    let excludedModels = corpus.models
      .filter { ExpectedDifferences.excludedCases.contains($0.caseName) }
      .map { Original.mapToDevice(identifier: $0.identifiers[0]) }
    let excludedNames = Set(excludedModels.flatMap { [$0.description, Original.simulator($0).description] })
    let addedNames: Set<String> = [
      Replacement.iPhoneDuo.description, Replacement.simulator(.iPhoneDuo).description,
      Replacement.iPadMiniA20Pro.description, Replacement.simulator(.iPadMiniA20Pro).description,
    ]
    report.groupNames = oldGroups.keys.sorted()
    report.coverage["ordered groups"] = oldGroups.count
    for name in oldGroups.keys.sorted() {
      let old = oldGroups[name]!
      let new = newGroups[name] ?? []
      XCTAssertEqual(Set(old).count, old.count, "Duplicate in original \(name)")
      XCTAssertEqual(Set(new).count, new.count, "Duplicate in replacement \(name)")
      for member in Set(old).union(new).sorted() {
        report.comparisons += 1
        guard old.contains(member) != new.contains(member) else { continue }
        let reason: String?
        if excludedNames.contains(member), old.contains(member), !new.contains(member) {
          reason = "outside-ios18-catalog"
        } else if addedNames.contains(member), !old.contains(member), new.contains(member) {
          reason = member.contains("iPad mini")
            ? "mini-a20-pro-absent-in-devicekit-5.9.0" : "duo-absent-in-devicekit-5.9.0"
        } else {
          reason = nil
        }
        report.differences.append(Difference(
          identifier: name, variant: "group", field: "contains(\(member))",
          original: String(old.contains(member)), replacement: String(new.contains(member)), reason: reason))
      }
      let oldCommon = old.filter { !excludedNames.contains($0) }
      let newCommon = new.filter { !addedNames.contains($0) }
      report.comparisons += 1
      if oldCommon != newCommon {
        report.differences.append(Difference(
          identifier: name, variant: "group", field: "sharedModelOrder",
          original: oldCommon.joined(separator: ", "), replacement: newCommon.joined(separator: ", "),
          reason: nil))
      }
    }
  }

  func testComparatorRejectsWrongNameAndWrongSimulatorCamera() {
    let original = Snapshots.read(Original.iPhoneXS)
    var corrupted = Snapshots.read(Replacement.iPhoneXS)
    corrupted.fields["description"] = "wrong persisted name"
    var report = ComparisonReport()
    report.compare(identifier: "iPhone11,2", variant: "hardware",
                   original: original, replacement: corrupted, originalReal: original)
    XCTAssertEqual(report.unexpected.map(\.field), ["description"])

    let simulator = Snapshots.read(Original.simulator(.iPhoneXS))
    corrupted = Snapshots.read(Replacement.simulator(.iPhoneXS))
    corrupted.fields["hasUltraWideCamera"] = "true" // XS has no ultra-wide camera.
    report = ComparisonReport()
    report.compare(identifier: "iPhone11,2", variant: "simulator",
                   original: simulator, replacement: corrupted, originalReal: original)
    XCTAssertEqual(report.unexpected.map(\.field), ["hasUltraWideCamera"])
    XCTAssertFalse(report.differences.filter { $0.reason == "simulator-camera-metadata" }.isEmpty)
  }

  func testCorrectionsDoNotHideOtherCatalogRegressions() {
    for model in [Original.iPadAir11M3, .iPadPro11M5] {
      let original = Snapshots.read(model)
      let replacement = Replacement.mapToDevice(identifier: model == .iPadAir11M3 ? "iPad15,3" : "iPad17,1")
      var correct = ComparisonReport()
      correct.compare(identifier: "control", variant: "hardware", original: original,
                      replacement: Snapshots.read(replacement), originalReal: original)
      XCTAssertTrue(correct.unexpected.isEmpty)
      for field in ["screenRatio.width", "applePencilSupport", "description"] {
        var corrupted = Snapshots.read(replacement)
        corrupted.fields[field] = "invalid"
        var report = ComparisonReport()
        report.compare(identifier: "corrupted", variant: "hardware", original: original,
                       replacement: corrupted, originalReal: original)
        XCTAssertEqual(report.unexpected.map(\.field), [field])
      }
    }
  }
}
