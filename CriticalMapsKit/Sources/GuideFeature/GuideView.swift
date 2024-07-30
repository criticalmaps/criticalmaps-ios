import L10n
import Styleguide
import SwiftUI
import SwiftUIHelpers

public struct GuideView: View {
  public init() {}

  public var body: some View {
    List(Guide.all) { guide in
      NavigationLink(
        destination: GuideDetailView(guide: guide),
        label: {
          Text(guide.rule.title)
            .font(.titleOne)
            .foregroundColor(Color(.textPrimary))
            .padding(.vertical, .grid(2))
        }
      )
    }
    .listStyle(PlainListStyle())
    .navigationTitle(L10n.Rules.title)
    .dismissable()
  }
}

#Preview {
  GuideView()
}
