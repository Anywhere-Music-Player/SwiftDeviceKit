// Copyright © 2014 - 2018 Dennis Weissmann and the DeviceKit project authors
// SPDX-License-Identifier: MIT

extension DeviceDefinition {
  static let iPadPro11Inch4 = DeviceDefinition(
    model: .iPadPro11Inch4, family: .pad,
    name: "iPad Pro (11-inch) (4th generation)",
    identifiers: ["iPad14,3", "iPad14,4"],
    cpu: .m2,
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
