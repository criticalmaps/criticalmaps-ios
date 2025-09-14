import ComposableArchitecture
import CoreLocation
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

      Section {
        ForEach(store.scope(state: \.rideEventTypes, action: \.rideEventType)) {
          RideEventTypeView(store: $0)
        }
        .disabled(!store.isEnabled)
      } header: {
        SectionHeader {
          Text(L10n.Settings.eventTypes)
        }
      } footer: {
        Text("Select which types of ride events you'd like to be notified about when they occur near your location.")
          .font(.footnote)
          .foregroundStyle(.secondary)
      }
      
      Section {
        ForEach(EventDistance.allCases, id: \.self) { radius in
          Button(
            action: {
              store.send(.binding(.set(\.eventSearchRadius, radius)))
            },
            label: { distanceRow(radius) }
          )
        }
        .disabled(!store.isEnabled)
      } header: {
        SectionHeader {
          Text(L10n.Settings.eventSearchRadius)
        }
      } footer: {
        Text("Choose how far around your location to search for ride events. A larger radius will show more events but may include those less relevant to your ride.")
          .font(.footnote)
          .foregroundStyle(.secondary)
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
        Image(systemName: "checkmark")
          .accessibilityRepresentation { Text(L10n.A11y.General.selected) }
          .fontWeight(.medium)
      }
    }
    .animation(nil, value: store.isEnabled)
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
