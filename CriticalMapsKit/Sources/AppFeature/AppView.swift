import ComposableArchitecture
import L10n
import MapFeature
import SharedModels
import Styleguide
import SwiftUI

/// The apps main view
public struct AppView: View {
  @State private var store: StoreOf<AppFeature>
  @Namespace private var namespace
  
  @Environment(\.accessibilityReduceTransparency) private var reduceTransparency
  @Environment(\.horizontalSizeClass) private var horizontalSizeClass
  
  public init(store: StoreOf<AppFeature>) {
    self.store = store
  }
  
  public var body: some View {
    ZStack(alignment: .topLeading) {
      MapFeatureView(
        store: store.scope(state: \.mapFeatureState, action: \.map)
      )
      .ignoresSafeArea(edges: .vertical)

      HStack {
        OverlayViewsStack(store: store)
          .padding(.top, .grid(1))

        Spacer()
      }
      .padding(.horizontal)

      VStack {
        Spacer()

        AppNavigationView(store: store)
          .accessibilitySortPriority(1)
          .padding(.horizontal)
          .padding(.bottom, .grid(7))
          .frame(maxWidth: 450)
      }
      .frame(maxWidth: .infinity, alignment: .center)
      .padding(.horizontal)
    }
    .onAppear { store.send(.onAppear) }
    .onDisappear { store.send(.onDisappear) }
    .sheet(
      item: $store.scope(\.$destination.rideEvents, action: \.destination.rideEvents),
      onDismiss: { store.send(.dismissEventList) }
    ) { rideEventsStore in
      NavigationStack {
        RideEventBottomSheet(store: rideEventsStore)
          .presentationDetents(
            [.fraction(0.3), .large],
            selection: $store.eventListPresentation
          )
          .presentationBackgroundInteraction(.enabled(upThrough: .fraction(0.3)))
          .presentationBackgroundInteraction(.enabled)
      }
    }
    .sheet(
      item: $store.scope(\.$destination.whatsNew, action: \.destination.whatsNew),
      onDismiss: { store.send(.whatsNewDismissed) },
      content: { whatsNewStore in
        NavigationStack {
          WhatsNewSheet(store: whatsNewStore)
            .navigationTitle("Whats new")
        }
      }
    )
  }
}

// MARK: - Subviews

private struct OfflineBannerView: View {
  @Environment(\.accessibilityReduceTransparency) private var reduceTransparency

  var body: some View {
    Image(systemName: "wifi.slash")
      .foregroundColor(
        reduceTransparency
          ? Color.white
          : Color.attention
      )
      .accessibilityLabel(Text("Internet not available"))
      .padding()
      .conditionalBackground(shouldUseBlur: true)
  }
}

private struct NextRideBannerButton: View {
  let action: () -> Void

  var body: some View {
    Button(
      action: action,
      label: { Asset.cm.swiftUIImage }
    )
    .frame(minWidth: 50, minHeight: 50)
    .padding(Bool.iOS26 ? 0 : .grid(1))
    .foregroundStyle(Color.textPrimary)
    .clipShape(.circle)
    .accessibilityHint(Text(L10n.A11y.Mapfeatureview.Nextridebanner.hint))
    .accessibilityLabel(Text(L10n.A11y.Mapfeatureview.Nextridebanner.label))
  }
}

private struct OverlayViewsStack: View {
  let store: StoreOf<AppFeature>

  var body: some View {
    VStack(alignment: .leading) {
      if store.shouldShowNextRideBanner {
        NextRideBannerButton(action: { store.send(.didTapNextRideOverlayButton) })
          .conditionalBackground(shouldUseBlur: true)
      }

      if store.userSettings.showInfoViewEnabled {
        InfoOverlayView(
          cycleStartTime: store.requestTimer.cycleStartTime,
          ridersCountLabel: store.ridersCount,
          isInPrivacyZone: store.isCurrentLocationInPrivacyZone
        )
      }

      if store.hasConnectionError {
        OfflineBannerView()
          .clipShape(.circle)
          .accessibleAnimation(.snappy, value: store.hasConnectionError)
      }
    }
  }
}

// MARK: - RideEventSheet

@Reducer
public struct RideEvents: Sendable {
  public init() {}
	
  @ObservableState
  public struct State: Equatable, Sendable {
    let rideEvents: [Ride]

    public init(
      rideEvents: [Ride]
    ) {
      self.rideEvents = rideEvents
    }
  }
	
  public enum Action {
    case selectRide(Ride)
    case dismiss
  }
	
  public var body: some ReducerOf<Self> {
    Reduce { _, action in
      switch action {
      case .selectRide:
        .none
      case .dismiss:
        .none
      }
    }
  }
}

private struct RideEventBottomSheet: View {
  @State var store: StoreOf<RideEvents>
	
  var body: some View {
    List(store.rideEvents) { ride in
      RideEventView(ride: ride)
        .contentShape(.rect)
        .padding(.vertical, .grid(1))
        .accessibilityElement(children: .combine)
        .onTapGesture {
          store.send(.selectRide(ride))
        }
        .listRowBackground(Color.clear)
    }
    .listStyle(.plain)
    .padding(.top, .grid(2))
    .accessibilityAction(.escape) {
      store.send(.dismiss)
    }
  }
}

// MARK: - Previews

#Preview {
  AppView(
    store: Store(
      initialState: AppFeature.State(),
      reducer: { AppFeature()._printChanges() }
    )
  )
}
