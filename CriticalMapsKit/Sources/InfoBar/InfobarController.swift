import ComposableArchitecture
import SwiftUI

public struct InfobarController {
  let store: Store<InfobarOverlayState, InfobarOverlayAction>
  
  init(store: Store<InfobarOverlayState, InfobarOverlayAction>, show: @escaping (Infobar) -> Void) {
    self.store = store
    self._show = show
  }
  
  private let _show: (Infobar) -> Void
  public func show(_ infobar: Infobar) {
    _show(infobar)
  }
}

public extension InfobarController {
  static func live() -> InfobarController {
    let store = Store<InfobarOverlayState, InfobarOverlayAction>(
      initialState: InfobarOverlayState(infobars: []),
      reducer: infobarOverlayReducer,
      environment: InfobarOverlayEnvironment(
        uuid: UUID.init,
        scheduler: DispatchQueue.main.eraseToAnyScheduler()
      )
    )
    
    return InfobarController(
      store: store,
      show: { infobar in
        withAnimation {
          ViewStore(store).send(.show(infobar))
        }
      }
    )
  }
  
  static func mock(show: @escaping (Infobar) -> Void = { _ in }) -> InfobarController {
    let store = Store<InfobarOverlayState, InfobarOverlayAction>(
      initialState: InfobarOverlayState(infobars: []),
      reducer: .empty,
      environment: ()
    )
    
    return InfobarController(
      store: store,
      show: show
    )
  }
}
