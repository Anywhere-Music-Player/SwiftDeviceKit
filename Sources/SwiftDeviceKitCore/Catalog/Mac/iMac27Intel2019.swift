// https://support.apple.com/en-us/108054
extension DeviceDefinition {
  static let iMac27Intel2019 = DeviceDefinition(
    model: .iMac27Intel2019, family: .mac,
    name: "iMac (Retina 5K, 27-inch, 2019)",
    identifiers: ["iMac19,1"], cpu: .intel,
    capabilities: [.usbC],
    cameras: [.front],
    screens: [
      .init(role: .main, diagonal: 27, ppi: 218,
            screenRatio: .init(width: 9, height: 16), resolution: .init(width: 2880, height: 5120))
    ]
  )
}
