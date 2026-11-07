// https://support.apple.com/en-us/102852
extension DeviceDefinition {
  static let macMiniM6 = DeviceDefinition(
    model: .macMiniM6, family: .mac,
    name: "Mac mini (M6)",
    identifiers: ["Mac18,5"], cpu: .m6,
    capabilities: [.usbC, .mini]
  )
}
