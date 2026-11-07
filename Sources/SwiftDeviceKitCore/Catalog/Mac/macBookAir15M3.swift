// https://support.apple.com/en-us/102869
extension DeviceDefinition {
  static let macBookAir15M3 = DeviceDefinition(
    model: .macBookAir15M3, family: .mac,
    name: "MacBook Air (15-inch, M3)",
    identifiers: ["Mac15,13"], cpu: .m3,
    capabilities: [.usbC, .roundedDisplayCorners, .sensorHousing, .touchID],
    cameras: [.front],
    screens: [
      .init(role: .main, diagonal: 15.3, ppi: 224,
            screenRatio: .init(width: 233, height: 360), resolution: .init(width: 1864, height: 2880))
    ]
  )
}
