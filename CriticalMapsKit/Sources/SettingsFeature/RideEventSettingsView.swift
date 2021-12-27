import ComposableArchitecture
import L10n
import SharedModels
import Styleguide
import SwiftUI
import SwiftUIHelpers

/// A view to render next ride event settings
public struct RideEventSettingsView: View {
  let store: Store<RideEventSettings, RideEventSettingsActions>
  @ObservedObject var viewStore: ViewStore<RideEventSettings, RideEventSettingsActions>
  
  public init(store: Store<RideEventSettings, RideEventSettingsActions>) {
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
            get: \.isEnabled,
            send: RideEventSettingsActions.setRideEventsEnabled
          )
        )
      }
      ZStack(alignment: .top) {
        VStack {
          SettingsSection(title: L10n.Settings.eventTypes) {
            ForEach(viewStore.typeSettings, id: \.type.title) { rideType in
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
            ForEach(EventDistance.allCases, id: \.self) { radius in
              SettingsRow {
                Button(
                  action: { viewStore.send(.setRideEventRadius(radius)) },
                  label: {
                    HStack(spacing: .grid(3)) {
                      Text(String(radius.rawValue))
                        .padding(.vertical, .grid(2))
                      Spacer()
                      if viewStore.eventDistance == radius {
                        Image(systemName: "checkmark.circle.fill")
                      }
                    }
                  }
                )
              }
            }
          }
        }
      }
      .foregroundColor(
        viewStore.isEnabled
        ? Color(.textPrimary)
        : Color(.textPrimary).opacity(0.5)
      )
      .disabled(!viewStore.isEnabled)
    }
    .navigationBarTitle(L10n.Settings.eventSettings, displayMode: .inline)
  }
}

// MARK: Preview
struct RideEventSettings_Previews: PreviewProvider {
  static var previews: some View {
    Preview {
      NavigationView {
        RideEventSettingsView(
          store: .init(
            initialState: .init(
              isEnabled: true,
              typeSettings: .all,
              eventDistance: .near
            ),
            reducer: rideeventSettingsReducer,
            environment: .init()
          )
        )
      }
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
