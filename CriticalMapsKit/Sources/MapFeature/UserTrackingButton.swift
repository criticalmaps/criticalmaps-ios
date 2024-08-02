import ComposableArchitecture
import L10n
import MapKit
import SwiftUI
import SwiftUIHelpers

/// Button to toggle tracking modes
public struct UserTrackingButton: View {
  public typealias State = UserTrackingFeature.State
  public typealias Action = UserTrackingFeature.Action

  let store: StoreOf<UserTrackingFeature>
  @ObservedObject var viewStore: ViewStoreOf<UserTrackingFeature>

  public init(store: StoreOf<UserTrackingFeature>) {
    self.store = store
    viewStore = ViewStore(store, observe: { $0 })
  }

  public var body: some View {
    Button(
      action: {
        viewStore.send(.nextTrackingMode, animation: nil)
      },
      label: { iconImage }
    )
    .accessibility(label: Text(viewStore.mode.accessiblityLabel))
    .accessibilityAction(named: Text(L10n.A11y.Usertrackingbutton.hint)) {
      viewStore.send(.nextTrackingMode, animation: nil)
    }
    .accessibilityHint(Text(L10n.A11y.Usertrackingbutton.hint))
    .accessibilityShowsLargeContentViewer {
      Label(
        viewStore.mode.accessiblityLabel,
        systemImage: systemImageIdentifier
      )
    }
  }
  
  private var systemImageIdentifier: String {
    switch viewStore.mode {
    case .follow:
      return "location.fill"
    case .followWithHeading:
      return "location.north.line.fill"
    case .none:
      return "location"
    @unknown default:
      return "location"
    }
  }

  @ViewBuilder
  var iconImage: some View {
    Image(systemName: systemImageIdentifier)
      .iconModifier()
  }
}

// MARK: Preview

#Preview {
  Preview {
    Group {
      UserTrackingButton(
        store: .init(
          initialState: .init(userTrackingMode: .none),
          reducer: { UserTrackingFeature()._printChanges() }
        )
      )
      UserTrackingButton(
        store: .init(
          initialState: .init(userTrackingMode: .follow),
          reducer: { UserTrackingFeature()._printChanges() }
        )
      )
      UserTrackingButton(
        store: .init(
          initialState: .init(userTrackingMode: .followWithHeading),
          reducer: { UserTrackingFeature()._printChanges() }
        )
      )
    }
  }
}
