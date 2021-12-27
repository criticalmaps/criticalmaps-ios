import Styleguide
import SwiftUI
import SwiftUIHelpers

public struct GuideDetailView: View {
  let guide: Guide
  
  public init(guide: Guide) {
    self.guide = guide
  }
  
  public var body: some View {
    VStack(spacing: .grid(2)) {
      DIImage(Image(uiImage: guide.rule.image))
      Text(guide.rule.text)
        .font(.bodyOne)
        .foregroundColor(Color(.textPrimary))
        .padding(.horizontal, .grid(4))
      Spacer()
    }
    .navigationBarTitle(guide.rule.title, displayMode: .inline)
  }
}

struct GuideDetailView_Previews: PreviewProvider {
  static var previews: some View {
    Preview {
      GuideDetailView(guide: .all[1])
    }
  }
}


/// Wraps an Image View and color inverts it when colorScheme is dark
struct DIImage: View {
  @Environment(\.colorScheme) var colorScheme
  
  let image: Image
    
  init(_ image: Image) {
    self.image = image
  }
    
  var body: some View {
    Group {
      if colorScheme == .dark {
        img.colorInvert()
      } else {
        img
      }
    }
  }
  
  var img: some View {
    image
      .resizable()
      .aspectRatio(contentMode: .fit)
  }
}
