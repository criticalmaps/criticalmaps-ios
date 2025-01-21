import ComposableArchitecture
import FeedbackGeneratorClient
import Foundation
import L10n
import SharedModels
import SwiftUI

@Reducer
public struct RideEventRadius {
  public init() {}
  
  @Dependency(\.feedbackGenerator) private var feedbackGenerator
  
  @ObservableState
  public struct State: Equatable, Identifiable, Sendable, Codable {
    public let id: UUID
    public let eventDistance: EventDistance
    public var isSelected = false
    
    public init(id: UUID, eventDistance: EventDistance, isSelected: Bool) {
      self.id = id
      self.eventDistance = eventDistance
      self.isSelected = isSelected
    }
  }
  
  public enum Action: BindableAction, Equatable, Sendable {
    case binding(BindingAction<State>)
  }
  
  public var body: some Reducer<State, Action> {
    BindingReducer()
      .onChange(of: \.isSelected) { _, _ in
        Reduce { _, _ in
          .run { _ in await feedbackGenerator.selectionChanged() }
        }
      }
  }
}

public struct RideEventRadiusView: View {
  @Bindable var store: StoreOf<RideEventRadius>
  
  public var body: some View {
    SettingsRow {
      Button(
        action: { store.send(.binding(.set(\.isSelected, true))) },
        label: {
          HStack(spacing: .grid(3)) {
            Text(String(store.eventDistance.displayValue))
              .accessibility(label: Text(store.eventDistance.displayValue))
              .padding(.vertical, .grid(2))
            Spacer()
            if store.isSelected {
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
