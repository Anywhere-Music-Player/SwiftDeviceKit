// https://support.apple.com/en-us/102887
extension DeviceDefinition {
  static let macProM2Ultra = DeviceDefinition(
    model: .macProM2Ultra, family: .mac,
    name: "Mac Pro (M2 Ultra)",
    identifiers: ["Mac14,8"], cpu: .m2Ultra,
    capabilities: [.usbC, .pro]
  )
}
