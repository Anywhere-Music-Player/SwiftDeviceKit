# SwiftDeviceKit

A modern Swift library for identifying iPhones and iPads and reading their
hardware capabilities. Based on [DeviceKit](https://github.com/devicekit/DeviceKit),
built for **iOS and iPadOS 18+** with **Swift 6**.

SwiftDeviceKit combines a device catalog written entirely in Swift with optional
system utilities. It has no external dependencies, uses `Sendable` value types
and provides `@MainActor` isolation for UIKit-backed APIs.

~~~swift
import SwiftDeviceKitCore

let device = Device.current

print(device.realDevice.description)
print(device.cpu)
print(device.hasDynamicIsland)
~~~

## Installation

Requires **iOS / iPadOS 18+** and a toolchain with **Swift 6.4 or newer**.

Add this repository in Xcode's package dependencies:

~~~text
https://github.com/Anywhere-Music-Player/SwiftDeviceKit
~~~

Then select the product you need.

## Modules

| Module | What it provides |
| --- | --- |
| `SwiftDeviceKitCore` | Device identification, simulator and preview detection, model names, screens, cameras, processors and hardware capabilities. |
| `SwiftDeviceKitSystem` | Core plus battery, thermal state, storage, orientation, brightness and system information. |

Choose **Core** for device identification and catalog data. Choose **System**
when you also need the current device's state.

System includes Core and exposes the same `Device` type, so a single
`import SwiftDeviceKitSystem` gives access to both. Both modules share one
package version. Core can be used without UIKit.

## Device capabilities

Look up a model by its hardware identifier or work with `Device.current`:

~~~swift
import SwiftDeviceKitCore

let device = Device.mapToDevice(identifier: "iPhone19,2")

print(device.description)           // iPhone 18 Pro
print(device.hasUSBCConnectivity)   // true
print(device.hasLidarSensor)        // true
print(device.cameras)               // wide, telephoto, ultraWide

let phones = Device.allPhones
let iPads = Device.allPads
let devicesWithFaceID = Device.allFaceIDCapableDevices
~~~

The catalog covers iPhone and iPad models supporting iOS / iPadOS 18 or later.
Unknown identifiers are preserved as `.unknown(identifier)`. Simulator models
expose the hardware capabilities of the device they represent.

## Screens

Each device exposes its built-in screen specifications:

~~~swift
import SwiftDeviceKitCore

for screen in Device.current.screens {
    print(screen.role, screen.diagonal, screen.ppi)
}
~~~

Single-screen models have one `.main` screen. iPhone Duo exposes `.outer` and
`.inner` screens, each with its own specifications. These describe the hardware;
use your app's view geometry for the current layout.

See [screen specifications](Docs/Screens.md) for panel selection, pixel dimensions
and the behavior of `diagonal`, `ppi` and `screenRatio`.

## System state

~~~swift
import SwiftDeviceKitSystem

@MainActor
func readDeviceState() {
    let device = Device.current

    print(device.systemName ?? "Unknown")
    print(device.batteryState?.description ?? "Unavailable")
    print(device.thermalState as Any)
    print(Device.volumeAvailableCapacity as Any)
}
~~~

UIKit-backed properties such as battery state, brightness and orientation are
accessed on the main actor. Catalog data remains available across concurrency
boundaries.

## Documentation

- [Migrating from DeviceKit](Docs/Migration.md)
- [Screen specifications](Docs/Screens.md)
- [Adding a device to the catalog](Docs/Catalog.md)
- [Testing and optional DeviceKit comparison](Docs/Testing.md)
- [Changelog](CHANGELOG.md)

## License

[MIT](LICENSE). Based on DeviceKit, with the original authors' notices preserved.
See [attribution](ATTRIBUTION.md).
