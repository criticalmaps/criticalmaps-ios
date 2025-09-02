import ComposableArchitecture
import Foundation
import MastodonKit

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
      content: status.content,
      mediaAttachments: status.mediaAttachments
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
