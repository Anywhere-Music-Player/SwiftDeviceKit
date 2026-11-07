// https://support.apple.com/en-us/102852
extension DeviceDefinition {
  static let macMiniM1 = DeviceDefinition(
    model: .macMiniM1, family: .mac,
    name: "Mac mini (M1)",
    identifiers: ["Macmini9,1"], cpu: .m1,
    capabilities: [.usbC, .mini]
  )
}
