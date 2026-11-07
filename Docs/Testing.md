# Testing

Run the package tests from the repository root with Xcode and an available
iPhone simulator:

~~~sh
xcodebuild test -scheme SwiftDeviceKit-Package \
  -destination 'platform=iOS Simulator,id=<SIMULATOR-UUID>' \
  -derivedDataPath /tmp/SwiftDeviceKitTests \
  -parallel-testing-enabled NO
~~~

## Package tests

Core tests exercise every supported hardware identifier, simulator wrappers,
unknown inputs, screen records, capabilities and ordered model groups. Frozen
fixtures check retained metadata against the original catalog. The fixture files
are test resources and are not included in either library product.

System tests import only System and exercise its Core type alias and runtime
APIs. Identifier resolution also has tests for future models and malformed
simulator environment values, without changing process globals.

A single simulator can exercise the whole catalog by passing each identifier to
`mapToDevice(identifier:)`. A separate simulator for every model is unnecessary.

## Optional comparison with DeviceKit

The standalone [DeviceKitComparison package](../Validation/DeviceKitComparison/README.md)
runs the original DeviceKit and the local SwiftDeviceKit in the same test process.
It pins its reference dependency, checks the union of both iOS catalogs and
exports a report of every differing field.

~~~sh
./Validation/DeviceKitComparison/run.sh
~~~

This is an explicit validation command, separate from the normal package build
and tests. Its reference dependency is not part of either library product.
Generated reports, logs and build products stay local and are ignored by Git.

## Validation coverage

| Check | Where |
| --- | --- |
| Catalog and System tests | One current iPhone simulator |
| UIKit iPad idiom and iPadOS naming | One iPad simulator |
| Minimum-OS behavior | iOS 18 simulator or device |
| Battery, Low Power Mode, brightness, orientation, thermal and storage behavior | Physical iPhone or iPad |
| Module boundaries | Consumers selecting only Core and only System |

On 7 November 2026 the current source passed all 67 package tests on each of
iPhone 18 Pro and iPad mini (A20 Pro), running iOS/iPadOS 27.2 Simulator with
Xcode 27.2 (27B52) / Swift 6.4.2. There were no failures or skips. The 10 new
regression tests failed against the original implementation before the fixes.
The separate comparison passed 3 tests and 13,300 field/group checks with zero
unexpected differences, covering 67 models and 107 registered identifiers.
The generic iOS Release build also passed with the iOS 18 deployment target.

The regressions cover fresh disk capacity after a synchronous write, controlled
UIKit zoom inputs, structural identity, Pencil exclusions, portrait screen ratios,
battery ordering, nested simulators and the new mini. Donor fixtures remain frozen;
the comparator rejects corruption beyond the documented corrections.

Those runs do not establish execution on iOS 18 or physical hardware behavior.
In particular, [Display Zoom hardware acceptance](https://github.com/Anywhere-Music-Player/SwiftDeviceKit/issues/2)
remains pending; passing substituted UIKit getters does not verify actual display modes.
Matching DeviceKit establishes compatibility with its data; new or corrected
specifications need independent source checks. See
[Apple's guidance on simulated and physical devices](https://developer.apple.com/documentation/Xcode/running-your-app-on-simulated-or-physical-devices).

[Back to README](../README.md)
