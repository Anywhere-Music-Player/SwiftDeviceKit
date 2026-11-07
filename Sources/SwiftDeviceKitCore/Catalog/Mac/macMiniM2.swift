// https://support.apple.com/en-us/102852
extension DeviceDefinition {
  static let macMiniM2 = DeviceDefinition(
    model: .macMiniM2, family: .mac,
    name: "Mac mini (M2)",
    identifiers: ["Mac14,3"], cpu: .m2,
    capabilities: [.usbC, .mini]
  )
}
