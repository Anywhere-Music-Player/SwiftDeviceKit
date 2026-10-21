// Copyright © 2014 - 2018 Dennis Weissmann and the DeviceKit project authors
// SPDX-License-Identifier: MIT

extension DeviceDefinition {
  static let iPadPro11M5 = DeviceDefinition(
    model: .iPadPro11M5, family: .pad,
    name: "iPad Pro (11-inch) (M5)",
    identifiers: ["iPad17,1", "iPad17,2"],
    cpu: .m5,
    capabilities: [.pro, .faceID, .roundedDisplayCorners, .fiveG, .eSIM, .lidar, .usbC],
    cameras: [.wide],
    applePencilSupport: [.secondGeneration, .firstGenerationUsbC, .pro],
    screens: [
      .init(
        role: .main, diagonal: 11, ppi: 264,
        screenRatio: .init(width: 605, height: 417), resolution: nil)
    ]
  )
}
