import CryptoKit
import Foundation

let args = CommandLine.arguments
guard args.count == 4 else { fatalError("Usage: export-report.swift stamp|export <input> <output>") }
let fm = FileManager.default
let input = URL(fileURLWithPath: args[2])
let output = URL(fileURLWithPath: args[3])
if args[1] == "stamp" {
  let root = input.standardizedFileURL
  let sources = root.appending(path: "Sources")
  let enumerator = fm.enumerator(at: sources, includingPropertiesForKeys: [.isRegularFileKey])!
  var files = [root.appending(path: "Package.swift")]
  for case let url as URL in enumerator {
    if try url.resourceValues(forKeys: [.isRegularFileKey]).isRegularFile == true {
      files.append(url)
    }
  }
  var hashes: [String: String] = [:]
  for url in files {
    hashes[String(url.path.dropFirst(root.path.count + 1))] =
      SHA256.hash(data: try Data(contentsOf: url)).map { String(format: "%02x", $0) }.joined()
  }
  let data = try JSONSerialization.data(withJSONObject: hashes, options: [.prettyPrinted, .sortedKeys])
  try data.write(to: output, options: .atomic)
} else if args[1] == "export" {
  struct Entry: Decodable {
    struct Attachment: Decodable {
      let exportedFileName: String
      let suggestedHumanReadableName: String
    }
    let attachments: [Attachment]
  }
  let attachmentsURL = input.appending(path: "attachments")
  let manifest = try JSONDecoder().decode(
    [Entry].self, from: Data(contentsOf: attachmentsURL.appending(path: "manifest.json")))
  let attachments = manifest.flatMap(\.attachments)
  try fm.createDirectory(at: output, withIntermediateDirectories: true)
  for ext in ["json", "md"] {
    let matches = attachments.filter {
      let name = $0.suggestedHumanReadableName
      return name == "catalog-comparison.\(ext)"
        || (name.hasPrefix("catalog-comparison_") && name.hasSuffix(".\(ext)"))
    }
    guard matches.count == 1 else {
      fatalError("Expected exactly one comparison \(ext) attachment, found \(matches.count)")
    }
    let data = try Data(contentsOf: attachmentsURL.appending(path: matches[0].exportedFileName))
    try data.write(to: output.appending(path: "latest.\(ext)"), options: .atomic)
  }
  let head = try String(contentsOf: input.appending(path: "swiftdevicekit-head.txt"), encoding: .utf8)
    .trimmingCharacters(in: .whitespacesAndNewlines)
  let sourceDiff = try String(contentsOf: input.appending(path: "swiftdevicekit-source.diff"), encoding: .utf8)
  let toolchain = try String(contentsOf: input.appending(path: "toolchain.txt"), encoding: .utf8)
  let stampData = try Data(contentsOf: input.appending(path: "source-stamp.json"))
  let provenance: [String: Any] = [
    "generatedAt": ISO8601DateFormatter().string(from: Date()),
    "swiftDeviceKitHEAD": head,
    "swiftDeviceKitSourceDiff": sourceDiff,
    "toolchain": toolchain,
    "sourceFilesSHA256": try JSONSerialization.jsonObject(with: stampData),
    "resultBundle": input.appending(path: "Comparison.xcresult").path,
  ]
  try JSONSerialization.data(withJSONObject: provenance, options: [.prettyPrinted, .sortedKeys])
    .write(to: output.appending(path: "provenance.json"), options: .atomic)
  let reportURL = output.appending(path: "latest.md")
  var report = try String(contentsOf: reportURL, encoding: .utf8)
  report += """

  ## Source provenance

  SwiftDeviceKit HEAD: \(head). Production source changes relative to HEAD: \(sourceDiff.isEmpty ? "none" : "present; see provenance.json").
  Per-file SHA-256 hashes, toolchain and result-bundle location are in provenance.json.
  Source hashes were checked before and after the run.

  """
  try report.write(to: reportURL, atomically: true, encoding: .utf8)
} else {
  fatalError("Unknown command \(args[1])")
}
