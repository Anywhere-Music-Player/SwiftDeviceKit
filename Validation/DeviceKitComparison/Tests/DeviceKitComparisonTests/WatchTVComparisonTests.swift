#if os(watchOS) || os(tvOS)
import Foundation
import XCTest
@preconcurrency import DeviceKit
@testable import SwiftDeviceKitCore
import SwiftDeviceKitSystem

@MainActor
final class WatchTVComparisonTests: XCTestCase {
  private typealias Original = DeviceKit.Device
  private typealias Local = SwiftDeviceKitCore.Device

  func testPlatformAgainstDeviceKit() throws {
    #if os(watchOS)
      let platform = "watchOS", family = Local.Family.watch
      let oldModels = Original.allWatches, models = Local.allWatches
    #else
      let platform = "tvOS", family = Local.Family.tv
      let oldModels = Original.allTVs, models = Local.allTVs
    #endif
    let url = try XCTUnwrap(Bundle.module.url(forResource: "ReferenceIdentifiers-" + platform, withExtension: "json"))
    let corpus = try JSONDecoder().decode(Corpus.self, from: Data(contentsOf: url))
    XCTAssertEqual(corpus.revision, "fab82bd988405367c915143e293479f481e93ba0")
    var report = ComparisonReport()
    report.upstreamSourceSHA256 = corpus.sourceSHA256
    report.simulatorModel = try XCTUnwrap(ProcessInfo.processInfo.environment["SIMULATOR_MODEL_IDENTIFIER"])
    report.osVersion = ProcessInfo.processInfo.operatingSystemVersionString
    let localIDs = DeviceCatalog.all.filter { $0.family == family }.flatMap(\.identifiers)
    let referenceIDs = corpus.models.flatMap(\.identifiers)
    report.identifiers = Set(referenceIDs).union(localIDs).sorted()
    XCTAssertEqual(Set(corpus.models.map { Original.mapToDevice(identifier: $0.identifiers[0]).description }),
                   Set(oldModels.map(\.description)))
    XCTAssertEqual(Set(localIDs.map { Local.mapToDevice(identifier: $0).description }), Set(models.map(\.description)))
    #if os(watchOS)
      XCTAssertEqual(models.count, 22)
      XCTAssertEqual(localIDs.count, 40)
      let supported = oldModels.filter { !isExcluded($0.description) }
      XCTAssertEqual(supported.map { $0 == .appleWatchUltra2 ? "Apple Watch Ultra 2" : $0.description },
                     models.map(\.description))
    #else
      XCTAssertEqual(models.count, 5)
      XCTAssertEqual(oldModels.map(\.description), models.filter { $0 != .appleTV4K4 }.map(\.description))
    #endif
    var fields: Set<String> = []
    func check<T: Equatable>(_ id: String, _ variant: String, _ field: String, _ old: T, _ new: T,
                             correction: String? = nil) {
      fields.insert(field)
      report.comparisons += 1
      if old != new {
        report.differences.append(.init(identifier: id, variant: variant, field: field,
          original: String(describing: old), replacement: String(describing: new), reason: correction))
      }
    }
    for id in report.identifiers + ["future-device"] {
      let old = Original.mapToDevice(identifier: id)
      let local = Local.mapToDevice(identifier: id)
      #if os(watchOS)
        let excluded = isExcluded(old.description)
        if excluded { XCTAssertEqual(local, .unknown(id)) }
        // Apple's 40 mm SE 3 profile lists Watch7,13/15 and the 44 mm profile lists Watch7,14/16.
        let swapped = ["Watch7,14": Local.appleWatchSE3_44mm, "Watch7,15": .appleWatchSE3_40mm][id]
        if let swapped { XCTAssertEqual(local, swapped) }
        let reason = excluded ? "outside-watchOS-11" : (swapped == nil ? nil : "SE-3-size")
      #else
        let reason = id == "AppleTV18,1" ? "fourth-generation-Apple-TV" : nil
        if reason != nil {
          XCTAssertEqual(old, .unknown(id))
          XCTAssertEqual(local, .appleTV4K4)
        }
      #endif
      for wrapped in [false, true] {
        let variant = wrapped ? "simulator" : "hardware"
        let a: Original = wrapped ? .simulator(old) : old
        let b: Local = wrapped ? .simulator(local) : local
        for (field, originalName, localName) in [("name", a.description, b.description),
                                                  ("safeName", a.safeDescription, b.safeDescription)] {
          var nameReason = reason
          #if os(watchOS)
            let oldUltra2 = wrapped ? "Simulator (Apple Watch Ultra2)" : "Apple Watch Ultra2"
            let newUltra2 = wrapped ? "Simulator (Apple Watch Ultra 2)" : "Apple Watch Ultra 2"
            if id == "Watch7,5", originalName == oldUltra2, localName == newUltra2 {
              nameReason = "official-Ultra-2-name"
            }
          #endif
          check(id, variant, field, originalName, localName, correction: nameReason)
        }
        check(id, variant, "CPU", a.cpu.description, b.cpu.description, correction: reason)
        check(id, variant, "isSimulator", a.isSimulator, b.isSimulator)
        #if os(watchOS)
          check(id, variant, "Force Touch", a.hasForceTouchSupport, b.hasForceTouchSupport, correction: reason)
          let pixels = panelPixels(for: local)
          if local.family == .watch {
            let panel = try XCTUnwrap(pixels)
            XCTAssertEqual(b.screen(.main)?.resolution?.width, panel.0)
            XCTAssertEqual(b.screen(.main)?.resolution?.height, panel.1)
            XCTAssertEqual(b.screenRatio.width, Double(panel.0))
            XCTAssertEqual(b.screenRatio.height, Double(panel.1))
            XCTAssertEqual(b.ppi, 326)
            XCTAssertEqual(b.diagonal, (hypot(Double(panel.0), Double(panel.1)) / 326 * 100).rounded() / 100)
          }
          let geometryReason = reason ?? (pixels == nil ? nil : "Apple-panel-geometry")
          check(id, variant, "diagonal", a.diagonal, b.diagonal, correction: geometryReason)
          check(id, variant, "ratio.width", a.screenRatio.width, b.screenRatio.width, correction: geometryReason)
          check(id, variant, "ratio.height", a.screenRatio.height, b.screenRatio.height, correction: geometryReason)
          check(id, variant, "PPI", a.ppi, b.ppi, correction: geometryReason)
        #else
          check(id, variant, "PPI", a.ppi, b.ppi)
          check(id, variant, "ratio.width", a.screenRatio.width, b.screenRatio.width)
          check(id, variant, "ratio.height", a.screenRatio.height, b.screenRatio.height)
        #endif
      }
    }
    let current = Local.current, original = Original.current
    XCTAssertEqual(current, .simulator(.mapToDevice(identifier: report.simulatorModel)))
    XCTAssertEqual(current.name, original.name)
    XCTAssertEqual(current.systemName, original.systemName)
    XCTAssertEqual(current.systemVersion, original.systemVersion)
    XCTAssertEqual(current.localizedModel, original.localizedModel)
    XCTAssertEqual(current.model, original.model)
    XCTAssertEqual(current.screenBrightness, original.screenBrightness)
    XCTAssertEqual(current.isGuidedAccessSessionActive, original.isGuidedAccessSessionActive)
    report.coverage = ["upstream models": oldModels.count, "replacement models": models.count,
                       "upstream identifiers": referenceIDs.count, "replacement identifiers": localIDs.count]
    report.comparedFields = fields.sorted()
    try attach(report)
    XCTAssertTrue(report.unexpected.isEmpty, "\(report.unexpected)")
  }

