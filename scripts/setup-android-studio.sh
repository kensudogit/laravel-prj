#!/bin/bash

# Android Studio Setup Script
# This script helps set up Android Studio for Flutter development

set -e

echo "Starting Android Studio setup for Flutter development..."

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

# Function to install Android Studio on Linux
install_android_studio_linux() {
    echo "Installing Android Studio on Linux..."
    
    # Install dependencies
    sudo apt-get update
    sudo apt-get install -y openjdk-11-jdk
    
    # Download Android Studio
    ANDROID_STUDIO_VERSION="2023.1.1.26"
    ANDROID_STUDIO_URL="https://redirector.gvt1.com/edgedl/android/studio/ide-zips/2023.1.1.26/android-studio-2023.1.1.26-linux.tar.gz"
    
    echo "Downloading Android Studio..."
    cd ~
    wget -O android-studio.tar.gz $ANDROID_STUDIO_URL
    
    # Extract Android Studio
    echo "Extracting Android Studio..."
    tar xf android-studio.tar.gz
    
    # Move to opt directory
    sudo mv android-studio /opt/
    
    # Create desktop shortcut
    cat > ~/.local/share/applications/android-studio.desktop << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Android Studio
Comment=Android Studio IDE
Exec=/opt/android-studio/bin/studio.sh
Icon=/opt/android-studio/bin/studio.svg
Categories=Development;IDE;
Terminal=false
EOF
    
    # Clean up
    rm android-studio.tar.gz
    
    echo "Android Studio installed successfully on Linux!"
    echo "You can now launch Android Studio from the applications menu"
}

# Function to install Android Studio on macOS
install_android_studio_macos() {
    echo "Installing Android Studio on macOS..."
    
    # Check if Homebrew is installed
    if ! command -v brew &> /dev/null; then
        echo "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    
    # Install Android Studio using Homebrew
    echo "Installing Android Studio using Homebrew..."
    brew install --cask android-studio
    
    echo "Android Studio installed successfully on macOS!"
}

# Function to install Android Studio on Windows
install_android_studio_windows() {
    echo "Installing Android Studio on Windows..."
    
    # Download Android Studio
    ANDROID_STUDIO_VERSION="2023.1.1.26"
    ANDROID_STUDIO_URL="https://redirector.gvt1.com/edgedl/android/studio/ide-zips/2023.1.1.26/android-studio-2023.1.1.26-windows.exe"
    
    echo "Downloading Android Studio..."
    cd ~
    curl -o android-studio.exe $ANDROID_STUDIO_URL
    
    echo "Please run the downloaded android-studio.exe installer"
    echo "Follow the installation wizard to complete the setup"
    
    echo "Android Studio download completed!"
    echo "Please run the installer manually"
}

# Install Android Studio based on OS
case $MACHINE in
    Linux)
        install_android_studio_linux
        ;;
    Mac)
        install_android_studio_macos
        ;;
    MinGw|Cygwin)
        install_android_studio_windows
        ;;
    *)
        echo "Unsupported OS: $MACHINE"
        echo "Please install Android Studio manually from: https://developer.android.com/studio"
        exit 1
        ;;
esac

echo ""
echo "Android Studio setup completed!"
echo ""
echo "Next steps:"
echo "1. Launch Android Studio"
echo "2. Complete the initial setup wizard"
echo "3. Install Android SDK"
echo "4. Set up Android emulator"
echo "5. Configure Flutter in Android Studio" 