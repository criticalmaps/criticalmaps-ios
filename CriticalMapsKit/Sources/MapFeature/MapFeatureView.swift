import ComposableArchitecture
import Helpers
import L10n
import SharedDependencies
import SharedModels
import Styleguide
import SwiftUI

public struct MapFeatureView: View {
  @Environment(\.accessibilityReduceTransparency) var reduceTransparency

  public typealias State = MapFeature.State
  public typealias Action = MapFeature.Action

  public init(store: Store<State, Action>) {
    self.store = store
    viewStore = ViewStore(store)
  }

  let store: Store<State, Action>
  @ObservedObject var viewStore: ViewStore<State, Action>

  public var body: some View {
    ZStack(alignment: .topLeading) {
      MapView(
        riderCoordinates: viewStore.riderLocations,
        userTrackingMode: viewStore.binding(\.$userTrackingMode),
        shouldAnimateUserTrackingMode: viewStore.shouldAnimateTrackingMode,
        nextRide: viewStore.nextRide,
        rideEvents: viewStore.rideEvents,
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
          reducer: MapFeature().debug()
        )
      )
    }
  }
}
