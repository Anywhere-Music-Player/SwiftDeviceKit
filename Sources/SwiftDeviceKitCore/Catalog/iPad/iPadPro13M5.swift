// Copyright © 2014 - 2018 Dennis Weissmann and the DeviceKit project authors
// SPDX-License-Identifier: MIT

extension DeviceDefinition {
  static let iPadPro13M5 = DeviceDefinition(
    model: .iPadPro13M5, family: .pad,
    name: "iPad Pro (13-inch) (M5)",
    identifiers: ["iPad17,3", "iPad17,4"],
    cpu: .m5,
    capabilities: [.pro, .faceID, .roundedDisplayCorners, .fiveG, .eSIM, .lidar, .usbC],
    cameras: [.wide],
    applePencilSupport: [.secondGeneration, .firstGenerationUsbC, .pro],
    screens: [
      .init(
        role: .main, diagonal: 13, ppi: 264,
        screenRatio: .init(width: 4, height: 3), resolution: nil)
    ]
  )
}
