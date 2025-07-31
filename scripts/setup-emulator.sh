#!/bin/bash

# Emulator Setup Script
# This script helps set up Android emulator and iOS simulator

set -e

echo "Starting emulator setup for Flutter development..."

# Detect OS
OS="$(uname -s)"
case "${OS}" in
    Linux*)     MACHINE=Linux;;
    Darwin*)    MACHINE=Mac;;
    CYGWIN*)    MACHINE=Cygwin;;
    MINGW*)     MACHINE=MinGw;;
    *)          MACHINE="UNKNOWN:${OS}"
esac

echo "Detected OS: $MACHINE"

# Function to setup Android emulator
setup_android_emulator() {
    echo "Setting up Android emulator..."
    
    # Check if Android SDK is available
    if ! command -v adb &> /dev/null; then
        echo "Android SDK not found. Please install Android Studio first."
        echo "Run: ./scripts/setup-android-studio.sh"
        exit 1
    fi
    
    # Check if emulator is available
    if ! command -v emulator &> /dev/null; then
        echo "Android emulator not found. Please install Android Studio and SDK tools."
        exit 1
    fi
    
    # List available AVDs
    echo "Available Android Virtual Devices (AVDs):"
    emulator -list-avds
    
    # Create a new AVD if none exists
    if [ -z "$(emulator -list-avds)" ]; then
        echo "No AVDs found. Creating a new one..."
        
        # Create AVD with API 34 (Android 14)
        echo "Creating AVD with API 34..."
        avdmanager create avd \
            --name "flutter_emulator" \
            --package "system-images;android-34;google_apis;x86_64" \
            --device "pixel_7" \
            --force
        
        echo "AVD 'flutter_emulator' created successfully!"
    else
        echo "Using existing AVD: $(emulator -list-avds | head -1)"
    fi
    
    # Start the emulator
    echo "Starting Android emulator..."
    emulator -avd flutter_emulator &
    
    echo "Android emulator is starting..."
    echo "Please wait for the emulator to fully boot before running Flutter apps"
}

# Function to setup iOS simulator (macOS only)
setup_ios_simulator() {
    echo "Setting up iOS simulator..."
    
    # Check if Xcode is installed
    if ! command -v xcode-select &> /dev/null; then
        echo "Xcode not found. Please install Xcode from the App Store."
        exit 1
    fi
    
    # Check if iOS simulator is available
    if ! command -v xcrun &> /dev/null; then
        echo "iOS simulator not found. Please install Xcode command line tools."
        exit 1
    fi
    
    # List available simulators
    echo "Available iOS simulators:"
    xcrun simctl list devices available
    
    # Get the first available iPhone simulator
    IPHONE_SIMULATOR=$(xcrun simctl list devices available | grep "iPhone" | head -1 | sed 's/.*(\([^)]*\)).*/\1/')
    
    if [ -z "$IPHONE_SIMULATOR" ]; then
        echo "No iPhone simulators found. Creating a new one..."
        
        # Create iPhone 15 simulator with iOS 17
        xcrun simctl create "iPhone 15" "iPhone 15" "iOS17.0"
        IPHONE_SIMULATOR=$(xcrun simctl list devices available | grep "iPhone 15" | head -1 | sed 's/.*(\([^)]*\)).*/\1/')
    fi
    
    echo "Using iPhone simulator: $IPHONE_SIMULATOR"
    
    # Boot the simulator
    echo "Starting iOS simulator..."
    xcrun simctl boot "$IPHONE_SIMULATOR"
    
    # Open Simulator app
    open -a Simulator
    
    echo "iOS simulator is starting..."
    echo "Please wait for the simulator to fully boot before running Flutter apps"
}

# Function to check Flutter doctor
check_flutter_doctor() {
    echo "Running Flutter doctor..."
    flutter doctor
    
    echo ""
    echo "Flutter doctor completed!"
    echo "Please resolve any issues shown above before proceeding."
}

# Setup based on OS
case $MACHINE in
    Linux)
        echo "Setting up Android emulator on Linux..."
        setup_android_emulator
        ;;
    Mac)
        echo "Setting up emulators on macOS..."
        echo "You can use both Android emulator and iOS simulator on macOS"
        
        echo ""
        echo "1. Setting up Android emulator..."
        setup_android_emulator
        
        echo ""
        echo "2. Setting up iOS simulator..."
        setup_ios_simulator
        ;;
    MinGw|Cygwin)
        echo "Setting up Android emulator on Windows..."
        setup_android_emulator
        ;;
    *)
        echo "Unsupported OS: $MACHINE"
        echo "Please set up emulators manually"
        exit 1
        ;;
esac

echo ""
echo "Emulator setup completed!"
echo ""
echo "Next steps:"
echo "1. Wait for emulator/simulator to fully boot"
echo "2. Run 'flutter doctor' to verify setup"
echo "3. Navigate to mobile directory: cd mobile"
echo "4. Run the Flutter app: flutter run"
echo ""
echo "Useful commands:"
echo "  flutter devices              # List available devices"
echo "  flutter run                  # Run app on connected device"
echo "  flutter run -d android       # Run on Android emulator"
echo "  flutter run -d ios           # Run on iOS simulator" 