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
      Section {
        Picker(L10n.AppearanceSettings.ThemePicker.label, selection: $store.colorScheme) {
          ForEach(AppearanceSettings.ColorScheme.allCases, id: \.id) { theme in
            Text(theme.title)
              .tag(theme)
          }
        }
        .pickerStyle(.palette)
        .labelsHidden()
        .frame(height: 40)
        .padding(.horizontal, .grid(2))
      } header: {
        SectionHeader {
          Text(L10n.AppearanceSettings.ThemePicker.sectionHeader)
        }
      }

      Section {
        AppIconPicker(appIcon: $store.appIcon)
      } header: {
        SectionHeader {
          Text(L10n.Settings.appIcon)
        }
      }
    }
    .navigationBarTitle(
      L10n.Settings.Theme.appearance,
      displayMode: .inline
    )
  }
}

// MARK: - Subviews

struct AppIconPicker: View {
  @Binding var appIcon: AppIcon

  var body: some View {
    ForEach(AppIcon.allCases, id: \.id) { icon in
      Button(
        action: { appIcon = icon },
        label: {
          AppIconRow(selectedIcon: appIcon, icon: icon)
            .accessibilityLabel(icon.title)
        }
      )
    }
  }
}

private struct AppIconRow: View {
  let selectedIcon: AppIcon
  let icon: AppIcon

  var body: some View {
    HStack(spacing: .grid(3)) {
      AppIconImage(icon: icon)

      Text(icon.title)

      Spacer()

      if selectedIcon == icon {
        Image(systemName: "checkmark")
          .accessibilityRepresentation { Text(L10n.A11y.General.selected) }
          .fontWeight(.medium)
      }
    }
  }
}

private struct AppIconImage: View {
  let icon: AppIcon

  var body: some View {
    Image(uiImage: icon.image)
      .resizable()
      .scaledToFit()
      .frame(width: 48, height: 48)
      .clipShape(
        RoundedRectangle(
          cornerRadius: 12,
          style: .continuous
        )
      )
      .id(icon.id)
      .overlay(
        RoundedRectangle(cornerRadius: 12)
          .stroke(Color.textPrimary, lineWidth: 0.4)
      )
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
