// https://support.apple.com/en-us/117810
extension DeviceDefinition {
  static let appleVisionProM2 = DeviceDefinition(
    model: .appleVisionProM2, family: .vision,
    name: "Apple Vision Pro (M2)",
    identifiers: ["RealityDevice14,1"], cpu: .m2,
    capabilities: [.pro, .opticID, .lidar, .usbC],
    cameras: [.stereoscopic],
    spatialDisplay: .init(approximateTotalPixels: 23_000_000, pixelPitchMicrometers: 7.5,
                          refreshRatesHz: [90, 96, 100])
  )
}
