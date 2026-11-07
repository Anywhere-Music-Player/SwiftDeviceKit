// https://support.apple.com/en-us/108054
extension DeviceDefinition {
  static let iMac27Intel2020 = DeviceDefinition(
    model: .iMac27Intel2020, family: .mac,
    name: "iMac (Retina 5K, 27-inch, 2020)",
    identifiers: ["iMac20,1", "iMac20,2"], cpu: .intel,
    capabilities: [.usbC],
    cameras: [.front],
    screens: [
      .init(role: .main, diagonal: 27, ppi: 218,
            screenRatio: .init(width: 9, height: 16), resolution: .init(width: 2880, height: 5120))
    ]
  )
}
