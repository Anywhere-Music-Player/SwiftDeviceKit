# DeviceKitComparison

A standalone iOS 18+ Swift Package that executes **DeviceKit 5.9.0** and the
local **SwiftDeviceKit** in the same XCTest process. No application UI or release
is required. Open this folder's Package.swift in Xcode to inspect the tests.

The parent library's Package.swift is unchanged. Only this validation package
depends on DeviceKit; consumers of either SwiftDeviceKit product do not acquire
that dependency. System is linked here to compare its isPhone/isPad API too.

## Run

From this directory, with Xcode 27 / Swift 6.4 selected:

~~~sh
./run.sh
~~~

The script creates a temporary iPhone 18 Pro simulator on the newest compatible
installed runtime and deletes it on exit. It does not use or reset your existing
simulators. First use needs access to GitHub and the selected simulator runtime
must already be installed.

To select a runtime or device type:

~~~sh
SIMULATOR_RUNTIME=com.apple.CoreSimulator.SimRuntime.iOS-27-2 ./run.sh
SIMULATOR_TYPE=com.apple.CoreSimulator.SimDeviceType.iPad-A16 ./run.sh
~~~

Alternatively pass an existing simulator UUID as the first argument. That device
is not deleted by the script. This test suite expects an iOS Simulator destination.

Outputs:

- Reports/latest.md: counts and every differing ID/variant/field with both values.
- Reports/latest.json: the same comparison data for tooling.
- Reports/provenance.json: tested production-source hashes, Git HEAD, toolchain,
  any production changes relative to HEAD and the local xcresult path.
- .results/run-*/: full build/test logs, attachments and xcresult; ignored by Git.

Generated Reports/ files are also ignored by Git; rerun the comparison to refresh them.

An unexpected difference or failed assertion returns a nonzero exit code.
Attachments are exported even when a comparison assertion fails. Check the current
command's exit code: a build or export failure can leave an older Reports/latest file.

## What actually runs

The original dependency is pinned to exact version 5.9.0 and revision
19528aa07e1426626ea9fb2c4a161edf43c4f9e8 in Package.resolved. The script verifies the
checkout revision and rejects local changes to that reference.

Scripts/prepare-corpus.swift extracts **inputs only** from the original iOS
identifier switch: 99 model names and 171 identifiers. It does not extract expected
property values. Both libraries execute their own mapToDevice and property APIs
at test time. No Python, GYB execution or copied library implementation is used.

The input corpus is the union of those IDs and every registered local catalog ID.
Coverage gates check it against both executable public model lists, reject
duplicates and assert the explicit iOS 18 catalog policy. The current union has
172 IDs: 104 shared, 67 deliberately excluded and one newly supported Duo ID.

For every ID, tests compare both the hardware model and its simulator wrapper:

- 32 fields: exact names, unknown/known classification, realDevice name, screen
  diagonal/ratio/PPI, CPU, cameras, symbolic Pencil support, biometrics, connectivity,
  other shared capabilities, simulator/preview flags and phone/pad classification.
- Seven unknown/malformed IDs in hardware and simulator form.
- Architecture inputs i386/x86_64/arm64 and actual Device.current using the test
  process's simulator environment. No global environment mutation is performed.
- Membership and retained-model ordering of 34 public groups, including deprecated
  group aliases. Deprecation warnings for these deliberate calls are expected.
- Deliberately corrupted snapshots proving that a wrong model name and a wrong
  simulator-camera capability are rejected.

Names are compared exactly, including Unicode and spacing. Numeric fields use
their exact values. Camera order is preserved; Pencil flags are compared by named
capability rather than assuming the two enum types share an implementation.

## Expected differences

The comparison records these changes rather than hiding their rows:

| Category | Allowed behavior |
| --- | --- |
| outside-ios18-catalog | The explicitly listed old models must have exactly the replacement's unknown-device behavior; their removal from groups is expected. |
| duo-absent-in-devicekit-5.9.0 | Original 5.9.0 returns unknown for iPhone19,4. The replacement must resolve it to iPhoneDuo; all value differences are visible but have no upstream oracle. |
| portrait-reference-orientation | Only the exact width/height swap for the nine documented iPad records is permitted. |
| m5-pencil-compatibility | Only removal of second-generation Pencil support from the two M5 iPad Pro records is permitted. |
| simulator-camera-metadata | Only camera fields changing from empty/false to the original real model's values are permitted. Other simulator differences still fail. |
| unknown-simulator-detection | Only isSimulator changing false to true for an unknown simulated model is permitted. |

Unexpected additions/removals or ordering changes among shared models fail.
Removing a shared model cannot silently reclassify it as unsupported: the exclusion
policy is explicit and independent of the production registry.

## Boundaries

This is a differential **catalog** test. It establishes correspondence to the
pinned reference, not that either catalog perfectly describes physical hardware.

New-only screens/isFoldable APIs, Duo's physical specifications, mutable battery/
storage/thermal readings, active panels and physical-device behavior have no
equivalent oracle here. Keep the parent package's separate tests for these APIs.
Passing on iOS 27.2 does not constitute execution on the iOS 18 minimum runtime.

No Anywhere integration, Mixpanel events, package publication, commit or push is
performed by this project.
