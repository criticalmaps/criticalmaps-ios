# Change Log

Changelog for Critical Maps iOS

# [4.2.1] - 2023-06-05

### Fixed

- Coordinate encoding to match expected format
- RideEvent settings update now refetches the next ride


# [4.2.0] - 2023-06-01

### Added

- Adopt new Backend architecture
- Update BottomSheet view that will focus on available next ride
- Performance enhencements

# [4.0.0] - 2022-03-18

__Proposal for the release is to make it `4.0.0`__
This release is a rebuild of the app built with [`The Composable Architecture`](https://github.com/pointfreeco/swift-composable-architecture) and `SwiftUI`

### Added

- ErrorStateView and EmtpyState view
- Adopts new Styleguide
- Contribute with translation view to Settings
- Add increased contrast support
- Show all ride events from `NextRide` overlay button contextMenu
- Show observation mode prompt on first app launch


# [3.9.2] - 2021-05-04

### Fixed

- Fix a bug that showed cancelled events
- Adapt BikeAnnotation Size to equal the Sizes in Maps
- Fix Switching Appearance Settings and using `.system`
- 🤞Should fix event feature related crashes.

# [3.9.1] - 2020-11-20

### Fixed 

- Remove Container Background Color in MapInfoView
- Make `BikeAnnotation` it is more accesible now(scales with preferredContentSizeCategory)
- Minor layout fixes: accessory color in Settings and update chat input to follow the design from sketch

# [3.9.0] - 2020-11-09

### Added

- Fullpage screenshots of the Map
- Large preview images on long press for the navigation buttons on devices that use large font sizes
- Next event feature: See where the next Critical Mass close to you takes place.
- Select an alternate app icon
- Added settings option to choose system appearance or dark/light
- Shows error view on the map when the server does not respond

### Fixed

- Fix Wrong displayed timestamps for tweets if the App was active for a while
- Fix Dark Mode Color Behaviour in Action Indicator (in Rules, Settings) and Separator (in Settings)
- Fix missing information for VoiceOver user for the navigationbar buttons
- Fix VoiceControl labels on each view
- Fix `bottomContentOffset` for NavigationOverlay (did hide the Legal button)

### Changed

- Bump deployment target to iOS 12
- Localised snapshot tests

## [3.8.0] - 2020-03-01

### Fixed

- Fixed a Bug that caused a 12 second delay to display Riders on the Map after launching the App

### Updated

- Cleaner BikeAnnotation appearance

## [3.7.0] - 2020-02-11

### Added

- Replace send text button in ChatInputView with an icon button
- Accessability support for chat input textview
- VoiceOver improvements for the Navigation TabBar
- Spanish translations

## [3.6.0] - 2019-11-28

### Fixed

- Fix: Don't update content when slightly swipe down in Social Modal
- Fix whitespace only chat message can not be send anymore.
- Fix dark mode for Rules Detail

### Added

- Loading and ErrorStateView for Twitter and Chat section

## [3.4.0] - 2019-10-08

### Added

- Landscape support
- Set userStyle as Theme under iOS 13
- Add infrastructure for UITests to easily generate automated screenshots with different languages and devices
- Infrastructure for Snapshot tests
- Open Twitter tapping on tweet

### Fixed

- Fix: NavigationBar Colors under iOS 13
- Fix: UITableViewHeaderFooterView backgroundColor deprecation warning
- Fix: Ambiguous auto layout constraints for Settings screen

## [3.3.0] - 2019-09-01

### Added

- iOS 13 support

### Fixed

- A bug that made the app unusable with assistive technologies like Switch Control or VoiceOver
- SocialSegment sliding under NavigationBar bug in iOS 10
- Dynamic Type Layout issues

## [3.2.0] - 2019-06-18

### Added

- Dynamic Type support
- Observation Mode

### Fixed

- A bug that stopped updating locations if one update request failed

## [3.1.0] - 2019-05-28

### Added

- Message Notification Bubble
- Swiftformat to the build phases
- The ID isn't constant anymore
- Network activity indicator support
- French localisation. Thanks Alban!
- Night mode feature

### Updated

- SDWebImage

### Fixed

- Users can not send empty chat messages anymore.
- A bug that prevented sending messages if another network request is active
- input dismissed when switching to the emoji keyboard

## [3.0.0] - 2019-04-18

### Changed

- Complete Redesign
- Migrate map page to Swift
- Migrate rules page to Swift
- Migrate chat page to Swift
- Migrate twitter page to Swift
- Migrate settings page to Swift
- New navigation

### Added

- Swift bridge
- Tests

## [2.5.1]

### Fixed

- Modern devices support

## [2.5.0]

### Added

- italian translations

### Changed

- allow observing if GPS is disabled
- english translations

### Updated

- XCode project to recommend settings
- AFNetworking
- Appirater
- SDWebImage

## [2.4.0] - 2017-08-01

### Changed

- less bike symbol opacity

## [2.3.0] - 2017-07-02

### Changed

- switch back to api.criticalmaps.net

### Removed

- Travis

## [2.2.1] - 2017-06-07

### Fixed

- intended purpose of using the user's location while the app is in the background (NSLocationAlwaysUsageDescription)

## [2.2.0] - 2017-06-06

### Changed

- temporary API url

### Updated

- SDWebImage
- Appirater 2.1.2 (was 2.0.5)
- STTwitter 0.2.6 (was 0.2.5)

## [2.1.0] - 2016-09-24

### Added

- Changelog

### Changed

- Update pods
- Remove parse
- Change title on map screen to "Critical Maps"

### Fixed

- Podfile

## [2.0.1] - 2016-04-10

### Updated

- pods

## [2.0.0] - 2016-01-15

### Changed

- redesign by zutrinken

previous versions are not tracked
