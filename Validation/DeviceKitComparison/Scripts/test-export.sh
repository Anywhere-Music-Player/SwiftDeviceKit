#!/bin/zsh
set -euo pipefail

cd -- "$(dirname -- "$0")"
work="$(mktemp -d "${TMPDIR:-/tmp}/SwiftDeviceKitExportTest.XXXXXX")"
trap 'rm -rf -- "$work"' EXIT
run="$work/run"
out="$work/export"
mkdir -p "$run/attachments"
print 'fixture' > "$run/swiftdevicekit-head.txt"
print 'fixture' > "$run/toolchain.txt"
print '{}' > "$run/source-stamp.json"
touch "$run/swiftdevicekit-source.diff"
cat > "$run/attachments/manifest.json" <<'JSON'
[{"attachments":[
  {"suggestedHumanReadableName":"catalog-comparison.md","exportedFileName":"report.md"},
  {"suggestedHumanReadableName":"catalog-comparison.json","exportedFileName":"report.json"}
]}]
JSON
print '# Catalog\n\nUnexpected differences: 0' > "$run/attachments/report.md"
print '{"comparisons":10,"differences":[]}' > "$run/attachments/report.json"

check_status() {
  local code="$1" expected="$2"
  print -r -- "$code" > "$run/xcodebuild-exit-code.txt"
  xcrun swift export-report.swift export "$run" "$out"
  [[ "$(plutil -extract testRun.status raw "$out/latest.json")" == "$expected" ]]
  [[ "$(plutil -extract testRun.xcodebuildExitCode raw "$out/latest.json")" == "$code" ]]
  grep -Fq "**XCTest run: $expected**" "$out/latest.md"
}

check_status 0 Passed
check_status 65 Failed
[[ "$(plutil -extract comparisons raw "$out/latest.json")" == 10 ]]
grep -Fq 'Unexpected differences: 0' "$out/latest.md"

# A failed launch can leave no attachments. Replace the previous catalog with its run status.
print '[]' > "$run/attachments/manifest.json"
check_status 65 Failed
! grep -Fq 'Unexpected differences: 0' "$out/latest.md" || exit 1
! plutil -extract comparisons raw "$out/latest.json" >/dev/null 2>&1 || exit 1
