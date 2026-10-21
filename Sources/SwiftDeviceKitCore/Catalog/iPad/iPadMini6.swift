// Copyright © 2014 - 2018 Dennis Weissmann and the DeviceKit project authors
// SPDX-License-Identifier: MIT

extension DeviceDefinition {
  static let iPadMini6 = DeviceDefinition(
    model: .iPadMini6, family: .pad,
    name: "iPad mini (6th generation)",
    identifiers: ["iPad14,1", "iPad14,2"],
    cpu: .a15Bionic,
    capabilities: [.mini, .touchID, .roundedDisplayCorners, .fiveG, .eSIM, .usbC],
    cameras: [.wide],
    applePencilSupport: [.secondGeneration, .firstGenerationUsbC],
    screens: [
      .init(
        role: .main, diagonal: 8.3, ppi: 326,
        screenRatio: .init(width: 744, height: 1133), resolution: nil)
    ]
  )
}
