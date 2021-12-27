import ComposableArchitecture
import MapKit

public struct UserTrackingState: Equatable {
  public init(userTrackingMode: MKUserTrackingMode) {
    self.mode = userTrackingMode
  }
  
  public var mode: MKUserTrackingMode
}

public enum UserTrackingAction: Equatable {
  case nextTrackingMode
}

public struct UserTrackingEnvironment: Equatable {}

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
    switch self { // TODO: L10n
    case .follow:
      return "Follow"
    case .followWithHeading:
      return "Follow with heading"
    case .none:
      return "Don't follow"
    @unknown default:
      return ""
    }
  }
}
