// https://support.apple.com/en-us/126322
extension DeviceDefinition {
  static let macBookNeo = DeviceDefinition(
    model: .macBookNeo, family: .mac,
    name: "MacBook Neo",
    identifiers: ["Mac17,5"], cpu: .a18Pro,
    capabilities: [.usbC, .touchID, .roundedDisplayCorners],
    cameras: [.front],
    screens: [
      .init(role: .main, diagonal: 13, ppi: 219,
            screenRatio: .init(width: 753, height: 1204), resolution: .init(width: 1506, height: 2408))
    ]
  )
}
