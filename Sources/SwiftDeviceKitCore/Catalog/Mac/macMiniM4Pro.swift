// https://support.apple.com/en-us/102852
extension DeviceDefinition {
  static let macMiniM4Pro = DeviceDefinition(
    model: .macMiniM4Pro, family: .mac,
    name: "Mac mini (M4 Pro)",
    identifiers: ["Mac16,11"], cpu: .m4Pro,
    capabilities: [.usbC, .mini]
  )
}
