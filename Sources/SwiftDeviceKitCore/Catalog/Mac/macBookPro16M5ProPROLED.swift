// https://support.apple.com/en-us/108052
extension DeviceDefinition {
  static let macBookPro16M5ProPROLED = DeviceDefinition(
    model: .macBookPro16M5ProPROLED, family: .mac,
    name: "MacBook Pro (16-inch PROLED XDR, M5 Pro)",
    identifiers: ["Mac17,12"], cpu: .m5Pro,
    capabilities: [.usbC, .roundedDisplayCorners, .sensorHousing, .dynamicIsland, .pro, .touchID],
    cameras: [.front],
    screens: [
      .init(role: .main, diagonal: 16.3, ppi: 254,
            screenRatio: .init(width: 1133, height: 1736), resolution: .init(width: 2266, height: 3472))
    ]
  )
}
