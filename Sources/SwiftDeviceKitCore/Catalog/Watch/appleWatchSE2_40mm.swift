// DeviceKit 5.10.0 and the Apple CoreSimulator device profile for this case size.
extension DeviceDefinition {
  static let appleWatchSE2_40mm = DeviceDefinition(
    model: .appleWatchSE2_40mm, family: .watch,
    name: "Apple Watch SE (2nd generation) 40mm",
    identifiers: ["Watch6,10", "Watch6,12"], cpu: .s8,
    capabilities: [.roundedDisplayCorners, .wirelessCharging, .eSIM],
    screens: [
      .init(role: .main, diagonal: 1.56, ppi: 326,
            screenRatio: .init(width: 324, height: 394), resolution: .init(width: 324, height: 394))
    ]
  )
}
