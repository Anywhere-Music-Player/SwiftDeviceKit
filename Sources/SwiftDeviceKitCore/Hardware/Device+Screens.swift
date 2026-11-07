extension Device {
  /// Static specifications of a built-in panel, independent of orientation, window size and fold state.
  public struct Screen: Sendable, Hashable {
    public enum Role: Sendable, Hashable {
      /// The panel of a single-screen model.
      case main
      case outer
      case inner
    }

    /// Physical pixel dimensions in portrait reference orientation (width <= height), not UIKit points.
    public struct Resolution: Sendable, Hashable {
      public let width: Int
      public let height: Int
    }

    public struct AspectRatio: Sendable, Hashable {
      public let width: Double
      public let height: Double
    }

    public let role: Role

    /// Diagonal in inches. Watch values use the pixel diagonal divided by panel PPI. Rounded corners reduce the actual viewable area.
    public let diagonal: Double

    /// Physical pixels per inch.
    public let ppi: Int

    /// Portrait width-to-height ratio (width <= height), independent of current UI orientation.
    public let screenRatio: AspectRatio

    /// Published pixel dimensions, or nil when the catalog has no verified resolution.
    public let resolution: Resolution?
  }

  /// Apple's published specifications for both eye displays together.
  public struct SpatialDisplay: Sendable, Hashable {
    public let approximateTotalPixels: Int
    public let pixelPitchMicrometers: Double
    public let refreshRatesHz: [Int]
  }

  public var spatialDisplay: SpatialDisplay? { definition?.spatialDisplay }

  /// Known rectangular panels: one `.main` panel for a single-screen model,
  /// or `.outer` followed by `.inner` for iPhone Duo. Unknown models return an empty array.
  /// Simulator wrappers expose the same catalog specifications as their model.
  /// These values do not describe the currently active screen or connected external displays.
  public var screens: [Screen] { definition?.screens ?? [] }

  /// Finds a built-in panel by its catalog role, or returns nil if that role is absent.
  public func screen(_ role: Screen.Role) -> Screen? {
    screens.first { $0.role == role }
  }
}
