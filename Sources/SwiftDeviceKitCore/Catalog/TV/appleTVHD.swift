// https://support.apple.com/en-us/111928
extension DeviceDefinition {
  static let appleTVHD = DeviceDefinition(
    model: .appleTVHD, family: .tv,
    name: "Apple TV HD",
    identifiers: ["AppleTV5,3"], cpu: .a8,
    capabilities: [.usbC]
  )
}
