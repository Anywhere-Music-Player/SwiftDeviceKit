// https://support.apple.com/en-us/102852
extension DeviceDefinition {
  static let macMiniM2Pro = DeviceDefinition(
    model: .macMiniM2Pro, family: .mac,
    name: "Mac mini (M2 Pro)",
    identifiers: ["Mac14,12"], cpu: .m2Pro,
    capabilities: [.usbC, .mini]
  )
}
