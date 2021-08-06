import ComposableArchitecture

struct IdentifiedInfobar: Equatable, Identifiable {
  enum State: Equatable {
    case initial
    case active
    case inactive
    case replaced
  }
  
  let id: UUID
  let infobar: Infobar
  var state: State
}

struct InfobarOverlayState: Equatable {
  let slideDuration = 250
  
  var infobars: IdentifiedArrayOf<IdentifiedInfobar>
  
  var shouldShowOverlay: Bool {
    infobars.count > 0
  }
}

enum InfobarOverlayAction: Equatable {
  case show(Infobar)
  case update(IdentifiedInfobar.ID, state: IdentifiedInfobar.State)
  case completedAnimation(IdentifiedInfobar.ID)
  
  case didTap(IdentifiedInfobar.ID)
  case didSwipeUp(IdentifiedInfobar.ID)
}

struct InfobarOverlayEnvironment {
  let uuid: () -> UUID
  let scheduler: AnySchedulerOf<DispatchQueue>
}

struct InfobarAnimationIdentifier: Hashable {
  let id: IdentifiedInfobar.ID
}

func showInfobarEffect(
  id: IdentifiedInfobar.ID,
  slideDuration: Int,
  displayDuration: Int,
  scheduler: AnySchedulerOf<DispatchQueue>
) -> Effect<InfobarOverlayAction, Never> {
  Effect.concatenate(
    Effect(value: .update(id, state: .active))
    // delay is needed for the initial state to be part of the view tree
      .delay(for: .milliseconds(1), scheduler: scheduler)
      .eraseToEffect(),
    Effect.concatenate(
      Effect(value: .update(id, state: .inactive))
        .delay(for: .milliseconds(displayDuration), scheduler: scheduler)
        .eraseToEffect(),
      Effect(value: .completedAnimation(id))
        .delay(for: .milliseconds(slideDuration), scheduler: scheduler)
        .eraseToEffect()
    )
      .cancellable(id: InfobarAnimationIdentifier(id: id), cancelInFlight: true)
  )
}

func replaceEffect(
  id: IdentifiedInfobar.ID,
  slideDuration: Int,
  scheduler: AnySchedulerOf<DispatchQueue>
) -> Effect<InfobarOverlayAction, Never> {
  Effect.concatenate(
    Effect(value: .update(id, state: .replaced))
      .eraseToEffect(),
    Effect(value: .completedAnimation(id))
      .delay(for: .milliseconds(slideDuration), scheduler: scheduler)
      .eraseToEffect()
  )
    .cancellable(id: InfobarAnimationIdentifier(id: id), cancelInFlight: true)
}

let infobarOverlayReducer = Reducer<
  InfobarOverlayState,
  InfobarOverlayAction,
  InfobarOverlayEnvironment
> { state, action, environment in
  switch action {
  case let .show(infobar):
    let id = environment.uuid()
    let identifiedInfobar = IdentifiedInfobar(
      id: id,
      infobar: infobar,
      state: .initial
    )
    
    let replaceEffects = state.infobars
      .filter { $0.state == .active }
      .map { activeInfobar in
        replaceEffect(
          id: activeInfobar.id,
          slideDuration: state.slideDuration,
          scheduler: environment.scheduler
        )
      }
    
    let effects = replaceEffects + [
      showInfobarEffect(
        id: id,
        slideDuration: state.slideDuration,
        displayDuration: infobar.style.displayDuration,
        scheduler: environment.scheduler
      )
    ]
    
    state.infobars.insert(identifiedInfobar, at: 0)
    
    return Effect.merge(effects)
    
  case let .update(id, state: newState):
    guard let index = state.infobars.firstIndex(where: { $0.id == id }) else {
      return .none
    }
    
    state.infobars[index].state = newState
    
    return .none
    
  case let .completedAnimation(id):
    guard
      state.infobars
        .lazy
        .map(\.id)
        .contains(id)
    else {
      return .none
    }
    state.infobars.remove(id: id)
    return .none
    
  case let .didTap(id):
    if let identifiedBar = state.infobars.first(where: { $0.id == id }),
       let action = identifiedBar.infobar.action {
      action()
    }
    
    return Effect.concatenate(
      Effect(value: .update(id, state: .inactive))
        .eraseToEffect(),
      Effect(value: .completedAnimation(id))
        .delay(for: .milliseconds(200), scheduler: environment.scheduler)
        .eraseToEffect()
    )
      .cancellable(id: InfobarAnimationIdentifier(id: id), cancelInFlight: true)
  
  case let .didSwipeUp(id):
    return Effect(value: .completedAnimation(id))
      .delay(for: .milliseconds(200), scheduler: environment.scheduler)
      .eraseToEffect()
  }
}
