#!/bin/sh
if which swiftlint >/dev/null; then
swiftlint
else
echo "warning: SwiftLint not installed, download from https://github.com/realm/SwiftLint"
fi

if hash tailor 2>/dev/null; then
tailor
else
echo "warning: Please install Tailor from https://tailor.sh"
fi

