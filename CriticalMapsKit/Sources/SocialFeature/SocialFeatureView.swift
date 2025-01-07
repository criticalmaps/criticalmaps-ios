import ChatFeature
import ComposableArchitecture
import MastodonFeedFeature
import SwiftUI

/// A view that holds the chatfeature and twitterfeature and just offers a control to switch between the two.
public struct SocialView: View {
  @Environment(\.presentationMode) var presentationMode
  @SwiftUICore.Bindable var store: StoreOf<SocialFeature>
  
  public init(store: StoreOf<SocialFeature>) {
    self.store = store
  }

  public var body: some View {
    NavigationView {
      Group {
        switch store.socialControl {
        case .chat:
          ChatView(
            store: store.scope(
              state: \.chatFeatureState,
              action: \.chat
            )
          )
        case .toots:
          MastodonFeedView(
            store: store.scope(
              state: \.mastodonFeedState,
              action: \.toots
            )
          )
        }
      }
      .toolbar {
        ToolbarItem(placement: .cancellationAction) {
          Button(
            action: { presentationMode.wrappedValue.dismiss() },
            label: {
              Image(systemName: "xmark")
                .font(Font.system(size: 22, weight: .medium))
                .foregroundColor(Color(.textPrimary))
            }
          )
        }
        
        ToolbarItem(placement: .principal) {
          Picker(
            "Social Segment",
            selection: $store.socialControl.sending(\.setSocialSegment)
          ) {
            Text(SocialFeature.SocialControl.chat.title).tag(0)
            Text(SocialFeature.SocialControl.toots.title).tag(1)
          }
          .pickerStyle(SegmentedPickerStyle())
          .frame(maxWidth: 180)
        }
      }
    }
  }
}

// MARK: Preview

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
