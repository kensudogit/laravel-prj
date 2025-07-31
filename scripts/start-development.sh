#!/bin/bash

# Complete Development Environment Startup Script
# This script starts all components of the full-stack development environment

set -e

echo "🚀 Starting Complete Development Environment"
echo "============================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
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

print_step() {
    echo -e "${PURPLE}[STEP]${NC} $1"
}

print_component() {
    echo -e "${CYAN}[COMPONENT]${NC} $1"
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to check if port is in use
port_in_use() {
    lsof -i :$1 >/dev/null 2>&1
}

# Function to wait for service to be ready
wait_for_service() {
    local url=$1
    local service_name=$2
    local max_attempts=30
    local attempt=1
    
    print_status "Waiting for $service_name to be ready..."
    
    while [ $attempt -le $max_attempts ]; do
        if curl -s "$url" >/dev/null 2>&1; then
            print_success "$service_name is ready!"
            return 0
        fi
        
        echo -n "."
        sleep 2
        attempt=$((attempt + 1))
    done
    
    print_warning "$service_name might not be ready yet. Continuing..."
    return 1
}

# Function to start Laravel backend
start_laravel_backend() {
    print_component "Starting Laravel Backend"
    
    if command_exists docker && command_exists docker-compose; then
        if [ -f "docker-compose.yml" ]; then
            print_status "Starting Laravel backend with Docker..."
            docker-compose up -d app webserver db
            
            # Wait for Laravel to be ready
            wait_for_service "http://localhost:8000/api/health" "Laravel API"
            
            print_success "Laravel backend started on http://localhost:8000"
        else
            print_warning "docker-compose.yml not found. Starting Laravel manually..."
            start_laravel_manual
        fi
    else
        print_warning "Docker not available. Starting Laravel manually..."
        start_laravel_manual
    fi
}

# Function to start Laravel manually
start_laravel_manual() {
    if command_exists php && command_exists composer; then
        print_status "Starting Laravel with PHP artisan serve..."
        
        # Check if .env exists
        if [ ! -f ".env" ]; then
            print_status "Creating .env file..."
            cp .env.example .env
            php artisan key:generate
        fi
        
        # Start Laravel server in background
        php artisan serve --host=0.0.0.0 --port=8000 > laravel.log 2>&1 &
        LARAVEL_PID=$!
        echo $LARAVEL_PID > laravel.pid
        
        # Wait for Laravel to be ready
        wait_for_service "http://localhost:8000/api/health" "Laravel API"
        
        print_success "Laravel backend started on http://localhost:8000 (PID: $LARAVEL_PID)"
    else
        print_error "PHP or Composer not found. Please install them first."
        exit 1
    fi
}

# Function to start Next.js frontend
start_nextjs_frontend() {
    print_component "Starting Next.js Frontend"
    
    if [ -d "frontend" ]; then
        cd frontend
        
        # Check if node_modules exists
        if [ ! -d "node_modules" ]; then
            print_status "Installing Next.js dependencies..."
            npm install
        fi
        
        # Start Next.js in background
        print_status "Starting Next.js development server..."
        npm run dev > ../nextjs.log 2>&1 &
        NEXTJS_PID=$!
        echo $NEXTJS_PID > ../nextjs.pid
        
        cd ..
        
        # Wait for Next.js to be ready
        wait_for_service "http://localhost:3000" "Next.js Frontend"
        
        print_success "Next.js frontend started on http://localhost:3000 (PID: $NEXTJS_PID)"
    else
        print_warning "Frontend directory not found. Skipping Next.js startup."
    fi
}

# Function to start Flutter mobile
start_flutter_mobile() {
    print_component "Starting Flutter Mobile Development"
    
    if command_exists flutter; then
        if [ -d "mobile" ]; then
            cd mobile
            
            # Check if dependencies are installed
            if [ ! -d ".dart_tool" ]; then
                print_status "Installing Flutter dependencies..."
                flutter pub get
            fi
            
            # Generate code
            print_status "Generating Flutter code..."
            flutter packages pub run build_runner build --delete-conflicting-outputs
            
            # Check available devices
            print_status "Available devices:"
            flutter devices
            
            cd ..
            
            print_success "Flutter mobile environment is ready!"
            print_status "To run the mobile app:"
            echo "  cd mobile"
            echo "  flutter run"
        else
            print_warning "Mobile directory not found. Skipping Flutter startup."
        fi
    else
        print_warning "Flutter not found. Please install Flutter first."
        print_status "Run: ./scripts/install-flutter.sh"
    fi
}

# Function to start emulators
start_emulators() {
    print_component "Starting Emulators"
    
    if command_exists flutter; then
        # Check if Android emulator is available
        if command_exists emulator; then
            print_status "Starting Android emulator..."
            flutter emulators --launch flutter_emulator > emulator.log 2>&1 &
            EMULATOR_PID=$!
            echo $EMULATOR_PID > emulator.pid
            
            print_success "Android emulator starting (PID: $EMULATOR_PID)"
        else
            print_warning "Android emulator not found. Please set up Android Studio first."
        fi
        
        # Check if iOS simulator is available (macOS only)
        if [[ "$OSTYPE" == "darwin"* ]] && command_exists xcrun; then
            print_status "Starting iOS simulator..."
            open -a Simulator > ios_simulator.log 2>&1 &
            print_success "iOS simulator starting"
        fi
    else
        print_warning "Flutter not found. Skipping emulator startup."
    fi
}

# Function to show status
show_status() {
    echo ""
    print_step "Development Environment Status"
    echo "=================================="
    
    # Check Laravel
    if port_in_use 8000; then
        print_success "✅ Laravel Backend: http://localhost:8000"
    else
        print_error "❌ Laravel Backend: Not running"
    fi
    
    # Check Next.js
    if port_in_use 3000; then
        print_success "✅ Next.js Frontend: http://localhost:3000"
    else
        print_error "❌ Next.js Frontend: Not running"
    fi
    
    # Check phpMyAdmin
    if port_in_use 8080; then
        print_success "✅ phpMyAdmin: http://localhost:8080"
    else
        print_warning "⚠️  phpMyAdmin: Not running"
    fi
    
    # Check Flutter
    if command_exists flutter; then
        print_success "✅ Flutter: Available"
    else
        print_error "❌ Flutter: Not installed"
    fi
    
    echo ""
}

# Function to show useful commands
show_commands() {
    echo ""
    print_step "Useful Commands"
    echo "=================="
    echo ""
    echo "🌐 Web Development:"
    echo "  Laravel Backend:    http://localhost:8000"
    echo "  Next.js Frontend:   http://localhost:3000"
    echo "  phpMyAdmin:         http://localhost:8080"
    echo ""
    echo "📱 Mobile Development:"
    echo "  cd mobile"
    echo "  flutter run                    # Run on connected device"
    echo "  flutter run -d android         # Run on Android emulator"
    echo "  flutter run -d ios             # Run on iOS simulator"
    echo ""
    echo "🔧 Development Tools:"
    echo "  ./scripts/stop-development.sh  # Stop all services"
    echo "  ./scripts/restart-backend.sh   # Restart Laravel backend"
    echo "  ./scripts/restart-frontend.sh  # Restart Next.js frontend"
    echo ""
}

# Main execution
main() {
    print_step "Starting Complete Development Environment"
    
    # Step 1: Start Laravel Backend
    start_laravel_backend
    
    # Step 2: Start Next.js Frontend
    start_nextjs_frontend
    
    # Step 3: Start Emulators
    start_emulators
    
    # Step 4: Setup Flutter Mobile
    start_flutter_mobile
    
    # Step 5: Show status
    show_status
    
    # Step 6: Show useful commands
    show_commands
    
    print_success "🎉 Development environment started successfully!"
    echo ""
    echo "📋 Next Steps:"
    echo "=============="
    echo "1. Open your browser and visit:"
    echo "   - Laravel API: http://localhost:8000/api/health"
    echo "   - Next.js App: http://localhost:3000"
    echo ""
    echo "2. For mobile development:"
    echo "   cd mobile"
    echo "   flutter run"
    echo ""
    echo "3. To stop all services:"
    echo "   ./scripts/stop-development.sh"
    echo ""
    print_success "Happy coding! 🚀"
}

# Run main function
main 