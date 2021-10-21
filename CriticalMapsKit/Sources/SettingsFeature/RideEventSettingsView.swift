import ComposableArchitecture
import L10n
import SharedModels
import Styleguide
import SwiftUI

public struct RideEventSettingsView: View {
  let store: Store<SettingsState, SettingsAction>
  @ObservedObject var viewStore: ViewStore<SettingsState, SettingsAction>
  
  public init(store: Store<SettingsState, SettingsAction>) {
    self.store = store
    self.viewStore = ViewStore(store)
  }
  
  public var body: some View {
    SettingsForm {
      Spacer(minLength: 28)
      
      SettingsRow {
        Toggle(
          L10n.Settings.eventSettingsEnable,
          isOn: viewStore.binding(
            get: \.userSettings.rideEventSettings.isEnabled,
            send: SettingsAction.setRideEventsEnabled
          )
        )
      }
      ZStack(alignment: .top) {
        VStack {
          SettingsSection(title: L10n.Settings.eventTypes) {
            ForEach(viewStore.state.userSettings.rideEventSettings.typeSettings, id: \.type.title) { rideType in
              SettingsRow {
                Button(
                  action: { viewStore.send(
                    .setRideEventTypeEnabled(
                      .init(
                        type: rideType.type,
                        isEnabled: !rideType.isEnabled)
                      )
                    )
                  },
                  label: {
                    RideEventSettingsRow(
                      title: rideType.type.title,
                      isEnabled: rideType.isEnabled
                    )
                  }
                )
              }
            }
          }
          
          SettingsSection(title: L10n.Settings.eventSearchRadius) {
            ForEach(Ride.eventRadii, id: \.self) { radius in
              SettingsRow {
                Button(
                  action: { viewStore.send(.setRideEventRadius(radius)) },
                  label: {
                    RideEventSettingsRow(
                      title: String(radius),
                      isEnabled: viewStore.userSettings.rideEventSettings.radiusSettings == radius
                    )
                  }
                )
              }
            }
          }
        }
      }
      .foregroundColor(
        viewStore.userSettings.rideEventSettings.isEnabled
        ? Color(.textPrimary)
        : Color(.textPrimary).opacity(0.4)
      )
      .disabled(!viewStore.userSettings.rideEventSettings.isEnabled)
    }
    .navigationBarTitle(L10n.Settings.eventSettings, displayMode: .inline)
  }
}

struct RideEventSettingsRow: View {
  let title: String
  let isEnabled: Bool
  
  var body: some View {
    HStack(spacing: .grid(3)) {
      Text(title)
        .padding(.vertical, .grid(2))
      Spacer()
      if isEnabled {
        Image(systemName: "checkmark")
      }
    }
  }
}
