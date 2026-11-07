// DeviceKit 5.10.0 and the Apple CoreSimulator device profile for this case size.
extension DeviceDefinition {
  static let appleWatchSeries8_45mm = DeviceDefinition(
    model: .appleWatchSeries8_45mm, family: .watch,
    name: "Apple Watch Series 8 45mm",
    identifiers: ["Watch6,15", "Watch6,17"], cpu: .s8,
    capabilities: [.roundedDisplayCorners, .wirelessCharging, .eSIM],
    screens: [
      .init(role: .main, diagonal: 1.92, ppi: 326,
            screenRatio: .init(width: 396, height: 484), resolution: .init(width: 396, height: 484))
    ]
  )
}
