// Copyright © 2014 - 2018 Dennis Weissmann and the DeviceKit project authors
// SPDX-License-Identifier: MIT

extension DeviceDefinition {
  static let iPhoneSE2 = DeviceDefinition(
    model: .iPhoneSE2, family: .phone,
    name: "iPhone SE (2nd generation)",
    identifiers: ["iPhone12,8"],
    cpu: .a13Bionic,
    capabilities: [.touchID, .wirelessCharging, .eSIM],
    cameras: [.wide],
    applePencilSupport: [],
    screens: [
      .init(
        role: .main, diagonal: 4.7, ppi: 326,
        screenRatio: .init(width: 9, height: 16), resolution: nil)
    ]
  )
}
