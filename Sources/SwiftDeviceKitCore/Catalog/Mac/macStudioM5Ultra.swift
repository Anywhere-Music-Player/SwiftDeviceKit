// https://support.apple.com/en-us/102231
extension DeviceDefinition {
  static let macStudioM5Ultra = DeviceDefinition(
    model: .macStudioM5Ultra, family: .mac,
    name: "Mac Studio (M5 Ultra)",
    identifiers: ["Mac17,15"], cpu: .m5Ultra,
    capabilities: [.usbC]
  )
}
