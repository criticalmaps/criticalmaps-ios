import ComposableArchitecture
import L10n
import MapKit
import SwiftUI
import SwiftUIHelpers

/// Button to toggle tracking modes
public struct UserTrackingButton: View {
  let store: Store<UserTrackingState, UserTrackingAction>
  @ObservedObject var viewStore: ViewStore<UserTrackingState, UserTrackingAction>
  
  public init(store: Store<UserTrackingState, UserTrackingAction>) {
    self.store = store
    self.viewStore = ViewStore(store)
  }
  
  public var body: some View {
    Button(
      action: {
        viewStore.send(.nextTrackingMode)
      },
      label: {
        iconImage
      }
    )
    .accessibility(label: Text(viewStore.mode.accessiblityLabel))
    .accessibilityAction(named: Text("Toggle tracking mode"), {
      viewStore.send(.nextTrackingMode)
    })
    .accessibilityHint(Text("Toggle tracking mode")) // TODO: L10n
    
  }
  
  var iconImage: some View {
    switch viewStore.mode {
    case .follow:
      return Image(systemName: "location.fill")
        .iconModifier()
    case .followWithHeading:
      return Image(systemName: "location.north.line.fill")
        .iconModifier()
    case .none:
      return Image(systemName: "location")
        .iconModifier()
    @unknown default:
      return Image(systemName: "location")
        .iconModifier()
    }
  }
}

// MARK: Preview
struct UserTrackingButton_Previews: PreviewProvider {
  static var previews: some View {
    Preview {
      Group {
        UserTrackingButton(
          store: .init(
            initialState: .init(userTrackingMode: .none),
            reducer: userTrackingReducer,
            environment: UserTrackingEnvironment()
          )
        )
        UserTrackingButton(
          store: .init(
            initialState: .init(userTrackingMode: .follow),
            reducer: userTrackingReducer,
            environment: UserTrackingEnvironment()
          )
        )
        UserTrackingButton(
          store: .init(
            initialState: .init(userTrackingMode: .followWithHeading),
            reducer: userTrackingReducer,
            environment: UserTrackingEnvironment()
          )
        )
      }
    }
  }
}
