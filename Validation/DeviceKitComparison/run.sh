#!/bin/zsh
set -euo pipefail

cd -- "$(dirname -- "$0")"
package_dir="$PWD"
mkdir -p .results Reports
run_dir="$(mktemp -d "$package_dir/.results/run-XXXXXX")"
reference_revision=19528aa07e1426626ea9fb2c4a161edf43c4f9e8
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
  -clonedSourcePackagesDirPath "$package_dir/.results/SourcePackages" \
  -onlyUsePackageVersionsFromResolvedFile > "$run_dir/resolve.log" 2>&1

reference_dir="$package_dir/.results/SourcePackages/checkouts/DeviceKit"
[[ "$(git -C "$reference_dir" rev-parse HEAD)" == "$reference_revision" ]] || {
  print -u2 "Wrong DeviceKit reference revision"; exit 1
}
[[ -z "$(git -C "$reference_dir" status --porcelain)" ]] || {
  print -u2 "DeviceKit checkout has local changes"; exit 1
}
xcrun swift Scripts/prepare-corpus.swift "$reference_dir" \
  Tests/DeviceKitComparisonTests/Resources/ReferenceIdentifiers.json

git -C ../.. rev-parse HEAD > "$run_dir/swiftdevicekit-head.txt"
git -C ../.. diff HEAD -- Package.swift Sources > "$run_dir/swiftdevicekit-source.diff"
xcodebuild -version > "$run_dir/toolchain.txt"
xcrun swift --version >> "$run_dir/toolchain.txt"
xcrun swift Scripts/export-report.swift stamp ../.. "$run_dir/source-stamp.json"

if [[ -z "$simulator_id" ]]; then
  simulator_args=("SwiftDeviceKit Comparison $$" "${SIMULATOR_TYPE:-com.apple.CoreSimulator.SimDeviceType.iPhone-18-Pro}")
  if [[ -n "${SIMULATOR_RUNTIME:-}" ]]; then simulator_args+=("$SIMULATOR_RUNTIME"); fi
  simulator_id="$(xcrun simctl create "${simulator_args[@]}")"
  created_simulator=1
fi
print "Comparing every catalog ID on simulator $simulator_id."
run_status=0
xcodebuild test -scheme DeviceKitComparison-Package \
  -destination "platform=iOS Simulator,id=$simulator_id" \
  -derivedDataPath "$package_dir/.results/DerivedData" \
  -clonedSourcePackagesDirPath "$package_dir/.results/SourcePackages" \
  -disableAutomaticPackageResolution -onlyUsePackageVersionsFromResolvedFile \
  -parallel-testing-enabled NO \
  -resultBundlePath "$run_dir/Comparison.xcresult" > "$run_dir/test.log" 2>&1 || run_status=$?

# Export even on assertion failure, so the unexpected differences remain reviewable.
xcrun xcresulttool export attachments --path "$run_dir/Comparison.xcresult" \
  --output-path "$run_dir/attachments"
xcrun swift Scripts/export-report.swift stamp ../.. "$run_dir/source-stamp-after.json"
cmp "$run_dir/source-stamp.json" "$run_dir/source-stamp-after.json"
xcrun swift Scripts/export-report.swift export "$run_dir" "$package_dir/Reports"
print "Reports: $package_dir/Reports/latest.md and latest.json"
if [[ "$run_status" != 0 ]]; then
  print -u2 "Comparison failed (xcodebuild $run_status). See $run_dir/test.log"
fi
exit "$run_status"
