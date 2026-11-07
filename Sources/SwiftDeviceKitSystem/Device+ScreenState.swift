// Copyright © 2014 - 2018 Dennis Weissmann and the DeviceKit project authors
// SPDX-License-Identifier: MIT

public import SwiftDeviceKitCore
#if os(iOS)
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

  /// Starts UIKit's physical orientation notifications for the current device.
  /// Balance each call with `endOrientationUpdates()` when the reading is no longer needed.
  @MainActor
  public static func beginOrientationUpdates() {
    UIDevice.current.beginGeneratingDeviceOrientationNotifications()
  }

  /// Ends one request for orientation updates. Other UIKit observers keep their own requests.
  @MainActor
  public static func endOrientationUpdates() {
    UIDevice.current.endGeneratingDeviceOrientationNotifications()
  }

  /// Physical orientation of the current device. Start updates before reading this property.
  /// It can be unknown before the first reading and while the device is face up or face down.
  @MainActor
  public var orientation: Orientation {
    switch UIDevice.current.orientation {
    case .landscapeLeft, .landscapeRight: .landscape
    case .portrait, .portraitUpsideDown: .portrait
    default: .unknown
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

  /// Screen brightness in percent, or nil when UIKit has no reading.
  @MainActor
  public var screenBrightness: Int? {
    let brightness = UIScreen.main.brightness
    guard (0...1).contains(brightness) else { return nil }
    return Int(brightness * 100)
  }
}
#elseif os(watchOS) || os(tvOS)
extension Device {
  /// Historical DeviceKit fallback on Watch and TV. The OS exposes no brightness reading.
  public var screenBrightness: Int { 100 }
}
#endif
