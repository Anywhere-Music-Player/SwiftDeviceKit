// DeviceKit 5.10.0 and the Apple CoreSimulator device profile for this case size.
extension DeviceDefinition {
  static let appleWatchSE3_40mm = DeviceDefinition(
    model: .appleWatchSE3_40mm, family: .watch,
    name: "Apple Watch SE (3rd generation) 40mm",
    identifiers: ["Watch7,13", "Watch7,15"], cpu: .s10,
    capabilities: [.roundedDisplayCorners, .wirelessCharging, .eSIM, .fiveG],
    screens: [
      .init(role: .main, diagonal: 1.56, ppi: 326,
            screenRatio: .init(width: 324, height: 394), resolution: .init(width: 324, height: 394))
    ]
  )
}
