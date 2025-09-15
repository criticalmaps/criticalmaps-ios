import ComposableArchitecture
import GuideFeature
import Helpers
import L10n
import MapFeature
import MastodonFeedFeature
import SettingsFeature
import SocialFeature
import Styleguide
import SwiftUI

public struct AppNavigationView: View {
  @State private var store: StoreOf<AppFeature>
  @Environment(\.colorScheme) private var colorScheme
  private let minHeight: CGFloat = 56
  
  public init(store: StoreOf<AppFeature>) {
    self.store = store
  }
  
  public var body: some View {
    HStack {
      UserTrackingButton(
        store: store.scope(
          state: \.mapFeatureState.userTrackingMode,
          action: \.map.userTracking
        )
      )
      .padding(10)
      .frame(maxWidth: .infinity, minHeight: minHeight)
      .contentShape(Rectangle())
      menuSeperator
      
      // Chat
      chatFeature
        .accessibility(label: Text("App navigation \(L10n.Chat.title)"))
      menuSeperator
      
      // Settings
      settingsFeature
        .accessibility(label: Text("App navigation \(L10n.Settings.title)"))
    }
    .font(.body)
    .modifier(AppNavigationBackgroundModifier())
    .modifier(ShadowModifier())
  }
  
  // MARK: Chat
  
  private var badge: some View {
    ZStack {
      Circle()
        .foregroundColor(.red)
      
      Text(store.chatMessageBadgeCount == 0 ? "" : String(store.chatMessageBadgeCount))
        .animation(nil)
        .foregroundColor(.white)
        .font(Font.system(size: 12))
        .contentTransition(.numericText())
    }
    .frame(width: 20, height: 20)
    .offset(x: 14, y: -10)
    .scaleEffect(store.chatMessageBadgeCount == 0 ? 0 : 1, anchor: .topTrailing)
    .opacity(store.chatMessageBadgeCount == 0 ? 0 : 1)
    .accessibleAnimation(.easeIn(duration: 0.1), value: store.chatMessageBadgeCount)
    .accessibilityLabel(Text(L10n.Home.Tab.Social.unreadMessages(store.chatMessageBadgeCount)))
  }
  
  private var chatFeature: some View {
    Button(
      action: { store.send(.socialButtonTapped) },
      label: {
        ZStack {
          Image(systemName: "bubble.left")
            .iconModifier()
          badge
        }
      }
    )
    .frame(maxWidth: .infinity, minHeight: minHeight)
    .contentShape(Rectangle())
    .accessibilityShowsLargeContentViewer {
      let unreadMessages = store.chatMessageBadgeCount != 0 ? "\n " + L10n.Home.Tab.Social.unreadMessages(store.chatMessageBadgeCount) : ""
      Label(L10n.Chat.title + unreadMessages, systemImage: "bubble.left")
    }
    .sheet(
      item: $store.scope(
        state: \.destination?.social,
        action: \.destination.social
      ),
      onDismiss: { store.send(.dismissDestination) },
      content: { store in
        NavigationStack {
          SocialView(store: store)
        }
      }
    )
  }
  
  private var settingsFeature: some View {
    Button(
      action: { store.send(.settingsButtonTapped) },
      label: {
        Image(systemName: "gearshape")
          .iconModifier()
      }
    )
    .frame(maxWidth: .infinity, minHeight: minHeight)
    .contentShape(Rectangle())
    .accessibilityShowsLargeContentViewer {
      Label(L10n.Settings.title, systemImage: "gearshape")
    }
    .sheet(
      item: $store.scope(
        state: \.destination?.settings,
        action: \.destination.settings
      ),
      onDismiss: { store.send(.dismissDestination) },
      content: { store in
        NavigationStack {
          SettingsView(store: store)
        }
        .accentColor(Color(.textPrimary))
      }
    )
  }
  
  private var menuSeperator: some View {
    Color(.border)
      .frame(width: 1, height: minHeight)
      .accessibilityHidden(true)
  }
}

// MARK: Preview

#Preview {
  AppNavigationView(
    store: Store<AppFeature.State, AppFeature.Action>(
      initialState: .init(),
      reducer: { AppFeature() }
    )
  )
}

// MARK: - Helper

private struct AppNavigationBackgroundModifier: ViewModifier {
  @Environment(\.accessibilityReduceTransparency) private var reduceTransparency
  @Environment(\.colorSchemeContrast) private var colorSchemeContrast
  
  private var shouldShowAccessiblyBackground: Bool {
    reduceTransparency || colorSchemeContrast.isIncreased
  }
  
  func body(content: Content) -> some View {
    if #available(iOS 26.0, *) {
      content
        .glassEffect()
        .clipShape(.capsule)
    } else {
      content
        .background(
          shouldShowAccessiblyBackground
          ? Color(.backgroundSecondary)
          : Color(.backgroundTranslucent)
        )
        .clipShape(.rect(cornerRadius: 18, style: .continuous))
    }
  }
}

private struct ShadowModifier: ViewModifier {
  @Environment(\.colorScheme) var colorScheme
  
  func body(content: Content) -> some View {
    Group {
      if colorScheme == .light {
        content
          .shadow(color: Color.black.opacity(0.2), radius: 6, x: 0.0, y: 0.0)
      } else {
        content
      }
    }
  }
}
