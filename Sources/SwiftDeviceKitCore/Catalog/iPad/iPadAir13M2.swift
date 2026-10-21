// Copyright © 2014 - 2018 Dennis Weissmann and the DeviceKit project authors
// SPDX-License-Identifier: MIT

extension DeviceDefinition {
  static let iPadAir13M2 = DeviceDefinition(
    model: .iPadAir13M2, family: .pad,
    name: "iPad Air (13-inch) (M2)",
    identifiers: ["iPad14,10", "iPad14,11"],
    cpu: .m2,
    capabilities: [.touchID, .roundedDisplayCorners, .fiveG, .eSIM, .usbC],
    cameras: [.wide],
    applePencilSupport: [.firstGenerationUsbC, .pro],
    screens: [
      .init(
        role: .main, diagonal: 12.9, ppi: 264,
        screenRatio: .init(width: 683, height: 512), resolution: nil)
    ]
  )
}
