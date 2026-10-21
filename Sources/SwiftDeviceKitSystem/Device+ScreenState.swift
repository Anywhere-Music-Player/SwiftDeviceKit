// Copyright © 2014 - 2018 Dennis Weissmann and the DeviceKit project authors
// SPDX-License-Identifier: MIT

public import SwiftDeviceKitCore
import UIKit

extension Device {
  // MARK: Orientation
  /**
    This enum describes the state of the orientation.
    - Landscape: The device is in Landscape Orientation
    - Portrait:  The device is in Portrait Orientation
    - Unknown:   The device orientation is unknown.
  */
  public enum Orientation: Sendable {
    case landscape
    case portrait
    case unknown
  }

  @MainActor
  public var orientation: Orientation {
    if UIDevice.current.orientation.isLandscape {
      return .landscape
    } else if UIDevice.current.orientation.isPortrait {
      return .portrait
    } else {
      return .unknown
    }
  }
}

extension Device {
  @MainActor
  public var isZoomed: Bool? {
    guard isCurrent else { return nil }
    if Int(UIScreen.main.scale.rounded()) == 3 {
      // Plus-sized
      return UIScreen.main.nativeScale > 2.7 && UIScreen.main.nativeScale < 3
    } else {
      return UIScreen.main.nativeScale > UIScreen.main.scale
    }
  }

  /// The brightness level of the screen.
  @MainActor
  public var screenBrightness: Int {
    return Int(UIScreen.main.brightness * 100)
  }
}
