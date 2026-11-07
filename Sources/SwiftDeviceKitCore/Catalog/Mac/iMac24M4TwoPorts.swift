// https://support.apple.com/en-us/108054
extension DeviceDefinition {
  static let iMac24M4TwoPorts = DeviceDefinition(
    model: .iMac24M4TwoPorts, family: .mac,
    name: "iMac (24-inch, M4, 2 ports)",
    identifiers: ["Mac16,2"], cpu: .m4,
    capabilities: [.usbC],
    cameras: [.front],
    screens: [
      .init(role: .main, diagonal: 23.5, ppi: 218,
            screenRatio: .init(width: 9, height: 16), resolution: .init(width: 2520, height: 4480))
    ]
  )
}
