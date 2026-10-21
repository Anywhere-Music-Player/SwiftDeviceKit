// Copyright © 2014 - 2018 Dennis Weissmann and the DeviceKit project authors
// SPDX-License-Identifier: MIT

extension DeviceDefinition {
  static let iPad7 = DeviceDefinition(
    model: .iPad7, family: .pad,
    name: "iPad (7th generation)",
    identifiers: ["iPad7,11", "iPad7,12"],
    cpu: .a10Fusion,
    capabilities: [.touchID, .eSIM],
    cameras: [.wide],
    applePencilSupport: .firstGeneration,
    screens: [
      .init(
        role: .main, diagonal: 10.2, ppi: 264,
        screenRatio: .init(width: 3, height: 4), resolution: nil)
    ]
  )
}
