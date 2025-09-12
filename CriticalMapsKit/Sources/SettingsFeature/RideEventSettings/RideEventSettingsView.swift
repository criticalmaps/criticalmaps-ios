import ComposableArchitecture
import L10n
import SharedModels
import Styleguide
import SwiftUI
import SwiftUIHelpers

/// A view to render next ride event settings
public struct RideEventSettingsView: View {
  @Bindable private var store: StoreOf<RideEventsSettingsFeature>

  public init(store: StoreOf<RideEventsSettingsFeature>) {
    self.store = store
  }

  public var body: some View {
    SettingsForm {
      Toggle(
        isOn: $store.isEnabled.animation(),
        label: { Text(L10n.Settings.eventSettingsEnable) }
      )

      Section(L10n.Settings.eventTypes) {
        ForEach(store.scope(state: \.rideEventTypes, action: \.rideEventType)) {
          RideEventTypeView(store: $0)
        }
        .disabled(!store.isEnabled)
      }
      
      Section(L10n.Settings.eventSearchRadius) {
        ForEach(EventDistance.allCases, id: \.self) { radius in
          Button(
            action: {
              store.send(
                .binding(.set(\.eventSearchRadius, radius)),
                animation: .spring
              )
            },
            label: { distanceRow(radius) }
          )
        }
        .disabled(!store.isEnabled)
      }
    }
    .accessibleAnimation(.snappy, value: store.isEnabled)
    .navigationBarTitle(L10n.Settings.eventSettings, displayMode: .inline)
  }
  
  @ViewBuilder
  private func distanceRow(_ radius: EventDistance) -> some View {
    HStack(spacing: .grid(2)) {
      Text(String(radius.displayValue))
        .accessibility(label: Text(radius.accessibilityLabel))
      Spacer()
      if store.eventSearchRadius == radius {
        Image(systemName: "checkmark.circle.fill")
          .accessibilityRepresentation {
            Text(L10n.A11y.General.selected)
          }
      }
    }
    .animation(nil)
    .padding(.vertical, .grid(1))
    .accessibilityElement(children: .combine)
  }
}

// MARK: Preview

#Preview {
  NavigationView {
    RideEventSettingsView(
      store: Store(
        initialState: .init(isEnabled: true),
        reducer: {
          RideEventsSettingsFeature()
        }
      )
    )
  }
}

// MARK: Helper

struct RideEventSettingsRow: View {
  let title: String
  let isEnabled: Bool

  var body: some View {
    HStack(spacing: .grid(3)) {
      Text(title)
        .padding(.vertical, .grid(2))
      Spacer()
      if isEnabled {
        Image(systemName: "checkmark.circle.fill")
      } else {
        Image(systemName: "circle")
      }
    }
  }
}
