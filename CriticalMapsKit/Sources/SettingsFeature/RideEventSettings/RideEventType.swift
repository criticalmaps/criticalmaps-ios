import ComposableArchitecture
import Foundation
import L10n
import SharedModels
import SwiftUI

// MARK: - Store

@Reducer
public struct RideEventType {
  public init() {}
  
  @ObservableState
  public struct State: Equatable, Identifiable {
    public var id: String {
      rideType.rawValue
    }

    public let rideType: Ride.RideType
    public var isEnabled = true
    
    public init(rideType: Ride.RideType, isEnabled: Bool) {
      self.rideType = rideType
      self.isEnabled = isEnabled
    }
  }
  
  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
  }
  
  public var body: some Reducer<State, Action> {
    BindingReducer()
  }
}

// MARK: - View

public struct RideEventTypeView: View {
  @Bindable private var store: StoreOf<RideEventType>
  
  public init(store: StoreOf<RideEventType>) {
    self.store = store
  }
  
  public var body: some View {
    Button(
      action: { store.isEnabled.toggle() },
      label: {
        HStack(spacing: .grid(3)) {
          Text(store.rideType.title)
          Spacer()
          Image(systemName: store.isEnabled ? "checkmark.circle.fill" : "circle")
        }
        .padding(.grid(1))
      }
    )
    .accessibilityValue(store.isEnabled ? Text(L10n.A11y.General.selected) : Text(""))
  }
}
