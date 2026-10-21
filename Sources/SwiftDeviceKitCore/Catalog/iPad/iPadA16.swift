// Copyright © 2014 - 2018 Dennis Weissmann and the DeviceKit project authors
// SPDX-License-Identifier: MIT

extension DeviceDefinition {
  static let iPadA16 = DeviceDefinition(
    model: .iPadA16, family: .pad,
    name: "iPad (A16)",
    identifiers: ["iPad15,7", "iPad15,8"],
    cpu: .a16Bionic,
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
