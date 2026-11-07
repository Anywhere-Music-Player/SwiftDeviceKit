// DeviceKit 5.10.0 and the Apple CoreSimulator device profile for this case size.
extension DeviceDefinition {
  static let appleWatchSeries12_46mm = DeviceDefinition(
    model: .appleWatchSeries12_46mm, family: .watch,
    name: "Apple Watch Series 12 46mm",
    identifiers: ["Watch8,3", "Watch8,5"], cpu: .s11,
    capabilities: [.roundedDisplayCorners, .wirelessCharging, .eSIM, .fiveG],
    screens: [
      .init(role: .main, diagonal: 1.99, ppi: 326,
            screenRatio: .init(width: 416, height: 496), resolution: .init(width: 416, height: 496))
    ]
  )
}
