// https://support.apple.com/en-us/102231
extension DeviceDefinition {
  static let macStudioM4Max = DeviceDefinition(
    model: .macStudioM4Max, family: .mac,
    name: "Mac Studio (M4 Max)",
    identifiers: ["Mac16,9"], cpu: .m4Max,
    capabilities: [.usbC]
  )
}
