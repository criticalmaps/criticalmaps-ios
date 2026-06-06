import L10n
import Styleguide
import SwiftUI

/// "What's New" onboarding sheet shown once after updating to a version with new
/// features. Purely presentational — the gating and dismissal live in `AppFeature`.
/// Highlights the "Highlight active riders" feature (hero) and Observation Mode.
struct WhatsNewSheet: View {
  var onContinue: () -> Void

  var body: some View {
    NavigationStack {
      ScrollView {
        VStack(spacing: .grid(6)) {
          Asset.highlightActiveUsersFeature.swiftUIImage
            .resizable()
            .scaledToFit()
            .clipShape(RoundedRectangle(cornerRadius: .grid(5)))
            .accessibilityHidden(true)

          VStack(spacing: .grid(2)) {
            Text(L10n.WhatsNew.header)
              .font(.headline)
              .foregroundStyle(.secondary)

            Text(L10n.Settings.HighlightActiveRiders.label)
              .font(.title.bold())
              .multilineTextAlignment(.center)

            Text(L10n.WhatsNew.HighlightActiveRiders.description)
              .multilineTextAlignment(.center)
          }

          Divider()

          featureCard(
            icon: "eye",
            title: L10n.Settings.Observationmode.title,
            description: L10n.WhatsNew.ObservationMode.description
          )
        }
        .padding()
      }
      .safeAreaInset(edge: .bottom) {
        Button(action: onContinue) {
          Text(L10n.WhatsNew.continue)
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.criticalMaps)
        .padding()
      }
    }
    .presentationDetents([.large])
  }

  private func featureCard(
    icon: String,
    title: String,
    description: String
  ) -> some View {
    HStack(alignment: .top, spacing: .grid(4)) {
      Image(systemName: icon)
        .font(.title2)
        .accessibilityHidden(true)

      VStack(alignment: .leading, spacing: .grid(1)) {
        Text(title)
          .font(.headline)
        Text(description)
          .foregroundStyle(.secondary)
      }

      Spacer()
    }
    .padding()
    .background(.regularMaterial)
    .clipShape(RoundedRectangle(cornerRadius: .grid(5)))
  }
}
