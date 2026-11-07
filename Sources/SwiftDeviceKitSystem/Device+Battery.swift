// Copyright © 2014 - 2018 Dennis Weissmann and the DeviceKit project authors
// SPDX-License-Identifier: MIT

public import SwiftDeviceKitCore
import UIKit

// MARK: Battery

extension Device {
  /**
   This enum describes the state of the battery.

   - Full:      The device is plugged into power and the battery is 100% charged or the device is the iOS Simulator.
   - Charging:  The device is plugged into power and the battery is less than 100% charged.
   - Unplugged: The device is not plugged into power; the battery is discharging.
   */
  public enum BatteryState: CustomStringConvertible, Equatable, Sendable {
    /// The device is plugged into power and the battery is 100% charged or the device is the iOS Simulator.
    case full
    /// The device is plugged into power and the battery is less than 100% charged.
    /// The associated value is in percent (0-100).
    case charging(Int)
    /// The device is not plugged into power; the battery is discharging.
    /// The associated value is in percent (0-100).
    case unplugged(Int)

    @MainActor
    fileprivate init() {
      let wasBatteryMonitoringEnabled = UIDevice.current.isBatteryMonitoringEnabled
      UIDevice.current.isBatteryMonitoringEnabled = true
      let batteryLevel = Int(round(UIDevice.current.batteryLevel * 100))  // round() is actually not needed anymore since -[batteryLevel] seems to always return a two-digit precision number
      // but maybe that changes in the future.
      switch UIDevice.current.batteryState {
      case .charging: self = .charging(batteryLevel)
      case .full: self = .full
      case .unplugged: self = .unplugged(batteryLevel)
      case .unknown: self = .full  // Should never happen since `batteryMonitoring` is enabled.
      @unknown default:
        self = .full  // To cover any future additions for which DeviceKit might not have updated yet.
      }
      UIDevice.current.isBatteryMonitoringEnabled = wasBatteryMonitoringEnabled
    }

    /// The user enabled Low Power mode
    public var lowPowerMode: Bool {
      return ProcessInfo.processInfo.isLowPowerModeEnabled
    }

    /// Provides a textual representation of the battery state.
    /// Examples:
    /// ```
    /// Battery level: 90%, device is plugged in.
    /// Battery level: 100 % (Full), device is plugged in.
    /// Battery level: \(batteryLevel)%, device is unplugged.
    /// ```
    public var description: String {
      switch self {
      case .charging(let batteryLevel):
        return "Battery level: \(batteryLevel)%, device is plugged in."
      case .full: return "Battery level: 100 % (Full), device is plugged in."
      case .unplugged(let batteryLevel):
        return "Battery level: \(batteryLevel)%, device is unplugged."
      }
    }

  }

  /// The state of the battery
  @MainActor
  public var batteryState: BatteryState? {
    guard isCurrent else { return nil }
    return BatteryState()
  }

  /// Battery level ranges from 0 (fully discharged) to 100 (100% charged).
  @MainActor
  public var batteryLevel: Int? {
    guard isCurrent else { return nil }
    switch BatteryState() {
    case .charging(let value): return value
    case .full: return 100
    case .unplugged(let value): return value
    }
  }

}

// MARK: Device.Batterystate: Comparable

extension Device.BatteryState: Comparable {
  /// Compares two battery states.
  ///
  /// - parameter lhs: A battery state.
  /// - parameter rhs: Another battery state.
  ///
  /// Full sorts last. Otherwise compare charge percentages, with unplugged before charging
  /// at the same percentage. Equality retains both the state and its associated percentage.
  public static func < (lhs: Device.BatteryState, rhs: Device.BatteryState) -> Bool {
    switch (lhs, rhs) {
    case (.full, _): return false  // return false (even if both are `.Full` -> they are equal)
    case (_, .full): return true  // lhs is *not* `.Full`, rhs is
    case (.charging(let lhsLevel), .charging(let rhsLevel)): return lhsLevel < rhsLevel
    case (.charging(let lhsLevel), .unplugged(let rhsLevel)): return lhsLevel < rhsLevel
    case (.unplugged(let lhsLevel), .charging(let rhsLevel)): return lhsLevel <= rhsLevel
    case (.unplugged(let lhsLevel), .unplugged(let rhsLevel)): return lhsLevel < rhsLevel
    }
  }
}
