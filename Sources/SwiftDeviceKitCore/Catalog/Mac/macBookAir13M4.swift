// https://support.apple.com/en-us/102869
extension DeviceDefinition {
  static let macBookAir13M4 = DeviceDefinition(
    model: .macBookAir13M4, family: .mac,
    name: "MacBook Air (13-inch, M4)",
    identifiers: ["Mac16,12"], cpu: .m4,
    capabilities: [.usbC, .roundedDisplayCorners, .sensorHousing, .touchID],
    cameras: [.front],
    screens: [
      .init(role: .main, diagonal: 13.6, ppi: 224,
            screenRatio: .init(width: 13, height: 20), resolution: .init(width: 1664, height: 2560))
    ]
  )
}
