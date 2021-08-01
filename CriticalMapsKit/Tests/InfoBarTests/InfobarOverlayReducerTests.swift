@testable import InfoBar
import Combine
import ComposableArchitecture
import XCTest

final class InfobarOverlayReducerTest: XCTestCase {
  let scheduler = DispatchQueue.test
  let statusbarStyleProviderState = StatusbarStyleProviderState(
    isPresentingModalSheet: false,
    userInterfaceStyle: .unspecified,
    activeViewController: UIViewController()
  )
  
  func test_show_infobar() {
    let id = UUID()
    let infobar: Infobar = .success(message: "success")
    let store = TestStore(
      initialState: InfobarOverlayState(
        infobars: []
      ),
      reducer: infobarOverlayReducer,
      environment: InfobarOverlayEnvironment(
        uuid: { id },
        scheduler: scheduler.eraseToAnyScheduler()
      )
    )
    
    store.assert(
      .send(
        .show(infobar),
        { state in
          state.infobars.insert(
            IdentifiedInfobar(
              id: id,
              infobar: infobar,
              state: .initial
            ),
            at: 0
          )
        }
      ),
      .do {
        self.scheduler.advance(by: .milliseconds(1))
      },
      .receive(
        .update(id, state: .active),
        { state in
          state.infobars[0].state = .active
        }
      ),
      .do {
        self.scheduler.advance(by: .seconds(14))
      },
      .receive(
        .update(id, state: .inactive),
        { state in
          state.infobars[0].state = .inactive
        }
      ),
      .receive(
        .completedAnimation(id),
        { state in
          state.infobars = []
        }
      ),
      .do {
        self.scheduler.advance(by: .milliseconds(200))
      }
    )
  }
  
  func test_show_and_replace_current() {
    var counter = 0
    let firstID = UUID()
    let secondID = UUID()
    
    let firstInfobar: Infobar = .success(message: "success")
    let secondInfobar: Infobar = .success(message: "default")
    
    let store = TestStore(
      initialState: InfobarOverlayState(
        infobars: []
      ),
      reducer: infobarOverlayReducer,
      environment: InfobarOverlayEnvironment(
        uuid: {
          defer { counter += 1}
          if counter == 0 {
            return firstID
          } else if counter == 1 {
            return secondID
          }
          fatalError("Expected only two ids")
        },
        scheduler: scheduler.eraseToAnyScheduler()
      )
    )
    
    store.assert(
      .send(
        .show(firstInfobar),
        { state in
          state.infobars.insert(
            IdentifiedInfobar(
              id: firstID,
              infobar: firstInfobar,
              state: .initial
            ),
            at: 0
          )
        }
      ),
      .do {
        self.scheduler.advance(by: .milliseconds(1))
      },
      .receive(
        .update(firstID, state: .active),
        { state in
          state.infobars[0].state = .active
        }
      ),
      .send(
        .show(secondInfobar),
        { state in
          state.infobars.insert(
            IdentifiedInfobar(
              id: secondID,
              infobar: secondInfobar,
              state: .initial
            ),
            at: 0
          )
        }
      ),
      .receive(
        .update(firstID, state: .replaced),
        { state in
          state.infobars[1].state = .replaced
        }
      ),
      .do {
        self.scheduler.advance(by: .milliseconds(1))
      },
      .receive(
        .update(secondID, state: .active),
        { state in
          state.infobars[0].state = .active
        }
      ),
      .do {
        self.scheduler.advance(by: .milliseconds(250))
      },
      .receive(
        .completedAnimation(firstID),
        { state in
          state.infobars.remove(id: firstID)
        }
      ),
      .do {
        self.scheduler.advance(by: .milliseconds(15000))
      },
      .receive(
        .update(secondID, state: .inactive),
        { state in
          state.infobars[0].state = .inactive
        }
      ),
      .receive(
        .completedAnimation(secondID),
        { state in
          state.infobars = []
        }
      ),
      .do {
        self.scheduler.advance(by: .milliseconds(250))
      }
    )
  }
  
  func test_didTap_dismissesTapped() {
    let id = UUID()
    let infobar: Infobar = .success(message: "success")
    let store = TestStore(
      initialState: InfobarOverlayState(
        infobars: []
      ),
      reducer: infobarOverlayReducer,
      environment: InfobarOverlayEnvironment(
        uuid: { id },
        scheduler: scheduler.eraseToAnyScheduler()
      )
    )
    
    store.assert(
      .send(
        .show(infobar),
        { state in
          state.infobars.insert(
            IdentifiedInfobar(
              id: id,
              infobar: infobar,
              state: .initial
            ),
            at: 0
          )
        }
      ),
      .do {
        self.scheduler.advance(by: .milliseconds(1))
      },
      .receive(
        .update(id, state: .active),
        { state in
          state.infobars[0].state = .active
        }
      ),
      .send(
        .didTap(id)
      ),
      .receive(
        .update(id, state: .inactive),
        { state in
          state.infobars[0].state = .inactive
        }
      ),
      .do {
        self.scheduler.advance(by: .milliseconds(250))
      },
      .receive(
        .completedAnimation(id),
        { state in
          state.infobars = []
        }
      )
    )
  }
}
