import Foundation
import Testing

@testable import SwiftDeviceKitCore

private struct MigrationSnapshot: Decodable {
  struct Model: Decodable {
    let identifier: String
    let cpu: String
    let cameras: [String]
    let pencil: UInt
  }
  let models: [Model]
  let groups: [String: [String]]
}

@Suite("Swift catalog migration")
struct CatalogMigrationTests {
  @Test
  func hardwareAndOrderedGroupsMatchThePreMigrationCatalog() throws {
    let url = try #require(
      Bundle.module.url(forResource: "SwiftCatalogMigration", withExtension: "json"))
    let snapshot = try JSONDecoder().decode(MigrationSnapshot.self, from: Data(contentsOf: url))
    let excluded = try CatalogSupportPolicy.excludedIdentifiers()
    let supported = snapshot.models.filter { !excluded.contains($0.identifier) }
    #expect(supported.count == 66)
    for expected in supported {
      let model = Device.mapToDevice(identifier: expected.identifier)
      for device in [model, .simulator(model)] {
        #expect(device.cpu.description == expected.cpu)
        #expect(device.cameras.map { String(describing: $0) } == expected.cameras)
        #expect(device.applePencilSupport.rawValue == expected.pencil)
      }
    }
    let actualGroups: [String: [Device]] = [
      "allPhones": Device.allPhones,
      "allPads": Device.allPads,
      "allPlusSizedDevices": Device.allPlusSizedDevices,
      "allProDevices": Device.allProDevices,
      "allMiniDevices": Device.allMiniDevices,
      "allTouchIDCapableDevices": Device.allTouchIDCapableDevices,
      "allFaceIDCapableDevices": Device.allFaceIDCapableDevices,
      "allBiometricAuthenticationCapableDevices": Device.allBiometricAuthenticationCapableDevices,
      "allDevicesWithSensorHousing": Device.allDevicesWithSensorHousing,
      "allDevicesWithRoundedDisplayCorners": Device.allDevicesWithRoundedDisplayCorners,
      "allDevicesWithDynamicIsland": Device.allDevicesWithDynamicIsland,
      "allDevicesWith3dTouchSupport": Device.allDevicesWith3dTouchSupport,
      "allDevicesWithWirelessChargingSupport": Device.allDevicesWithWirelessChargingSupport,
      "allDevicesWith5gSupport": Device.allDevicesWith5gSupport,
      "allDevicesWithEsimSupport": Device.allDevicesWithEsimSupport,
      "allDevicesWithDualEsimSupport": Device.allDevicesWithDualEsimSupport,
      "allDevicesWithALidarSensor": Device.allDevicesWithALidarSensor,
      "allDevicesWithUSBCConnectivity": Device.allDevicesWithUSBCConnectivity,
      "allApplePencilCapableDevices": Device.allApplePencilCapableDevices,
      "allDevicesWithCamera": Device.allDevicesWithCamera,
      "allDevicesWithWideCamera": Device.allDevicesWithWideCamera,
      "allDevicesWithTelephotoCamera": Device.allDevicesWithTelephotoCamera,
      "allDevicesWithUltraWideCamera": Device.allDevicesWithUltraWideCamera,
    ]
    let expectedGroups = snapshot.groups.filter { $0.key != "allPods" }
    #expect(Set(actualGroups.keys) == Set(expectedGroups.keys))
    for (name, identifiers) in expectedGroups {
      #expect(
        actualGroups[name]
          == identifiers.filter { !excluded.contains($0) }.map {
            Device.mapToDevice(identifier: $0)
          },
        "\(name)")
    }
  }

  @Test
  func definitionsHaveUniqueIdentifiersAndMatchTheirRegisteredCase() {
    let definitions = DeviceCatalog.all
    let identifiers = definitions.flatMap(\.identifiers)
    #expect(definitions.count == 66)
    #expect(Set(identifiers).count == identifiers.count)
    #expect(identifiers.count == 105)
    #expect(Set(definitions.map { $0.model.description }).count == definitions.count)
    for definition in definitions {
      #expect(!definition.identifiers.isEmpty)
      #expect(definition.model.definition?.identifiers == definition.identifiers)
      for identifier in definition.identifiers {
        #expect(Device.mapToDevice(identifier: identifier) == definition.model)
      }
      let roles = definition.screens.map(\.role)
      #expect(Set(roles).count == roles.count)
      #expect(!roles.isEmpty)
      for screen in definition.screens {
        #expect(screen.diagonal > 0)
        #expect(screen.ppi > 0)
        #expect(screen.screenRatio.width > 0 && screen.screenRatio.height > 0)
      }
    }
  }
}
