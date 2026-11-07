# Platform support

The deployment targets follow Apple's 2024 OS generation. A model qualifies if
it can run that generation or a later release. The catalog contains 173 model
records and 235 hardware identifiers as of 7 November 2026.

| Platform | Minimum | Models | Core | Additional System APIs |
| --- | --- | ---: | --- | --- |
| iPhone | iOS 18 | 37 | All six families, including both iPhone Duo panels | UIKit names, battery, Low Power Mode, thermal state, storage, main display pixels, orientation, brightness, Display Zoom, Guided Access |
| iPad | iPadOS 18 | 30 | Same catalog, Pencil support by model | Same services as iPhone, with iPad family detection in iPhone-only apps |
| Apple Watch | watchOS 11 | 22 | Series 6–12, SE 2–3 and Ultra 1–4, including case sizes, CPU, physical screen metrics and cellular capabilities | WatchKit names, battery, Low Power Mode, thermal state, total/free storage, main display pixels |
| Apple TV | tvOS 18 | 5 | Apple TV HD and 4K generations 1–4, CPU and model groups | UIKit names, thermal state, total/free storage, connected main display pixels |
| Mac | macOS 15 | 77 | Compatible Intel and Apple silicon models, chip and built-in panel where applicable | Host and OS names, internal battery through IOKit when present, Low Power Mode, thermal state, storage, main display pixel dimensions through CoreGraphics |
| Apple Vision Pro | visionOS 2 | 2 | M2 and M5, Optic ID, LiDAR, spatial cameras and `spatialDisplay` specifications | UIKit names, battery when reported, Low Power Mode, thermal state, storage and Guided Access |

Both products can look up any family by hardware identifier on every platform.
`allRealDevices` includes native Macs. `allSimulators` enumerates the five families with an Apple simulator runtime.
`Device.family` and `Device.current` belong to Core. System exposes the same
`Device` through a public type alias. System keeps UIKit and WatchKit reads
on the main actor.

System reads `Device.current.isLowPowerModeEnabled` directly from Foundation on
every platform, including desktop Macs without battery monitoring.

Storage includes total and free bytes everywhere. The important-use and
opportunistic-use Foundation keys, and the `volumes` dictionary containing
them, are available on iOS, iPadOS, macOS and visionOS. On Watch and TV,
DeviceKit's `screenBrightness` and Guided Access compatibility properties
return the constants 100 and false. On Mac Guided Access returns false. The
`orientation` and `isZoomed` APIs are available on iPhone and iPad.

`currentDisplayPixels` reads a current main screen or framebuffer. On Vision,
`spatialDisplay` provides the published combined pixel count, pixel pitch and
refresh rates. A Mac without an internal battery returns nil for battery state
and level. Mac metadata groups configurations that share the same `hw.model`,
including tower and rack Mac Pro. Intel models report the Intel CPU family.
Hardware capabilities describe configurations offered for the model, including
cellular Watch variants and the Touch ID option on MacBook Neo. Desktop
biometrics supplied by an optional keyboard are outside the built-in catalog.

## Sources and compatibility checks

