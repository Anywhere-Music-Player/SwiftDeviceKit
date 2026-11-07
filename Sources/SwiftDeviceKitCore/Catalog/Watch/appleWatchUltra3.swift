// DeviceKit 5.10.0 and the Apple CoreSimulator device profile for this case size.
extension DeviceDefinition {
  static let appleWatchUltra3 = DeviceDefinition(
    model: .appleWatchUltra3, family: .watch,
    name: "Apple Watch Ultra 3",
    identifiers: ["Watch7,12"], cpu: .s10,
    capabilities: [.roundedDisplayCorners, .wirelessCharging, .eSIM, .fiveG, .actionButton],
    screens: [
      .init(role: .main, diagonal: 2.04, ppi: 326,
            screenRatio: .init(width: 422, height: 514), resolution: .init(width: 422, height: 514))
    ]
  )
}
