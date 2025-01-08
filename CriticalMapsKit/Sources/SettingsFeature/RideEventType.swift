import ComposableArchitecture
import Foundation
import L10n
import SharedModels
import SwiftUI

@Reducer
public struct RideEventType {
  public init() {}
  
  @ObservableState
  public struct State: Equatable, Identifiable, Sendable, Codable {
    public var id: String {
      self.rideType.rawValue
    }
    public let rideType: Ride.RideType
    public var isEnabled = true
    
    public init(rideType: Ride.RideType, isEnabled: Bool) {
      self.rideType = rideType
      self.isEnabled = isEnabled
    }
  }
  
  public enum Action: BindableAction, Equatable, Sendable {
    case binding(BindingAction<State>)
  }
  
  public var body: some Reducer<State, Action> {
    BindingReducer()
  }
}

public struct RideEventTypeView: View {
  @State private var store: StoreOf<RideEventType>
  
  public init(store: StoreOf<RideEventType>) {
    self.store = store
  }
  
  public var body: some View {
    SettingsRow {
      Button(
        action: { store.send(.binding(.set(\.isEnabled, !store.isEnabled))) },
        label: {
          HStack(spacing: .grid(3)) {
            Text(store.rideType.title)
              .padding(.vertical, .grid(2))
            Spacer()
            if store.isEnabled {
              Image(systemName: "checkmark.circle.fill")
            } else {
              Image(systemName: "circle")
            }
          }
        }
      )
    }
    .accessibilityValue(store.isEnabled ? Text(L10n.A11y.General.selected) : Text(""))
  }
}
