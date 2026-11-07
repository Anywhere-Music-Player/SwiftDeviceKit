// https://support.apple.com/en-us/108052
extension DeviceDefinition {
  static let macBookPro16M5Pro = DeviceDefinition(
    model: .macBookPro16M5Pro, family: .mac,
    name: "MacBook Pro (16-inch, M5 Pro)",
    identifiers: ["Mac17,8"], cpu: .m5Pro,
    capabilities: [.usbC, .roundedDisplayCorners, .sensorHousing, .pro, .touchID],
    cameras: [.front],
    screens: [
      .init(role: .main, diagonal: 16.2, ppi: 254,
            screenRatio: .init(width: 1117, height: 1728), resolution: .init(width: 2234, height: 3456))
    ]
  )
}