- As an independent completeness check on 7 November 2026, the public Apple Software Lookup response contained 39 iPhone, 68 iPad, 40 Watch and 5 TV identifiers across the relevant releases. The four local identifier sets matched exactly. [Apple Software Lookup Service](https://gdmf.apple.com/v2/pmv)
- Apple sets the Intel cutoff in its [Sequoia compatibility list](https://support.apple.com/en-us/120282). The tests include 16 Intel identifiers and 65 Apple silicon identifiers. The latter inventory comes from the DFU product types in [Apple's Mac restore catalog](https://mesu.apple.com/assets/macos/com_apple_macOSIPSW/com_apple_macOSIPSW.xml). Model records cite the corresponding Apple identification articles.
- The two Vision identifiers also appear in [Apple's software lookup service](https://gdmf.apple.com/v2/pmv). The M2 and M5 records use Apple's [model guide](https://support.apple.com/en-us/125375), [M2 specifications](https://support.apple.com/en-us/117810) and [M5 specifications](https://support.apple.com/en-us/125436).
- Apple CoreSimulator 27.2 profiles independently list 40 supported Watch hardware IDs. In particular, `Watch7,14` is the 44 mm SE 3 and `Watch7,15` is the 40 mm SE 3. DeviceKit 5.10.0 interchanges them. Watch screen ratios use physical pixel dimensions and rectangular diagonals are calculated from pixel dimensions and density. Check the [Series 12 specifications](https://www.apple.com/apple-watch-series-12/specs/) and [Ultra 3 specifications](https://www.apple.com/apple-watch-ultra-3/specs/).
- All five Apple TVs have corresponding Xcode profiles. The fourth-generation 4K uses A19. Apple TV HD has a USB-C service port. [Apple TV 4K specifications](https://www.apple.com/apple-tv-4k/specs/) · [Apple TV HD specifications](https://support.apple.com/en-us/111928)
- The [comparison suite](../Validation/DeviceKitComparison/README.md) pins DeviceKit 5.10.0. The original iOS 5.9.0 fixtures remain frozen to detect regressions in the pre-existing catalog.

### Upstream issues and pull requests addressed

| Area | SwiftDeviceKit behavior | DeviceKit history |
| --- | --- | --- |
| Cross-platform lookup | An iPhone app can resolve a Watch, TV, Mac or Vision identifier. | [Issue 233](https://github.com/devicekit/DeviceKit/issues/233), [issue 392](https://github.com/devicekit/DeviceKit/issues/392) |
| Watch identity | The catalog includes the Series 7 and Series 9 GPS identifiers. The two SE 3 sizes follow Apple's profiles. | [PR 329](https://github.com/devicekit/DeviceKit/pull/329), [PR 448](https://github.com/devicekit/DeviceKit/pull/448), [PR 473](https://github.com/devicekit/DeviceKit/pull/473) |
| Watch capabilities | The catalog records rounded displays and 5G support on applicable cellular configurations. Watch and TV retain DeviceKit's documented brightness fallback. | [Issue 502](https://github.com/devicekit/DeviceKit/issues/502), [PR 503](https://github.com/devicekit/DeviceKit/pull/503), [issue 498](https://github.com/devicekit/DeviceKit/issues/498), [issue 394](https://github.com/devicekit/DeviceKit/issues/394) |
| Apple TV | System exposes total and free storage. Core recognizes the fourth-generation Apple TV 4K. | [Issue 449](https://github.com/devicekit/DeviceKit/issues/449), [PR 455](https://github.com/devicekit/DeviceKit/pull/455), [PR 520](https://github.com/devicekit/DeviceKit/pull/520) |
| Mac and Vision | Mac lookup uses the host model in native and Designed for iPad/iPhone processes. Native visionOS recognizes M2 and M5 headsets. | [PR 217](https://github.com/devicekit/DeviceKit/pull/217), [issue 506](https://github.com/devicekit/DeviceKit/issues/506), [PR 391](https://github.com/devicekit/DeviceKit/pull/391), [PR 488](https://github.com/devicekit/DeviceKit/pull/488) |
| Duo and simulators | Both Duo panels remain available. Simulator wrappers preserve the underlying model's capabilities. | [PR 507](https://github.com/devicekit/DeviceKit/pull/507), [issue 528](https://github.com/devicekit/DeviceKit/issues/528) |

## Release client size

Measured with Xcode 27.2, Release, arm64, disabled signing and generic device
destinations. Values are byte lengths of the linked Mach-O executables. The
baseline uses the same client programs built against commit `5077c8c`. The
old manifest declared iOS only. Core also built for the other destinations
as a phone/tablet catalog. The old System product had a supported build only
for iOS/iPadOS. iPhone and iPad share the same iOS executable.

| SDK | Core before | Core after | System before | System after | Direct System frameworks |
| --- | ---: | ---: | ---: | ---: | --- |
| iOS / iPadOS | 166,688 | 282,344 | 192,248 | 307,928 | Foundation, CoreFoundation, UIKit |
| watchOS | 166,632 | 282,272 | — | 289,344 | Foundation, CoreFoundation, UIKit, WatchKit |
| tvOS | 166,632 | 282,272 | — | 288,624 | Foundation, CoreFoundation, UIKit |
| macOS | 169,976 | 267,400 | — | 293,312 | Foundation, CoreFoundation, CoreGraphics, IOKit |
| visionOS | 166,632 | 282,272 | — | 291,024 | Foundation, CoreFoundation, UIKit |

The iOS Core executable grew by 115,656 bytes and System by 115,680 bytes.
Core's only directly loaded **framework** on every platform is Foundation.
All executables also load system dylibs, including Swift runtime libraries and
overlays. The macOS Core executable links the Swift IOKit overlay. System ships
a separate bundle containing a 623-byte privacy manifest and a generated
Info.plist. Neither product has an external Swift package dependency.

To reproduce, choose either scheme in [the Release client package](../Validation/ReleaseClients/Package.swift).
For example, from that package directory, run the following commands.

~~~sh
xcodebuild -scheme CoreClient -configuration Release -destination 'generic/platform=iOS' \
  -derivedDataPath "$TMPDIR/SwiftDeviceKitSize" ARCHS=arm64 CODE_SIGNING_ALLOWED=NO build
client="$TMPDIR/SwiftDeviceKitSize/Build/Products/Release-iphoneos/CoreClient"
stat -f %z "$client"
otool -L "$client"
vtool -show-build "$client"
~~~

The client entry points exercise current model lookup, CPU, screens and the
catalog count. System also reads OS name, thermal state, disk capacity and,
where available, battery state. App Store compression, app resources and dSYMs
are outside these executable measurements.

`vtool -show-build` confirmed minimums of iOS 18.0, tvOS 18.0,
macOS 15.0 and visionOS 2.0 in the respective clients. Watch clients
also link for **arm64_32 with watchOS 11.0**. With this toolchain the
full arm64 Watch slice has a watchOS 26.0 minimum. The Intel Mac clients
link as x86_64 with macOS 15.0. The watchOS 11 arm64_32 clients measured
265,512 bytes for Core and 288,792 for System. The x86_64 Mac clients
measured 269,584 and 295,312 bytes respectively.

## Verification on 7 November 2026

The standalone clients linked in Release for every SDK in the size table.
Tests used Xcode 27.2 and OS 27.2. The deployment targets above also describe
older supported releases; the runtime tests exercised 27.2.

| Platform | Simulator or native execution | Physical device evidence from this change |
| --- | --- | --- |
| iOS | iPhone 18 Pro and iPhone Duo, 75/75 package tests each | No completed physical run |
| iPadOS | iPad Pro 13-inch (M5), 75/75 package tests | No completed physical run |
| watchOS | Apple Watch Series 12, 34/34 package tests | Simulator coverage |
| tvOS | Apple TV 4K (4th generation), 34/34 package tests | Simulator coverage |
| macOS | Native Apple silicon, 34/34 package tests, plus one hosted iOS-on-Mac XCTest | The local Mac ran both processes. Intel verification was a cross-build. |
| visionOS | Apple Vision Pro simulator, 34/34 package tests | Simulator coverage |

All completed package suites above had zero skipped tests. The hosted Mac test
checked `isiOSAppOnMac`, the host hardware ID against `sysctl`, the catalog
model, macOS names/version, both family flags and simulator status. The native
Mac Release client also read an internal battery through IOKit. The Watch,
Apple TV and Vision Pro runtime checks used simulators. Physical measurements
of panel brightness, battery discharge and thermals are outside these checks.

The DeviceKit 5.10.0 comparisons ran in the same simulator SDK generation.

| Reference process | Field and group comparisons | Unexpected differences |
| --- | ---: | ---: |
| iPhone 18 Pro | 13,300 | 0 |
| Apple Watch Series 12, 46 mm | 1,134 | 0 |
| Apple TV 4K (4th generation) | 84 | 0 |

The independent Apple computer inventory and the Duo two-panel regressions
are exercised by the package suite. Reference-device system readings on a
simulator establish API behavior under that runtime. They do not measure
battery or display accuracy on physical Watch, TV or Vision hardware.
