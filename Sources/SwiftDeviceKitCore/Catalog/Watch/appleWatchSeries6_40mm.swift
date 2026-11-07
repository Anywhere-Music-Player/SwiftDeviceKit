// DeviceKit 5.10.0 and the Apple CoreSimulator device profile for this case size.
extension DeviceDefinition {
  static let appleWatchSeries6_40mm = DeviceDefinition(
    model: .appleWatchSeries6_40mm, family: .watch,
    name: "Apple Watch Series 6 40mm",
    identifiers: ["Watch6,1", "Watch6,3"], cpu: .s6,
    capabilities: [.roundedDisplayCorners, .wirelessCharging, .eSIM],
    screens: [
      .init(role: .main, diagonal: 1.56, ppi: 326,
            screenRatio: .init(width: 324, height: 394), resolution: .init(width: 324, height: 394))
    ]
  )
}
