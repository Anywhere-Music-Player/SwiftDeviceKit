<p align="center">
  <img src="SwiftDeviceKit.svg" width="112" height="112" alt="SwiftDeviceKit icon">
</p>
<h1 align="center">SwiftDeviceKit</h1>
<p align="center">
  <a href="https://github.com/Anywhere-Music-Player/SwiftDeviceKit/releases/latest"><img src="https://img.shields.io/github/v/release/Anywhere-Music-Player/SwiftDeviceKit?label=release" alt="Latest GitHub release"></a>
  <a href="Package.swift"><img src="https://img.shields.io/badge/Swift_tools-6.4%2B-F05138" alt="Swift tools 6.4+"></a>
  <a href="Package.swift"><img src="https://img.shields.io/badge/iOS_%7C_iPadOS-18%2B-2463A2" alt="iOS and iPadOS 18+"></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/license-MIT-blue" alt="MIT license"></a>
</p>

SwiftDeviceKit identifies the iPhone or iPad running your app and describes its hardware. Based on [DeviceKit](https://github.com/devicekit/DeviceKit), it keeps the familiar `Device` cases for models that support iOS or iPadOS 18 and later. The hardware catalog is written in Swift and can be used independently of the system APIs.

## Features

Choose **SwiftDeviceKitCore** for the hardware catalog without UIKit. Choose **SwiftDeviceKitSystem** when you also need live readings. System includes every Core feature through the same `Device` type.

| Feature | Core | System |
| :--- | :---: | :---: |
| [Model name, processor and simulator detection](#get-the-current-device) | ✓ | ✓ |
| SwiftUI preview detection in debug builds | ✓ | ✓ |
| [Screen size, pixel density and both iPhone Duo panels](#show-display-sizes-on-iphone-and-iphone-duo) | ✓ | ✓ |
| [Camera lenses and catalog groups](#find-iphones-with-a-telephoto-camera), LiDAR, Dynamic Island | ✓ | ✓ |
| [Face ID and Touch ID hardware](#identify-the-biometric-sensor) | ✓ | ✓ |
| [Apple Pencil and wireless charging support](#check-accessory-support-on-iphone-and-ipad), USB-C | ✓ | ✓ |
| 5G, eSIM and dual eSIM capabilities | ✓ | ✓ |
| Current device family (`isPhone`, `isPad`), [OS name and version](#include-the-model-and-os-in-a-support-report) | — | ✓ |
| [Battery percentage and charging state](#display-battery-percentage-and-charging-status) | — | ✓ |
| [Low Power Mode and thermal state](#defer-background-work-when-power-or-cooling-is-limited) | — | ✓ |
| [Available and total storage capacity](#check-space-before-a-download) | — | ✓ |
| [Screen brightness and Display Zoom](#read-the-current-display-settings), orientation and Guided Access | — | ✓ |

## Requirements

- iOS 18+ or iPadOS 18+
- Swift tools 6.4+ (Swift 6 language mode)

## Installation

In Xcode, choose **File → Add Package Dependencies…** and paste this URL.

```text
https://github.com/Anywhere-Music-Player/SwiftDeviceKit.git
```

Add one [product](#features) to your app target.

## Usage

### SwiftDeviceKitCore

#### Get the current device

```swift
import SwiftDeviceKitCore

let device = Device.current
print(device.realDevice)   // e.g. iPhone 17
print(device.cpu)          // A19 on iPhone 17
print(device.isSimulator)  // true in Simulator
```

#### Show display sizes on iPhone and iPhone Duo

Use `realDevice` to match the same model on hardware and in Simulator.

```swift
import SwiftDeviceKitCore

let model = Device.current.realDevice
if model == .iPhoneDuo {
    for screen in model.screens {
        print("\(screen.role) display · \(screen.diagonal)″")
    }
} else if let screen = model.screen(.main) {
    print("\(model) · \(screen.diagonal)″ display")
}
```

On iPhone Duo this prints `outer display · 5.4″` and `inner display · 7.6″`. On iPhone 17 it prints `iPhone 17 · 6.3″ display`. For the current window size, use your view’s geometry.

#### Identify the biometric sensor

```swift
import SwiftDeviceKitCore

let model = Device.current
if model.isFaceIDCapable {
    print("Face ID")
} else if model.isTouchIDCapable {
    print("Touch ID")
}
```

#### Find iPhones with a telephoto camera

```swift
import SwiftDeviceKitCore

let phones = Device.allPhones.filter(\.hasTelephotoCamera)
for phone in phones {
    print(phone)
}
```

### SwiftDeviceKitSystem

Import System alone to use these examples. Access UIKit-backed properties on the main actor.

#### Check accessory support on iPhone and iPad

```swift
import SwiftDeviceKitSystem

let device = Device.current
if device.isPhone && device.supportsWirelessCharging {
    print("This iPhone supports wireless charging.")
}
if device.isPad && device.applePencilSupport.contains(.pro) {
    print("This iPad supports Apple Pencil Pro.")
}
```

#### Include the model and OS in a support report

```swift
import SwiftDeviceKitSystem

let device = Device.current
if let name = device.systemName, let version = device.systemVersion {
    print("\(device.realDevice) · \(name) \(version)")
}
```

#### Display battery percentage and charging status

```swift
import SwiftDeviceKitSystem

@MainActor
func batteryLabel() -> String {
    switch Device.current.batteryState {
    case .charging(let percent): "\(percent)% · Charging"
    case .unplugged(let percent): "\(percent)%"
    case .full: "Fully charged"
    case nil: "Battery unavailable"
    }
}
```

For a percentage alone, use `Device.current.batteryLevel` on the main actor.

#### Defer background work when power or cooling is limited

```swift
import SwiftDeviceKitSystem

@MainActor
func shouldDeferBackgroundWork() -> Bool {
    let device = Device.current
    if device.batteryState?.lowPowerMode == true { return true }
    switch device.thermalState {
    case .serious, .critical: return true
    default: return false
    }
}
```

#### Check space before a download

```swift
import SwiftDeviceKitSystem

func hasSpaceForDownload(bytes: Int64) -> Bool? {
    Device.volumeAvailableCapacityForImportantUsage.map { $0 >= bytes }
}
```

For a user-requested download, compare the expected file size in bytes. A `nil` result means the capacity reading is unavailable.

#### Read the current display settings

```swift
import SwiftDeviceKitSystem

let device = Device.current
print("Brightness: \(device.screenBrightness)%")
if device.isZoomed == true {
    print("Display Zoom is enabled.")
}
```

## Documentation

- [Migrating from DeviceKit](Docs/Migration.md)
- [Screen specifications](Docs/Screens.md)
- [Adding a model](Docs/Catalog.md) and [testing the catalog](Docs/Testing.md)
- [Changelog](CHANGELOG.md)

SwiftDeviceKit is distributed under the [MIT license](LICENSE). See [attribution](ATTRIBUTION.md) for the original authors and sources.
