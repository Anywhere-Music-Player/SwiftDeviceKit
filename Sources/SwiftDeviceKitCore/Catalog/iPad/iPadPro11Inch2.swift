// Copyright © 2014 - 2018 Dennis Weissmann and the DeviceKit project authors
// SPDX-License-Identifier: MIT

extension DeviceDefinition {
  static let iPadPro11Inch2 = DeviceDefinition(
    model: .iPadPro11Inch2, family: .pad,
    name: "iPad Pro (11-inch) (2nd generation)",
    identifiers: ["iPad8,9", "iPad8,10"],
    cpu: .a12ZBionic,
    capabilities: [.pro, .faceID, .roundedDisplayCorners, .eSIM, .lidar, .usbC],
    cameras: [.wide, .ultraWide],
    applePencilSupport: [.secondGeneration, .firstGenerationUsbC],
    screens: [
      .init(
        role: .main, diagonal: 11, ppi: 264,
        screenRatio: .init(width: 139, height: 199), resolution: nil)
    ]
  )
}
