// https://support.apple.com/en-us/108052
extension DeviceDefinition {
  static let macBookPro14M4Pro = DeviceDefinition(
    model: .macBookPro14M4Pro, family: .mac,
    name: "MacBook Pro (14-inch, M4 Pro)",
    identifiers: ["Mac16,8"], cpu: .m4Pro,
    capabilities: [.usbC, .roundedDisplayCorners, .sensorHousing, .pro, .touchID],
    cameras: [.front],
    screens: [
      .init(role: .main, diagonal: 14.2, ppi: 254,
            screenRatio: .init(width: 491, height: 756), resolution: .init(width: 1964, height: 3024))
    ]
  )
}
