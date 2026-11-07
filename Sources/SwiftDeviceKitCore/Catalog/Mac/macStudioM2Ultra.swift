// https://support.apple.com/en-us/102231
extension DeviceDefinition {
  static let macStudioM2Ultra = DeviceDefinition(
    model: .macStudioM2Ultra, family: .mac,
    name: "Mac Studio (M2 Ultra)",
    identifiers: ["Mac14,14"], cpu: .m2Ultra,
    capabilities: [.usbC]
  )
}
