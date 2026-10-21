// Copyright © 2014 - 2018 Dennis Weissmann and the DeviceKit project authors
// SPDX-License-Identifier: MIT

extension DeviceDefinition {
  static let iPadPro12Inch5 = DeviceDefinition(
    model: .iPadPro12Inch5, family: .pad,
    name: "iPad Pro (12.9-inch) (5th generation)",
    identifiers: ["iPad13,8", "iPad13,9", "iPad13,10", "iPad13,11"],
    cpu: .m1,
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
