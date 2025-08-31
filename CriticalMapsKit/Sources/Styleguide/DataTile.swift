import Foundation
import SwiftUIHelpers
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
    .conditionalBackground(shouldUseBlur: false, shouldUseGlassEffect: false)
    .adaptiveClipShape()
    .if(!.iOS26) { view in
      view
        .overlay(
          RoundedRectangle(cornerRadius: 8, style: .continuous)
            .stroke(Color(.textPrimary).opacity(0.2), lineWidth: 1)
        )
    }
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

public extension View {
  @ViewBuilder func conditionalBackground(
    shouldUseBlur: Bool = false,
    shouldUseGlassEffect: Bool = true
  ) -> some View {
    @Environment(\.accessibilityReduceTransparency) var reduceTransparency
    if #available(iOS 26, *) {
      self
        .if(shouldUseGlassEffect) { view in
          view
            .glassEffect()
        }
    } else {
      self
        .background(
          Group {
            if reduceTransparency {
              Color(.backgroundPrimary)
            } else {
              if shouldUseBlur {
                Blur()
                  .cornerRadius(12)
              } else {
                Color(.backgroundPrimary).opacity(0.4)
              }
            }
          }
        )
    }
  }
}
