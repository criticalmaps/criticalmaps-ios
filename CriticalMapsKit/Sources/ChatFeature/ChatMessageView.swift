import SharedModels
import Styleguide
import SwiftUI

public struct ChatMessageView: View {
  public init(_ chat: ChatMessage) {
    self.chat = chat
  }

  var chatTime: String {
    let date = Date(timeIntervalSince1970: chat.timestamp)
    return date.formatted(Date.FormatStyle.chatTime())
  }
  
  let chat: ChatMessage

  public var body: some View {
    VStack(alignment: .leading, spacing: .grid(1)) {
      Text(chat.decodedMessage)
        .foregroundColor(Color(.textPrimary))
        .font(.bodyOne)
      
      HStack {
        Spacer()
        Text(chatTime)
          .foregroundColor(Color(.textSecondary))
          .font(.footnote)
      }
    }
  }
}

#Preview {
  ChatMessageView(
    .init(
      identifier: "id",
      device: "device",
      message: "123",
      timestamp: 1235
    )
  )
}

extension Array where Element == Color {
  static func random(from colors: [Element] = [.blue, .pink, .green, .mint, .orange, .purple, .red]) -> [Element] {
    var elements: [Element?] = []
    for _ in 0..<4 {
      elements.append(colors.randomElement())
    }
    return elements.compactMap { $0 }
  }
}
