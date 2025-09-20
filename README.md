<p align="center"><a href="https://itunes.apple.com/app/critical-maps/id918669647"><img src="_images/Icon.svg" width="250" /></a></p>

<p align="center"><a href="https://itunes.apple.com/app/critical-maps/id918669647"><img src="_images/appstore-badge.png" width="150" /></a></p>

## Critical Maps iOS App

[![CI](https://github.com/criticalmaps/criticalmaps-ios/actions/workflows/tests.yml/badge.svg)](https://github.com/criticalmaps/criticalmaps-ios/actions/workflows/tests.yml)
<a title="Crowdin" target="_blank" href="https://crowdin.com/project/critical-maps">
	<img src="https://badges.crowdin.net/critical-maps/localized.svg" alt="Localized Status" />
</a>

## What's "Critical Mass"?

> Critical Mass has been described as 'monthly political-protest rides', and characterized as being part of a social movement.

http://en.wikipedia.org/wiki/Critical_Mass_(cycling)

## What's this app?

This iOS app is made for Critical Maps. It tracks your location and shares it with all other participants of the Critical Mass bicycle protest. You can use the chat to communicate with all other participants.

## How the App Works

Critical Maps connects cyclists during Critical Mass rides through real-time location sharing and communication.

### Core Functionality
- **🗺️ Real-time Location Tracking**: Your location is shared anonymously with other riders on an interactive map
- **💬 Live Chat System**: Communicate with all participants in real-time during rides
- **📅 Next Ride Events**: Discover upcoming Critical Mass events in your area
- **🎨 Customizable Experience**: Personalize your rider appearance and app settings
- **🌐 Social Integration**: Stay connected through integrated Mastodon feeds
- **🔒 Privacy-Focused**: Anonymous participation with optional customization

### Technical Architecture
Built with modern iOS development practices:
- **SwiftUI** for declarative, responsive user interfaces
- **The Composable Architecture (TCA)** for predictable state management and unidirectional data flow
- **Swift Package Manager** for dependency management
- **Real-time API Integration** for live location sharing and chat

## Where can I get the app?

- [AppStore](https://apps.apple.com/de/app/critical-maps/id918669647)

## Project Setup

The iOS client's logic is built in the [`The Composable Architecture`](https://github.com/pointfreeco/swift-composable-architecture) and the UI is built in SwiftUI.

**Minimum platform requirements**: iOS 17.0

### Architecture Overview

#### Modular Design Philosophy
The application follows a hyper-modularized architecture with feature modules:

**Core Features:**
- `AppFeature` - Main app coordination and navigation
- `MapFeature` - Interactive map with real-time rider locations
- `ChatFeature` - Real-time messaging system
- `NextRideFeature` - Event discovery and management
- `SettingsFeature` - User preferences and app configuration
- `SocialFeature` - Mastodon feed integration

**Supporting Modules:**
- `ApiClient` - Network layer and API communication
- `SharedModels` - Data structures (e.g. `Rider`, `Location`, `Coordinate`)
- `Styleguide` - Design system and UI components
- `L10n` - Internationalization and localization
- `IDProvider` - Unique identifier generation for anonymous riders

#### Benefits of Modularization
- **Faster Build Times**: Work on individual features without building the entire app
- **Improved SwiftUI Previews**: More stable preview environments for each feature
- **Independent Development**: Features can be developed and tested in isolation
- **Mini-Apps**: Each feature can be built as a standalone app for development
- **Scalable Architecture**: Easy to add new features without affecting existing code

#### Data Flow & State Management
The app uses TCA's unidirectional data flow:
1. **Actions** represent user interactions and system events
2. **Reducers** handle state mutations and side effects
3. **Effects** manage asynchronous operations (API calls, location services)
4. **State** is the single source of truth for each feature

Example: Location sharing flow
```
User enables tracking → LocationAction → LocationReducer → API Effect → State Update → UI Re-render
```

### Getting Started

This repo contains both the client for running the entire [Critical Maps](https://itunes.apple.com/app/critical-maps/id918669647) application, as well as an extensive test suite.

#### Quick Start
1. **Clone the repository**:
2. **Open the Xcode project**: `CriticalMaps.xcodeproj`
3. **Run the app**: Select the `Critical Maps` target in Xcode and run (`⌘R`)

#### Development Setup (Optional)
Install all development tools with:
```sh
make setup
```

Or install components individually:
```sh
make dependencies  # Install Swift tools (SwiftLint, SwiftFormat, SwiftGen) + Ruby gems
make ruby         # Install only Ruby dependencies (bundler, fastlane)
```

**Available Makefile Commands:**
- `make help` - Show all available commands
- `make setup` - Complete project setup for new developers
- `make tests` - Run all tests
- `make lint` - Run SwiftLint with auto-fix
- `make format` - Format code with SwiftFormat
- `make assets` - Generate type-safe assets
- `make clean` - Clean build artifacts


### Assets & Code Generation

#### SwiftGen Integration
The project uses type-safe assets generated with [SwiftGen](https://github.com/SwiftGen/SwiftGen):

```sh
# After adding new images or localization strings
make assets
```

This generates strongly-typed Swift code for:
- **Images**: `Asset.Images.iconName` instead of `"icon-name"`
- **Localizations**: `L10n.buttonSave` instead of `NSLocalizedString`


### Testing

The project includes comprehensive testing across all feature modules:

#### Running Tests
```sh
# Run all tests
⌘U in Xcode

# Run specific feature tests
xcodebuild test -scheme MapFeatureTests -destination 'platform=iOS Simulator,name=iPhone 17 Pro'
```

#### Test Architecture
- **Unit Tests**: Logic and reducer testing with TCA's testing utilities
- **Snapshot Tests**: UI component visual regression testing
- **Integration Tests**: Feature-level behavior testing

**Test Coverage by Module:**
- `AppFeatureTests` - Main app flow and navigation
- `ChatFeatureTests` - Messaging functionality
- `MapFeatureTests` - Location and map interactions
- `SettingsFeatureTests` - User preference management
- And more...

## Contribute

- Please report bugs with GitHub [issues](https://github.com/CriticalMaps/criticalmaps-ios/issues).
- If you can code please check the build & contribute guide below.
- If you have some coins left you can help to finance the project on [Open Collective](https://opencollective.com/criticalmaps).

### How to contribute

In general, we follow the "fork-and-pull" Git workflow.

1.  **Fork** the repo on GitHub
2.  **Clone** the project to your own machine
3.  **Commit** changes to your own branch. Please add your changes also to the [`CHANGELOG`](CHANGELOG.md). We're following the standard of [Keep a Changelog](https://keepachangelog.com/en/1.0.0/)
4.  **Push** your work back up to your fork
5.  Submit a **Pull request** so that we can review your changes

#### Development Guidelines
- Follow the existing code style and SwiftLint rules
- Write tests for new features and bug fixes
- Update documentation and comments when adding new functionality
- Run `make assets` after adding new images or localization strings
- Ensure all CI checks pass before requesting review

**Notes**:
- Be sure to merge the latest from "upstream" before making a pull request!
- For significant changes, consider opening an issue first to discuss the approach

## Open Source & Copying

We ship CriticalMaps on the App Store for free and provide its entire source code for free as well. In the spirit of openness, CriticalMaps is licensed under MIT so that you can use the code in your app, if you choose to.

However, **please do not ship this app** under your own account. Paid or free.

## Credits

<!-- readme: contributors -start -->
<table>
	<tbody>
		<tr>
            <td align="center">
                <a href="https://github.com/lennet">
                    <img src="https://avatars.githubusercontent.com/u/7677738?v=4" width="100;" alt="lennet"/>
                    <br />
                    <sub><b>Leo Thomas</b></sub>
                </a>
            </td>
            <td align="center">
                <a href="https://github.com/mltbnz">
                    <img src="https://avatars.githubusercontent.com/u/14075359?v=4" width="100;" alt="mltbnz"/>
                    <br />
                    <sub><b>Malte Bünz</b></sub>
                </a>
            </td>
            <td align="center">
                <a href="https://github.com/normansander">
                    <img src="https://avatars.githubusercontent.com/u/1220469?v=4" width="100;" alt="normansander"/>
                    <br />
                    <sub><b>Norman Sander</b></sub>
                </a>
            </td>
            <td align="center">
                <a href="https://github.com/fbernutz">
                    <img src="https://avatars.githubusercontent.com/u/26111180?v=4" width="100;" alt="fbernutz"/>
                    <br />
                    <sub><b>Felizia Bernutz</b></sub>
                </a>
            </td>
            <td align="center">
                <a href="https://github.com/i5glu">
                    <img src="https://avatars.githubusercontent.com/u/9765299?v=4" width="100;" alt="i5glu"/>
                    <br />
                    <sub><b>I5glu</b></sub>
                </a>
            </td>
            <td align="center">
                <a href="https://github.com/maxxx777">
                    <img src="https://avatars.githubusercontent.com/u/2142832?v=4" width="100;" alt="maxxx777"/>
                    <br />
                    <sub><b>Maxim Tsvetkov</b></sub>
                </a>
            </td>
		</tr>
		<tr>
            <td align="center">
                <a href="https://github.com/besilva">
                    <img src="https://avatars.githubusercontent.com/u/20118834?v=4" width="100;" alt="besilva"/>
                    <br />
                    <sub><b>Bernardo Silva</b></sub>
                </a>
            </td>
            <td align="center">
                <a href="https://github.com/stephanlindauer">
                    <img src="https://avatars.githubusercontent.com/u/1323145?v=4" width="100;" alt="stephanlindauer"/>
                    <br />
                    <sub><b>Stephan Lindauer</b></sub>
                </a>
            </td>
            <td align="center">
                <a href="https://github.com/jacquealvesb">
                    <img src="https://avatars.githubusercontent.com/u/86978515?v=4" width="100;" alt="jacquealvesb"/>
                    <br />
                    <sub><b>Jacqueline Alves</b></sub>
                </a>
            </td>
            <td align="center">
                <a href="https://github.com/huschu">
                    <img src="https://avatars.githubusercontent.com/u/879754?v=4" width="100;" alt="huschu"/>
                    <br />
                    <sub><b>Joscha</b></sub>
                </a>
            </td>
            <td align="center">
                <a href="https://github.com/woxtu">
                    <img src="https://avatars.githubusercontent.com/u/5673994?v=4" width="100;" alt="woxtu"/>
                    <br />
                    <sub><b>Null</b></sub>
                </a>
            </td>
            <td align="center">
                <a href="https://github.com/jkandzi">
                    <img src="https://avatars.githubusercontent.com/u/9692434?v=4" width="100;" alt="jkandzi"/>
                    <br />
                    <sub><b>Justus Kandzi</b></sub>
                </a>
            </td>
		</tr>
		<tr>
            <td align="center">
                <a href="https://github.com/zutrinken">
                    <img src="https://avatars.githubusercontent.com/u/888679?v=4" width="100;" alt="zutrinken"/>
                    <br />
                    <sub><b>Peter Amende</b></sub>
                </a>
            </td>
            <td align="center">
                <a href="https://github.com/ravi-aggarwal-code">
                    <img src="https://avatars.githubusercontent.com/u/91732598?v=4" width="100;" alt="ravi-aggarwal-code"/>
                    <br />
                    <sub><b>Ravi Aggarwal</b></sub>
                </a>
            </td>
            <td align="center">
                <a href="https://github.com/AlbanSagouis">
                    <img src="https://avatars.githubusercontent.com/u/25483578?v=4" width="100;" alt="AlbanSagouis"/>
                    <br />
                    <sub><b>Alban Sagouis</b></sub>
                </a>
            </td>
            <td align="center">
                <a href="https://github.com/thisIsTheFoxe">
                    <img src="https://avatars.githubusercontent.com/u/18512366?v=4" width="100;" alt="thisIsTheFoxe"/>
                    <br />
                    <sub><b>Henry</b></sub>
                </a>
            </td>
            <td align="center">
                <a href="https://github.com/k-nut">
                    <img src="https://avatars.githubusercontent.com/u/1096357?v=4" width="100;" alt="k-nut"/>
                    <br />
                    <sub><b>Knut Hühne</b></sub>
                </a>
            </td>
            <td align="center">
                <a href="https://github.com/wacumov">
                    <img src="https://avatars.githubusercontent.com/u/2861871?v=4" width="100;" alt="wacumov"/>
                    <br />
                    <sub><b>Mikhail Akopov</b></sub>
                </a>
            </td>
		</tr>
		<tr>
            <td align="center">
                <a href="https://github.com/StartingCoding">
                    <img src="https://avatars.githubusercontent.com/u/43170443?v=4" width="100;" alt="StartingCoding"/>
                    <br />
                    <sub><b>Loris</b></sub>
                </a>
            </td>
		</tr>
	<tbody>
</table>
<!-- readme: contributors -end -->

## Copyright & License

Copyright (c) 2021 headione - Released under the [MIT license](https://github.com/criticalmaps/criticalmaps-ios/blob/main/LICENSE).
