// https://support.apple.com/en-us/108052
extension DeviceDefinition {
  static let macBookPro13M1 = DeviceDefinition(
    model: .macBookPro13M1, family: .mac,
    name: "MacBook Pro (13-inch, M1)",
    identifiers: ["MacBookPro17,1"], cpu: .m1,
    capabilities: [.usbC, .pro, .touchID],
    cameras: [.front],
    screens: [
      .init(role: .main, diagonal: 13.3, ppi: 227,
            screenRatio: .init(width: 5, height: 8), resolution: .init(width: 1600, height: 2560))
    ]
  )
}
