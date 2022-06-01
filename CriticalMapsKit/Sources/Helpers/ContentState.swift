import Foundation
import Styleguide

/// Wrapper type to represent the state of a loadable object. Typically from a network request
public enum ContentState<T: Hashable>: Equatable {
  case loading(T)
  case results(T)
  case empty(EmptyState)
  case error(ErrorState)

  public var elements: T? {
    switch self {
    case let .results(results):
      return results
    default:
      return nil
    }
  }
}
