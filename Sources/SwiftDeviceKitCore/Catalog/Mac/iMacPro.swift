// https://support.apple.com/en-us/108054
extension DeviceDefinition {
  static let iMacPro = DeviceDefinition(
    model: .iMacPro, family: .mac,
    name: "iMac Pro (2017)",
    identifiers: ["iMacPro1,1"], cpu: .intel,
    capabilities: [.usbC, .pro],
    cameras: [.front],
    screens: [
      .init(role: .main, diagonal: 27, ppi: 218,
            screenRatio: .init(width: 9, height: 16), resolution: .init(width: 2880, height: 5120))
    ]
  )
}
