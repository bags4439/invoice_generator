#!/bin/bash
set -e

echo "Cleaning old Flutter builds..."
fvm flutter clean

echo "Getting Flutter packages..."
fvm flutter pub get

echo "Cleaning iOS Pods..."
cd ios
rm -rf Pods Podfile.lock
rm -rf ~/Library/Developer/Xcode/DerivedData

echo "Installing CocoaPods (Apple Silicon safe)..."
arch -x86_64 pod install --repo-update

echo "Opening Xcode workspace..."
open Runner.xcworkspace

echo "Setup complete. You can now run your app with 'flutter run'."
