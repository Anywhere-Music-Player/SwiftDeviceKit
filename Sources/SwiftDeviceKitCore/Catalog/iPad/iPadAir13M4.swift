// Copyright © 2014 - 2018 Dennis Weissmann and the DeviceKit project authors
// SPDX-License-Identifier: MIT

extension DeviceDefinition {
  static let iPadAir13M4 = DeviceDefinition(
    model: .iPadAir13M4, family: .pad,
    name: "iPad Air (13-inch) (M4)",
    identifiers: ["iPad16,10", "iPad16,11"],
    cpu: .m4,
    capabilities: [.touchID, .roundedDisplayCorners, .fiveG, .eSIM, .usbC],
    cameras: [.wide],
    applePencilSupport: [.firstGenerationUsbC, .pro],
    screens: [
      .init(
        role: .main, diagonal: 12.9, ppi: 264,
        screenRatio: .init(width: 512, height: 683), resolution: nil)
    ]
  )
}
