#!/bin/bash

# Run Mobile App Script
# This script runs the Flutter mobile app

set -e

echo "Starting Flutter mobile app..."

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo "Flutter is not installed. Please install Flutter first."
    echo "Run: ./scripts/install-flutter.sh"
    exit 1
fi

# Check if we're in the correct directory
if [ ! -f "mobile/pubspec.yaml" ]; then
    echo "Error: mobile/pubspec.yaml not found."
    echo "Please run this script from the project root directory."
    exit 1
fi

# Navigate to mobile directory
cd mobile

# Check Flutter doctor
echo "Running Flutter doctor..."
flutter doctor

# Get dependencies
echo "Getting Flutter dependencies..."
flutter pub get

# Generate code
echo "Generating code..."
flutter packages pub run build_runner build --delete-conflicting-outputs

# Check available devices
echo "Available devices:"
flutter devices

# Function to run on Android
run_android() {
    echo "Running on Android..."
    flutter run -d android
}

# Function to run on iOS
run_ios() {
    echo "Running on iOS..."
    flutter run -d ios
}

# Function to run on connected device
run_connected() {
    echo "Running on connected device..."
    flutter run
}

# Function to show device selection menu
select_device() {
    echo ""
    echo "Select device to run on:"
    echo "1. Android emulator"
    echo "2. iOS simulator (macOS only)"
    echo "3. Connected device"
    echo "4. List available devices"
    echo "5. Exit"
    echo ""
    read -p "Enter your choice (1-5): " choice
    
    case $choice in
        1)
            run_android
            ;;
        2)
            if [[ "$OSTYPE" == "darwin"* ]]; then
                run_ios
            else
                echo "iOS simulator is only available on macOS"
                select_device
            fi
            ;;
        3)
            run_connected
            ;;
        4)
            flutter devices
            select_device
            ;;
        5)
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo "Invalid choice. Please try again."
            select_device
            ;;
    esac
}

# Check if Laravel backend is running
check_backend() {
    echo "Checking Laravel backend..."
    
    # Try to connect to Laravel API
    if curl -s http://localhost:8000/api/health > /dev/null 2>&1; then
        echo "✅ Laravel backend is running on http://localhost:8000"
    else
        echo "⚠️  Laravel backend is not running on http://localhost:8000"
        echo "Please start the Laravel backend first:"
        echo "  cd .."
        echo "  docker-compose up -d"
        echo "  # or"
        echo "  php artisan serve"
        echo ""
        read -p "Continue anyway? (y/n): " continue_anyway
        if [[ $continue_anyway != "y" && $continue_anyway != "Y" ]]; then
            exit 1
        fi
    fi
}

# Main execution
echo "Setting up Flutter mobile app..."

# Check backend
check_backend

# Show device selection
select_device

echo ""
echo "Mobile app setup completed!"
echo ""
echo "Useful commands:"
echo "  flutter run                    # Run the app"
echo "  flutter run -d android         # Run on Android"
echo "  flutter run -d ios             # Run on iOS"
echo "  flutter build apk              # Build Android APK"
echo "  flutter build ios              # Build iOS app"
echo "  flutter test                   # Run tests"
echo "  flutter analyze                # Analyze code"
echo "  flutter packages pub run build_runner build  # Generate code" 