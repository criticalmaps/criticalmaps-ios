import ComposableArchitecture
import Network

/// A client to monitor the apps connectivity
@DependencyClient
public struct PathMonitorClient {
  public var networkPathPublisher: @Sendable () async -> AsyncStream<NetworkPath> = { AsyncStream<NetworkPath>.makeStream().stream }
}

extension DependencyValues {
  public var pathMonitorClient: PathMonitorClient {
    get { self[PathMonitorClient.self] }
    set { self[PathMonitorClient.self] = newValue }
  }
}
