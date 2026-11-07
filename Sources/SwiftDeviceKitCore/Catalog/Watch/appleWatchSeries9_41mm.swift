// DeviceKit 5.10.0 and the Apple CoreSimulator device profile for this case size.
extension DeviceDefinition {
  static let appleWatchSeries9_41mm = DeviceDefinition(
    model: .appleWatchSeries9_41mm, family: .watch,
    name: "Apple Watch Series 9 41mm",
    identifiers: ["Watch7,1", "Watch7,3"], cpu: .s9,
    capabilities: [.roundedDisplayCorners, .wirelessCharging, .eSIM],
    screens: [
      .init(role: .main, diagonal: 1.70, ppi: 326,
            screenRatio: .init(width: 352, height: 430), resolution: .init(width: 352, height: 430))
    ]
  )
}
