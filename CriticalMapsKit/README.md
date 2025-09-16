# CriticalMapsKit

## Modules

All things needed to run the app is inside this package and is build in a hyper-modularization style.
This allows to work on features without building the entire application, which improves compile times and SwiftUI preview stability. Every feature is its own target which makes it also possible to build mini-apps to run in the simulator for preview.

For most modules there is also a test module which includes unit and snapshot tests.
