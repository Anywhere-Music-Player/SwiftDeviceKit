extension DeviceDefinition {
  // Verified 7 November 2026. See Docs/CatalogCorrections.md for Apple sources and ID provenance.
  static let iPadMiniA20Pro = DeviceDefinition(
    model: .iPadMiniA20Pro, family: .pad,
    name: "iPad mini (A20 Pro)",
    identifiers: ["iPad19,1", "iPad19,2"],
    cpu: .a20Pro,
    capabilities: [.mini, .touchID, .roundedDisplayCorners, .fiveG, .eSIM, .usbC],
    cameras: [.wide],
    applePencilSupport: [.firstGenerationUsbC, .pro],
    screens: [
      .init(
        role: .main, diagonal: 8.5, ppi: 326,
        screenRatio: .init(width: 126, height: 193),
        resolution: .init(width: 1512, height: 2316))
    ]
  )
}
