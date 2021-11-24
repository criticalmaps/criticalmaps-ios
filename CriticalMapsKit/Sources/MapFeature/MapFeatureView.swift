import ComposableArchitecture
import Helpers
import SharedModels
import Styleguide
import SwiftUI

public struct MapFeatureView: View {
  @Environment(\.accessibilityReduceTransparency) var reduceTransparency
  
  public init(store: Store<MapFeatureState, MapFeatureAction>) {
    self.store = store
    self.viewStore = ViewStore(store)
  }
  
  let store: Store<MapFeatureState, MapFeatureAction>
  @ObservedObject var viewStore: ViewStore<MapFeatureState, MapFeatureAction>
  
  public var body: some View {
    ZStack(alignment: .topTrailing) {
      MapView(
        riderCoordinates: viewStore.riderLocations,
        userTrackingMode: viewStore.binding(
          get: { $0.userTrackingMode.userTrackingMode },
          send: MapFeatureAction.updateUserTrackingMode
        ),
        shouldAnimateUserTrackingMode: viewStore.shouldAnimateTrackingMode,
        nextRide: viewStore.nextRide,
        centerRegion: viewStore.binding(
          get: \.centerRegion,
          send: MapFeatureAction.updateCenterRegion
        )
      )
      .edgesIgnoringSafeArea(.all)
      
      nextRideBanner
        .padding(.top, .grid(12))
        .padding(.horizontal)
    }
  }
  
  var nextRideBanner: some View {
    Button(
      action: { viewStore.send(.focusNextRide) },
      label: {
        HStack {
          Image(uiImage: Images.eventMarker)
          
          if viewStore.isNextRideBannerExpanded {
            VStack(alignment: .leading) {
              Text(viewStore.nextRide?.title ?? "")
                .font(.titleTwo)
                .foregroundColor(Color(.textPrimary))
              Text(viewStore.nextRide?.rideDateAndTime ?? "")
                .font(.bodyTwo)
                .foregroundColor(Color(.textSecondary))
            }
            .opacity(viewStore.isNextRideBannerExpanded ? 1 : 0)
            .animation(.easeOut, value: viewStore.isNextRideBannerExpanded)
          }
        }
        .padding(.horizontal, viewStore.isNextRideBannerExpanded ? 8 : 0)
      }
    )
      .frame(minWidth: 50, minHeight: 50)
      .foregroundColor(.white)
      .background(
        Group {
          if reduceTransparency {
            RoundedRectangle(
              cornerRadius: 4,
              style: .circular
            )
          } else {
            Blur()
              .cornerRadius(12)
          }
        }
      )
      .scaleEffect(viewStore.isNextRideBannerVisible ? 1 : 0)
      .animation(.easeOut)
  }
}

// MARK: Preview
struct MapFeatureView_Previews: PreviewProvider {
  static var previews: some View {
    MapFeatureView(
      store: Store<MapFeatureState, MapFeatureAction>(
        initialState: MapFeatureState(
          riders: [],
          userTrackingMode: UserTrackingState(userTrackingMode: .follow)
        ),
        reducer: mapFeatureReducer,
        environment: MapFeatureEnvironment(
          locationManager: .live,
          mainQueue: .failing
        )
      )
    )
  }
}
