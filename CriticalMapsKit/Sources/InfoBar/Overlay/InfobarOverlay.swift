import ComposableArchitecture
import SwiftUI

struct InfobarOverlay: View {
  let store: Store<InfobarOverlayState, InfobarOverlayAction>
  
  var body: some View {
    WithViewStore(store) { viewStore in
      ZStack {
        ForEach(
          viewStore.infobars,
          id: \.id,
          content: { infobar in
            VStack {
              InfobarView(infobar.infobar)
                .onTapGesture {
                  viewStore.send(.didTap(infobar.id))
                }
                .modifier(
                  SizeRelativeOffsetEffect(
                    offsetMutiplier: CGPoint(
                      x: 0,
                      y: offsetMultiplier(basedOn: infobar.state)
                    )
                  )
                )
                .opacity(alpha(basedOn: infobar.state))
                .animation(
                  .easeOut(
                    duration: Double(viewStore.slideDuration) / 1000.0
                  )
                )
              Spacer()
            }
          }
        )
        Spacer()
      }
      .padding(.horizontal, 8)
    }
  }
  
  private func alpha(basedOn state: IdentifiedInfobar.State) -> Double {
    switch state {
    case .active:
      return 1
    case .inactive, .initial, .replaced:
      return 0
    }
  }
  
  private func offsetMultiplier(basedOn state: IdentifiedInfobar.State) -> CGFloat {
    switch state {
    case .active:
      return 0
    case .inactive, .initial:
      return -1
    case .replaced:
      return 1
    }
  }
}

struct InfobarOverlay_Previews: PreviewProvider {
  static var previews: some View {
    InfobarOverlay(
      store: .init(
        initialState: .init(infobars: []),
        reducer: .empty,
        environment: ()
      )
    )
  }
}
