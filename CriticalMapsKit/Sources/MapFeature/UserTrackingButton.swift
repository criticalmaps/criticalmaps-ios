import ComposableArchitecture
import L10n
import MapKit
import SwiftUI

/// Button to toggle tracking modes
public struct UserTrackingButton: View {
  @State private var store: StoreOf<UserTrackingFeature>

  public init(store: StoreOf<UserTrackingFeature>) {
    self.store = store
  }

  public var body: some View {
    Button(
      action: { store.send(.nextTrackingMode, animation: nil) },
      label: { iconImage }
    )
    .contentTransition(.symbolEffect(.replace.downUp, options: .speed(3)))
    .accessibility(label: Text(store.mode.accessibilityLabel))
    .accessibilityAction(named: Text(L10n.A11y.Usertrackingbutton.hint)) {
      store.send(.nextTrackingMode, animation: nil)
    }
    .accessibilityHint(Text(L10n.A11y.Usertrackingbutton.hint))
    .accessibilityShowsLargeContentViewer {
      Label(
        store.mode.accessibilityLabel,
        systemImage: systemImageIdentifier
      )
    }
  }

  private var systemImageIdentifier: String {
    switch store.mode {
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
