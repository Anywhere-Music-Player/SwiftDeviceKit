// swift-tools-version: 6.4
import PackageDescription

// A standalone test consumer. These dependencies are not part of SwiftDeviceKit.
let package = Package(
  name: "DeviceKitComparison",
  platforms: [.iOS(.v18)],
  dependencies: [
    .package(url: "https://github.com/devicekit/DeviceKit.git", exact: "5.9.0"),
    .package(path: "../.."),
  ],
  targets: [
    .testTarget(
      name: "DeviceKitComparisonTests",
      dependencies: [
        .product(name: "DeviceKit", package: "DeviceKit"),
        .product(name: "SwiftDeviceKitSystem", package: "SwiftDeviceKit"),
      ],
      resources: [.process("Resources")]
    ),
  ],
  swiftLanguageModes: [.v6]
)
