// DeviceKit 5.10.0 and the Apple CoreSimulator device profile for this case size.
extension DeviceDefinition {
  static let appleWatchUltra2 = DeviceDefinition(
    model: .appleWatchUltra2, family: .watch,
    name: "Apple Watch Ultra2",
    identifiers: ["Watch7,5"], cpu: .s9,
    capabilities: [.roundedDisplayCorners, .wirelessCharging, .eSIM, .actionButton],
    screens: [
      .init(role: .main, diagonal: 1.99, ppi: 326,
            screenRatio: .init(width: 410, height: 502), resolution: .init(width: 410, height: 502))
    ]
  )
}
