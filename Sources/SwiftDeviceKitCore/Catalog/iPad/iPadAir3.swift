// Copyright © 2014 - 2018 Dennis Weissmann and the DeviceKit project authors
// SPDX-License-Identifier: MIT

extension DeviceDefinition {
  static let iPadAir3 = DeviceDefinition(
    model: .iPadAir3, family: .pad,
    name: "iPad Air (3rd generation)",
    identifiers: ["iPad11,3", "iPad11,4"],
    cpu: .a12Bionic,
    capabilities: [.touchID, .eSIM],
    cameras: [.wide],
    applePencilSupport: .firstGeneration,
    screens: [
      .init(
        role: .main, diagonal: 10.5, ppi: 264,
        screenRatio: .init(width: 3, height: 4), resolution: nil)
    ]
  )
}
