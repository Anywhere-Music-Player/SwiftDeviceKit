// Copyright © 2014 - 2018 Dennis Weissmann and the DeviceKit project authors
// SPDX-License-Identifier: MIT

extension DeviceDefinition {
  static let iPadMini5 = DeviceDefinition(
    model: .iPadMini5, family: .pad,
    name: "iPad mini (5th generation)",
    identifiers: ["iPad11,1", "iPad11,2"],
    cpu: .a12Bionic,
    capabilities: [.mini, .touchID, .eSIM],
    cameras: [.wide],
    applePencilSupport: .firstGeneration,
    screens: [
      .init(
        role: .main, diagonal: 7.9, ppi: 326,
        screenRatio: .init(width: 3, height: 4), resolution: nil)
    ]
  )
}
