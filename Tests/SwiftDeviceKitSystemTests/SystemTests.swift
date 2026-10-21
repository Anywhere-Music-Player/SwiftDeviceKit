import SwiftDeviceKitSystem
import Testing

@Suite("System module")
struct SystemTests {
  @Test @MainActor
  func systemImportIncludesTheCoreDeviceAPI() {
    let model: Device = .iPhoneDuo
    #expect(Device.mapToDevice(identifier: "iPhone19,4") == model)
    #expect(model.screen(.inner)?.ppi == 430)
    #expect(model.isPhone)
    #expect(!model.isPad)
  }

  @Test @MainActor
  func simulatorFamilyUsesTheSystemIdiom() {
    #if targetEnvironment(simulator)
      #expect(Device.current.isSimulator)
      #expect(Device.current.isPhone != Device.current.isPad)
      #expect(Device.current.systemName == (Device.current.isPad ? "iPadOS" : "iOS"))
    #endif
  }

  @Test @MainActor
  func runtimeStateOnlyAppliesToCurrentModel() {
    let other = Device.unknown("unavailable-test-model")
    #expect(other.name == nil)
    #expect(other.systemName == nil)
    #expect(other.systemVersion == nil)
    #expect(other.model == nil)
    #expect(other.localizedModel == nil)
    #expect(other.isCanvas == nil)
    #expect(other.batteryState == nil)
    #expect(other.batteryLevel == nil)
    #expect(other.thermalState == nil)
    #expect(other.isZoomed == nil)
  }
}
