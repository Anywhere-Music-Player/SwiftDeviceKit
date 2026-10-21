import CryptoKit
import Foundation

// Extract inputs only, never expected property values or executable library code.
let arguments = CommandLine.arguments
guard arguments.count == 3 else {
  fatalError("Usage: swift prepare-corpus.swift <DeviceKit checkout> <output.json>")
}
let sourceURL = URL(fileURLWithPath: arguments[1])
  .appending(path: "Source/Device.generated.swift")
let sourceData = try Data(contentsOf: sourceURL)
let source = String(decoding: sourceData, as: UTF8.self)
guard let start = source.range(of: "public static func mapToDevice(identifier: String) -> Device {"),
      let end = source.range(of: "#elseif os(tvOS)", range: start.upperBound..<source.endIndex)
else { fatalError("Cannot locate the upstream iOS identifier switch") }
let mapping = String(source[start.upperBound..<end.lowerBound])
let cases = try NSRegularExpression(pattern: #"(?m)^\s*case (.+): return (\w+)\s*$"#)
let identifiers = try NSRegularExpression(pattern: #""([^"]+)""#)
struct Entry: Codable { let caseName: String; let identifiers: [String] }
struct Corpus: Codable {
  let version: String
  let revision: String
  let sourceSHA256: String
  let models: [Entry]
}
let entries = cases.matches(in: mapping, range: NSRange(mapping.startIndex..., in: mapping)).map {
  match -> Entry in
  let list = String(mapping[Range(match.range(at: 1), in: mapping)!])
  let values = identifiers.matches(in: list, range: NSRange(list.startIndex..., in: list)).map {
    String(list[Range($0.range(at: 1), in: list)!])
  }
  return Entry(
    caseName: String(mapping[Range(match.range(at: 2), in: mapping)!]),
    identifiers: values)
}
precondition(entries.count == 99, "Upstream model coverage changed")
precondition(entries.flatMap(\.identifiers).count == 171, "Upstream ID coverage changed")
precondition(Set(entries.flatMap(\.identifiers)).count == 171, "Duplicate upstream IDs")
let corpus = Corpus(
  version: "5.9.0", revision: "19528aa07e1426626ea9fb2c4a161edf43c4f9e8",
  sourceSHA256: SHA256.hash(data: sourceData).map { String(format: "%02x", $0) }.joined(),
  models: entries)
let encoder = JSONEncoder()
encoder.outputFormatting = [.prettyPrinted, .sortedKeys, .withoutEscapingSlashes]
try (encoder.encode(corpus) + Data("\n".utf8))
  .write(to: URL(fileURLWithPath: arguments[2]), options: .atomic)
print("Prepared inputs: \(entries.count) DeviceKit models, 171 identifiers.")
