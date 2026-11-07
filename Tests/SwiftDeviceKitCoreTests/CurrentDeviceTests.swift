import Foundation
import Testing

@testable import SwiftDeviceKitCore

@Suite("Core device identity")
struct CurrentDeviceTests {
  @Test func iPadCompatibilityOnVisionPreservesTheHostFamily() {
    #expect(Device.currentHardware("RealityDevice17,1", iOSAppOnVision: true) == .appleVisionProM5)
    for id in ["iPad8,6", "RealityDevice99,1"] {
      let host = Device.currentHardware(id, iOSAppOnVision: true)
      #expect(host == .unidentifiedVision(reportedIdentifier: id))
      #expect(host.isVision)
      #expect(Device.simulator(host).isVision)
      #expect(host.cpu == .unknown)
    }
    #expect(Device.currentHardware("iPad8,6", iOSAppOnVision: false) == .iPadPro12Inch3)
    #expect(Device.mapToDevice(identifier: "iPad8,6") == .iPadPro12Inch3)
    #expect(Device.mapToDevice(identifier: "RealityDevice99,1") == .unknown("RealityDevice99,1"))
  }

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
          == .unknown(architecture))
      // Malformed environment values must not recurse indefinitely.
      #expect(
        Device.resolve(identifier: architecture, simulatorModelIdentifier: architecture)
          == .simulator(.unknown(architecture)))
    }
  }

  @Test func missingAndEmptySimulatorModelsKeepTheRawIdentifier() {
    for model: String? in [nil, ""] {
      for raw in ["arm64", "x86_64"] {
        #expect(Device.currentSimulator(rawIdentifier: raw, modelIdentifier: model, iOSAppOnVision: false)
          == .simulator(.unknown(raw)))
        #expect(Device.resolve(identifier: raw, simulatorModelIdentifier: model) == .unknown(raw))
      }
      #expect(Device.currentSimulator(rawIdentifier: "arm64", modelIdentifier: model, iOSAppOnVision: true)
        == .simulator(.unidentifiedVision(reportedIdentifier: "arm64")))
    }
    #expect(Device.currentSimulator(rawIdentifier: "arm64", modelIdentifier: "iPhone19,4", iOSAppOnVision: false)
      == .simulator(.iPhoneDuo))
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
  func currentDeviceMatchesTheSimulatorProvidedModel() {
    #if targetEnvironment(simulator)
      let supplied = ProcessInfo.processInfo.environment["SIMULATOR_MODEL_IDENTIFIER"]
      let identifier = supplied.flatMap { $0.isEmpty ? nil : $0 } ?? Device.identifier
      if case .unidentifiedVision(let reported) = Device.current.realDevice {
        #expect(DeviceHost.isIOSAppOnVision && reported == identifier && Device.current.isSimulator)
      } else {
        #expect(Device.current == .simulator(Device.mapToDevice(identifier: identifier)))
      }
    #else
      if case .unidentifiedVision(let reported) = Device.current {
        #expect(DeviceHost.isIOSAppOnVision && reported == Device.identifier)
      } else {
        #expect(Device.current == Device.mapToDevice(identifier: Device.identifier))
      }
    #endif
  }
}
