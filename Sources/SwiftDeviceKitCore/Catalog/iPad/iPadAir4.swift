// Copyright © 2014 - 2018 Dennis Weissmann and the DeviceKit project authors
// SPDX-License-Identifier: MIT

extension DeviceDefinition {
  static let iPadAir4 = DeviceDefinition(
    model: .iPadAir4, family: .pad,
    name: "iPad Air (4th generation)",
    identifiers: ["iPad13,1", "iPad13,2"],
    cpu: .a14Bionic,
    capabilities: [.touchID, .roundedDisplayCorners, .eSIM, .usbC],
    cameras: [.wide],
    applePencilSupport: [.secondGeneration, .firstGenerationUsbC],
    screens: [
      .init(
        role: .main, diagonal: 10.9, ppi: 264,
        screenRatio: .init(width: 41, height: 59), resolution: nil)
    ]
  )
}
