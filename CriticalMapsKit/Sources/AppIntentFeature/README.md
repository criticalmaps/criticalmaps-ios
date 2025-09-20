# AppIntents Integration

This module provides AppIntents support for controlling CriticalMaps settings through Shortcuts.

## Features

### ObservationModeIntent

Allows users to control the `isObservationModeEnabled` setting through Shortcuts app automation.

#### Parameters
- `enableObservationMode`: Boolean parameter to enable or disable observation mode

#### Usage in Shortcuts
1. Open the Shortcuts app
2. Create a new shortcut
3. Add the "Toggle Observation Mode" action
4. Set the parameter to enable/disable observation mode
5. Configure automation triggers like location-based triggers

#### Location-based Automation Example
1. Create a shortcut with the ObservationModeIntent
2. Set up automation based on location:
   - **Arriving at Critical Mass location**: Set `enableObservationMode` to `false` (participate in ride)
   - **Leaving Critical Mass location**: Set `enableObservationMode` to `true` (observe only)

## Integration

The AppIntents module is automatically included in the main app when building through Xcode. The `CriticalMapsShortcuts` provides suggested shortcuts that users can easily add to their shortcuts library.

## Requirements

- Xcode project must include the AppIntents target in packageProductDependencies
