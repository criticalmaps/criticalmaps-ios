default: tests

assets:
	./tools/swiftgen/swiftgen

dependencies: ruby

licenses:
	./tools/spm-ack generate-plist ./CriticalMaps.xcodeproj/project.xcworkspace ./CriticalMapsKit/Sources/SettingsFeature/Resources/Acknowledgements.plist

lint:
	./scripts/swiftlint.sh

ruby:
	gem install bundler
	bundle install

tests:
	bundle exec fastlane ios test