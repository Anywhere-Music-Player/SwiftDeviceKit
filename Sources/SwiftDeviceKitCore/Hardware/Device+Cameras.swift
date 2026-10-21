// Copyright © 2014 - 2018 Dennis Weissmann and the DeviceKit project authors
// SPDX-License-Identifier: MIT

extension Device {
  public enum CameraType: Sendable {
    @available(*, deprecated, renamed: "wide")
    case normal

    case wide
    case telephoto
    case ultraWide
  }

  /// Returns whether or not the current device has a camera
  public var hasCamera: Bool {
    return !self.cameras.isEmpty
  }

  /// Returns whether or not the current device has a normal camera
  @available(*, deprecated, renamed: "hasWideCamera")
  public var hasNormalCamera: Bool {
    return self.hasWideCamera
  }

  /// Returns whether or not the current device has a wide camera
  public var hasWideCamera: Bool {
    return self.cameras.contains(.wide)
  }

  /// Returns whether or not the current device has a telephoto camera
  public var hasTelephotoCamera: Bool {
    return self.cameras.contains(.telephoto)
  }

  /// Returns whether or not the current device has an ultra wide camera
  public var hasUltraWideCamera: Bool {
    return self.cameras.contains(.ultraWide)
  }
}
