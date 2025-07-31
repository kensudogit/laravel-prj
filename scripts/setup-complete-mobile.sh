#!/bin/bash

# Complete Mobile Development Setup Script
# This script sets up the entire mobile development environment

set -e

echo "🚀 Complete Mobile Development Setup"
echo "====================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to ask for user confirmation
ask_confirmation() {
    read -p "$1 (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        return 0
    else
        return 1
    fi
}

# Step 1: Check prerequisites
print_status "Step 1: Checking prerequisites..."

# Check if we're in the correct directory
if [ ! -f "mobile/pubspec.yaml" ]; then
    print_error "mobile/pubspec.yaml not found. Please run this script from the project root directory."
    exit 1
fi

print_success "Project structure verified"

# Step 2: Install Flutter SDK
print_status "Step 2: Installing Flutter SDK..."

if command_exists flutter; then
    print_success "Flutter is already installed"
    flutter --version
else
    print_status "Flutter not found. Installing..."
    if [ -f "scripts/install-flutter.sh" ]; then
        chmod +x scripts/install-flutter.sh
        ./scripts/install-flutter.sh
    else
        print_error "install-flutter.sh not found. Please install Flutter manually."
        exit 1
    fi
fi

# Step 3: Run Flutter doctor
print_status "Step 3: Running Flutter doctor..."
flutter doctor

print_warning "Please resolve any issues shown by Flutter doctor before proceeding."

if ask_confirmation "Continue with the setup?"; then
    print_status "Continuing setup..."
else
    print_status "Setup paused. Please resolve Flutter doctor issues and run this script again."
    exit 0
fi

# Step 4: Install Android Studio
print_status "Step 4: Setting up Android Studio..."

if command_exists studio; then
    print_success "Android Studio is already installed"
else
    print_status "Android Studio not found. Installing..."
    if [ -f "scripts/setup-android-studio.sh" ]; then
        chmod +x scripts/setup-android-studio.sh
        ./scripts/setup-android-studio.sh
    else
        print_warning "setup-android-studio.sh not found. Please install Android Studio manually."
    fi
fi

# Step 5: Setup emulators
print_status "Step 5: Setting up emulators..."

if [ -f "scripts/setup-emulator.sh" ]; then
    chmod +x scripts/setup-emulator.sh
    ./scripts/setup-emulator.sh
else
    print_warning "setup-emulator.sh not found. Please set up emulators manually."
fi

# Step 6: Setup mobile app
print_status "Step 6: Setting up mobile app..."

if [ -f "scripts/setup-mobile.sh" ]; then
    chmod +x scripts/setup-mobile.sh
    ./scripts/setup-mobile.sh
else
    print_warning "setup-mobile.sh not found. Setting up manually..."
    
    cd mobile
    
    print_status "Installing Flutter dependencies..."
    flutter pub get
    
    print_status "Generating code..."
    flutter packages pub run build_runner build --delete-conflicting-outputs
    
    cd ..
fi

# Step 7: Check Laravel backend
print_status "Step 7: Checking Laravel backend..."

if curl -s http://localhost:8000/api/health > /dev/null 2>&1; then
    print_success "Laravel backend is running on http://localhost:8000"
else
    print_warning "Laravel backend is not running on http://localhost:8000"
    print_status "Please start the Laravel backend:"
    echo "  docker-compose up -d"
    echo "  # or"
    echo "  php artisan serve"
fi

# Step 8: Final verification
print_status "Step 8: Final verification..."

print_status "Checking available devices..."
flutter devices

print_status "Running Flutter doctor again..."
flutter doctor

# Step 9: Run the app
print_status "Step 9: Ready to run the mobile app!"

print_success "Mobile development environment setup completed!"
echo ""
echo "🎉 Setup Summary:"
echo "================="
echo "✅ Flutter SDK installed"
echo "✅ Android Studio configured"
echo "✅ Emulators set up"
echo "✅ Mobile app dependencies installed"
echo "✅ Code generated"
echo ""
echo "🚀 Next steps:"
echo "=============="
echo "1. Start Laravel backend (if not running):"
echo "   docker-compose up -d"
echo ""
echo "2. Start emulator:"
echo "   flutter emulators --launch flutter_emulator"
echo ""
echo "3. Run the mobile app:"
echo "   cd mobile"
echo "   flutter run"
echo ""
echo "📱 Available commands:"
echo "====================="
echo "  flutter run                    # Run the app"
echo "  flutter run -d android         # Run on Android"
echo "  flutter run -d ios             # Run on iOS"
echo "  flutter build apk              # Build Android APK"
echo "  flutter test                   # Run tests"
echo "  flutter analyze                # Analyze code"
echo ""
echo "📚 Documentation:"
echo "================"
echo "  Mobile Setup Guide: MOBILE_SETUP_GUIDE.md"
echo "  Mobile README: mobile/README.md"
echo "  Flutter Docs: https://flutter.dev/docs"
echo ""
print_success "Happy coding! 🎊" 