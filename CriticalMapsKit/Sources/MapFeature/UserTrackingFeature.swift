import ComposableArchitecture
import L10n
import MapKit

@Reducer
public struct UserTrackingFeature: Sendable {
  public init() {}

  @ObservableState
  public struct State: Equatable {
    public var mode: MKUserTrackingMode

    public init(userTrackingMode: MKUserTrackingMode = .follow) {
      mode = userTrackingMode
    }
  }

  public enum Action: Equatable, Sendable {
    case nextTrackingMode
  }

  /// Reducer handling tracking mode button state changes
  public func reduce(into state: inout State, action: Action) -> Effect<Action> {
    switch action {
    case .nextTrackingMode:
      switch state.mode {
      case .follow:
        state.mode = .followWithHeading
      case .followWithHeading:
        state.mode = .none
      case .none:
        state.mode = .follow
      @unknown default:
        fatalError()
      }
      return .none
    }
  }
}

public extension MKUserTrackingMode {
  var accessibilityLabel: String {
    switch self {
    case .follow:
      return L10n.A11y.Usertrackingbutton.follow
    case .followWithHeading:
      return L10n.A11y.Usertrackingbutton.followWithHeading
    case .none:
      return L10n.A11y.Usertrackingbutton.dontFollow
    @unknown default:
      return ""
    }
  }
}
