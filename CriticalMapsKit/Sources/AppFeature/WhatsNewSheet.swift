import ComposableArchitecture
import L10n
import SharedKeys
import SharedModels
import Styleguide
import SwiftUI

@Reducer
public struct WhatsNew: Sendable {
  public init() {}
	
  @ObservableState
  public struct State: Equatable, Sendable {
    public init() {}
  }
	
  public enum Action {
    case closeButtonTapped
    case continueButtonTapped
  }
	
  public var body: some ReducerOf<Self> {
    Reduce { _, action in
      switch action {
      case .continueButtonTapped:
        .none
      case .closeButtonTapped:
        .none
      }
    }
  }
}

// MARK: - Views

/// "What's New" onboarding sheet shown once after updating to a version with new
/// features. Presentational — the gating/dismissal live in `AppFeature`
public struct WhatsNewSheet: View {
  let store: StoreOf<WhatsNew>
	
  @Shared(.userSettings) private var userSettings: UserSettings
  
  public var body: some View {
    NavigationStack {
      ScrollView {
        VStack(spacing: .grid(6)) {
          VStack(spacing: .grid(4)) {
            FeatureCard {
              VStack(spacing: .grid(3)) {
                Text(L10n.Settings.HighlightActiveRiders.label)
                  .font(.headline)

                Divider()
									
                heroImage
                  .resizable()
                  .scaledToFit()
                  .clipShape(RoundedRectangle(cornerRadius: .grid(5)))
                  .accessibilityHidden(true)
                  .animation(.snappy, value: userSettings.highlightActiveRiders)
									
                VStack(alignment: .leading, spacing: .grid(2)) {
                  Text(L10n.WhatsNew.HighlightActiveRiders.description)
                    .foregroundStyle(.secondary)
										
                  Toggle(isOn: Binding($userSettings.highlightActiveRiders)) {
                    Text(L10n.Settings.HighlightActiveRiders.label)
                      .font(.body)
                  }
                }
              }
            }
							
            Section {
              FeatureCard {
                VStack(spacing: .grid(3)) {
                  VStack(alignment: .leading, spacing: .grid(2)) {
                    Toggle(isOn: Binding($userSettings.isObservationModeEnabled)) {
                      Text(L10n.Settings.Observationmode.title)
                        .font(.body)
                    }
											
                    Text(L10n.WhatsNew.ObservationMode.description)
                      .foregroundStyle(.secondary)
                  }
                }
              }
            } header: {
              Text(L10n.Settings.title)
            }
          }
        }
        .padding()
      }
      .safeAreaInset(edge: .bottom) {
        Button {
          store.send(.continueButtonTapped)
        } label: {
          Text(L10n.WhatsNew.continue)
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.criticalMaps)
        .padding()
      }
    }
    .toolbar {
      ToolbarItem(placement: .primaryAction) {
        Button {
          store.send(.closeButtonTapped)
        } label: {
          Text(L10n.Close.Button.label)
        }
      }
    }
    .tint(.brand500)
    .presentationDetents([.large])
  }

  private var heroImage: Image {
    (userSettings.highlightActiveRiders ? Asset.highlightActiveOn : Asset.highlightActiveOff)
      .swiftUIImage
  }
}

private struct FeatureCard<Content: View>: View {
  @ViewBuilder let content: Content

  var body: some View {
    content
      .padding()
      .background(.regularMaterial)
      .clipShape(.rect(cornerRadius: .grid(5)))
  }
}

// MARK: - Preview

#Preview {
  WhatsNewSheet(
    store: Store(initialState: WhatsNew.State()) {
      WhatsNew()
    }
  )
}
