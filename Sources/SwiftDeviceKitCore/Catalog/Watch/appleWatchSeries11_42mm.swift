// DeviceKit 5.10.0 and the Apple CoreSimulator device profile for this case size.
extension DeviceDefinition {
  static let appleWatchSeries11_42mm = DeviceDefinition(
    model: .appleWatchSeries11_42mm, family: .watch,
    name: "Apple Watch Series 11 42mm",
    identifiers: ["Watch7,17", "Watch7,19"], cpu: .s10,
    capabilities: [.roundedDisplayCorners, .wirelessCharging, .eSIM, .fiveG],
    screens: [
      .init(role: .main, diagonal: 1.79, ppi: 326,
            screenRatio: .init(width: 374, height: 446), resolution: .init(width: 374, height: 446))
    ]
  )
}
