// https://support.apple.com/en-us/102231
extension DeviceDefinition {
  static let macStudioM2Max = DeviceDefinition(
    model: .macStudioM2Max, family: .mac,
    name: "Mac Studio (M2 Max)",
    identifiers: ["Mac14,13"], cpu: .m2Max,
    capabilities: [.usbC]
  )
}
