// https://support.apple.com/en-us/102231
extension DeviceDefinition {
  static let macStudioM5Max = DeviceDefinition(
    model: .macStudioM5Max, family: .mac,
    name: "Mac Studio (M5 Max)",
    identifiers: ["Mac17,14"], cpu: .m5Max,
    capabilities: [.usbC]
  )
}
