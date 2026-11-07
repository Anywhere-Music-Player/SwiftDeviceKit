// https://support.apple.com/en-us/102852
extension DeviceDefinition {
  static let macMiniM5Pro = DeviceDefinition(
    model: .macMiniM5Pro, family: .mac,
    name: "Mac mini (M5 Pro)",
    identifiers: ["Mac17,16"], cpu: .m5Pro,
    capabilities: [.usbC, .mini]
  )
}
