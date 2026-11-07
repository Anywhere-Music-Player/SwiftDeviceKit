// DeviceKit 5.10.0 and the Apple CoreSimulator device profile for this case size.
extension DeviceDefinition {
  static let appleWatchSeries9_45mm = DeviceDefinition(
    model: .appleWatchSeries9_45mm, family: .watch,
    name: "Apple Watch Series 9 45mm",
    identifiers: ["Watch7,2", "Watch7,4"], cpu: .s9,
    capabilities: [.roundedDisplayCorners, .wirelessCharging, .eSIM],
    screens: [
      .init(role: .main, diagonal: 1.92, ppi: 326,
            screenRatio: .init(width: 396, height: 484), resolution: .init(width: 396, height: 484))
    ]
  )
}
