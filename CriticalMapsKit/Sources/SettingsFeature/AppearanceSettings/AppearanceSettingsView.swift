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
        Picker("Select Theme", selection: $store.colorScheme) {
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
          Text("Theme")
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

// AppIcon grid view
struct AppIconPicker: View {
  @Binding var appIcon: AppIcon

  var body: some View {
    ForEach(AppIcon.allCases, id: \.id) { icon in
      Button(
        action: { self.appIcon = icon },
        label: {
          row(for: icon)
            .accessibilityLabel(icon.title)
        }
      )
    }
  }
  
  @ViewBuilder
  private func row(for icon: AppIcon) -> some View {
    HStack(spacing: .grid(3)) {
      appIconView(icon)
      
      Text(icon.title)
      
      Spacer()
      
      if self.appIcon == icon {
        Image(systemName: "checkmark")
          .accessibilityRepresentation { Text(L10n.A11y.General.selected) }
          .fontWeight(.medium)
      }
    }
  }
  
  @ViewBuilder
  private func appIconView(_ icon: AppIcon) -> some View {
    Image(uiImage: icon.image)
      .resizable()
      .scaledToFit()
      .frame(width: 48, height: 48)
      .continuousCornerRadius(12)
      .id(icon.id)
      .overlay(
        RoundedRectangle(cornerRadius: 12)
          .stroke(Color(.textPrimary), lineWidth: 0.4)
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
