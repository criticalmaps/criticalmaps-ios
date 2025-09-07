import ComposableArchitecture
import Foundation
import Helpers
import MastodonKit
import SharedModels
import Styleguide
import SwiftUI
import UIApplicationClient

@Reducer
public struct TootFeature {
  public init() {}
  
  @ObservableState
  public struct State: Equatable, Identifiable {
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
  @State private var selectedImageItem: ImageSheetItem? = nil
  
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
            Color(.textSilent).opacity(0.6)
          case let .success(image):
            image
              .resizable()
              .transition(.opacity)
          case .failure:
            Color(.textSilent).opacity(0.6)
          @unknown default:
            EmptyView()
          }
        }
        .frame(width: 44, height: 44)
        .background(Color.gray)
        .clipShape(Circle())
        .accessibilityHidden(true)
        
        VStack(alignment: .leading, spacing: .grid(1)) {
          tweetheader()
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
      item: $selectedImageItem,
      onDismiss: { selectedImageItem = nil }
    ) { imageSheetItem in
      NavigationStack {
        UIKitZoomableImageView(item: imageSheetItem)
          .background(Color.black.opacity(0.95))
          .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
              CloseButton(color: .white) {
                selectedImageItem = nil
              }
            }
          }
      }
    }
    .accessibilityElement(children: .combine)
    .padding(.vertical, .grid(2))
  }
  
  @ViewBuilder
  func tweetheader() -> some View {
    Group {
      if dynamicTypeSize.isAccessibilitySize {
        VStack(alignment: .leading) {
          if !store.accountDisplayName.isEmpty {
            displayName
          }
          accountName
          tweetPostDatetime
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
          tweetPostDatetime
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
        tweetPostDatetime
      }
    })
  }
  
  private var displayName: some View {
    Text(store.accountDisplayName)
      .lineLimit(1)
      .font(.titleTwo)
      .foregroundColor(Color(.textPrimary))
  }
  
  private var accountName: some View {
    Text(store.accountAcct)
      .lineLimit(1)
      .font(.bodyTwo)
      .foregroundColor(Color(.textSilent))
      .accessibilityHidden(true)
  }
  
  private var tweetPostDatetime: some View {
    let (text, a11yValue) = store.state.formattedCreationDate()
    return Text(text ?? "")
      .font(.meta)
      .foregroundColor(Color(.textPrimary))
      .accessibilityLabel(a11yValue ?? "")
  }
  
  @ViewBuilder
  private var imageAttachmentsView: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      HStack {
        ForEach(store.imageAttachments, id: \.id) { attachment in
          if let url = URL(string: attachment.previewURL ?? attachment.url) {
            AsyncImage(url: url) { phase in
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
                    selectedImageItem = ImageSheetItem(
                      url: url,
                      description: attachment.description
                    )
                  }
              case .failure:
                Color.red.opacity(0.2)
              @unknown default:
                EmptyView()
              }
            }
            .accessibilityHidden(attachment.description == nil)
            .accessibilityLabel(attachment.description ?? "")
          }
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

extension RelativeDateTimeFormatter {
  static let tweetDateFormatter: RelativeDateTimeFormatter = {
    let formatter = RelativeDateTimeFormatter()
    formatter.dateTimeStyle = .named
    return formatter
  }()
}

struct ImageSheetItem: Identifiable, Hashable {
  let url: URL
  var description: String?
  
  var id: URL { url }
}
