import Foundation
import Network

/// Wrapper structure to handle not availabe initializers of NWPath
public struct NetworkPath: Equatable {
  public var status: NWPath.Status

  public init(status: NWPath.Status) {
    self.status = status
  }
}

extension NetworkPath {
  public init(rawValue: NWPath) {
    self.status = rawValue.status
  }
}
