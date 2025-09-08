import ComposableArchitecture
import L10n
import SharedModels
import Styleguide
import SwiftUI

/// A view to render appearance settings.
public struct AppearanceSettingsView: View {
  @Bindable private var store: StoreOf<AppearanceSettingsFeature>

  public init(store: StoreOf<AppearanceSettingsFeature>) {
    self.store = store
  }

  public var body: some View {
    SettingsForm {
      Section("Theme") {
        Picker("", selection: $store.colorScheme.animation()) {
          ForEach(AppearanceSettings.ColorScheme.allCases, id: \.id) {
            Text($0.title)
          }
        }
        .pickerStyle(.segmented)
        .frame(height: 50)
        .padding(.horizontal, .grid(4))
      }
      
      Section(L10n.Settings.appIcon) {
        AppIconPicker(appIcon: $store.appIcon.animation())
      }
    }
    .foregroundStyle(Color(.textPrimary))
    .navigationBarTitle(L10n.Settings.Theme.appearance, displayMode: .inline)
  }
}

// AppIcon grid view
struct AppIconPicker: View {
  @Binding var appIcon: AppIcon

  var body: some View {
    VStack(spacing: .grid(2)) {
      ForEach(AppIcon.allCases, id: \.id) { appIcon in
        SettingsRow {
          Button(
            action: { self.appIcon = appIcon },
            label: {
              HStack(spacing: .grid(3)) {
                Image(uiImage: appIcon.image)
                  .resizable()
                  .scaledToFit()
                  .frame(width: 48, height: 48)
                  .continuousCornerRadius(12)
                  .id(appIcon.id)
                  .overlay(
                    RoundedRectangle(cornerRadius: 12)
                      .stroke(Color(.textPrimary), lineWidth: 0.4)
                  )

                Text(appIcon.title)

                Spacer()

                if self.appIcon == appIcon {
                  Image(systemName: "checkmark.circle.fill")
                    .accessibilityRepresentation { Text(L10n.A11y.General.selected) }
                }
              }
              .accessibilityLabel(appIcon.title)
            }
          )
        }
      }
    }
  }
}

extension AppearanceSettings.ColorScheme {
  var title: String {
    switch self {
    case .system:
      L10n.Settings.Theme.system
    case .light:
      L10n.Settings.Theme.light
    case .dark:
      L10n.Settings.Theme.dark
    }
  }
}

extension AppIcon {
  var image: UIImage {
    UIImage(named: rawValue, in: .module, with: nil)!
  }

  var title: String {
    switch self {
    case .appIcon1:
      "Dark"
    case .appIcon2:
      "Light"
    case .appIcon3:
      "Neon"
    case .appIcon4:
      "Rainbow"
    case .appIcon5:
      "Yellow"
    }
  }
}


#Preview {
  AppearanceSettingsView(
    store: StoreOf<AppearanceSettingsFeature>(
      initialState: AppearanceSettingsFeature.State(),
      reducer: { AppearanceSettingsFeature() }
    )
  )
}
