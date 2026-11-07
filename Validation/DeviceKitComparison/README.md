# DeviceKitComparison

This standalone XCTest consumer links DeviceKit **5.10.0** (commit
`fab82bd988405367c915143e293479f481e93ba0`) and the local System product.
The shipping libraries have no dependency on the reference package.

Run from this directory with a matching simulator runtime installed.

~~~sh
./run.sh
PLATFORM=watchOS ./run.sh
PLATFORM=tvOS ./run.sh
~~~

Each invocation creates and removes its own simulator. To reuse an existing
device, pass its UUID as the first argument. `SIMULATOR_TYPE` and
`SIMULATOR_RUNTIME` select a different simulator for a new run. Logs, xcresults
and Markdown/JSON reports go under `$TMPDIR/SwiftDeviceKitComparison` by
default. Set `RESULTS_DIR` to choose another directory. Reports for different
platforms are kept separately.

The runner checks the exact reference checkout, compares freshly extracted
identifier corpora with the checked-in fixtures, and hashes production sources
before and after the test. The fixture generator reads identifier cases only.
The two libraries execute their own mapping and property getters.

- iOS compares names, hardware properties, Pencil and camera metadata,
  family flags and ordered groups over the union of phone and tablet IDs.
  It exercises both real values and simulator wrappers. The original recognizes
  Duo. Two iPad mini A20 Pro identifiers are unique to the replacement.
  Tests retain the explicit iOS 18 cutoff, nine iPad ratio corrections, M5 Pencil
  exclusions and simulator camera checks. Deliberately corrupted snapshots must fail.
- watchOS covers all 62 reference IDs, including 22 excluded IDs below watchOS 11.
  It checks identity, names, CPU, screen geometry, Force Touch, simulator behavior,
  current-device getters and group order. The SE 3 size correction and pixel-derived
  Watch geometry are independently asserted against Apple values.
- tvOS covers the four shared Apple TVs and the newer fourth-generation 4K model.
  It checks identifiers, names, CPU, screen metadata, groups and current-device getters.

The xcresult retains the original and replacement values for every recorded
difference. An unexpected difference or a failing XCTest assertion fails the run.
The six-family Core catalog and the Mac and Vision checks are covered by the parent
package tests. See [platform support](../../Docs/PlatformSupport.md).
