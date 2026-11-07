// https://support.apple.com/en-us/108054
extension DeviceDefinition {
  static let iMac24M1FourPorts = DeviceDefinition(
    model: .iMac24M1FourPorts, family: .mac,
    name: "iMac (24-inch, M1, 4 ports)",
    identifiers: ["iMac21,1"], cpu: .m1,
    capabilities: [.usbC],
    cameras: [.front],
    screens: [
      .init(role: .main, diagonal: 23.5, ppi: 218,
            screenRatio: .init(width: 9, height: 16), resolution: .init(width: 2520, height: 4480))
    ]
  )
}
