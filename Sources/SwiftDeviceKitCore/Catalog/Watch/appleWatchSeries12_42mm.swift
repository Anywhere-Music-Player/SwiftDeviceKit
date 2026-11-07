// DeviceKit 5.10.0 and the Apple CoreSimulator device profile for this case size.
extension DeviceDefinition {
  static let appleWatchSeries12_42mm = DeviceDefinition(
    model: .appleWatchSeries12_42mm, family: .watch,
    name: "Apple Watch Series 12 42mm",
    identifiers: ["Watch8,2", "Watch8,4"], cpu: .s11,
    capabilities: [.roundedDisplayCorners, .wirelessCharging, .eSIM, .fiveG],
    screens: [
      .init(role: .main, diagonal: 1.79, ppi: 326,
            screenRatio: .init(width: 374, height: 446), resolution: .init(width: 374, height: 446))
    ]
  )
}
