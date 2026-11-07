// https://support.apple.com/en-us/108052
extension DeviceDefinition {
  static let macBookPro14M5MaxPROLED = DeviceDefinition(
    model: .macBookPro14M5MaxPROLED, family: .mac,
    name: "MacBook Pro (14-inch PROLED XDR, M5 Max)",
    identifiers: ["Mac17,11"], cpu: .m5Max,
    capabilities: [.usbC, .roundedDisplayCorners, .sensorHousing, .dynamicIsland, .pro, .touchID],
    cameras: [.front],
    screens: [
      .init(role: .main, diagonal: 14.2, ppi: 254,
            screenRatio: .init(width: 331, height: 504), resolution: .init(width: 1986, height: 3024))
    ]
  )
}
