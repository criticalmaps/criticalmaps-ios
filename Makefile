default: tests

assets:
	./tools/swiftgen/swiftgen

dependencies: ruby

lint:
	./scripts/swiftlint.sh

ruby:
	gem install bundler
	bundle install

format:
	swiftformat .

tests:
	bundle exec fastlane ios test