extension Device {
  /// Static specifications of a built-in panel, independent of orientation, window size and fold state.
  public struct Screen: Sendable, Hashable {
    public enum Role: Sendable, Hashable {
      /// The panel of a single-screen model.
      case main
      case outer
      case inner
    }

    /// Physical pixel dimensions in the catalog's reference orientation, not UIKit points.
    public struct Resolution: Sendable, Hashable {
      public let width: Int
      public let height: Int
    }

    public struct AspectRatio: Sendable, Hashable {
      public let width: Double
      public let height: Double
    }

    public let role: Role

    /// Advertised diagonal in inches. Rounded corners reduce the actual viewable area.
    public let diagonal: Double

    /// Physical pixels per inch.
    public let ppi: Int

    /// Catalog width-to-height ratio. Duo uses the reduced ratio of its published pixel dimensions.
    public let screenRatio: AspectRatio

    /// Published pixel dimensions, or nil when the catalog has no verified resolution.
    /// Both iPhone Duo panels have a resolution. Other models currently retain their existing metrics.
    public let resolution: Resolution?
  }

  /// Known built-in screens: one `.main` panel for a single-screen model,
  /// or `.outer` followed by `.inner` for iPhone Duo. Unknown models return an empty array.
  /// Simulator wrappers expose the same catalog specifications as their model.
  /// These values do not describe the currently active screen or connected external displays.
  public var screens: [Screen] { definition?.screens ?? [] }

  /// Finds a built-in panel by its catalog role, or returns nil if that role is absent.
  public func screen(_ role: Screen.Role) -> Screen? {
    screens.first { $0.role == role }
  }
}
