import ComposableArchitecture
import MapKit

public struct UserTrackingState: Equatable {
  public init(userTrackingMode: MKUserTrackingMode) {
    self.userTrackingMode = userTrackingMode
  }
  
  public var userTrackingMode: MKUserTrackingMode
}

public enum UserTrackingAction: Equatable {
  case nextTrackingMode
}

public struct UserTrackingEnvironment: Equatable {}

public let userTrackingReducer = Reducer<UserTrackingState, UserTrackingAction, UserTrackingEnvironment> { state, action, _ in
  switch action {
  case .nextTrackingMode:
    switch state.userTrackingMode {
    case .follow:
      state.userTrackingMode = .followWithHeading
    case .followWithHeading:
      state.userTrackingMode = .none
    case .none:
      state.userTrackingMode = .follow
    @unknown default:
      fatalError()
    }
    return .none
  }
}
