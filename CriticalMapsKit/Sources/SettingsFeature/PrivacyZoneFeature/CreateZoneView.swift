import ComposableArchitecture
import SharedModels
import SwiftUI

public struct CreateZoneView: View {
  @Bindable var store: StoreOf<CreateZoneFeature>
  
  public init(store: StoreOf<CreateZoneFeature>) {
    self.store = store
  }
  
  public var body: some View {
    NavigationStack {
      VStack(spacing: 20) {
        mapSection
        detailsSection
        Spacer()
      }
      .navigationTitle("Create Privacy Zone")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .navigationBarLeading) {
          Button("Cancel") {
            store.send(.dismiss)
          }
        }
        
        ToolbarItem(placement: .navigationBarTrailing) {
          Button("Create") {
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
    VStack(alignment: .leading, spacing: 12) {
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
        store.send(.setMapCenter(Coordinate(
          latitude: coordinate.latitude,
          longitude: coordinate.longitude
        )))
      }
      .frame(height: 300)
      .cornerRadius(12)
      .overlay(
        RoundedRectangle(cornerRadius: 12)
          .stroke(Color(.systemGray4), lineWidth: 1)
      )
    }
  }
  
  @ViewBuilder
  private var detailsSection: some View {
    VStack(alignment: .leading, spacing: 20) {
      VStack(alignment: .leading, spacing: 8) {
        Text("Zone Name")
          .font(.headline)
        
        TextField("e.g., Home, Work, Gym", text: $store.newZoneName)
          .textFieldStyle(.roundedBorder)
      }
      
      VStack(alignment: .leading, spacing: 12) {
        HStack {
          Text("Radius")
            .font(.headline)
          Spacer()
          Text("\(Int(store.newZoneRadius))m")
            .font(.subheadline)
            .foregroundColor(.primary)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color(.systemGray5))
            .cornerRadius(6)
        }
        
        Slider(
          value: $store.newZoneRadius,
          in: 100...1000,
          step: 50
        ) {
          Text("Radius")
        } minimumValueLabel: {
          Text("100m")
            .font(.caption)
            .foregroundColor(.secondary)
        } maximumValueLabel: {
          Text("1km")
            .font(.caption)
            .foregroundColor(.secondary)
        }
      }
      
      if store.mapCenter != nil {
        HStack {
          Image(systemName: "checkmark.circle.fill")
            .foregroundColor(.green)
          Text("Location selected")
            .font(.subheadline)
            .foregroundColor(.secondary)
          Spacer()
        }
      } else {
        HStack {
          Image(systemName: "location.circle")
            .foregroundColor(.secondary)
          Text("Tap the map to select a location")
            .font(.subheadline)
            .foregroundColor(.secondary)
          Spacer()
        }
      }
    }
  }
}

#Preview {
  CreateZoneView(
    store: Store(initialState: CreateZoneFeature.State()) {
      CreateZoneFeature()
    }
  )
}