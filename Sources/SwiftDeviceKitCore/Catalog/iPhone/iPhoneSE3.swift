// Copyright © 2014 - 2018 Dennis Weissmann and the DeviceKit project authors
// SPDX-License-Identifier: MIT

extension DeviceDefinition {
  static let iPhoneSE3 = DeviceDefinition(
    model: .iPhoneSE3, family: .phone,
    name: "iPhone SE (3rd generation)",
    identifiers: ["iPhone14,6"],
    cpu: .a15Bionic,
    capabilities: [.touchID, .wirelessCharging, .fiveG, .eSIM, .dualESIM],
    cameras: [.wide],
    applePencilSupport: [],
    screens: [
      .init(
        role: .main, diagonal: 4.7, ppi: 326,
        screenRatio: .init(width: 9, height: 16), resolution: nil)
    ]
  )
}
