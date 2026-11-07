// https://support.apple.com/en-us/102869
extension DeviceDefinition {
  static let macBookAir15M4 = DeviceDefinition(
    model: .macBookAir15M4, family: .mac,
    name: "MacBook Air (15-inch, M4)",
    identifiers: ["Mac16,13"], cpu: .m4,
    capabilities: [.usbC, .roundedDisplayCorners, .sensorHousing, .touchID],
    cameras: [.front],
    screens: [
      .init(role: .main, diagonal: 15.3, ppi: 224,
            screenRatio: .init(width: 233, height: 360), resolution: .init(width: 1864, height: 2880))
    ]
  )
}
