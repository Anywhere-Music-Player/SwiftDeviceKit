import Foundation
import Testing

/// Test-only policy, independent of the production catalog. Keep donor fixtures frozen.
enum CatalogSupportPolicy {
  // Intentional corrections; the original fixtures stay unchanged. See Docs/CatalogCorrections.md.
  static let portraitRatios: [String: (Double, Double)] = [
    "iPadAir11M3": (41, 59), "iPadAir11M4": (41, 59),
    "iPadAir13M2": (512, 683), "iPadAir13M3": (512, 683), "iPadAir13M4": (512, 683),
    "iPadPro11M4": (417, 605), "iPadPro11M5": (417, 605),
    "iPadPro13M4": (3, 4), "iPadPro13M5": (3, 4),
  ]

  // Apple iOS 18: https://support.apple.com/en-nz/104985
  // Apple iPadOS 18: https://www.apple.com/ie/newsroom/2024/09/ipados-18-is-now-available-taking-ipad-to-the-next-level/
  static let excludedCaseNames: Set<String> = [
    "iPhone4", "iPhone4s", "iPhone5", "iPhone5c", "iPhone5s", "iPhone6", "iPhone6Plus",
    "iPhone6s", "iPhone6sPlus", "iPhone7", "iPhone7Plus", "iPhoneSE", "iPhone8",
    "iPhone8Plus", "iPhoneX",
    "iPad2", "iPad3", "iPad4", "iPadAir", "iPadAir2", "iPad5", "iPad6",
    "iPadMini", "iPadMini2", "iPadMini3", "iPadMini4", "iPadPro9Inch", "iPadPro12Inch",
    "iPadPro12Inch2", "iPadPro10Inch", "iPodTouch5", "iPodTouch6", "iPodTouch7", "homePod",
  ]

  static func excludedIdentifiers() throws -> Set<String> {
    struct Entry: Decodable {
      let caseName: String
      let identifiers: [String]
    }
    let url = try #require(Bundle.module.url(forResource: "DeviceKit-5.9.0", withExtension: "json"))
    let baseline = try JSONDecoder().decode([Entry].self, from: Data(contentsOf: url))
    return Set(baseline.filter { excludedCaseNames.contains($0.caseName) }.flatMap(\.identifiers))
  }
}
