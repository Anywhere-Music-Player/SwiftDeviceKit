// https://support.apple.com/en-us/108052
extension DeviceDefinition {
  static let macBookPro132019TwoPorts = DeviceDefinition(
    model: .macBookPro132019TwoPorts, family: .mac,
    name: "MacBook Pro (13-inch, 2019, Two Thunderbolt 3 ports)",
    identifiers: ["MacBookPro15,4"], cpu: .intel,
    capabilities: [.usbC, .pro, .touchID],
    cameras: [.front],
    screens: [
      .init(role: .main, diagonal: 13.3, ppi: 227,
            screenRatio: .init(width: 5, height: 8), resolution: .init(width: 1600, height: 2560))
    ]
  )
}
