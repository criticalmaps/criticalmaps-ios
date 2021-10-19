import ComposableArchitecture
import L10n
import SharedModels
import Styleguide
import SwiftUI

public struct EventSettingsView: View {
  let store: Store<SettingsState, SettingsAction>
  @ObservedObject var viewStore: ViewStore<SettingsState, SettingsAction>
  
  public init(store: Store<SettingsState, SettingsAction>) {
    self.store = store
    self.viewStore = ViewStore(store)
  }
  
  public var body: some View {
    SettingsForm {
      SettingsSection(title: " ") {
        SettingsRow {
          Toggle(L10n.Settings.eventSettingsEnable, isOn: .constant(true))
        }
      }
      
      SettingsSection(title: L10n.Settings.eventTypes) {
        ForEach(Ride.IdentifiableRideType.all) { rideType in
          SettingsRow {
            HStack(spacing: .grid(3)) {
              Text(rideType.rideType.title)
                .padding(.vertical, .grid(2))
              Spacer()
              Image(systemName: "checkmark")
            }
            .foregroundColor(Color(.textPrimary))
          }
        }
      }
      
      SettingsSection(title: L10n.Settings.eventSearchRadius) {
        ForEach(Ride.Radius.all) { radius in
          SettingsRow {
            HStack(spacing: .grid(3)) {
              Text(String(radius.value))
                .padding(.vertical, .grid(2))
              Spacer()
              Image(systemName: "checkmark")
            }
          }
          .foregroundColor(Color(.textPrimary))
        }
      }
    }
    .navigationBarTitle(L10n.Settings.eventSettings, displayMode: .inline)
  }
}
