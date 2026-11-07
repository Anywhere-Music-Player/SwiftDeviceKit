// https://support.apple.com/en-us/102869
extension DeviceDefinition {
  static let macBookAir13Intel2020 = DeviceDefinition(
    model: .macBookAir13Intel2020, family: .mac,
    name: "MacBook Air (13-inch, Intel, 2020)",
    identifiers: ["MacBookAir9,1"], cpu: .intel,
    capabilities: [.usbC, .touchID],
    cameras: [.front],
    screens: [
      .init(role: .main, diagonal: 13.3, ppi: 227,
            screenRatio: .init(width: 5, height: 8), resolution: .init(width: 1600, height: 2560))
    ]
  )
}
