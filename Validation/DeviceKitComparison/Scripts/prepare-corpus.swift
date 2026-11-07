import CryptoKit
import Foundation

// Extract inputs only, never expected property values or executable library code.
let arguments = CommandLine.arguments
guard arguments.count == 3 else {
  fatalError("Usage: swift prepare-corpus.swift <DeviceKit checkout> <resources directory>")
}
let sourceURL = URL(fileURLWithPath: arguments[1])
  .appending(path: "Source/Device.generated.swift")
let sourceData = try Data(contentsOf: sourceURL)
let source = String(decoding: sourceData, as: UTF8.self)
let mapper = source.components(separatedBy: "public static func mapToDevice(identifier: String) -> Device {")[1]
let platforms = [
  ("iOS", "#if os(iOS)", "#elseif os(tvOS)", 100, 172),
  ("tvOS", "#elseif os(tvOS)", "#elseif os(watchOS)", 4, 4),
  ("watchOS", "#elseif os(watchOS)", "#elseif os(visionOS)", 36, 62),
]
let cases = try NSRegularExpression(pattern: #"(?m)^\s*case (.+): return (\w+)\s*$"#)
let identifiers = try NSRegularExpression(pattern: #""([^"]+)""#)
struct Entry: Codable { let caseName: String; let identifiers: [String] }
struct Corpus: Codable {
  let version: String
  let revision: String
  let sourceSHA256: String
  let models: [Entry]
}
for (platform, start, end, modelCount, identifierCount) in platforms {
  let mapping = mapper.components(separatedBy: start)[1].components(separatedBy: end)[0]
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
  let ids = entries.flatMap(\.identifiers)
  precondition(entries.count == modelCount && ids.count == identifierCount && Set(ids).count == ids.count,
               "Upstream \(platform) coverage changed: \(entries.count) models, \(ids.count) IDs")
  let corpus = Corpus(
    version: "5.10.0", revision: "fab82bd988405367c915143e293479f481e93ba0",
    sourceSHA256: SHA256.hash(data: sourceData).map { String(format: "%02x", $0) }.joined(),
    models: entries)
  let encoder = JSONEncoder()
  encoder.outputFormatting = [.prettyPrinted, .sortedKeys, .withoutEscapingSlashes]
  let output = URL(fileURLWithPath: arguments[2])
  let file = output.appendingPathComponent(platform == "iOS" ? "ReferenceIdentifiers.json" : "ReferenceIdentifiers-\(platform).json")
  try (encoder.encode(corpus) + Data("\n".utf8)).write(to: file, options: .atomic)
}
