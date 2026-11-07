import Foundation
import XCTest

struct Difference: Codable {
  let identifier: String
  let variant: String
  let field: String
  let original: String
  let replacement: String
  /// nil means an unexpected difference, not a successful comparison.
  let reason: String?
}

enum ExpectedDifferences {
  // Independent scope policy, not inferred from which models the new catalog happens to contain.
  static let excludedCases: Set<String> = [
    "iPhone4", "iPhone4s", "iPhone5", "iPhone5c", "iPhone5s", "iPhone6", "iPhone6Plus",
    "iPhone6s", "iPhone6sPlus", "iPhone7", "iPhone7Plus", "iPhoneSE", "iPhone8",
    "iPhone8Plus", "iPhoneX", "iPad2", "iPad3", "iPad4", "iPadAir", "iPadAir2",
    "iPad5", "iPad6", "iPadMini", "iPadMini2", "iPadMini3", "iPadMini4",
    "iPadPro9Inch", "iPadPro12Inch", "iPadPro12Inch2", "iPadPro10Inch",
    "iPodTouch5", "iPodTouch6", "iPodTouch7", "homePod",
  ]
  static let cameraFields: Set<String> = [
    "cameras", "hasCamera", "hasWideCamera", "hasTelephotoCamera", "hasUltraWideCamera",
  ]
  // Only these model/field/value corrections are allowed; keep the donor unchanged.
  static let portraitRatios: [String: (Double, Double)] = [
    "iPad Air (11-inch) (M3)": (41, 59), "iPad Air (11-inch) (M4)": (41, 59),
    "iPad Air (13-inch) (M2)": (512, 683), "iPad Air (13-inch) (M3)": (512, 683),
    "iPad Air (13-inch) (M4)": (512, 683),
    "iPad Pro (11-inch) (M4)": (417, 605), "iPad Pro (11-inch) (M5)": (417, 605),
    "iPad Pro (13-inch) (M4)": (3, 4), "iPad Pro (13-inch) (M5)": (3, 4),
  ]

  static func reason(
    field: String, original: String, replacement: String,
    simulator: Bool, originalReal: Snapshot, excludedAndUnknown: Bool,
    addedMini: Bool
  ) -> String? {
    if excludedAndUnknown { return "outside-ios18-catalog" }
    if addedMini { return "mini-a20-pro-absent-in-devicekit-5.10.0" }
    let name = originalReal.fields["description"] ?? ""
    if let (width, height) = portraitRatios[name] {
      if field == "screenRatio.width", original == String(height), replacement == String(width) {
        return "portrait-reference-orientation"
      }
      if field == "screenRatio.height", original == String(width), replacement == String(height) {
        return "portrait-reference-orientation"
      }
    }
    if ["iPad Pro (11-inch) (M5)", "iPad Pro (13-inch) (M5)"].contains(name),
       field == "applePencilSupport", original == "secondGeneration,firstGenerationUsbC,pro",
       replacement == "firstGenerationUsbC,pro" {
      return "m5-pencil-compatibility"
    }
    // Permit only the documented field/value change, not all simulator differences.
    if simulator, cameraFields.contains(field),
       original == (field == "cameras" ? "" : "false"),
       replacement == originalReal.fields[field] {
      return "simulator-camera-metadata"
    }
    return nil
  }
}

struct ComparisonReport: Codable {
  var upstreamVersion = "5.10.0"
  var upstreamRevision = "fab82bd988405367c915143e293479f481e93ba0"
  var upstreamSourceSHA256 = ""
  var simulatorModel = ""
  var osVersion = ""
  var coverage: [String: Int] = [:]
  var comparedFields: [String] = []
  var identifiers: [String] = []
  var groupNames: [String] = []
  var comparisons = 0
  var differences: [Difference] = []

  var unexpected: [Difference] { differences.filter { $0.reason == nil } }

  mutating func compare(
    identifier: String, variant: String, original: Snapshot, replacement: Snapshot,
    originalReal: Snapshot, excludedAndUnknown: Bool = false,
    addedMini: Bool = false
  ) {
    for field in Set(original.fields.keys).union(replacement.fields.keys).sorted() {
      comparisons += 1
      let old = original.fields[field] ?? "<missing field>"
      let new = replacement.fields[field] ?? "<missing field>"
      guard old != new else { continue }
      differences.append(Difference(
        identifier: identifier, variant: variant, field: field, original: old, replacement: new,
        reason: ExpectedDifferences.reason(
          field: field, original: old, replacement: new, simulator: variant != "hardware",
          originalReal: originalReal, excludedAndUnknown: excludedAndUnknown,
          addedMini: addedMini)))
    }
  }

  var markdown: String {
    let reasons = Dictionary(grouping: differences, by: { $0.reason ?? "UNEXPECTED" })
    var lines = [
      "# DeviceKit 5.10.0 versus local SwiftDeviceKit",
      "",
      "DeviceKit and SwiftDeviceKit execute in the same Simulator test process.",
      "Reference: \(upstreamRevision). Source SHA-256: \(upstreamSourceSHA256).",
      "Host model: \(simulatorModel). OS: \(osVersion).",
      "",
      "**Unexpected differences: \(unexpected.count). Field comparisons: \(comparisons).**",
      "",
      "| Coverage | Count |", "| --- | ---: |",
    ]
    for key in coverage.keys.sorted() { lines.append("| \(key) | \(coverage[key]!) |") }
    lines += ["", "| Difference category | Field differences |", "| --- | ---: |"]
    for key in reasons.keys.sorted() { lines.append("| \(key) | \(reasons[key]!.count) |") }
    lines += [
      "", "## Scope", "",
      "The report covers the named simulator and catalog. Physical hardware and live sensor accuracy require separate tests.",
      "",
      "## Unexpected differences", "",
    ]
    func table(_ rows: [Difference]) -> [String] {
      func cell(_ value: String) -> String {
        value.replacingOccurrences(of: "|", with: "\\|")
          .replacingOccurrences(of: "\n", with: "\\n").isEmpty ? "(empty)" :
          value.replacingOccurrences(of: "|", with: "\\|").replacingOccurrences(of: "\n", with: "\\n")
      }
      return [
        "| ID / group | Variant | Field | DeviceKit | SwiftDeviceKit |",
        "| --- | --- | --- | --- | --- |",
      ] + rows.map {
        "| \(cell($0.identifier)) | \($0.variant) | \($0.field) | \(cell($0.original)) | \(cell($0.replacement)) |"
      }
    }
    lines += unexpected.isEmpty ? ["None."] : table(unexpected)
    for reason in reasons.keys.sorted() where reason != "UNEXPECTED" {
      lines += ["", "## \(reason)", ""] + table(reasons[reason]!)
    }
    lines += ["", "## Compared fields", "", comparedFields.joined(separator: ", "), ""]
    return lines.joined(separator: "\n")
  }
}

struct Corpus: Decodable {
  struct Model: Decodable { let caseName: String; let identifiers: [String] }
  let version: String
  let revision: String
  let sourceSHA256: String
  let models: [Model]
}

extension XCTestCase {
  @MainActor func attach(_ report: ComparisonReport) throws {
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
  }
}
