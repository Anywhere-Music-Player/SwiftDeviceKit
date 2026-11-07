// https://support.apple.com/en-us/108052
extension DeviceDefinition {
  static let macBookPro132020TwoPorts = DeviceDefinition(
    model: .macBookPro132020TwoPorts, family: .mac,
    name: "MacBook Pro (13-inch, 2020, Two Thunderbolt 3 ports)",
    identifiers: ["MacBookPro16,3"], cpu: .intel,
    capabilities: [.usbC, .pro, .touchID],
    cameras: [.front],
    screens: [
      .init(role: .main, diagonal: 13.3, ppi: 227,
            screenRatio: .init(width: 5, height: 8), resolution: .init(width: 1600, height: 2560))
    ]
  )
}
