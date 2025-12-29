import Foundation
import Network

/// Wrapper structure to handle not available initialisers of NWPath
public struct NetworkPath: Equatable, Sendable {
  public var status: NWPath.Status

  public init(status: NWPath.Status) {
    self.status = status
  }
}

public extension NetworkPath {
  init(rawValue: NWPath) {
    status = rawValue.status
  }
}
