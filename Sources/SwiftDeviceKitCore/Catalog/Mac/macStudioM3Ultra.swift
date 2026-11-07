// https://support.apple.com/en-us/102231
extension DeviceDefinition {
  static let macStudioM3Ultra = DeviceDefinition(
    model: .macStudioM3Ultra, family: .mac,
    name: "Mac Studio (M3 Ultra)",
    identifiers: ["Mac15,14"], cpu: .m3Ultra,
    capabilities: [.usbC]
  )
}
