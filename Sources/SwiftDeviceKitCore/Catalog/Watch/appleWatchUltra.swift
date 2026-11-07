// DeviceKit 5.10.0 and the Apple CoreSimulator device profile for this case size.
extension DeviceDefinition {
  static let appleWatchUltra = DeviceDefinition(
    model: .appleWatchUltra, family: .watch,
    name: "Apple Watch Ultra",
    identifiers: ["Watch6,18"], cpu: .s8,
    capabilities: [.roundedDisplayCorners, .wirelessCharging, .eSIM, .actionButton],
    screens: [
      .init(role: .main, diagonal: 1.99, ppi: 326,
            screenRatio: .init(width: 410, height: 502), resolution: .init(width: 410, height: 502))
    ]
  )
}
