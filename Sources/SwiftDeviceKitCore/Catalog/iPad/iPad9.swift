// Copyright © 2014 - 2018 Dennis Weissmann and the DeviceKit project authors
// SPDX-License-Identifier: MIT

extension DeviceDefinition {
  static let iPad9 = DeviceDefinition(
    model: .iPad9, family: .pad,
    name: "iPad (9th generation)",
    identifiers: ["iPad12,1", "iPad12,2"],
    cpu: .a13Bionic,
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
