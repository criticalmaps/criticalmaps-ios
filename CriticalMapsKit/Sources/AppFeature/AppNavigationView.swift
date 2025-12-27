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
      .contentShape(.rect)

      MenuSeparator(height: minHeight)

      // Chat
      ChatFeatureButton(
        store: $store,
        minHeight: minHeight,
        badgeCount: store.chatMessageBadgeCount
      )
      .accessibility(label: Text("App navigation \(L10n.Chat.title)"))

      MenuSeparator(height: minHeight)

      // Settings
      SettingsFeatureButton(
        store: $store,
        minHeight: minHeight
      )
      .accessibility(label: Text("App navigation \(L10n.Settings.title)"))
    }
    .font(.body)
    .modifier(AppNavigationBackgroundModifier())
    .modifier(ShadowModifier())
  }
}

// MARK: - Subviews

private struct MenuSeparator: View {
  let height: CGFloat

  var body: some View {
    Color(.border)
      .frame(width: 1, height: height)
      .accessibilityHidden(true)
  }
}

private struct ChatBadgeView: View {
  let messageCount: UInt
  
  private var isEmpty: Bool { messageCount == 0 }

  var body: some View {
    if isEmpty {
      EmptyView()
    } else {
      ZStack {
        Circle()
          .foregroundColor(.attention)
        
        Text(messageCount, format: .number)
          .animation(nil)
          .foregroundColor(.white)
          .font(Font.system(size: 12))
          .contentTransition(.numericText())
      }
      .frame(width: 20, height: 20)
      .offset(x: 14, y: -10)
      .accessibleAnimation(.easeIn(duration: 0.1), value: messageCount)
      .accessibilityLabel(Text(L10n.Home.Tab.Social.unreadMessages(messageCount)))
    }
  }
}

private struct ChatFeatureButton: View {
  @Binding var store: StoreOf<AppFeature>
  let minHeight: CGFloat
  let badgeCount: UInt

  var body: some View {
    Button(
      action: { store.send(.socialButtonTapped) },
      label: {
        ZStack {
          Image(systemName: "bubble.left")
            .iconModifier()
          ChatBadgeView(messageCount: badgeCount)
        }
      }
    )
    .frame(maxWidth: .infinity, minHeight: minHeight)
    .contentShape(.rect)
    .accessibilityShowsLargeContentViewer {
      let unreadMessages = badgeCount != 0 ? "\n " + L10n.Home.Tab.Social.unreadMessages(badgeCount) : ""
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
}

private struct SettingsFeatureButton: View {
  @Binding var store: StoreOf<AppFeature>
  let minHeight: CGFloat

  var body: some View {
    Button(
      action: { store.send(.settingsButtonTapped) },
      label: {
        Image(systemName: "gearshape")
          .iconModifier()
      }
    )
    .frame(maxWidth: .infinity, minHeight: minHeight)
    .contentShape(.rect)
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
        .accentColor(.textPrimary)
      }
    )
  }
}

// MARK: - Previews

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
            ? Color.backgroundSecondary
            : Color.backgroundTranslucent
        )
        .clipShape(.rect(cornerRadius: 18, style: .continuous))
    }
  }
}

private struct ShadowModifier: ViewModifier {
  @Environment(\.colorScheme) private var colorScheme

  func body(content: Content) -> some View {
    content
      .shadow(
        color: colorScheme == .light ? Color.black.opacity(0.2) : .clear,
        radius: colorScheme == .light ? 6 : 0,
        x: 0,
        y: 0
      )
  }
}
