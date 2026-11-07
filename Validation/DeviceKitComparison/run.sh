#!/bin/zsh
set -euo pipefail

cd -- "$(dirname -- "$0")"
package_dir="$PWD"
platform="${PLATFORM:-iOS}"
case "$platform" in
  iOS) device_type=iPhone-18-Pro ;;
  watchOS) device_type=Apple-Watch-Series-12-46mm ;;
  tvOS) device_type=Apple-TV-4K-4th-generation-4K ;;
  *) print -u2 "Choose iOS, watchOS or tvOS"; exit 1 ;;
esac
results="${RESULTS_DIR:-${TMPDIR:-/tmp}/SwiftDeviceKitComparison}"
mkdir -p "$results"
run_dir="$(mktemp -d "$results/run-XXXXXX")"
reference_revision=fab82bd988405367c915143e293479f481e93ba0
simulator_id="${1:-}"
created_simulator=0
cleanup() {
  if [[ "$created_simulator" == 1 ]]; then
    xcrun simctl shutdown "$simulator_id" >/dev/null 2>&1 || true
    xcrun simctl delete "$simulator_id" >/dev/null 2>&1 || true
  fi
}
trap cleanup EXIT
trap 'exit 130' INT
trap 'exit 143' TERM

print "Resolving the pinned reference. Logs: $run_dir"
xcodebuild -resolvePackageDependencies \
  -clonedSourcePackagesDirPath "$results/SourcePackages" \
  -onlyUsePackageVersionsFromResolvedFile > "$run_dir/resolve.log" 2>&1

reference_dir="$results/SourcePackages/checkouts/DeviceKit"
[[ "$(git -C "$reference_dir" rev-parse HEAD)" == "$reference_revision" ]] || {
  print -u2 "Wrong DeviceKit reference revision"; exit 1
}
[[ -z "$(git -C "$reference_dir" status --porcelain)" ]] || {
  print -u2 "DeviceKit checkout has local changes"; exit 1
}
mkdir -p "$run_dir/corpus"
xcrun swift Scripts/prepare-corpus.swift "$reference_dir" "$run_dir/corpus"
diff -r Tests/DeviceKitComparisonTests/Resources "$run_dir/corpus"

git -C ../.. rev-parse HEAD > "$run_dir/swiftdevicekit-head.txt"
git -C ../.. diff HEAD -- Package.swift Sources > "$run_dir/swiftdevicekit-source.diff"
xcodebuild -version > "$run_dir/toolchain.txt"
xcrun swift --version >> "$run_dir/toolchain.txt"
xcrun swift Scripts/export-report.swift stamp ../.. "$run_dir/source-stamp.json"

if [[ -z "$simulator_id" ]]; then
  simulator_args=("SwiftDeviceKit Comparison $$" "${SIMULATOR_TYPE:-com.apple.CoreSimulator.SimDeviceType.$device_type}")
  if [[ -n "${SIMULATOR_RUNTIME:-}" ]]; then simulator_args+=("$SIMULATOR_RUNTIME"); fi
  simulator_id="$(xcrun simctl create "${simulator_args[@]}")"
  created_simulator=1
fi
# A new runtime can need more than XCTest's device preparation timeout on its first boot.
xcrun simctl bootstatus "$simulator_id" -b > "$run_dir/boot.log" 2>&1
print "Comparing the $platform catalog."
run_status=0
xcodebuild test -scheme DeviceKitComparison-Package \
  -destination "platform=$platform Simulator,id=$simulator_id" \
  -derivedDataPath "$results/DerivedData-$platform" \
  -clonedSourcePackagesDirPath "$results/SourcePackages" \
  -disableAutomaticPackageResolution -onlyUsePackageVersionsFromResolvedFile \
  -parallel-testing-enabled NO \
  -resultBundlePath "$run_dir/Comparison.xcresult" > "$run_dir/test.log" 2>&1 || run_status=$?

# Attachments describe catalog differences. Only the completed xcodebuild test command
# knows whether the entire suite passed, including assertions outside that catalog.
print -r -- "$run_status" > "$run_dir/xcodebuild-exit-code.txt"
if ! xcrun xcresulttool export attachments --path "$run_dir/Comparison.xcresult" \
  --output-path "$run_dir/attachments"; then
  [[ "$run_status" != 0 ]] || exit 1
fi
xcrun swift Scripts/export-report.swift stamp ../.. "$run_dir/source-stamp-after.json"
cmp "$run_dir/source-stamp.json" "$run_dir/source-stamp-after.json"
xcrun swift Scripts/export-report.swift export "$run_dir" "$results/Reports/$platform"
print "Reports: $results/Reports/$platform/latest.md and latest.json"
if [[ "$run_status" != 0 ]]; then
  print -u2 "Comparison failed (xcodebuild $run_status). See $run_dir/test.log"
fi
exit "$run_status"
