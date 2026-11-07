// DeviceKit 5.10.0 and the Apple CoreSimulator device profile for this case size.
extension DeviceDefinition {
  static let appleWatchSE3_44mm = DeviceDefinition(
    model: .appleWatchSE3_44mm, family: .watch,
    name: "Apple Watch SE (3rd generation) 44mm",
    identifiers: ["Watch7,14", "Watch7,16"], cpu: .s10,
    capabilities: [.roundedDisplayCorners, .wirelessCharging, .eSIM, .fiveG],
    screens: [
      .init(role: .main, diagonal: 1.78, ppi: 326,
            screenRatio: .init(width: 368, height: 448), resolution: .init(width: 368, height: 448))
    ]
  )
}
