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
