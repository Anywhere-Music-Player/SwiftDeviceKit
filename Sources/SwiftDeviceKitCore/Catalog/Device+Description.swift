// Copyright © 2014 - 2018 Dennis Weissmann and the DeviceKit project authors
// SPDX-License-Identifier: MIT

extension Device: CustomStringConvertible {
  /// A textual representation of the device.
  public var description: String {
    formattedName(safe: false)
  }

  /// A safe version of `description`.
  /// Example:
  /// Device.iPhoneXR.description:     iPhone Xʀ
  /// Device.iPhoneXR.safeDescription: iPhone XR
  public var safeDescription: String {
    formattedName(safe: true)
  }

  private func formattedName(safe: Bool) -> String {
    var base = self
    var depth = 0
    while case .simulator(let model) = base {
      depth += 1
      base = model
    }

    let name: String
    switch base {
    case .unknown(let identifier): name = identifier
    case .unidentifiedVision: name = "Apple Vision"
    default:
      guard let definition = base.definition else {
        preconditionFailure("Every known Device case must have a catalog definition")
      }
      name = safe ? definition.safeName : definition.name
    }
    guard depth > 0 else { return name }
    return String(repeating: "Simulator (", count: depth) + name + String(repeating: ")", count: depth)
  }
}
