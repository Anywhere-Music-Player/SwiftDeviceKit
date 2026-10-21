// Copyright © 2014 - 2018 Dennis Weissmann and the DeviceKit project authors
// SPDX-License-Identifier: MIT

extension Device {
  /**
    This option set describes the current Apple Pencils
    - firstGeneration: 1st Generation Apple Pencil
    - secondGeneration: 2nd Generation Apple Pencil
    - firstGenerationUsbC: 1st Generation Apple Pencil (USB-C)
    - pro: Apple Pencil Pro
   */
  public struct ApplePencilSupport: OptionSet, Sendable {

    public var rawValue: UInt

    public init(rawValue: UInt) {
      self.rawValue = rawValue
    }

    public static let firstGeneration = ApplePencilSupport(rawValue: 0x01)
    public static let secondGeneration = ApplePencilSupport(rawValue: 0x02)
    public static let firstGenerationUsbC = ApplePencilSupport(rawValue: 0x04)
    public static let pro = ApplePencilSupport(rawValue: 0x08)
  }
}
