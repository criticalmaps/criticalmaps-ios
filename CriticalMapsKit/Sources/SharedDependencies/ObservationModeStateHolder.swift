import ComposableArchitecture
import Foundation

@DependencyClient
public struct ObservationModeStateHolder {
  public var setObservationModeState: @Sendable (_ isEnabled: Bool) -> Void
  public var getObservationModeState: @Sendable () -> Bool = { false }
}

extension ObservationModeStateHolder: DependencyKey {
  public static var liveValue: ObservationModeStateHolder {
    let store = ObservationModeStore()
    return Self(
      setObservationModeState: {
        store.setMode($0)
      },
      getObservationModeState: {
        store.observationModeEnabled.value
      }
    )
  }
}

private final class ObservationModeStore {
  var observationModeEnabled = LockIsolated(false)
  
  func setMode(_ mode: Bool) {
    self.observationModeEnabled.setValue(mode)
  }
}

// MARK: TestDependencyKey
extension ObservationModeStateHolder: TestDependencyKey {
  public static var testValue: ObservationModeStateHolder = Self()
}

// MARK: Values

extension DependencyValues {
  public var observationModeStore: ObservationModeStateHolder {
    get { self[ObservationModeStateHolder.self] }
    set { self[ObservationModeStateHolder.self] = newValue }
  }
}
