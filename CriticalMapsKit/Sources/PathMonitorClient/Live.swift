import Combine
import Network

public extension PathMonitorClient {
  static func live(queue: DispatchQueue) -> Self {
    let monitor = NWPathMonitor()
    monitor.start(queue: queue)
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
