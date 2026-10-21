// Copyright © 2014 - 2018 Dennis Weissmann and the DeviceKit project authors
// SPDX-License-Identifier: MIT

extension DeviceDefinition {
  static let iPadPro12Inch6 = DeviceDefinition(
    model: .iPadPro12Inch6, family: .pad,
    name: "iPad Pro (12.9-inch) (6th generation)",
    identifiers: ["iPad14,5", "iPad14,6"],
    cpu: .m2,
    capabilities: [.pro, .faceID, .roundedDisplayCorners, .fiveG, .eSIM, .lidar, .usbC],
    cameras: [.wide, .ultraWide],
    applePencilSupport: [.secondGeneration, .firstGenerationUsbC],
    screens: [
      .init(
        role: .main, diagonal: 12.9, ppi: 264,
        screenRatio: .init(width: 512, height: 683), resolution: nil)
    ]
  )
}
