// https://support.apple.com/en-us/108052
extension DeviceDefinition {
  static let macBookPro152018To2019 = DeviceDefinition(
    model: .macBookPro152018To2019, family: .mac,
    name: "MacBook Pro (15-inch, 2018–2019)",
    identifiers: ["MacBookPro15,1"], cpu: .intel,
    capabilities: [.usbC, .pro, .touchID],
    cameras: [.front],
    screens: [
      .init(role: .main, diagonal: 15.4, ppi: 220,
            screenRatio: .init(width: 5, height: 8), resolution: .init(width: 1800, height: 2880))
    ]
  )
}
