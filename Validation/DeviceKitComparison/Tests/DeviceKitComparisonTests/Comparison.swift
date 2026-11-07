import Foundation

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

  static func reason(
    field: String, original: String, replacement: String,
    simulator: Bool, originalReal: Snapshot, excludedAndUnknown: Bool, addedDuo: Bool
  ) -> String? {
    if excludedAndUnknown { return "outside-ios18-catalog" }
    if addedDuo { return "duo-absent-in-devicekit-5.9.0" }
    let name = originalReal.fields["description"] ?? ""
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
    if simulator, field == "isSimulator", original == "false", replacement == "true",
       originalReal.fields["kind"] == "unknown" {
      return "unknown-simulator-detection"
    }
    return nil
  }
}

struct ComparisonReport: Codable {
  var upstreamVersion = "5.9.0"
  var upstreamRevision = "19528aa07e1426626ea9fb2c4a161edf43c4f9e8"
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
    originalReal: Snapshot, excludedAndUnknown: Bool = false, addedDuo: Bool = false
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
          originalReal: originalReal, excludedAndUnknown: excludedAndUnknown, addedDuo: addedDuo)))
    }
  }

  var markdown: String {
    let reasons = Dictionary(grouping: differences, by: { $0.reason ?? "UNEXPECTED" })
    var lines = [
      "# DeviceKit 5.9.0 versus local SwiftDeviceKit",
      "",
      "Both original binaries execute in the same iOS Simulator test process.",
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
      "", "## Interpretation", "",
      "- Matching fields establish compatibility with DeviceKit, not independent hardware truth.",
      "- Excluded models must resolve to exactly the replacement's unknown-device behavior.",
      "- Duo has no reference model in 5.9.0; its differences are reported, not independently validated here.",
      "- M5 Pencil compatibility excludes second generation.",
      "- Simulator cameras intentionally forward the model's metadata; 5.9.0 returns no cameras.",
      "- Unknown simulator detection intentionally returns true in the replacement.",
      "- Group membership changes are reported; common-model order is compared without filtering other differences.",
      "- New-only APIs (screens, isFoldable), battery, storage, thermal state and physical hardware are outside this differential test.",
      "- Minimum deployment target is iOS 18; this report covers only the runtime named above.",
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
