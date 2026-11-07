// https://support.apple.com/en-us/102231
extension DeviceDefinition {
  static let macStudioM1Ultra = DeviceDefinition(
    model: .macStudioM1Ultra, family: .mac,
    name: "Mac Studio (M1 Ultra)",
    identifiers: ["Mac13,2"], cpu: .m1Ultra,
    capabilities: [.usbC]
  )
}
