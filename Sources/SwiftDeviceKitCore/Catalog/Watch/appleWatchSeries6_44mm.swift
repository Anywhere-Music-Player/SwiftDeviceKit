// DeviceKit 5.10.0 and the Apple CoreSimulator device profile for this case size.
extension DeviceDefinition {
  static let appleWatchSeries6_44mm = DeviceDefinition(
    model: .appleWatchSeries6_44mm, family: .watch,
    name: "Apple Watch Series 6 44mm",
    identifiers: ["Watch6,2", "Watch6,4"], cpu: .s6,
    capabilities: [.roundedDisplayCorners, .wirelessCharging, .eSIM],
    screens: [
      .init(role: .main, diagonal: 1.78, ppi: 326,
            screenRatio: .init(width: 368, height: 448), resolution: .init(width: 368, height: 448))
    ]
  )
}
