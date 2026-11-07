// Copyright © 2014 - 2018 Dennis Weissmann and the DeviceKit project authors
// SPDX-License-Identifier: MIT

extension DeviceDefinition {
  static let iPadPro11M4 = DeviceDefinition(
    model: .iPadPro11M4, family: .pad,
    name: "iPad Pro (11-inch) (M4)",
    identifiers: ["iPad16,3", "iPad16,4"],
    cpu: .m4,
    capabilities: [.pro, .faceID, .roundedDisplayCorners, .fiveG, .eSIM, .lidar, .usbC],
    cameras: [.wide],
    applePencilSupport: [.firstGenerationUsbC, .pro],
    screens: [
      .init(
        role: .main, diagonal: 11, ppi: 264,
        screenRatio: .init(width: 417, height: 605), resolution: nil)
    ]
  )
}
