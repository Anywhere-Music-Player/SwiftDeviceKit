// Copyright © 2014 - 2018 Dennis Weissmann and the DeviceKit project authors
// SPDX-License-Identifier: MIT

extension DeviceDefinition {
  static let iPadPro13M4 = DeviceDefinition(
    model: .iPadPro13M4, family: .pad,
    name: "iPad Pro (13-inch) (M4)",
    identifiers: ["iPad16,5", "iPad16,6"],
    cpu: .m4,
    capabilities: [.pro, .faceID, .roundedDisplayCorners, .fiveG, .eSIM, .lidar, .usbC],
    cameras: [.wide],
    applePencilSupport: [.firstGenerationUsbC, .pro],
    screens: [
      .init(
        role: .main, diagonal: 13, ppi: 264,
        screenRatio: .init(width: 3, height: 4), resolution: nil)
    ]
  )
}
