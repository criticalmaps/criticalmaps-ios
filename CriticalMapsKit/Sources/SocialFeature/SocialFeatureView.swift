import ChatFeature
import ComposableArchitecture
import L10n
import MastodonFeedFeature
import SwiftUI

public struct SocialView: View {
  @Bindable private var store: StoreOf<SocialFeature>
  
  public init(store: StoreOf<SocialFeature>) {
    self.store = store
  }

  public var body: some View {
    NavigationStack {
      Group {
        switch store.socialControl {
        case .chat:
          ChatView(
            store: store.scope(state: \.chatFeatureState, action: \.chat)
          )
        case .toots:
          MastodonFeedView(
            store: store.scope(state: \.mastodonFeedState, action: \.toots)
          )
        }
      }
      .toolbar {
        ToolbarItem(placement: .cancellationAction) {
          Button(
            action: { store.send(.dismiss) },
            label: {
              Image(systemName: "xmark")
                .font(Font.system(size: 22, weight: .medium))
                .foregroundColor(Color(.textPrimary))
            }
          )
          .accessibilityLabel(L10n.Close.Button.label)
        }
        
        ToolbarItem(placement: .principal) {
          Picker(
            "Social Segment",
            selection: $store.socialControl.animation()
          ) {
            ForEach(SocialFeature.SocialControl.allCases, id: \.self) { control in
              Text(control.rawValue).tag(control)
            }
          }
          .pickerStyle(.segmented)
          .frame(maxWidth: 180)
        }
      }
    }
  }
}

// MARK: - Preview

#Preview {
  SocialView(
    store: StoreOf<SocialFeature>(
      initialState: SocialFeature.State(
        chatFeatureState: .init(),
        mastodonFeedState: .init()
      ),
      reducer: { SocialFeature()._printChanges() }
    )
  )
}
