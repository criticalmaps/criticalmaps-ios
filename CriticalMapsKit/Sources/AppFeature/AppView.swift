import ComposableArchitecture
import L10n
import MapFeature
import SharedDependencies
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
        overlayViewsStack()
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
      onDismiss: { store.send(.set(\.isEventListPresented, false))
      },
      content: {
        NavigationStack {
          bottomSheetContentView()
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
  
  @ViewBuilder
  private func bottomSheetContentView() -> some View {
    List(store.nextRideState.rideEvents, id: \.id) { ride in
      RideEventView(ride: ride)
        .contentShape(Rectangle())
        .padding(.vertical, .grid(1))
        .accessibilityElement(children: .combine)
        .onTapGesture {
          store.send(.onRideSelectedFromBottomSheet(ride))
        }
        .listRowBackground(Color.clear)
    }
    .listStyle(.plain)
    .padding(.top, .grid(2))
    .accessibilityAction(.escape) {
      store.send(.set(\.isEventListPresented, false))
    }
  }
  
  @ViewBuilder
  private func offlineBanner() -> some View {
    Image(systemName: "wifi.slash")
      .foregroundColor(
        reduceTransparency
          ? Color.white
          : Color(.attention)
      )
      .accessibilityLabel(Text("Internet not available"))
      .padding()
      .conditionalBackground(shouldUseBlur: true, shouldUseGlassEffect: true)
  }
  
  @ViewBuilder
  private func nextRideBanner() -> some View {
    Button(
      action: { store.send(.didTapNextRideOverlayButton) },
      label: { Asset.cm.swiftUIImage }
    )
    .frame(minWidth: 50, minHeight: 50)
    .if(!.iOS26) { view in
      view
        .padding(.grid(1))
    }
    .foregroundStyle(Color(.textPrimary))
    .clipShape(.circle)
    .accessibilityHint(Text(L10n.A11y.Mapfeatureview.Nextridebanner.hint))
    .accessibilityLabel(Text(L10n.A11y.Mapfeatureview.Nextridebanner.label))
  }
  
  @ViewBuilder
  private func overlayViewsStack() -> some View {
    VStack(alignment: .leading) {
      if store.shouldShowNextRideBanner {
        nextRideBanner()
          .conditionalBackground(shouldUseBlur: true)
      }
      
      if store.userSettings.showInfoViewEnabled {
        InfoOverlayView(
          timerProgress: store.timerProgress,
          timerValue: store.timerValue,
          ridersCountLabel: store.ridersCount,
          isInPrivacyZone: store.isCurrentLocationInPrivacyZone
        )
      }
      
      if store.hasConnectionError {
        offlineBanner()
          .clipShape(Circle())
          .accessibleAnimation(.snappy, value: store.hasConnectionError)
      }
    }
  }
}

// MARK: - Preview

#Preview {
  AppView(
    store: Store(
      initialState: AppFeature.State(),
      reducer: { AppFeature()._printChanges() }
    )
  )
}

// MARK: - Helper

struct NumericContentTransition: ViewModifier {
  func body(content: Content) -> some View {
    content
      .contentTransition(.numericText())
  }
}
