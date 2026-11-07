// DeviceKit 5.10.0 and the Apple CoreSimulator device profile for this case size.
extension DeviceDefinition {
  static let appleWatchSeries8_41mm = DeviceDefinition(
    model: .appleWatchSeries8_41mm, family: .watch,
    name: "Apple Watch Series 8 41mm",
    identifiers: ["Watch6,14", "Watch6,16"], cpu: .s8,
    capabilities: [.roundedDisplayCorners, .wirelessCharging, .eSIM],
    screens: [
      .init(role: .main, diagonal: 1.70, ppi: 326,
            screenRatio: .init(width: 352, height: 430), resolution: .init(width: 352, height: 430))
    ]
  )
}
