import ComposableArchitecture
import Styleguide
import SwiftUI

struct InfobarOverlay: View {
  let store: Store<InfobarOverlayState, InfobarOverlayAction>
  @State private var offset = CGSize.zero
  
  var body: some View {
    WithViewStore(store) { viewStore in
      ZStack {
        ForEach(
          viewStore.infobars,
          id: \.id,
          content: { infobar in
            VStack {
              InfobarView(infobar.infobar)
                .offset(x: 0, y: offset.height)
                .gesture(
                  DragGesture(
                    minimumDistance: 40,
                    coordinateSpace: .global
                  )
                  .onChanged({ value in
                    guard value.translation.height < 50 else { return }
                    offset = value.translation
                  })
                  .onEnded({ _ in
                    let offsetWidth = abs(offset.width)
                    if offsetWidth > 0 {
                      viewStore.send(.didSwipeUp(infobar.id))
                    } else {
                        offset = .zero
                    }
                  })
                )
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
      .padding(.horizontal, .grid(4))
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
