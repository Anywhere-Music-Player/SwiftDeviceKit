// Copyright © 2014 - 2018 Dennis Weissmann and the DeviceKit project authors
// SPDX-License-Identifier: MIT

extension Device: CustomStringConvertible {
  /// A textual representation of the device.
  public var description: String {
    if let definition, !isSimulator { return definition.name }
    switch self {
    case .simulator(let model): return "Simulator (\(model.description))"
    case .unknown(let identifier): return identifier
    default: preconditionFailure("Every known Device case must have a catalog definition")
    }
  }

  /// A safe version of `description`.
  /// Example:
  /// Device.iPhoneXR.description:     iPhone Xʀ
  /// Device.iPhoneXR.safeDescription: iPhone XR
  public var safeDescription: String {
    if let definition, !isSimulator { return definition.safeName }
    switch self {
    case .simulator(let model): return "Simulator (\(model.safeDescription))"
    case .unknown(let identifier): return identifier
    default: preconditionFailure("Every known Device case must have a catalog definition")
    }
  }
}
