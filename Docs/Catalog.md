# Extending the catalog

Each model is an immutable `DeviceDefinition` value declared in an extension.
Models share the same typed fields; they do not subclass one another.

```text
Sources/SwiftDeviceKitCore/
  Device.swift                         Public Device cases
  Catalog/
    DeviceDefinition.swift             Shared record fields and capabilities
    DeviceCatalog.swift                Registration and case-to-record mapping
    Device+Catalog.swift               Queries and capability groups
    iPhone/iPhone18Pro.swift            One model's IDs and specifications
    iPhone/iPhoneDuo.swift              Duo, including both display records
    iPad/, Watch/, TV/, Mac/, Vision/   Model records for the other families
  Hardware/                            Screen, CPU, camera and Pencil value types
  Device+Current.swift                 Identity, simulator and preview detection
Sources/SwiftDeviceKitSystem/
  Device.swift                         Public alias of Core's Device
  Device+System.swift                   Platform-specific device and OS names
  Device+Battery.swift                 Battery state
  Device+ThermalState.swift             Thermal state
  Device+Display.swift                 Current main display pixels where exposed
  Device+Storage.swift                  Disk capacity
  Device+ScreenState.swift              Existing orientation, brightness and zoom APIs
  PrivacyInfo.xcprivacy                 Disk-space API declarations
```

Identifiers, names, screens and capabilities are defined only in the model record.
For example, `Catalog/iPhone/iPhone18Pro.swift` contains:

```swift
extension DeviceDefinition {
  static let iPhone18Pro = DeviceDefinition(
    model: .iPhone18Pro, family: .phone,
    name: "iPhone 18 Pro",
    identifiers: ["iPhone19,2"],
    cpu: .a20Pro,
    capabilities: [
      .pro, .xSeries, .faceID, .sensorHousing, .roundedDisplayCorners, .dynamicIsland,
      .wirelessCharging, .fiveG, .eSIM, .dualESIM, .lidar, .usbC, .actionButton, .variableAperture,
    ],
    cameras: [.wide, .telephoto, .ultraWide],
    applePencilSupport: [],
    screens: [
      .init(
        role: .main, diagonal: 6.3, ppi: 460,
        screenRatio: .init(width: 9, height: 19.5), resolution: nil)
    ]
  )
}
```

The public `Device` remains an enum so existing cases and pattern matching stay
available. A central registry is explicit: Swift does not discover extension
records by scanning source files at runtime. Capability groups are derived from
the registered records, and identifier lookup uses an immutable index.

## Hardware capability lookup

Use `Device.current.hasActionButton` to check the current model and
`Device.allDevicesWithActionButton` to list matching catalog models. Simulator
wrappers report their model's capability, and unknown models return `false`.
Apple distinguishes the customizable Action button from Camera Control on
[its iPhone controls page](https://support.apple.com/105103). The iPhone Duo
has Camera Control and no Action button in its [hardware specifications](https://www.apple.com/iphone-duo/specs/).

`Device.current.hasVariableAperture` reports whether the model has a lens with a
physically adjustable aperture. `Device.allDevicesWithVariableAperture` lists the
matching models. Apple specifies this capability for the 48 MP Fusion Main camera
on [iPhone 18 Pro and iPhone 18 Pro Max](https://www.apple.com/iphone-18-pro/specs/).

## Adding a model

1. Add the public case to `Device.swift`.
2. Add a model file under the appropriate `Catalog/` family, using named fields
   and verified identifiers/specifications. Reuse existing hardware types where applicable.
3. Register the record in `DeviceCatalog.all` and map the new case in
   `Device.definition`, both in `Catalog/DeviceCatalog.swift`. Preserve existing
   catalog order; the exhaustive switch reports missing case mappings at compile time.
4. Add regression coverage for the identifiers and relevant capabilities. Run the
   [catalog tests](Testing.md). Keep frozen fixtures unchanged; extend tests deliberately
   when adding a model to an existing public group.

No generation command is needed. SwiftPM includes the model files directly.

[Back to README](../README.md)
