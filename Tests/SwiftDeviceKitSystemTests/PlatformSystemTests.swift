import Foundation
import SwiftDeviceKitSystem
import Testing
#if os(watchOS)
import WatchKit
#endif

@Suite("Platform system state")
@MainActor
struct PlatformSystemTests {
  @Test func familyIsIndependentOfHost() {
    for device in Device.allRealDevices {
      #expect(device.isPhone == (device.family == .phone))
      #expect(device.isPad == (device.family == .pad))
    }
  }

  @Test func currentSystemServices() {
    let device = Device.current
    #expect(device.thermalState != nil)
    #expect(device.systemVersion?.isEmpty == false)
    #expect(device.model?.isEmpty == false)
    #expect((Device.volumeTotalCapacity ?? 0) > 0)
    #expect(Device.volumeAvailableCapacity != nil)
    #if os(macOS)
      #expect(device.isMac)
      #expect(!device.isSimulator)
      #expect(device.systemName == "macOS")
      #expect(Device.identifier != "arm64" && Device.identifier != "x86_64")
    #elseif os(watchOS)
      #expect(device.isWatch)
      let watch = WKInterfaceDevice.current()
      let previous = watch.isBatteryMonitoringEnabled
      _ = device.batteryState
      #expect(watch.isBatteryMonitoringEnabled == previous)
      #expect(device.systemVersion == watch.systemVersion)
    #elseif os(tvOS)
      #expect(device.isTV)
      #expect(device.systemName == "tvOS")
    #elseif os(visionOS)
      #expect(device.isVision)
      #expect(device.systemName == "visionOS")
    #endif
    #if targetEnvironment(simulator)
      #expect(device.isSimulator)
    #endif
    #if !os(visionOS)
      #expect(Device.unknown("other").currentDisplayPixels == nil)
    #endif
  }
}
