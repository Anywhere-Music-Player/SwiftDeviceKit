// https://support.apple.com/en-us/102852
extension DeviceDefinition {
  static let macMini2018 = DeviceDefinition(
    model: .macMini2018, family: .mac,
    name: "Mac mini (2018)",
    identifiers: ["Macmini8,1"], cpu: .intel,
    capabilities: [.usbC, .mini]
  )
}
