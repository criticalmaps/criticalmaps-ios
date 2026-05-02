.PHONY: help default tests assets dependencies ruby lint format clean setup install-pre-commit pre-commit-run pre-commit-update check-versions

default: tests

help: ## Show this help
	@echo "Critical Maps iOS - Available commands:"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'

check-versions: ## Check tool versions against .tool-versions
	@echo "🔍 Checking tool versions..."
	@echo "Expected versions (from .tool-versions):"
	@grep -v '^#' .tool-versions | while read tool version; do \
		echo "  $$tool: $$version"; \
	done
	@echo ""
	@echo "Note: swiftformat and swiftlint are pinned in .pre-commit-config.yaml"
	@echo "and managed by pre-commit, not brew."
	@echo ""
	@echo "Installed versions:"
	@if command -v swiftgen >/dev/null 2>&1; then \
		echo "  swiftgen: $$(swiftgen --version | grep -o 'v[0-9\.]*' | head -1 | sed 's/v//')"; \
	else \
		echo "  swiftgen: ❌ not installed"; \
	fi
	@if command -v pre-commit >/dev/null 2>&1; then \
		echo "  pre-commit: $$(pre-commit --version | grep -o '[0-9\.]*')"; \
	else \
		echo "  pre-commit: ❌ not installed"; \
	fi

dependencies: ruby check-versions ## Install all development dependencies
	@echo "📦 Installing development tools..."
	@if ! command -v swiftgen >/dev/null 2>&1; then \
		echo "Installing swiftgen..."; \
		brew install swiftgen; \
	else \
		echo "✅ swiftgen already installed"; \
	fi
	@if ! command -v pre-commit >/dev/null 2>&1; then \
		echo "Installing pre-commit..."; \
		brew install pre-commit; \
	else \
		echo "✅ pre-commit already installed"; \
	fi
	@echo "Building swiftformat / swiftlint via pre-commit (first run only)..."
	@pre-commit install-hooks

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

lint: ## Run SwiftLint with auto-fix via pre-commit
	@echo "🔍 Running SwiftLint..."
	@pre-commit run swiftlint-fix --all-files || true
	@pre-commit run swiftlint --all-files

format: ## Format Swift code with SwiftFormat via pre-commit
	@echo "✨ Formatting Swift code..."
	@pre-commit run swiftformat --all-files

tests: ## Run all tests via Fastlane
	@echo "🧪 Running tests..."
	@bundle exec fastlane ios test

install-pre-commit: ## Install pre-commit hooks
	@echo "🪝 Installing pre-commit hooks..."
	@pre-commit install
	@echo "✅ Pre-commit hooks installed"

pre-commit-run: ## Run pre-commit on all files
	@echo "🔍 Running pre-commit on all files..."
	@pre-commit run --all-files

pre-commit-update: ## Update pre-commit hook versions
	@echo "⬆️ Updating pre-commit hooks..."
	@pre-commit autoupdate
