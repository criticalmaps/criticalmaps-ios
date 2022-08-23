import Network

/// A client to monitor the apps connectivity
public struct PathMonitorClient {
  public var networkPathPublisher: @Sendable () async -> AsyncStream<NetworkPath>

  public init(networkPathPublisher: @escaping @Sendable () async -> AsyncStream<NetworkPath>) {
    self.networkPathPublisher = networkPathPublisher
  }
}
