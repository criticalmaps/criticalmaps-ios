<p align="center"><a href="https://itunes.apple.com/app/critical-maps/id918669647"><img src="_images/Icon.svg" width="250" /></a></p>

<p align="center"><a href="https://itunes.apple.com/app/critical-maps/id918669647"><img src="_images/appstore-badge.png" width="150" /></a></p>

## Critical Maps iOS App

[![CI](https://github.com/criticalmaps/criticalmaps-ios/actions/workflows/ci.yml/badge.svg)](https://github.com/criticalmaps/criticalmaps-ios/actions/workflows/ci.yml)
<a title="TestFlight" target="_blank" href="https://testflight.apple.com/join/nyGeQVxk">
	<img src="https://img.shields.io/badge/Join-TestFlight-blue.svg"
				alt="Join TestFlight" />
</a>
<a title="Crowdin" target="_blank" href="https://crowdin.com/project/critical-maps">
	<img src="https://badges.crowdin.net/critical-maps/localized.svg" alt="Localized Status" />
</a>

## What's "Critical Mass"?

> Critical Mass has been described as 'monthly political-protest rides', and characterized as being part of a social movement.

http://en.wikipedia.org/wiki/Critical_Mass_(cycling)

## What's this app?

This iOS app is made for Critical Maps. It tracks your location and shares it via a map with all other participants of the Critical Mass bicycle protest. You can use the chat to communicate with all other participants.

## Where can I get the app?

- **iTunes:** https://itunes.apple.com/app/critical-maps/id918669647
- **TestFlight:** https://testflight.apple.com/join/nyGeQVxk
- **Website:** https://criticalmaps.net

## Project Setup

The App uses Apple's `Combine.framework` for operation scheduling. The UI-Layer is built with [The Composable Architecture](https://github.com/pointfreeco/swift-composable-architecture) and `SwiftUI`.
Minimum platform requirements are: iOS 15.0

### Modularization

The application is built in a hyper-modularized style. This allows to work on features without building the entire application, which improves compile times and SwiftUI preview stability. Every feature is its own target which makes it also possible to build mini-apps to run in the simulator for preview.

### Getting Started

This repo contains both the client for running the entire [criticalmaps](https://itunes.apple.com/app/critical-maps/id918669647) application, as well as an extensive test suite. To get things running:

1. Grab the code:
    ```sh
    git clone https://github.com/criticalmaps/criticalmaps-ios
    cd criticalmaps-ios
    ```
2. Open the Xcode project `CriticalMaps.xcodeproj`.
3. To run the client locally, select the `Critical Maps` target in Xcode and run (`⌘R`).

### Assets

The project is using type-safe assets generated with [SwiftGen](https://github.com/SwiftGen/SwiftGen).
If you add images to the project be sure to install it and run `swiftgen` from the root folder and add the changes to your PR.


## Contribute

- Please report bugs with GitHub [issues](https://github.com/CriticalMaps/criticalmaps-ios/issues).
- If you can code please check the build & contribute guide below.
- If you have some coins left you can help to finance the project on [Open Collective](https://opencollective.com/criticalmaps).

### How to contribute

In general, we follow the "fork-and-pull" Git workflow.

1.  **Fork** the repo on GitHub
2.  **Clone** the project to your own machine
3.  **Commit** changes to your own branch. Please add your changes also to the CHANGELOG. We're following the standard of [Keep a Changelog](https://keepachangelog.com/en/1.0.0/)
4.  **Push** your work back up to your fork
5.  Submit a **Pull request** so that we can review your changes

NOTES: 
- Be sure to merge the latest from "upstream" before making a pull request!

## Open Source & Copying

We ship CriticalMaps on the App Store for free and provide its entire source code for free as well. In the spirit of openness, CriticalMaps is licensed under MIT so that you can use my code in your app, if you choose.

However, **please do not ship this app** under your own account. Paid or free.

## Credits

<!-- readme: contributors -start -->
<!-- readme: contributors -end -->

## Copyright & License

Copyright (c) 2021 headione - Released under the [MIT license](https://github.com/criticalmaps/criticalmaps-ios/blob/master/LICENSE).
