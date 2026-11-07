import SwiftDeviceKitCore
import Testing

struct DeviceDescriptionTests {
  @Test func nestedNamesPreserveEachWrapper() {
    let cases: [(Device, String, String)] = [
      (.iPhoneXR, "iPhone Xʀ", "iPhone XR"),
      (.unknown("future(model)"), "future(model)", "future(model)"),
      (.unidentifiedVision(reportedIdentifier: "iPad8,6"), "Apple Vision", "Apple Vision"),
    ]
    for (base, name, safeName) in cases {
      var value = base
      for depth in 0...2048 {
        if [0, 1, 2, 2048].contains(depth) {
          let prefix = String(repeating: "Simulator (", count: depth)
          let suffix = String(repeating: ")", count: depth)
          #expect(value.description == prefix + name + suffix)
          #expect(value.safeDescription == prefix + safeName + suffix)
        }
        value = .simulator(value)
      }
    }
  }
}
