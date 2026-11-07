// DeviceKit 5.10.0 and the Apple CoreSimulator device profile for this case size.
extension DeviceDefinition {
  static let appleWatchSE2_44mm = DeviceDefinition(
    model: .appleWatchSE2_44mm, family: .watch,
    name: "Apple Watch SE (2nd generation) 44mm",
    identifiers: ["Watch6,11", "Watch6,13"], cpu: .s8,
    capabilities: [.roundedDisplayCorners, .wirelessCharging, .eSIM],
    screens: [
      .init(role: .main, diagonal: 1.78, ppi: 326,
            screenRatio: .init(width: 368, height: 448), resolution: .init(width: 368, height: 448))
    ]
  )
}
