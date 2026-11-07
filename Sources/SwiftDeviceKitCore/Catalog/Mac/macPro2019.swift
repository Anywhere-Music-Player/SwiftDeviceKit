// https://support.apple.com/en-us/102887
extension DeviceDefinition {
  static let macPro2019 = DeviceDefinition(
    model: .macPro2019, family: .mac,
    name: "Mac Pro (2019)",
    identifiers: ["MacPro7,1"], cpu: .intel,
    capabilities: [.usbC, .pro]
  )
}
