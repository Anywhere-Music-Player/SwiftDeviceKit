// https://support.apple.com/en-us/108052
extension DeviceDefinition {
  static let macBookPro162019 = DeviceDefinition(
    model: .macBookPro162019, family: .mac,
    name: "MacBook Pro (16-inch, 2019)",
    identifiers: ["MacBookPro16,1", "MacBookPro16,4"], cpu: .intel,
    capabilities: [.usbC, .pro, .touchID],
    cameras: [.front],
    screens: [
      .init(role: .main, diagonal: 16, ppi: 226,
            screenRatio: .init(width: 5, height: 8), resolution: .init(width: 1920, height: 3072))
    ]
  )
}
