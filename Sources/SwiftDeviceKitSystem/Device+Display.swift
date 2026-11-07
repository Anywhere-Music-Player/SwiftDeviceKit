#if !os(visionOS)
public import SwiftDeviceKitCore
#if os(macOS)
import CoreGraphics
#elseif os(watchOS)
import WatchKit
#else
import UIKit
#endif

extension Device {
  /// Current main display's pixel dimensions in its native coordinate system.
  /// On macOS this is the active framebuffer mode, including Retina scaling.
  @MainActor
  public var currentDisplayPixels: (width: Int, height: Int)? {
    guard isCurrent else { return nil }
    #if os(macOS)
      guard let mode = CGDisplayCopyDisplayMode(CGMainDisplayID()) else { return nil }
      return (mode.pixelWidth, mode.pixelHeight)
    #elseif os(watchOS)
      let device = WKInterfaceDevice.current()
      let size = device.screenBounds.size
      return (Int(size.width * device.screenScale), Int(size.height * device.screenScale))
    #else
      let size = UIScreen.main.nativeBounds.size
      return (Int(size.width), Int(size.height))
    #endif
  }
}
#endif
