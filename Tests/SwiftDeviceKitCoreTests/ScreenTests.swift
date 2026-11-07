import SwiftDeviceKitCore
import Testing

@Suite("Built-in screen catalog")
struct ScreenTests {
  @Test
  func singleScreenModelsKeepTheirCatalogMetrics() throws {
    let models = Device.allRealDevices
    for device in models where device != .iPhoneDuo {
      #expect(device.screens.count == 1)
      let screen = try #require(device.screen(.main))
      #expect(screen.diagonal == device.diagonal)
      #expect(screen.ppi == device.ppi)
      #expect(screen.screenRatio.width == device.screenRatio.width)
      #expect(screen.screenRatio.height == device.screenRatio.height)
      if device == .iPadMiniA20Pro {
        #expect(screen.resolution?.width == 1512)
        #expect(screen.resolution?.height == 2316)
      } else {
        #expect(screen.resolution == nil)
      }
      #expect(device.screen(.outer) == nil)
      #expect(device.screen(.inner) == nil)
    }
  }

  @Test
  func missingScreensDoNotProduceSentinelRecords() {
    for device in [Device.unknown("future-model")] {
      #expect(device.screens.isEmpty)
      #expect(device.screen(.main) == nil)
      #expect(device.screen(.outer) == nil)
      #expect(device.screen(.inner) == nil)
      #expect(Device.simulator(device).screens.isEmpty)
    }
  }

  @Test
  func simulatorScreensDescribeTheirModel() {
    for model in Device.allRealDevices + [.unknown("future-model")] {
      #expect(Device.simulator(model).screens == model.screens)
      #expect(Device.simulator(.simulator(model)).screens == model.screens)
    }
  }

  @Test
  func screenSpecificationsCrossActorBoundaries() async {
    let screens = await Task.detached {
      Device.mapToDevice(identifier: "iPhone19,4").screens
    }.value
    #expect(screens == Device.iPhoneDuo.screens)
    #expect(screens.map(\.ppi) == [460, 430])
  }
}
