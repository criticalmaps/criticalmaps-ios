import ComposableArchitecture
import SharedModels
import SwiftUI

// MARK: - Reducer

@Reducer
public struct CreateZoneFeature {
  public init() {}
  
  @ObservableState
  public struct State: Equatable {
    @Shared(.privacyZoneSettings) var settings
    public var newZoneName = ""
    public var newZoneRadius: Double = 400
    public var mapCenter: Coordinate?
    
    public var newZoneRadiusMeasurement: Measurement<UnitLength> {
      Measurement(value: newZoneRadius, unit: UnitLength.meters)
    }
    
    public init() {
      // Initialize radius with default from settings
      self.newZoneRadius = settings.defaultRadius
    }
    
    public var canCreateZone: Bool {
      !newZoneName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
      mapCenter != nil
    }
  }
  
  @CasePathable
  public enum Action: BindableAction {
    case binding(BindingAction<State>)
    case createZone
    case setMapCenter(Coordinate?)
    case dismiss
    case delegate(Delegate)
    
    @CasePathable
    public enum Delegate {
      case zoneCreated(PrivacyZone)
    }
  }
  
  @Dependency(\.uuid) var uuid
  @Dependency(\.date) var date
  @Dependency(\.dismiss) var dismiss
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    
    Reduce { state, action in
      switch action {
      case .createZone:
        guard
          state.canCreateZone,
          let center = state.mapCenter
        else {
          return .none
        }
        
        let newZone = PrivacyZone(
          id: uuid(),
          name: state.newZoneName.trimmingCharacters(in: .whitespacesAndNewlines),
          center: center,
          radius: state.newZoneRadius,
          createdAt: date()
        )
        
        return .run { send in
          await send(.delegate(.zoneCreated(newZone)))
          await dismiss()
        }
        
      case let .setMapCenter(coordinate):
        state.mapCenter = coordinate
        return .none
        
      case .dismiss:
        return .run { _ in
          await dismiss()
        }
        
      case .delegate:
        return .none
        
      case .binding:
        return .none
      }
    }
  }
}

// MARK: - View

let zoneRadiusRangeMin = Measurement(value: 100, unit: UnitLength.meters)
let zoneRadiusRangeMax = Measurement(value: 1000, unit: UnitLength.meters)
let zoneRadiusRange: ClosedRange<Double> = zoneRadiusRangeMin.value...zoneRadiusRangeMax.value

public struct CreatePrivacyZoneView: View {
  @Bindable var store: StoreOf<CreateZoneFeature>
  
  public init(store: StoreOf<CreateZoneFeature>) {
    self.store = store
  }
  
  public var body: some View {
    NavigationStack {
      VStack(spacing: .grid(5)) {
        mapSection
        detailsSection
        Spacer()
      }
      .navigationTitle("Create Privacy Zone")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .cancellationAction) {
          Button("Cancel", systemImage: "xmark") {
            store.send(.dismiss)
          }
        }
        
        ToolbarItem(placement: .confirmationAction) {
          Button("Create", systemImage: "checkmark") {
            store.send(.createZone)
          }
          .disabled(!store.canCreateZone)
          .fontWeight(.semibold)
        }
      }
      .padding()
    }
  }
  
  @ViewBuilder
  private var mapSection: some View {
    VStack(alignment: .leading, spacing: .grid(3)) {
      Text("Choose Location")
        .font(.headline)
      
      Text("Tap on the map to set the center of your privacy zone")
        .font(.subheadline)
        .foregroundColor(.secondary)
      
      PrivacyZoneMapView(
        zones: .constant([]),
        selectedZone: .constant(nil),
        isCreatingZone: .constant(true),
        newZoneRadius: $store.newZoneRadius,
        mapCenter: $store.mapCenter,
        showZones: false
      ) { coordinate in
        store.send(
          .setMapCenter(
            Coordinate(
              latitude: coordinate.latitude,
              longitude: coordinate.longitude
            )
          )
        )
      }
      .frame(height: 300)
      .clipShape(.rect(cornerRadius: 24))
      .overlay(
        RoundedRectangle(cornerRadius: 24)
          .stroke(Color(.systemGray4), lineWidth: 1)
      )
    }
  }
  
  @ViewBuilder
  private var detailsSection: some View {
    VStack(alignment: .leading, spacing: .grid(5)) {
      VStack(alignment: .leading, spacing: .grid(2)) {
        Text("Zone Name")
          .font(.headline)
        
        TextField("e.g., Home, Work, Gym", text: $store.newZoneName)
          .textFieldStyle(.roundedBorder)
          .autocorrectionDisabled()
      }
      
      VStack(alignment: .leading, spacing: .grid(3)) {
        HStack {
          Text("Radius")
            .font(.headline)
          Spacer()
          Text(store.newZoneRadiusMeasurement.formatted())
            .font(.subheadline)
            .foregroundColor(.primary)
            .padding(.horizontal, .grid(2))
            .padding(.vertical, .grid(1))
            .background(Color(.systemGray5))
            .cornerRadius(8)
        }
        
        Slider(
          value: $store.newZoneRadius,
          in: zoneRadiusRange,
          step: 50
        ) {
          Text("Radius")
        } minimumValueLabel: {
          Text(zoneRadiusRangeMin.formatted())
            .font(.caption)
            .foregroundColor(.secondary)
        } maximumValueLabel: {
          Text(zoneRadiusRangeMax.formatted())
            .font(.caption)
            .foregroundColor(.secondary)
        }
        .tint(Color(.brand500))
      }
    }
  }
}

#Preview {
  CreatePrivacyZoneView(
    store: Store(initialState: CreateZoneFeature.State()) {
      CreateZoneFeature()
    }
  )
}
