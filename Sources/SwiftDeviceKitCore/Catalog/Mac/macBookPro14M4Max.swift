// https://support.apple.com/en-us/108052
extension DeviceDefinition {
  static let macBookPro14M4Max = DeviceDefinition(
    model: .macBookPro14M4Max, family: .mac,
    name: "MacBook Pro (14-inch, M4 Max)",
    identifiers: ["Mac16,6"], cpu: .m4Max,
    capabilities: [.usbC, .roundedDisplayCorners, .sensorHousing, .pro, .touchID],
    cameras: [.front],
    screens: [
      .init(role: .main, diagonal: 14.2, ppi: 254,
            screenRatio: .init(width: 491, height: 756), resolution: .init(width: 1964, height: 3024))
    ]
  )
}
