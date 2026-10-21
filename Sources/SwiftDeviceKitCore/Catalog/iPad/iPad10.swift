// Copyright © 2014 - 2018 Dennis Weissmann and the DeviceKit project authors
// SPDX-License-Identifier: MIT

extension DeviceDefinition {
  static let iPad10 = DeviceDefinition(
    model: .iPad10, family: .pad,
    name: "iPad (10th generation)",
    identifiers: ["iPad13,18", "iPad13,19"],
    cpu: .a14Bionic,
    capabilities: [.touchID, .roundedDisplayCorners, .fiveG, .eSIM, .usbC],
    cameras: [.wide],
    applePencilSupport: [.firstGeneration, .firstGenerationUsbC],
    screens: [
      .init(
        role: .main, diagonal: 10.9, ppi: 264,
        screenRatio: .init(width: 41, height: 59), resolution: nil)
    ]
  )
}
