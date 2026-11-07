// Copyright © 2014 - 2018 Dennis Weissmann and the DeviceKit project authors
// SPDX-License-Identifier: MIT

import Foundation
public import SwiftDeviceKitCore
#if os(watchOS)
import WatchKit
#elseif !os(macOS)
import UIKit
#endif

extension Device {
  var isCurrent: Bool { self == Device.current }

  /// Current OS power-saving state, including on Macs without an internal battery.
  public var isLowPowerModeEnabled: Bool? {
    guard isCurrent else { return nil }
    return ProcessInfo.processInfo.isLowPowerModeEnabled
  }

  /// Known models use their hardware family, including iPads running iPhone-only apps.
  @MainActor
  public var isPhone: Bool {
    if let family { return family == .phone }
    #if os(iOS)
      return isCurrent && !DeviceHost.isIOSAppOnMac && UIDevice.current.userInterfaceIdiom == .phone
    #else
      return false
    #endif
  }

  @MainActor
  public var isPad: Bool {
    if let family { return family == .pad }
    #if os(iOS)
      return isCurrent && !DeviceHost.isIOSAppOnMac && UIDevice.current.userInterfaceIdiom == .pad
    #else
      return false
    #endif
  }

  #if os(watchOS)
  @MainActor private var systemDevice: WKInterfaceDevice { WKInterfaceDevice.current() }
  #elseif !os(macOS)
  @MainActor private var systemDevice: UIDevice { UIDevice.current }
  #endif

  /// The name identifying the current device, subject to platform privacy restrictions.
  @MainActor
  public var name: String? {
    guard isCurrent else { return nil }
    #if os(macOS)
      return Host.current().localizedName
    #else
      return systemDevice.name
    #endif
  }

  @MainActor
  public var systemName: String? {
    guard isCurrent else { return nil }
    #if os(macOS)
      return "macOS"
    #else
      if DeviceHost.isIOSAppOnMac { return "macOS" }
      #if os(iOS)
        if isVision { return "visionOS" }
      #endif
      if isPad, systemDevice.systemName == "iOS" { return "iPadOS" }
      return systemDevice.systemName
    #endif
  }

  @MainActor
  public var systemVersion: String? {
    guard isCurrent else { return nil }
    #if os(macOS)
      return DeviceHost.systemVersion
    #else
      if DeviceHost.isIOSAppOnMac { return DeviceHost.systemVersion }
      #if os(iOS)
        if isVision {
          #if targetEnvironment(simulator)
            return ProcessInfo.processInfo.environment["SIMULATOR_RUNTIME_VERSION"]
          #else
            return DeviceHost.systemVersion
          #endif
        }
      #endif
      return systemDevice.systemVersion
    #endif
  }

  #if !os(macOS)
  private var compatibilityModel: String? {
    #if os(iOS)
      if DeviceHost.isIOSAppOnMac { return "Mac" }
      if isVision {
        if case .unidentifiedVision = realDevice { return "Apple Vision" }
        return "Apple Vision Pro"
      }
    #endif
    return nil
  }
  #endif

  @MainActor
  public var model: String? {
    guard isCurrent else { return nil }
    #if os(macOS)
      return "Mac"
    #else
      return compatibilityModel ?? systemDevice.model
    #endif
  }

  @MainActor
  public var localizedModel: String? {
    guard isCurrent else { return nil }
    #if os(macOS)
      return "Mac"
    #else
      return compatibilityModel ?? systemDevice.localizedModel
    #endif
  }

  /// DeviceKit returns false on Watch and TV.
  @MainActor
  public var isGuidedAccessSessionActive: Bool {
    #if os(iOS) || os(visionOS)
      UIAccessibility.isGuidedAccessEnabled
    #else
      false
    #endif
  }
}
