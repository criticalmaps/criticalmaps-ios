if which swiftlint >/dev/null; then
  ./tools/swiftlint --fix && ./tools/swiftlint
else
  echo "warning: SwiftLint not installed, download from https://github.com/realm/SwiftLint"
fi