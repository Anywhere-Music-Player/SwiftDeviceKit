// https://support.apple.com/en-us/108054
extension DeviceDefinition {
  static let iMac24M6 = DeviceDefinition(
    model: .iMac24M6, family: .mac,
    name: "iMac (24-inch, M6)",
    identifiers: ["Mac18,2"], cpu: .m6,
    capabilities: [.usbC],
    cameras: [.front],
    screens: [
      .init(role: .main, diagonal: 23.5, ppi: 218,
            screenRatio: .init(width: 9, height: 16), resolution: .init(width: 2520, height: 4480))
    ]
  )
}
