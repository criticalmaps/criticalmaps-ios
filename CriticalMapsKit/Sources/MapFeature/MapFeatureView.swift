import ComposableArchitecture
import Helpers
import L10n
import SharedDependencies
import SharedModels
import Styleguide
import SwiftUI

public struct MapFeatureView: View {
  @Environment(\.accessibilityReduceTransparency) var reduceTransparency
  
  public init(store: StoreOf<MapFeature>) {
    self.store = store
    viewStore = ViewStore(store, observe: { $0 })
  }

  let store: StoreOf<MapFeature>
  @ObservedObject var viewStore: ViewStoreOf<MapFeature>

  public var body: some View {
    ZStack(alignment: .topLeading) {
      MapView(
        riderCoordinates: viewStore.riderLocations,
        userTrackingMode: viewStore.binding(\.$userTrackingMode),
        nextRide: viewStore.nextRide,
        rideEvents: viewStore.rideEvents,
        annotationsCount: viewStore.binding(\.$visibleRidersCount),
        centerRegion: viewStore.binding(\.$centerRegion),
        centerEventRegion: viewStore.binding(\.$eventCenter),
        mapMenuShareEventHandler: {
          viewStore.send(.showShareSheet(true))
        },
        mapMenuRouteEventHandler: {
          viewStore.send(.routeToEvent)
        }
      )
      .edgesIgnoringSafeArea(.all)
    }
    .sheet(
      isPresented: viewStore.binding(\.$presentShareSheet),
      onDismiss: { viewStore.send(.showShareSheet(false)) },
      content: {
        ShareSheetView(activityItems: [viewStore.nextRide?.shareMessage ?? ""])
      }
    )
  }
}

// MARK: Preview

import SwiftUIHelpers

struct MapFeatureView_Previews: PreviewProvider {
  static var previews: some View {
    Preview {
      MapFeatureView(
        store: Store<MapFeature.State, MapFeature.Action>(
          initialState: MapFeature.State(
            riders: [],
            userTrackingMode: UserTrackingFeature.State(userTrackingMode: .follow)
          ),
          reducer: MapFeature()._printChanges()
        )
      )
    }
  }
}
