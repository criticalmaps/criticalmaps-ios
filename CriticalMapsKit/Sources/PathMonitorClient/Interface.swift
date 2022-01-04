import Combine
import Network

/// A client to monitor the apps connectivity
public struct PathMonitorClient {
  public var networkPathPublisher: AnyPublisher<NetworkPath, Never>

  public init(networkPathPublisher: AnyPublisher<NetworkPath, Never>) {
    self.networkPathPublisher = networkPathPublisher
  }
}
