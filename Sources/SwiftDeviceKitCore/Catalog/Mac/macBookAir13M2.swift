// https://support.apple.com/en-us/102869
extension DeviceDefinition {
  static let macBookAir13M2 = DeviceDefinition(
    model: .macBookAir13M2, family: .mac,
    name: "MacBook Air (13-inch, M2)",
    identifiers: ["Mac14,2"], cpu: .m2,
    capabilities: [.usbC, .roundedDisplayCorners, .sensorHousing, .touchID],
    cameras: [.front],
    screens: [
      .init(role: .main, diagonal: 13.6, ppi: 224,
            screenRatio: .init(width: 13, height: 20), resolution: .init(width: 1664, height: 2560))
    ]
  )
}
