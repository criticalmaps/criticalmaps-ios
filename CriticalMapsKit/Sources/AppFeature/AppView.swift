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
    .sheet(
      isPresented: $store.isEventListPresented,
      onDismiss: { store.send(.dismissEventList) },
      content: {
        NavigationStack {
          RideEventBottomSheet(
            rideEvents: store.nextRideState.rideEvents,
            onRideSelected: { ride in store.send(.onRideSelectedFromBottomSheet(ride)) },
            onDismiss: { store.send(.set(\.isEventListPresented, false)) }
          )
          .presentationDetents(
            [.fraction(0.3), .large],
            selection: $store.eventListPresentation
          )
          .presentationBackgroundInteraction(.enabled(upThrough: .fraction(0.3)))
          .presentationBackgroundInteraction(.enabled)
        }
      }
    )
    .alert(
      $store.scope(
        state: \.destination?.alert,
        action: \.destination.alert
      )
    )
    .onAppear { store.send(.onAppear) }
    .onDisappear { store.send(.onDisappear) }
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

private struct RideEventBottomSheet: View {
  let rideEvents: [Ride]
  let onRideSelected: (Ride) -> Void
  let onDismiss: () -> Void

  var body: some View {
    List(rideEvents, id: \.id) { ride in
      RideEventView(ride: ride)
        .contentShape(.rect)
        .padding(.vertical, .grid(1))
        .accessibilityElement(children: .combine)
        .onTapGesture {
          onRideSelected(ride)
        }
        .listRowBackground(Color.clear)
    }
    .listStyle(.plain)
    .padding(.top, .grid(2))
    .accessibilityAction(.escape) {
      onDismiss()
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
