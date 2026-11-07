// https://support.apple.com/en-us/108052
extension DeviceDefinition {
  static let macBookPro16M2Max = DeviceDefinition(
    model: .macBookPro16M2Max, family: .mac,
    name: "MacBook Pro (16-inch, M2 Max)",
    identifiers: ["Mac14,6"], cpu: .m2Max,
    capabilities: [.usbC, .roundedDisplayCorners, .sensorHousing, .pro, .touchID],
    cameras: [.front],
    screens: [
      .init(role: .main, diagonal: 16.2, ppi: 254,
            screenRatio: .init(width: 1117, height: 1728), resolution: .init(width: 2234, height: 3456))
    ]
  )
}
