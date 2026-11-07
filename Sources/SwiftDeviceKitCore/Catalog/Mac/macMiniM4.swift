// https://support.apple.com/en-us/102852
extension DeviceDefinition {
  static let macMiniM4 = DeviceDefinition(
    model: .macMiniM4, family: .mac,
    name: "Mac mini (M4)",
    identifiers: ["Mac16,11"], cpu: .m4,
    capabilities: [.usbC, .mini]
  )
}
