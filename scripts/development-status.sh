#!/bin/bash

# Development Environment Status Script
# This script checks the status of all development environment components

set -e

echo "📊 Development Environment Status"
echo "================================="
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

print_header() {
    echo -e "${PURPLE}[HEADER]${NC} $1"
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

# Function to get process info
get_process_info() {
    local port=$1
    if port_in_use $port; then
        local pid=$(lsof -ti:$port | head -1)
        local cmd=$(ps -p $pid -o comm= 2>/dev/null || echo "Unknown")
        echo "$pid ($cmd)"
    else
        echo "Not running"
    fi
}

# Function to check Laravel backend
check_laravel_backend() {
    print_component "Laravel Backend"
    echo "-------------------"
    
    # Check if port 8000 is in use
    if port_in_use 8000; then
        local process_info=$(get_process_info 8000)
        print_success "✅ Running on http://localhost:8000"
        print_status "Process: $process_info"
        
        # Test API endpoint
        if curl -s http://localhost:8000/api/health >/dev/null 2>&1; then
            print_success "✅ API Health Check: OK"
        else
            print_warning "⚠️  API Health Check: Failed"
        fi
    else
        print_error "❌ Not running"
    fi
    
    # Check Docker containers
    if command_exists docker && command_exists docker-compose; then
        if [ -f "docker-compose.yml" ]; then
            echo ""
            print_status "Docker Containers:"
            docker-compose ps --format "table {{.Name}}\t{{.Status}}\t{{.Ports}}"
        fi
    fi
    
    echo ""
}

# Function to check Next.js frontend
check_nextjs_frontend() {
    print_component "Next.js Frontend"
    echo "-------------------"
    
    # Check if port 3000 is in use
    if port_in_use 3000; then
        local process_info=$(get_process_info 3000)
        print_success "✅ Running on http://localhost:3000"
        print_status "Process: $process_info"
        
        # Test frontend endpoint
        if curl -s http://localhost:3000 >/dev/null 2>&1; then
            print_success "✅ Frontend Health Check: OK"
        else
            print_warning "⚠️  Frontend Health Check: Failed"
        fi
    else
        print_error "❌ Not running"
    fi
    
    echo ""
}

# Function to check phpMyAdmin
check_phpmyadmin() {
    print_component "phpMyAdmin"
    echo "------------"
    
    # Check if port 8080 is in use
    if port_in_use 8080; then
        local process_info=$(get_process_info 8080)
        print_success "✅ Running on http://localhost:8080"
        print_status "Process: $process_info"
    else
        print_warning "⚠️  Not running"
    fi
    
    echo ""
}

# Function to check Flutter
check_flutter() {
    print_component "Flutter Development"
    echo "----------------------"
    
    if command_exists flutter; then
        print_success "✅ Flutter SDK: Installed"
        print_status "Version: $(flutter --version | head -1)"
        
        # Check Flutter doctor
        echo ""
        print_status "Flutter Doctor Status:"
        flutter doctor --android-licenses 2>/dev/null | head -5 || true
        
        # Check available devices
        echo ""
        print_status "Available Devices:"
        flutter devices 2>/dev/null || print_warning "No devices found"
        
    else
        print_error "❌ Flutter SDK: Not installed"
    fi
    
    echo ""
}

# Function to check emulators
check_emulators() {
    print_component "Emulators"
    echo "----------"
    
    # Check Android emulator
    if command_exists emulator; then
        local avds=$(emulator -list-avds 2>/dev/null || echo "")
        if [ -n "$avds" ]; then
            print_success "✅ Android Emulator: Available"
            print_status "AVDs: $avds"
        else
            print_warning "⚠️  Android Emulator: No AVDs found"
        fi
    else
        print_warning "⚠️  Android Emulator: Not available"
    fi
    
    # Check iOS simulator (macOS only)
    if [[ "$OSTYPE" == "darwin"* ]]; then
        if command_exists xcrun; then
            local simulators=$(xcrun simctl list devices available 2>/dev/null | grep "iPhone" | head -3 || echo "")
            if [ -n "$simulators" ]; then
                print_success "✅ iOS Simulator: Available"
                print_status "Devices: $(echo "$simulators" | wc -l) iPhone simulators"
            else
                print_warning "⚠️  iOS Simulator: No devices found"
            fi
        else
            print_warning "⚠️  iOS Simulator: Not available"
        fi
    fi
    
    echo ""
}

# Function to check mobile app
check_mobile_app() {
    print_component "Mobile App"
    echo "-----------"
    
    if [ -d "mobile" ]; then
        print_success "✅ Mobile app directory: Found"
        
        # Check pubspec.yaml
        if [ -f "mobile/pubspec.yaml" ]; then
            print_success "✅ pubspec.yaml: Found"
            
            # Check dependencies
            if [ -d "mobile/.dart_tool" ]; then
                print_success "✅ Dependencies: Installed"
            else
                print_warning "⚠️  Dependencies: Not installed"
            fi
        else
            print_error "❌ pubspec.yaml: Not found"
        fi
    else
        print_error "❌ Mobile app directory: Not found"
    fi
    
    echo ""
}

# Function to check system resources
check_system_resources() {
    print_component "System Resources"
    echo "-------------------"
    
    # Check disk space
    local disk_usage=$(df -h . | tail -1 | awk '{print $5}')
    print_status "Disk Usage: $disk_usage"
    
    # Check memory
    if command_exists free; then
        local memory_usage=$(free -h | grep Mem | awk '{print $3"/"$2}')
        print_status "Memory Usage: $memory_usage"
    fi
    
    # Check CPU
    if command_exists top; then
        local cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1)
        print_status "CPU Usage: ${cpu_usage}%"
    fi
    
    echo ""
}

# Function to show summary
show_summary() {
    print_header "Summary"
    echo "========"
    
    local total_services=5
    local running_services=0
    
    # Count running services
    if port_in_use 8000; then ((running_services++)); fi
    if port_in_use 3000; then ((running_services++)); fi
    if port_in_use 8080; then ((running_services++)); fi
    if command_exists flutter; then ((running_services++)); fi
    if [ -d "mobile" ]; then ((running_services++)); fi
    
    print_status "Services Running: $running_services/$total_services"
    
    if [ $running_services -eq $total_services ]; then
        print_success "🎉 All services are running!"
    elif [ $running_services -gt 0 ]; then
        print_warning "⚠️  Some services are running"
    else
        print_error "❌ No services are running"
    fi
    
    echo ""
}

# Function to show quick actions
show_quick_actions() {
    print_header "Quick Actions"
    echo "=============="
    echo ""
    echo "🚀 Start all services:"
    echo "   ./scripts/start-development.sh"
    echo ""
    echo "🛑 Stop all services:"
    echo "   ./scripts/stop-development.sh"
    echo ""
    echo "📱 Run mobile app:"
    echo "   cd mobile && flutter run"
    echo ""
    echo "🔧 Restart specific service:"
    echo "   ./scripts/restart-backend.sh"
    echo "   ./scripts/restart-frontend.sh"
    echo ""
}

# Main execution
main() {
    # Check Laravel backend
    check_laravel_backend
    
    # Check Next.js frontend
    check_nextjs_frontend
    
    # Check phpMyAdmin
    check_phpmyadmin
    
    # Check Flutter
    check_flutter
    
    # Check emulators
    check_emulators
    
    # Check mobile app
    check_mobile_app
    
    # Check system resources
    check_system_resources
    
    # Show summary
    show_summary
    
    # Show quick actions
    show_quick_actions
    
    print_success "Status check completed! 📊"
}

# Run main function
main 