// Copyright © 2014 - 2018 Dennis Weissmann and the DeviceKit project authors
// SPDX-License-Identifier: MIT

public import SwiftDeviceKitCore
import UIKit

extension Device {
  var isCurrent: Bool { self == Device.current }

  /// Returns whether the device is an iPhone (real or simulator)
  @MainActor
  public var isPhone: Bool {
    return isOneOf(Device.allPhones)
      || isOneOf(Device.allSimulatorPhones)
      || (UIDevice.current.userInterfaceIdiom == .phone && isCurrent)
  }

  /// Returns whether the device is an iPad (real or simulator)
  @MainActor
  public var isPad: Bool {
    return isOneOf(Device.allPads)
      || isOneOf(Device.allSimulatorPads)
      || (UIDevice.current.userInterfaceIdiom == .pad && isCurrent)
  }

  /// The name identifying the device (e.g. "Dennis' iPhone").
  /// As of iOS 16, this will return a generic String like "iPhone", unless your app has additional entitlements.
  /// See the follwing link for more information: https://developer.apple.com/documentation/uikit/uidevice/1620015-name
  @MainActor
  public var name: String? {
    guard isCurrent else { return nil }
    return UIDevice.current.name
  }

  /// The name of the operating system running on the device represented by the receiver (e.g. "iOS" or "iPadOS").
  @MainActor
  public var systemName: String? {
    guard isCurrent else { return nil }
    if isPad, UIDevice.current.systemName == "iOS" {
      return "iPadOS"
    } else {
      return UIDevice.current.systemName
    }
  }

  /// The current version of the operating system (e.g. 18.0 or 27.0).
  @MainActor
  public var systemVersion: String? {
    guard isCurrent else { return nil }
    return UIDevice.current.systemVersion
  }

  /// The model of the device (e.g. "iPhone" or "iPad").
  @MainActor
  public var model: String? {
    guard isCurrent else { return nil }
    return UIDevice.current.model
  }

  /// The model of the device as a localized string.
  @MainActor
  public var localizedModel: String? {
    guard isCurrent else { return nil }
    return UIDevice.current.localizedModel
  }

  /// True when a Guided Access session is currently active; otherwise, false.
  @MainActor
  public var isGuidedAccessSessionActive: Bool {
    return UIAccessibility.isGuidedAccessEnabled
  }

}
