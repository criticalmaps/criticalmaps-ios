import ComposableArchitecture
import L10n
import MapKit

public struct UserTrackingState: Equatable {
  public init(userTrackingMode: MKUserTrackingMode) {
    mode = userTrackingMode
  }

  public var mode: MKUserTrackingMode
}

public enum UserTrackingAction: Equatable {
  case nextTrackingMode
}

public struct UserTrackingEnvironment: Equatable {
  public init() {}
}

/// Reducer handling tracking mode button state changes
public let userTrackingReducer = Reducer<UserTrackingState, UserTrackingAction, UserTrackingEnvironment> { state, action, _ in
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

public extension MKUserTrackingMode {
  var accessiblityLabel: String {
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
