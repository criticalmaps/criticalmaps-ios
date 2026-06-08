import L10n
import SharedKeys
import SharedModels
import Styleguide
import SwiftUI

/// "What's New" onboarding sheet shown once after updating to a version with new
/// features. Presentational — the gating/dismissal live in `AppFeature`
struct WhatsNewSheet: View {
  @Shared(.userSettings) private var userSettings: UserSettings
  var onContinue: () -> Void

  var body: some View {
    NavigationStack {
      ScrollView {
        VStack(spacing: .grid(6)) {
          heroImage
            .resizable()
            .scaledToFit()
            .clipShape(RoundedRectangle(cornerRadius: .grid(5)))
            .accessibilityHidden(true)
            .animation(.snappy, value: userSettings.highlightActiveRiders)

          Text(L10n.WhatsNew.header)
            .font(.headline)
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity, alignment: .leading)

          VStack(spacing: .grid(4)) {
            FeatureCard(
              title: L10n.Settings.HighlightActiveRiders.label,
              description: L10n.WhatsNew.HighlightActiveRiders.description,
              isOn: Binding($userSettings.highlightActiveRiders)
            )

            FeatureCard(
              title: L10n.Settings.Observationmode.title,
              description: L10n.WhatsNew.ObservationMode.description,
              isOn: Binding($userSettings.isObservationModeEnabled)
            )
          }
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

  private var heroImage: Image {
    (userSettings.highlightActiveRiders ? Asset.highlightActiveOn : Asset.highlightActiveOff)
      .swiftUIImage
  }
}

private struct FeatureCard: View {
  let title: String
  let description: String
  let isOn: Binding<Bool>
	
  var body: some View {
    HStack(alignment: .top, spacing: .grid(4)) {
      VStack(alignment: .leading, spacing: .grid(1)) {
        Text(title)
          .font(.headline)
        Text(description)
          .foregroundStyle(.secondary)
      }

      Spacer(minLength: .grid(2))

      Toggle(title, isOn: isOn)
        .labelsHidden()
        .tint(.brand500)
    }
    .padding()
    .background(.regularMaterial)
    .clipShape(.rect(cornerRadius: .grid(5)))
  }
}

#Preview {
  WhatsNewSheet {
    print("continue")
  }
}
