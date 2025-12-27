import ComposableArchitecture
import Foundation
import Helpers
import MastodonKit
import SharedModels
import Styleguide
import SwiftUI
import UIApplicationClient

@Reducer
public struct TootFeature: Sendable {
  public init() {}
  
  @ObservableState
  public struct State: Equatable, Identifiable, Sendable {
    public let id: String
    public let createdAt: Date
    public let uri: String
    public let accountURL: String
    public let accountAvatar: String
    public let accountDisplayName: String
    public let accountAcct: String
    public let content: MastodonKit.HTMLString
    public let mediaAttachments: [MastodonKit.Attachment]
    
    var imageAttachments: [MastodonKit.Attachment] {
      mediaAttachments.filter { $0.type == .image }
    }

    // Build the full items array once for this render
    var imageSheetItems: [ImageSheetItem] {
      imageAttachments.compactMap { attachment in
        let urlString = attachment.previewURL ?? attachment.url
        guard let url = URL(string: urlString) else { return nil }
        return ImageSheetItem(url: url, description: attachment.description)
      }
    }
    
    public init(
      id: String,
      createdAt: Date,
      uri: String,
      accountURL: String,
      accountAvatar: String,
      accountDisplayName: String,
      accountAcct: String,
      content: MastodonKit.HTMLString,
      mediaAttachments: [MastodonKit.Attachment] = []
    ) {
      self.id = id
      self.createdAt = createdAt
      self.uri = uri
      self.accountURL = accountURL
      self.accountAvatar = accountAvatar
      self.accountDisplayName = accountDisplayName
      self.accountAcct = accountAcct
      self.content = content
      self.mediaAttachments = mediaAttachments
    }
  }
  
  public enum Action {
    case openTweet
    case openUser
  }
  
  @Dependency(\.uiApplicationClient) var uiApplicationClient
  
  public func reduce(into state: inout State, action: Action) -> Effect<Action> {
    switch action {
    case .openTweet:
      guard let tootURL = URL(string: state.uri) else {
        return .none
      }
      return openURL(tootURL)
      
    case .openUser:
      guard let accountURL = URL(string: state.accountURL) else {
        return .none
      }
      return openURL(accountURL)
    }
  }
  
  private func openURL(_ url: URL) -> Effect<Action> {
    .run { _ in
      _ = await uiApplicationClient.open(url, [:])
    }
  }
}

/// A view that renders a tweet
public struct TootView: View {
  @Environment(\.dynamicTypeSize) private var dynamicTypeSize: DynamicTypeSize
  @Environment(\.colorScheme) private var colorScheme
  
  @State private var store: StoreOf<TootFeature>
  // Holds all image items for the sheet
  @State private var shouldPresentImageItems = false
  // Which index to start at in the zoomable view
  @State private var selectedImageStartIndex = 0
  
  public init(store: StoreOf<TootFeature>) {
    self.store = store
  }
  
  public var body: some View {
    ZStack {
      HStack(alignment: .top, spacing: .grid(4)) {
        AsyncImage(
          url: URL(string: store.accountAvatar),
          transaction: Transaction(animation: .easeInOut)
        ) { phase in
          switch phase {
          case .empty:
            Color.textSilent.opacity(0.6)
          case let .success(image):
            image
              .resizable()
              .transition(.opacity)
          case .failure:
            Color.textSilent.opacity(0.6)
          @unknown default:
            EmptyView()
          }
        }
        .frame(width: 44, height: 44)
        .background(Color.gray)
        .clipShape(Circle())
        .accessibilityHidden(true)
        
        VStack(alignment: .leading, spacing: .grid(1)) {
          header()
            .contentShape(Rectangle())
            .onTapGesture {
              store.send(.openUser)
            }
          
          Text(store.content.asSafeMarkdownAttributedString)
            .font(.body)
            .tint(Color(uiColor: colorScheme == .light ? .highlight : .brand500))
            .fixedSize(horizontal: false, vertical: true)
          
          if !store.imageAttachments.isEmpty {
            imageAttachmentsView
              .padding(.top, .grid(1))
          }
        }
      }
    }
    .sheet(
      isPresented: $shouldPresentImageItems,
      onDismiss: {
        shouldPresentImageItems = false
      }
    ) {
      NavigationStack {
        UIKitZoomableImageView(
          items: store.imageSheetItems,
          startIndex: selectedImageStartIndex
        )
        .background(Color.black.opacity(0.9))
        .toolbar {
          ToolbarItem(placement: .topBarTrailing) {
            CloseButton(color: .white) {
              shouldPresentImageItems = false
            }
          }
        }
      }
    }
    .accessibilityElement(children: .combine)
    .padding(.vertical, .grid(2))
  }
  
  @ViewBuilder
  func header() -> some View {
    Group {
      if dynamicTypeSize.isAccessibilitySize {
        VStack(alignment: .leading) {
          if !store.accountDisplayName.isEmpty {
            displayName
          }
          accountName
          postDatetime
        }
      } else {
        HStack(alignment: .top) {
          VStack(alignment: .leading) {
            if !store.accountDisplayName.isEmpty {
              displayName
            }
            accountName
          }
          Spacer()
          postDatetime
        }
      }
    }
    .accessibilityElement(children: .combine)
    .accessibilityRepresentation(representation: {
      HStack {
        if !store.accountDisplayName.isEmpty {
          displayName
        }
        displayName
        Text("posted at")
        postDatetime
      }
    })
  }
  
  private var displayName: some View {
    Text(store.accountDisplayName)
      .lineLimit(1)
      .font(.titleTwo)
      .foregroundColor(.textPrimary)
  }
  
  private var accountName: some View {
    Text(store.accountAcct)
      .lineLimit(1)
      .font(.bodyTwo)
      .foregroundColor(.textSilent)
      .accessibilityHidden(true)
  }
  
  private var postDatetime: some View {
    let (text, a11yValue) = store.state.formattedCreationDate()
    return Text(text ?? "")
      .font(.meta)
      .foregroundColor(.textPrimary)
      .accessibilityLabel(a11yValue ?? "")
  }
  
  @ViewBuilder
  private var imageAttachmentsView: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      HStack {
        ForEach(Array(store.imageSheetItems.enumerated()), id: \.element.id) { index, item in
          AsyncImage(url: item.url) { phase in
            switch phase {
            case .empty:
              Color.gray.opacity(0.2)
            case let .success(image):
              image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 180)
                .cornerRadius(8)
                .onTapGesture {
                  shouldPresentImageItems = true
                  selectedImageStartIndex = index
                }
            case .failure:
              Color.gray.opacity(0.2)
            @unknown default:
              EmptyView()
            }
          }
          .accessibilityHidden(item.description == nil)
          .accessibilityLabel(item.description ?? "")
        }
      }
    }
  }
}

// MARK: Preview

#Preview {
  TootView(
    store: StoreOf<TootFeature>(
      initialState: [TootFeature.State].placeHolder[0],
      reducer: { TootFeature() }
    )
  )
}

// MARK: - Helper

extension DateComponents {
  var dateComponentFromBiggestComponent: DateComponents {
    if let day, day != 0 {
      DateComponents(calendar: calendar, day: day)
    } else if let hour, hour != 0 {
      DateComponents(calendar: calendar, hour: hour)
    } else {
      DateComponents(calendar: calendar, minute: minute)
    }
  }
}

struct ImageSheetItem: Identifiable, Hashable {
  let url: URL
  var description: String?
  
  var id: URL { url }
}

extension MastodonKit.Attachment: @retroactive @unchecked Sendable {}
