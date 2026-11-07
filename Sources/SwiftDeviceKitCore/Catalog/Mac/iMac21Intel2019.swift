// https://support.apple.com/en-us/108054
extension DeviceDefinition {
  static let iMac21Intel2019 = DeviceDefinition(
    model: .iMac21Intel2019, family: .mac,
    name: "iMac (Retina 4K, 21.5-inch, 2019)",
    identifiers: ["iMac19,2"], cpu: .intel,
    capabilities: [.usbC],
    cameras: [.front],
    screens: [
      .init(role: .main, diagonal: 21.5, ppi: 219,
            screenRatio: .init(width: 9, height: 16), resolution: .init(width: 2304, height: 4096))
    ]
  )
}
