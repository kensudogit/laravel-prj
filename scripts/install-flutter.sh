#!/bin/bash

# Flutter SDK Installation Script
# This script installs Flutter SDK on different platforms

set -e

echo "Starting Flutter SDK installation..."

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

# Function to install Flutter on Linux
install_flutter_linux() {
    echo "Installing Flutter on Linux..."
    
    # Install dependencies
    sudo apt-get update
    sudo apt-get install -y curl git unzip xz-utils zip libglu1-mesa
    
    # Download Flutter
    FLUTTER_VERSION="3.16.9"
    FLUTTER_URL="https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_$FLUTTER_VERSION-stable.tar.xz"
    
    echo "Downloading Flutter $FLUTTER_VERSION..."
    cd ~
    wget -O flutter.tar.xz $FLUTTER_URL
    
    # Extract Flutter
    echo "Extracting Flutter..."
    tar xf flutter.tar.xz
    
    # Add Flutter to PATH
    echo 'export PATH="$PATH:$HOME/flutter/bin"' >> ~/.bashrc
    source ~/.bashrc
    
    # Clean up
    rm flutter.tar.xz
    
    echo "Flutter installed successfully on Linux!"
}

# Function to install Flutter on macOS
install_flutter_macos() {
    echo "Installing Flutter on macOS..."
    
    # Check if Homebrew is installed
    if ! command -v brew &> /dev/null; then
        echo "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    
    # Install Flutter using Homebrew
    echo "Installing Flutter using Homebrew..."
    brew install --cask flutter
    
    echo "Flutter installed successfully on macOS!"
}

# Function to install Flutter on Windows
install_flutter_windows() {
    echo "Installing Flutter on Windows..."
    
    # Download Flutter
    FLUTTER_VERSION="3.16.9"
    FLUTTER_URL="https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_$FLUTTER_VERSION-stable.zip"
    
    echo "Downloading Flutter $FLUTTER_VERSION..."
    cd ~
    curl -o flutter.zip $FLUTTER_URL
    
    # Extract Flutter
    echo "Extracting Flutter..."
    unzip flutter.zip
    
    # Add Flutter to PATH (Windows)
    echo "Please add the following to your PATH environment variable:"
    echo "%USERPROFILE%\flutter\bin"
    
    # Clean up
    del flutter.zip
    
    echo "Flutter installed successfully on Windows!"
    echo "Please restart your terminal and run 'flutter doctor'"
}

# Install Flutter based on OS
case $MACHINE in
    Linux)
        install_flutter_linux
        ;;
    Mac)
        install_flutter_macos
        ;;
    MinGw|Cygwin)
        install_flutter_windows
        ;;
    *)
        echo "Unsupported OS: $MACHINE"
        echo "Please install Flutter manually from: https://flutter.dev/docs/get-started/install"
        exit 1
        ;;
esac

# Verify installation
echo "Verifying Flutter installation..."
flutter --version

echo "Flutter SDK installation completed!"
echo ""
echo "Next steps:"
echo "1. Run 'flutter doctor' to check for additional dependencies"
echo "2. Install Android Studio or Xcode"
echo "3. Set up emulators/simulators"
echo "4. Run the mobile app setup script" 