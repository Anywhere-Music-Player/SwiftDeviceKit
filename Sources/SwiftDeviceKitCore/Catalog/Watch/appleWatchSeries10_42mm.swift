// DeviceKit 5.10.0 and the Apple CoreSimulator device profile for this case size.
extension DeviceDefinition {
  static let appleWatchSeries10_42mm = DeviceDefinition(
    model: .appleWatchSeries10_42mm, family: .watch,
    name: "Apple Watch Series 10 42mm",
    identifiers: ["Watch7,8", "Watch7,10"], cpu: .s10,
    capabilities: [.roundedDisplayCorners, .wirelessCharging, .eSIM],
    screens: [
      .init(role: .main, diagonal: 1.79, ppi: 326,
            screenRatio: .init(width: 374, height: 446), resolution: .init(width: 374, height: 446))
    ]
  )
}
