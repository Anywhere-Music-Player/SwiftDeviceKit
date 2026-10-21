// Copyright © 2014 - 2018 Dennis Weissmann and the DeviceKit project authors
// SPDX-License-Identifier: MIT

extension DeviceDefinition {
  static let iPad8 = DeviceDefinition(
    model: .iPad8, family: .pad,
    name: "iPad (8th generation)",
    identifiers: ["iPad11,6", "iPad11,7"],
    cpu: .a12Bionic,
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
