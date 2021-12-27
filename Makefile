default: tests

dependencies: ruby

ruby:
	gem install bundler
	bundle install

assets:
	./tools/swiftgen/swiftgen

lint:
	./scripts/swiftlint.sh

tests:
	bundle exec fastlane ios test