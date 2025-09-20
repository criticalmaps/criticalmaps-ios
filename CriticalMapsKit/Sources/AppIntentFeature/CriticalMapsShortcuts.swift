import AppIntents

public struct CriticalMapsShortcuts: AppShortcutsProvider {
  public static var appShortcuts: [AppShortcut] {
    AppShortcut(
      intent: ObservationModeIntent(),
      phrases: [
        "Enable observation mode in \(.applicationName)",
        "Turn on observation mode in \(.applicationName)",
        "Disable observation mode in \(.applicationName)",
        "Turn off observation mode in \(.applicationName)",
        "Toggle observation mode in \(.applicationName)"
      ],
      shortTitle: LocalizedStringResource(
        "appIntent.observationMode.shortcut.title",
        defaultValue: "Observation Mode"
      ),
      systemImageName: "eye"
    )
  }
}
