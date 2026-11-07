// https://support.apple.com/en-us/108052
extension DeviceDefinition {
  static let macBookPro16M1Max = DeviceDefinition(
    model: .macBookPro16M1Max, family: .mac,
    name: "MacBook Pro (16-inch, M1 Max)",
    identifiers: ["MacBookPro18,2"], cpu: .m1Max,
    capabilities: [.usbC, .roundedDisplayCorners, .sensorHousing, .pro, .touchID],
    cameras: [.front],
    screens: [
      .init(role: .main, diagonal: 16.2, ppi: 254,
            screenRatio: .init(width: 1117, height: 1728), resolution: .init(width: 2234, height: 3456))
    ]
  )
}
