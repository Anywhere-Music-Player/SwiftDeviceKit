// DeviceKit 5.10.0 and the Apple CoreSimulator device profile for this case size.
extension DeviceDefinition {
  static let appleWatchSeries7_41mm = DeviceDefinition(
    model: .appleWatchSeries7_41mm, family: .watch,
    name: "Apple Watch Series 7 41mm",
    identifiers: ["Watch6,6", "Watch6,8"], cpu: .s7,
    capabilities: [.roundedDisplayCorners, .wirelessCharging, .eSIM],
    screens: [
      .init(role: .main, diagonal: 1.70, ppi: 326,
            screenRatio: .init(width: 352, height: 430), resolution: .init(width: 352, height: 430))
    ]
  )
}