  #if os(watchOS)
  private func isExcluded(_ name: String) -> Bool {
    name.hasPrefix("Apple Watch (1st generation)") || name.hasPrefix("Apple Watch SE ") && !name.contains("(")
      || (1...5).contains { name.hasPrefix("Apple Watch Series \($0) ") }
  }

  // Physical pixel dimensions from Apple's Watch technical specifications and CoreSimulator profiles.
  private func panelPixels(for model: Local) -> (Int, Int)? {
    switch model {
    case .appleWatchSeries6_40mm, .appleWatchSE2_40mm, .appleWatchSE3_40mm: (324, 394)
    case .appleWatchSeries6_44mm, .appleWatchSE2_44mm, .appleWatchSE3_44mm: (368, 448)
    case .appleWatchSeries7_41mm, .appleWatchSeries8_41mm, .appleWatchSeries9_41mm: (352, 430)
    case .appleWatchSeries7_45mm, .appleWatchSeries8_45mm, .appleWatchSeries9_45mm: (396, 484)
    case .appleWatchSeries10_42mm, .appleWatchSeries11_42mm, .appleWatchSeries12_42mm: (374, 446)
    case .appleWatchSeries10_46mm, .appleWatchSeries11_46mm, .appleWatchSeries12_46mm: (416, 496)
    case .appleWatchUltra, .appleWatchUltra2: (410, 502)
    case .appleWatchUltra3, .appleWatchUltra4: (422, 514)
    default: nil
    }
  }
  #endif
}
#endif
