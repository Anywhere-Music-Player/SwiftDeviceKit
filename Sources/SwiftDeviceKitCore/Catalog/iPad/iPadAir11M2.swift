// Copyright © 2014 - 2018 Dennis Weissmann and the DeviceKit project authors
// SPDX-License-Identifier: MIT

extension DeviceDefinition {
  static let iPadAir11M2 = DeviceDefinition(
    model: .iPadAir11M2, family: .pad,
    name: "iPad Air (11-inch) (M2)",
    identifiers: ["iPad14,8", "iPad14,9"],
    cpu: .m2,
    capabilities: [.touchID, .roundedDisplayCorners, .fiveG, .eSIM, .usbC],
    cameras: [.wide],
    applePencilSupport: [.firstGenerationUsbC, .pro],
    screens: [
      .init(
        role: .main, diagonal: 10.9, ppi: 264,
        screenRatio: .init(width: 41, height: 59), resolution: nil)
    ]
  )
}
