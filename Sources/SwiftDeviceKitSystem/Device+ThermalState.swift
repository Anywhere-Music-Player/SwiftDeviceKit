// Copyright © 2014 - 2018 Dennis Weissmann and the DeviceKit project authors
// SPDX-License-Identifier: MIT

import Foundation
public import SwiftDeviceKitCore

// MARK: ThermalState

extension Device {
  /// The thermal state of the system.
  public enum ThermalState: Sendable {
    /// The thermal state is within normal limits.
    case nominal
    /// The thermal state is slightly elevated.
    case fair
    /// The thermal state is high.
    case serious
    /// The thermal state is significantly impacting the performance of the system and the device needs to cool down.
    case critical
  }

  /// Returns the current thermal state of the system (or nil if not called against the `current` device)
  public var thermalState: ThermalState? {
    guard isCurrent else { return nil }
    switch ProcessInfo().thermalState {
    case .nominal:
      return .nominal
    case .fair:
      return .fair
    case .serious:
      return .serious
    case .critical:
      return .critical
    @unknown default:
      return .nominal
    }
  }
}
