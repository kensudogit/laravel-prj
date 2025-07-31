#!/bin/bash

# Flutter Mobile Development Setup Script
# This script sets up Flutter for mobile development

set -e

echo "Starting Flutter mobile development setup..."

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo "Flutter is not installed. Please install Flutter first."
    echo "Visit: https://flutter.dev/docs/get-started/install"
    exit 1
fi

# Check Flutter version
FLUTTER_VERSION=$(flutter --version | grep -o "Flutter [0-9]\+\.[0-9]\+\.[0-9]\+" | head -1)
echo "Found Flutter version: $FLUTTER_VERSION"

# Navigate to mobile directory
cd mobile

# Get Flutter dependencies
echo "Installing Flutter dependencies..."
flutter pub get

# Generate code
echo "Generating code..."
flutter packages pub run build_runner build --delete-conflicting-outputs

# Check Flutter doctor
echo "Running Flutter doctor..."
flutter doctor

# Create assets directories
echo "Creating assets directories..."
mkdir -p assets/images
mkdir -p assets/icons
mkdir -p assets/fonts

# Create placeholder files
touch assets/images/.gitkeep
touch assets/icons/.gitkeep
touch assets/fonts/.gitkeep

echo "Flutter mobile setup completed successfully!"
echo ""
echo "Next steps:"
echo "1. Open the mobile directory in your IDE"
echo "2. Run 'flutter run' to start the app"
echo "3. Make sure your Laravel backend is running on http://localhost:8000"
echo ""
echo "Useful commands:"
echo "  flutter run                    # Run the app"
echo "  flutter build apk              # Build Android APK"
echo "  flutter build ios              # Build iOS app"
echo "  flutter test                   # Run tests"
echo "  flutter analyze                # Analyze code"
echo "  flutter packages pub run build_runner build  # Generate code" 