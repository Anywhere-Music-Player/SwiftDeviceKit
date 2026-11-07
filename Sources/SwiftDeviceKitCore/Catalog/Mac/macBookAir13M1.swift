// https://support.apple.com/en-us/102869
extension DeviceDefinition {
  static let macBookAir13M1 = DeviceDefinition(
    model: .macBookAir13M1, family: .mac,
    name: "MacBook Air (13-inch, M1)",
    identifiers: ["MacBookAir10,1"], cpu: .m1,
    capabilities: [.usbC, .touchID],
    cameras: [.front],
    screens: [
      .init(role: .main, diagonal: 13.3, ppi: 227,
            screenRatio: .init(width: 5, height: 8), resolution: .init(width: 1600, height: 2560))
    ]
  )
}
