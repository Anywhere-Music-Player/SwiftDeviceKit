// https://support.apple.com/en-us/108052
extension DeviceDefinition {
  static let macBookPro14M5ProPROLED = DeviceDefinition(
    model: .macBookPro14M5ProPROLED, family: .mac,
    name: "MacBook Pro (14-inch PROLED XDR, M5 Pro)",
    identifiers: ["Mac17,13"], cpu: .m5Pro,
    capabilities: [.usbC, .roundedDisplayCorners, .sensorHousing, .dynamicIsland, .pro, .touchID],
    cameras: [.front],
    screens: [
      .init(role: .main, diagonal: 14.2, ppi: 254,
            screenRatio: .init(width: 331, height: 504), resolution: .init(width: 1986, height: 3024))
    ]
  )
}
