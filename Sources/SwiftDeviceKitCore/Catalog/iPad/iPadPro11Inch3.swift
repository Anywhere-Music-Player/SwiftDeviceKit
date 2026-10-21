// Copyright © 2014 - 2018 Dennis Weissmann and the DeviceKit project authors
// SPDX-License-Identifier: MIT

extension DeviceDefinition {
  static let iPadPro11Inch3 = DeviceDefinition(
    model: .iPadPro11Inch3, family: .pad,
    name: "iPad Pro (11-inch) (3rd generation)",
    identifiers: ["iPad13,4", "iPad13,5", "iPad13,6", "iPad13,7"],
    cpu: .m1,
    capabilities: [.pro, .faceID, .roundedDisplayCorners, .fiveG, .eSIM, .lidar, .usbC],
    cameras: [.wide, .ultraWide],
    applePencilSupport: [.secondGeneration, .firstGenerationUsbC],
    screens: [
      .init(
        role: .main, diagonal: 11, ppi: 264,
        screenRatio: .init(width: 139, height: 199), resolution: nil)
    ]
  )
}
