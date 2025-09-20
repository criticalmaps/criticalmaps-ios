.PHONY: help default tests assets dependencies ruby lint format clean setup

default: tests

help: ## Show this help
	@echo "Critical Maps iOS - Available commands:"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'

setup: dependencies ## Complete project setup for new developers
	@echo "🎉 Project setup complete! You can now run 'make tests' or open CriticalMaps.xcodeproj"

dependencies: ruby ## Install all development dependencies
	@echo "📦 Installing development tools..."
	@if ! command -v swiftformat >/dev/null 2>&1; then \
		echo "Installing swiftformat..."; \
		brew install swiftformat; \
	else \
		echo "✅ swiftformat already installed"; \
	fi
	@if ! command -v swiftgen >/dev/null 2>&1; then \
		echo "Installing swiftgen..."; \
		brew install swiftgen; \
	else \
		echo "✅ swiftgen already installed"; \
	fi
	@if ! command -v swiftlint >/dev/null 2>&1; then \
		echo "Installing swiftlint..."; \
		brew install swiftlint; \
	else \
		echo "✅ swiftlint already installed"; \
	fi

ruby: ## Install Ruby dependencies (bundler, fastlane)
	@echo "💎 Setting up Ruby environment..."
	@if ! command -v bundler >/dev/null 2>&1; then \
		echo "Installing bundler..."; \
		gem install bundler; \
	else \
		echo "✅ bundler already installed"; \
	fi
	@echo "Installing fastlane and other Ruby gems..."
	@bundle install

assets: ## Generate type-safe assets with SwiftGen
	@echo "🎨 Generating type-safe assets..."
	@swiftgen

lint: ## Run SwiftLint with auto-fix
	@echo "🔍 Running SwiftLint..."
	@if command -v swiftlint >/dev/null 2>&1; then \
		swiftlint --fix && swiftlint; \
	else \
		echo "❌ SwiftLint not installed. Run 'make dependencies' first."; \
		exit 1; \
	fi

format: ## Format Swift code with SwiftFormat
	@echo "✨ Formatting Swift code..."
	@if command -v swiftformat >/dev/null 2>&1; then \
		swiftformat .; \
	else \
		echo "❌ SwiftFormat not installed. Run 'make dependencies' first."; \
		exit 1; \
	fi

tests: ## Run all tests via Fastlane
	@echo "🧪 Running tests..."
	@bundle exec fastlane ios test

clean: ## Clean build artifacts and derived data
	@echo "🗑️  Cleaning build artifacts..."
	@rm -rf build/
	@rm -rf .build/
	@rm -rf CriticalMapsKit/.build/
	@xcodebuild -project CriticalMaps.xcodeproj -alltargets clean 2>/dev/null || true
	@echo "✅ Clean complete"