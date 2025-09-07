import Combine
import ComposableArchitecture
import Network

extension PathMonitorClient: DependencyKey {
  public static var liveValue: PathMonitorClient {
    let monitor = NWPathMonitor()
    monitor.start(queue: .main)
    return Self {
      AsyncStream { continuation in
        monitor.pathUpdateHandler = { path in
          continuation.yield(NetworkPath(rawValue: path))
        }
        continuation.onTermination = { _ in monitor.cancel() }
      }
    }
  }
}
