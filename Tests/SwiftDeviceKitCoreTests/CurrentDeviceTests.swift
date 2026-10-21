import Foundation
import Testing

@testable import SwiftDeviceKitCore

@Suite("Core device identity")
struct CurrentDeviceTests {
  @Test
  func everySimulatorArchitectureResolvesWithoutChangingProcessEnvironment() {
    for architecture in ["i386", "x86_64", "arm64"] {
      #expect(
        Device.resolve(identifier: architecture, simulatorModelIdentifier: "iPhone19,4")
          == .simulator(.iPhoneDuo))
      #expect(
        Device.resolve(identifier: architecture, simulatorModelIdentifier: "iPad7,11")
          == .simulator(.iPad7))
      #expect(
        Device.resolve(identifier: architecture, simulatorModelIdentifier: "iPhone999,42")
          == .simulator(.unknown("iPhone999,42")))
      #expect(
        Device.resolve(identifier: architecture, simulatorModelIdentifier: nil)
          == .simulator(.unknown("iOS")))
      // Malformed environment values must not recurse indefinitely.
      #expect(
        Device.resolve(identifier: architecture, simulatorModelIdentifier: architecture)
          == .simulator(.unknown(architecture)))
    }
  }

  @Test
  func hardwareIdentifiersIgnoreSimulatorEnvironment() {
    #expect(
      Device.resolve(identifier: "iPhone19,2", simulatorModelIdentifier: "iPad7,11") == .iPhone18Pro
    )
    #expect(
      Device.resolve(identifier: "future-device", simulatorModelIdentifier: "iPhone19,4")
        == .unknown("future-device"))
  }

  @Test
  func currentDeviceMatchesTheSimulatorProvidedModel() throws {
    #if targetEnvironment(simulator)
      let identifier = try #require(
        ProcessInfo.processInfo.environment["SIMULATOR_MODEL_IDENTIFIER"])
      #expect(Device.current == .simulator(Device.mapToDevice(identifier: identifier)))
    #else
      #expect(Device.current == Device.mapToDevice(identifier: Device.identifier))
    #endif
  }
}
