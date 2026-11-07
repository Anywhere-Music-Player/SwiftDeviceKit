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
  /// Whether the current screen uses an enlarged rendering scale.
  /// Downsampled standard modes (including iPhone mini) and iPad More Space are not zoomed.
  /// This describes display scaling, not the Accessibility Zoom magnifier or a view's geometry.
  @MainActor
  public var isZoomed: Bool? {
    guard isCurrent else { return nil }
    // The old 1080p Plus pipeline is outside this package's iOS 18+ catalog.
    // A 3x rendering scale does not identify that pipeline.
    return UIScreen.main.nativeScale > UIScreen.main.scale
  }

  /// The brightness level of the screen.
  @MainActor
  public var screenBrightness: Int {
    return Int(UIScreen.main.brightness * 100)
  }
}
