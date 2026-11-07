// https://support.apple.com/en-us/125436
extension DeviceDefinition {
  static let appleVisionProM5 = DeviceDefinition(
    model: .appleVisionProM5, family: .vision,
    name: "Apple Vision Pro (M5)",
    identifiers: ["RealityDevice17,1"], cpu: .m5,
    capabilities: [.pro, .opticID, .lidar, .usbC],
    cameras: [.stereoscopic],
    spatialDisplay: .init(approximateTotalPixels: 23_000_000, pixelPitchMicrometers: 7.5,
                          refreshRatesHz: [90, 96, 100, 120])
  )
}
