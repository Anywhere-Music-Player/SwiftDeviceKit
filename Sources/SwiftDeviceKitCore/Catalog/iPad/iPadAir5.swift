// Copyright © 2014 - 2018 Dennis Weissmann and the DeviceKit project authors
// SPDX-License-Identifier: MIT

extension DeviceDefinition {
  static let iPadAir5 = DeviceDefinition(
    model: .iPadAir5, family: .pad,
    name: "iPad Air (5th generation)",
    identifiers: ["iPad13,16", "iPad13,17"],
    cpu: .m1,
    capabilities: [.touchID, .roundedDisplayCorners, .fiveG, .eSIM, .usbC],
    cameras: [.wide],
    applePencilSupport: [.secondGeneration, .firstGenerationUsbC],
    screens: [
      .init(
        role: .main, diagonal: 10.9, ppi: 264,
        screenRatio: .init(width: 41, height: 59), resolution: nil)
    ]
  )
}
