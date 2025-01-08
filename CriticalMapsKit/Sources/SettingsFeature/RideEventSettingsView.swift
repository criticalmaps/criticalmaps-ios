import ComposableArchitecture
import L10n
import SharedModels
import Styleguide
import SwiftUI
import SwiftUIHelpers

/// A view to render next ride event settings
public struct RideEventSettingsView: View {
  @State var store: StoreOf<RideEventsSettingsFeature>

  public init(store: StoreOf<RideEventsSettingsFeature>) {
    self.store = store
  }

  public var body: some View {
    SettingsForm {
      Spacer(minLength: 28)

      SettingsRow {
        HStack {
          Toggle(
            isOn: $store.isEnabled,
            label: { Text(L10n.Settings.eventSettingsEnable) }
          )
          .accessibilityRepresentation(representation: {
            store.isEnabled
              ? Text(L10n.A11y.General.on)
              : Text(L10n.A11y.General.off)
          })
        }
        .accessibilityElement(children: .combine)
      }
      
      ZStack(alignment: .top) {
        VStack {
          SettingsSection(title: L10n.Settings.eventTypes) {
            ForEachStore(
              self.store.scope(
                state: \.rideEventTypes,
                action: \.rideEventType
              )
            ) {
              RideEventTypeView(store: $0)
            }
          }

          SettingsSection(title: L10n.Settings.eventSearchRadius) {
            ForEach(EventDistance.allCases, id: \.self) { radius in
              SettingsRow {
                Button(
                  action: { store.send(.set(\.eventSearchRadius, radius)) },
                  label: {
                    HStack(spacing: .grid(3)) {
                      Text(String(radius.displayValue))
                        .accessibility(label: Text(radius.accessibilityLabel))
                        .padding(.vertical, .grid(2))
                      Spacer()
                      if store.eventSearchRadius == radius {
                        Image(systemName: "checkmark.circle.fill")
                          .accessibilityRepresentation {
                            Text(L10n.A11y.General.selected)
                          }
                      }
                    }
                    .accessibilityElement(children: .combine)
                  }
                )
              }
            }
          }
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: store.isEnabled ? .none : 0)
        .clipped()
        .accessibleAnimation(.interactiveSpring(), value: store.isEnabled)
      }
      .foregroundColor(Color(.textPrimary))
      .disabled(!store.isEnabled)
    }
    .navigationBarTitle(L10n.Settings.eventSettings, displayMode: .inline)
  }
}

// MARK: Preview

#Preview {
  Preview {
    NavigationView {
      RideEventSettingsView(
        store: Store(
          initialState: .init(settings: .init()),
          reducer: {
            RideEventsSettingsFeature()
          }
        )
      )
    }
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
