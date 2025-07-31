#!/bin/bash

# Stop Development Environment Script
# This script stops all components of the development environment

set -e

echo "🛑 Stopping Development Environment"
echo "==================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
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

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to check if process is running
process_running() {
    ps -p $1 >/dev/null 2>&1
}

# Function to stop Laravel backend
stop_laravel_backend() {
    print_step "Stopping Laravel Backend"
    
    # Try to stop Docker containers first
    if command_exists docker && command_exists docker-compose; then
        if [ -f "docker-compose.yml" ]; then
            print_status "Stopping Docker containers..."
            docker-compose down
            print_success "Docker containers stopped"
            return
        fi
    fi
    
    # Stop Laravel process if PID file exists
    if [ -f "laravel.pid" ]; then
        LARAVEL_PID=$(cat laravel.pid)
        if process_running $LARAVEL_PID; then
            print_status "Stopping Laravel process (PID: $LARAVEL_PID)..."
            kill $LARAVEL_PID
            rm laravel.pid
            print_success "Laravel backend stopped"
        else
            print_warning "Laravel process not running"
            rm laravel.pid
        fi
    else
        print_warning "Laravel PID file not found"
    fi
    
    # Kill any remaining PHP processes on port 8000
    if lsof -ti:8000 >/dev/null 2>&1; then
        print_status "Killing processes on port 8000..."
        lsof -ti:8000 | xargs kill -9
        print_success "Processes on port 8000 stopped"
    fi
}

# Function to stop Next.js frontend
stop_nextjs_frontend() {
    print_step "Stopping Next.js Frontend"
    
    # Stop Next.js process if PID file exists
    if [ -f "nextjs.pid" ]; then
        NEXTJS_PID=$(cat nextjs.pid)
        if process_running $NEXTJS_PID; then
            print_status "Stopping Next.js process (PID: $NEXTJS_PID)..."
            kill $NEXTJS_PID
            rm nextjs.pid
            print_success "Next.js frontend stopped"
        else
            print_warning "Next.js process not running"
            rm nextjs.pid
        fi
    else
        print_warning "Next.js PID file not found"
    fi
    
    # Kill any remaining Node.js processes on port 3000
    if lsof -ti:3000 >/dev/null 2>&1; then
        print_status "Killing processes on port 3000..."
        lsof -ti:3000 | xargs kill -9
        print_success "Processes on port 3000 stopped"
    fi
}

# Function to stop emulators
stop_emulators() {
    print_step "Stopping Emulators"
    
    # Stop Android emulator if PID file exists
    if [ -f "emulator.pid" ]; then
        EMULATOR_PID=$(cat emulator.pid)
        if process_running $EMULATOR_PID; then
            print_status "Stopping Android emulator (PID: $EMULATOR_PID)..."
            kill $EMULATOR_PID
            rm emulator.pid
            print_success "Android emulator stopped"
        else
            print_warning "Android emulator process not running"
            rm emulator.pid
        fi
    else
        print_warning "Emulator PID file not found"
    fi
    
    # Stop iOS simulator (macOS only)
    if [[ "$OSTYPE" == "darwin"* ]]; then
        print_status "Stopping iOS simulator..."
        pkill -f "Simulator" || true
        print_success "iOS simulator stopped"
    fi
    
    # Kill any remaining emulator processes
    if command_exists adb; then
        print_status "Stopping ADB server..."
        adb kill-server
        print_success "ADB server stopped"
    fi
}

# Function to stop Flutter processes
stop_flutter_processes() {
    print_step "Stopping Flutter Processes"
    
    # Kill any Flutter processes
    if pgrep -f "flutter" >/dev/null; then
        print_status "Stopping Flutter processes..."
        pkill -f "flutter" || true
        print_success "Flutter processes stopped"
    else
        print_warning "No Flutter processes found"
    fi
}

# Function to clean up temporary files
cleanup_temp_files() {
    print_step "Cleaning Up Temporary Files"
    
    # Remove log files
    if [ -f "laravel.log" ]; then
        rm laravel.log
        print_status "Removed laravel.log"
    fi
    
    if [ -f "nextjs.log" ]; then
        rm nextjs.log
        print_status "Removed nextjs.log"
    fi
    
    if [ -f "emulator.log" ]; then
        rm emulator.log
        print_status "Removed emulator.log"
    fi
    
    if [ -f "ios_simulator.log" ]; then
        rm ios_simulator.log
        print_status "Removed ios_simulator.log"
    fi
    
    print_success "Temporary files cleaned up"
}

# Function to show final status
show_final_status() {
    echo ""
    print_step "Final Status Check"
    echo "===================="
    
    # Check if ports are still in use
    if lsof -i:8000 >/dev/null 2>&1; then
        print_error "❌ Port 8000 still in use"
    else
        print_success "✅ Port 8000 (Laravel) - Free"
    fi
    
    if lsof -i:3000 >/dev/null 2>&1; then
        print_error "❌ Port 3000 still in use"
    else
        print_success "✅ Port 3000 (Next.js) - Free"
    fi
    
    if lsof -i:8080 >/dev/null 2>&1; then
        print_warning "⚠️  Port 8080 (phpMyAdmin) still in use"
    else
        print_success "✅ Port 8080 (phpMyAdmin) - Free"
    fi
    
    echo ""
}

# Main execution
main() {
    print_step "Stopping Complete Development Environment"
    
    # Step 1: Stop Laravel Backend
    stop_laravel_backend
    
    # Step 2: Stop Next.js Frontend
    stop_nextjs_frontend
    
    # Step 3: Stop Emulators
    stop_emulators
    
    # Step 4: Stop Flutter Processes
    stop_flutter_processes
    
    # Step 5: Clean up temporary files
    cleanup_temp_files
    
    # Step 6: Show final status
    show_final_status
    
    print_success "🎉 Development environment stopped successfully!"
    echo ""
    echo "📋 Summary:"
    echo "==========="
    echo "✅ Laravel backend stopped"
    echo "✅ Next.js frontend stopped"
    echo "✅ Emulators stopped"
    echo "✅ Flutter processes stopped"
    echo "✅ Temporary files cleaned up"
    echo ""
    echo "🚀 To restart the development environment:"
    echo "   ./scripts/start-development.sh"
    echo ""
    print_success "Goodbye! 👋"
}

# Run main function
main 