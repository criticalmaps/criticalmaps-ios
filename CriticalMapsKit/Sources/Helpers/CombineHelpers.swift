import Combine

public extension Publisher where Output == Never {
  func setOutputType<NewOutput>(to _: NewOutput.Type) -> AnyPublisher<NewOutput, Failure> {
    func absurd<A>(_ never: Never) -> A {}
    return map(absurd).eraseToAnyPublisher()
  }
}

public extension Publisher {
  func ignoreFailure() -> AnyPublisher<Output, Never> {
    self
      .catch { _ in Empty() }
      .setFailureType(to: Never.self)
      .eraseToAnyPublisher()
  }
}
