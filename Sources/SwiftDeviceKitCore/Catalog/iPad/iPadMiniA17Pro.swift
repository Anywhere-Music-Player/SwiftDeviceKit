// Copyright © 2014 - 2018 Dennis Weissmann and the DeviceKit project authors
// SPDX-License-Identifier: MIT

extension DeviceDefinition {
  static let iPadMiniA17Pro = DeviceDefinition(
    model: .iPadMiniA17Pro, family: .pad,
    name: "iPad mini (A17 Pro)",
    identifiers: ["iPad16,1", "iPad16,2"],
    cpu: .a17Pro,
    capabilities: [.mini, .touchID, .roundedDisplayCorners, .fiveG, .eSIM, .usbC],
    cameras: [.wide],
    applePencilSupport: [.firstGenerationUsbC, .pro],
    screens: [
      .init(
        role: .main, diagonal: 8.3, ppi: 326,
        screenRatio: .init(width: 744, height: 1133), resolution: nil)
    ]
  )
}
