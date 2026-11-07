// https://support.apple.com/en-us/108052
extension DeviceDefinition {
  static let macBookPro16M1Pro = DeviceDefinition(
    model: .macBookPro16M1Pro, family: .mac,
    name: "MacBook Pro (16-inch, M1 Pro)",
    identifiers: ["MacBookPro18,1"], cpu: .m1Pro,
    capabilities: [.usbC, .roundedDisplayCorners, .sensorHousing, .pro, .touchID],
    cameras: [.front],
    screens: [
      .init(role: .main, diagonal: 16.2, ppi: 254,
            screenRatio: .init(width: 1117, height: 1728), resolution: .init(width: 2234, height: 3456))
    ]
  )
}
