// Copyright © 2014 - 2018 Dennis Weissmann and the DeviceKit project authors
// SPDX-License-Identifier: MIT

extension DeviceDefinition {
  static let iPadPro12Inch3 = DeviceDefinition(
    model: .iPadPro12Inch3, family: .pad,
    name: "iPad Pro (12.9-inch) (3rd generation)",
    identifiers: ["iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8"],
    cpu: .a12XBionic,
    capabilities: [.pro, .faceID, .roundedDisplayCorners, .eSIM, .usbC],
    cameras: [.wide],
    applePencilSupport: [.secondGeneration, .firstGenerationUsbC],
    screens: [
      .init(
        role: .main, diagonal: 12.9, ppi: 264,
        screenRatio: .init(width: 512, height: 683), resolution: nil)
    ]
  )
}
