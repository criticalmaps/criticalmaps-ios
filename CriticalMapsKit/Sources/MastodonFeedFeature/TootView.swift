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
  
  @Dependency(\.uiApplicationClient) var uiApplicationClient
  
  @ObservableState
  public struct State: Equatable, Identifiable {
    public let id: String
    public let createdAt: Date
    public let uri: String
    public let accountURL: String
    public let accountAvatar: String
    public let accountDisplayName: String
    public let accountAcct: String
    public let content: String
    
    public init(
      id: String,
      createdAt: Date,
      uri: String,
      accountURL: String,
      accountAvatar: String,
      accountDisplayName: String,
      accountAcct: String,
      content: String
    ) {
      self.id = id
      self.createdAt = createdAt
      self.uri = uri
      self.accountURL = accountURL
      self.accountAvatar = accountAvatar
      self.accountDisplayName = accountDisplayName
      self.accountAcct = accountAcct
      self.content = content
    }
  }
  
  public enum Action {
    case openTweet
    case openUser
  }
  
  public func reduce(into state: inout State, action: Action) -> Effect<Action> {
    switch action {
    case .openTweet:
      guard let tootUrl = URL(string: state.uri) else {
        return .none
      }
      return .run { _ in
        _ = await uiApplicationClient.open(tootUrl, [:])
      }
      
    case .openUser:
      guard let accountUrl = URL(string: state.accountURL) else {
        return .none
      }
      return .run { _ in
        _ = await uiApplicationClient.open(accountUrl, [:])
      }
    }
  }
}

/// A view that renders a tweet
public struct TootView: View {
  @Environment(\.dynamicTypeSize) private var dynamicTypeSize: DynamicTypeSize
  @Environment(\.colorScheme) private var colorScheme
  
  private let store: StoreOf<TootFeature>
  
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
        
        VStack(alignment: .leading, spacing: .grid(2)) {
          tweetheader()
            .contentShape(Rectangle())
            .onTapGesture {
              store.send(.openUser)
            }
          
          if let content = store.content.convertHtmlToAttributedStringWithCSS(
            csscolor: colorScheme == .light ? "black" : "white",
            linkColor: colorScheme == .light ? "#1717E5" : "#FFD633"
          ) {
            Text(content)
              .id(dynamicTypeSize.hashValue)
              .contentShape(Rectangle())
              .onTapGesture { store.send(.openTweet) }
              .accessibilityAction(
                action: { store.send(.openTweet) },
                label: { Text("Open tweet")
                    .accessibilityHint("Opens the tweet in the twitter app if it is installed")
                }
              )
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
        Text("posted")
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

public extension TootFeature.State {
  init(_ status: MastodonKit.Status) {
    self.init(
      id: status.id,
      createdAt: status.createdAt,
      uri: status.uri,
      accountURL: status.account.url,
      accountAvatar: status.account.avatar,
      accountDisplayName: status.account.displayName,
      accountAcct: status.account.acct,
      content: status.content
    )
  }
  
  func formattedCreationDate() -> (String?, String?) {
    @Dependency(\.date.now) var date
    @Dependency(\.calendar) var calendar
    
    let components = calendar.dateComponents(
      [.hour, .day, .month],
      from: createdAt,
      to: date
    )
    
    let a11yValue = RelativeDateTimeFormatter.tweetDateFormatter.localizedString(for: createdAt, relativeTo: date)
    
    if let days = components.day, days == 0, let months = components.month, months == 0 {
      let diffComponents = calendar.dateComponents(
        [.hour, .minute],
        from: createdAt,
        to: date
      )
      
      let value = DateComponentsFormatter.tweetDateFormatter()
        .string(from: diffComponents.dateComponentFromBiggestComponent)
      return (value, a11yValue)
    } else {
      let value = createdAt.formatted(Date.FormatStyle.dateWithoutYear)
      return (value, a11yValue)
    }
  }
}

extension DateComponents {
  var dateComponentFromBiggestComponent: DateComponents {
    if let day = day, day != 0 {
      return DateComponents(calendar: calendar, day: day)
    } else if let hour = hour, hour != 0 {
      return DateComponents(calendar: calendar, hour: hour)
    } else {
      return DateComponents(calendar: calendar, minute: minute)
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

extension String {
  private var convertHtmlToNSAttributedString: NSAttributedString? {
    guard let data = data(using: .utf8) else {
      return nil
    }
    do {
      return try NSAttributedString(
        data: data,
        options: [
          .documentType: NSAttributedString.DocumentType.html,
          .characterEncoding: String.Encoding.unicode.rawValue
        ],
        documentAttributes: nil
      )
    } catch {
      debugPrint(error.localizedDescription)
      return nil
    }
  }
  
  public func convertHtmlToAttributedStringWithCSS(
    font: UIFont? = UIFont(name: "Helvetica", size: UIFont.preferredFont(forTextStyle: .body).pointSize),
    csscolor: String,
    linkColor: String,
    lineheight: Int = 5,
    csstextalign: String = "left"
  ) -> NSAttributedString? {
    guard let font = font else {
      return convertHtmlToNSAttributedString
    }
    let modifiedString = "<style>body{font-family: '\(font.fontName)'; font-size:\(font.pointSize)px; color: \(csscolor); line-height: \(lineheight)px; text-align: \(csstextalign);} a{color: \(linkColor)}</style>\(self)"
    guard let data = modifiedString.data(using: .unicode) else {
      return nil
    }
    do {
      return try NSAttributedString(
        data: data,
        options: [
          .documentType: NSAttributedString.DocumentType.html,
          .characterEncoding: String.Encoding.unicode.rawValue
        ],
        documentAttributes: nil
      )
    } catch {
      debugPrint(error.localizedDescription)
      return nil
    }
  }
}
