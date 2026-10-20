#!/usr/bin/env python3
"""Regenerate the catalog, or verify that the committed output is current."""
import argparse
from pathlib import Path
import subprocess
import sys

root = Path(__file__).resolve().parent.parent
parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument("--check", action="store_true")
args = parser.parse_args()
generated = subprocess.run(
    [sys.executable, str(root / "Tools/gyb.py"), "--line-directive", "",
     str(root / "Tools/Device.swift.gyb")],
    check=True, capture_output=True, text=True,
).stdout
generated = subprocess.run(
    ["xcrun", "swift-format", "format"], input=generated,
    check=True, capture_output=True, text=True,
).stdout
destination = root / "Sources/SwiftDeviceKit/Device.generated.swift"
if args.check:
    if not destination.exists() or destination.read_text() != generated:
        sys.exit("Generated catalog is stale. Run python3 Tools/generate.py")
    print("Generated catalog is up to date.")
else:
    destination.write_text(generated)
    print(f"Generated {destination.relative_to(root)}")
