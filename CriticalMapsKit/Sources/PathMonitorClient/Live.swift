import Combine
import Network

public extension PathMonitorClient {
  static func live(queue: DispatchQueue) -> Self {
    let monitor = NWPathMonitor()
    let subject = PassthroughSubject<NWPath, Never>()
    monitor.pathUpdateHandler = subject.send

    return Self(
      networkPathPublisher: subject
        .handleEvents(
          receiveSubscription: { _ in monitor.start(queue: queue) },
          receiveCancel: monitor.cancel
        )
        .map(NetworkPath.init(rawValue:))
        .eraseToAnyPublisher()
    )
  }
}
