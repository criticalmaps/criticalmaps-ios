import ComposableArchitecture
import Foundation
import Logger
import PathMonitorClient
import SharedDependencies

public struct NetworkConnectionObserver: ReducerProtocol {
  public init() {}
  
  @Dependency(\.pathMonitorClient) public var pathMonitorClient
  
  public struct State: Equatable {
    var isNetworkAvailable = true
  }
  
  public enum Action: Equatable {
    case observeConnection
    case observeConnectionResponse(NetworkPath)
  }
  
  public func reduce(into state: inout State, action: Action) -> Effect<Action, Never> {
    switch action {
    case .observeConnection:
      return .run { send in
        for await path in await pathMonitorClient.networkPathPublisher() {
          await send(.observeConnectionResponse(path))
        }
      }
      .cancellable(id: ObserveConnectionIdentifier())
      
    case let .observeConnectionResponse(networkPath):
      state.isNetworkAvailable = networkPath.status == .satisfied
      SharedDependencies._isNetworkAvailable = state.isNetworkAvailable
      
      logger.info("Is network available: \(state.isNetworkAvailable)")
      return .none
    }
  }
}

struct ObserveConnectionIdentifier: Hashable {}
