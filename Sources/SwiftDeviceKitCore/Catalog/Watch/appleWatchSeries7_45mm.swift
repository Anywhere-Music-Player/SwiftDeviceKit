// DeviceKit 5.10.0 and the Apple CoreSimulator device profile for this case size.
extension DeviceDefinition {
  static let appleWatchSeries7_45mm = DeviceDefinition(
    model: .appleWatchSeries7_45mm, family: .watch,
    name: "Apple Watch Series 7 45mm",
    identifiers: ["Watch6,7", "Watch6,9"], cpu: .s7,
    capabilities: [.roundedDisplayCorners, .wirelessCharging, .eSIM],
    screens: [
      .init(role: .main, diagonal: 1.92, ppi: 326,
            screenRatio: .init(width: 396, height: 484), resolution: .init(width: 396, height: 484))
    ]
  )
}
