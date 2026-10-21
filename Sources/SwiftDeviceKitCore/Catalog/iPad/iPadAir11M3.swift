// Copyright © 2014 - 2018 Dennis Weissmann and the DeviceKit project authors
// SPDX-License-Identifier: MIT

extension DeviceDefinition {
  static let iPadAir11M3 = DeviceDefinition(
    model: .iPadAir11M3, family: .pad,
    name: "iPad Air (11-inch) (M3)",
    identifiers: ["iPad15,3", "iPad15,4"],
    cpu: .m3,
    capabilities: [.touchID, .roundedDisplayCorners, .fiveG, .eSIM, .usbC],
    cameras: [.wide],
    applePencilSupport: [.firstGenerationUsbC, .pro],
    screens: [
      .init(
        role: .main, diagonal: 10.9, ppi: 264,
        screenRatio: .init(width: 59, height: 41), resolution: nil)
    ]
  )
}
