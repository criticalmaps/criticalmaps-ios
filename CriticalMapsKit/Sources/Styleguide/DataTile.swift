import Foundation
import SwiftUI

public struct DataTile<Content: View>: View {
  @Environment(\.accessibilityReduceTransparency) var reduceTransparency
  let content: Content
  let text: String
  
  public init(_ text: String, @ViewBuilder _ content: () -> Content) {
    self.content = content()
    self.text = text
  }
  
  public var body: some View {
    VStack(alignment: .leading) {
      Text(text)
        .font(.meta)
        .multilineTextAlignment(.leading)
        
      Spacer()
      
      HStack {
        Spacer()
        content
        Spacer()
      }
      
      Spacer()
    }
    .foregroundColor(Color(.textPrimary))
    .padding(.grid(2))
    .frame(width: 100, height: 90)
    .background(
      reduceTransparency
        ? Color(.backgroundPrimary)
        : Color(.backgroundPrimary).opacity(0.6)
    )
    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
    .overlay(
      RoundedRectangle(cornerRadius: 8, style: .continuous)
        .stroke(Color(.textPrimary).opacity(0.2), lineWidth: 1)
    )
    .accessibilityElement(children: .combine)
  }
}

#Preview {
  VStack {
    DataTile("Riders") {
      Label("342", systemImage: "bicycle.circle.fill")
    }
    
    DataTile("Next Update") {
      CircularProgressView(progress: 0.3)
        .frame(width: 24, height: 24)
    }
  }
}
