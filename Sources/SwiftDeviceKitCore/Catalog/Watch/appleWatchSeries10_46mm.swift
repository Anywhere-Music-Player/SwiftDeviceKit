// DeviceKit 5.10.0 and the Apple CoreSimulator device profile for this case size.
extension DeviceDefinition {
  static let appleWatchSeries10_46mm = DeviceDefinition(
    model: .appleWatchSeries10_46mm, family: .watch,
    name: "Apple Watch Series 10 46mm",
    identifiers: ["Watch7,9", "Watch7,11"], cpu: .s10,
    capabilities: [.roundedDisplayCorners, .wirelessCharging, .eSIM],
    screens: [
      .init(role: .main, diagonal: 1.99, ppi: 326,
            screenRatio: .init(width: 416, height: 496), resolution: .init(width: 416, height: 496))
    ]
  )
}
