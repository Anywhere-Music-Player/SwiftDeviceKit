// https://support.apple.com/en-us/102231
extension DeviceDefinition {
  static let macStudioM1Max = DeviceDefinition(
    model: .macStudioM1Max, family: .mac,
    name: "Mac Studio (M1 Max)",
    identifiers: ["Mac13,1"], cpu: .m1Max,
    capabilities: [.usbC]
  )
}
