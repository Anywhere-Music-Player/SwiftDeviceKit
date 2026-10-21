// Copyright © 2014 - 2018 Dennis Weissmann and the DeviceKit project authors
// SPDX-License-Identifier: MIT

extension DeviceDefinition {
  static let iPadPro12Inch4 = DeviceDefinition(
    model: .iPadPro12Inch4, family: .pad,
    name: "iPad Pro (12.9-inch) (4th generation)",
    identifiers: ["iPad8,11", "iPad8,12"],
    cpu: .a12ZBionic,
    capabilities: [.pro, .faceID, .roundedDisplayCorners, .eSIM, .lidar, .usbC],
    cameras: [.wide, .ultraWide],
    applePencilSupport: [.secondGeneration, .firstGenerationUsbC],
    screens: [
      .init(
        role: .main, diagonal: 12.9, ppi: 264,
        screenRatio: .init(width: 512, height: 683), resolution: nil)
    ]
  )
}
