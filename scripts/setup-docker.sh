#!/bin/bash

# Laravel Docker Development Environment Setup Script
# This script sets up Laravel with Docker for local development

set -e

echo "Starting Laravel Docker development environment setup..."

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "Docker is not installed. Please install Docker first."
    exit 1
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null; then
    echo "Docker Compose is not installed. Please install Docker Compose first."
    exit 1
fi

# Create src directory if it doesn't exist
if [ ! -d "src" ]; then
    echo "Creating src directory..."
    mkdir -p src
fi

# Start Docker containers
echo "Starting Docker containers..."
docker-compose up -d

# Wait for containers to be ready
echo "Waiting for containers to be ready..."
sleep 30

# Create Laravel project in the app container
echo "Creating Laravel 11 project..."
docker-compose exec app composer create-project laravel/laravel .

# Set proper permissions
echo "Setting permissions..."
docker-compose exec app chown -R www-data:www-data /var/www
docker-compose exec app chmod -R 755 /var/www
docker-compose exec app chmod -R 777 /var/www/storage
docker-compose exec app chmod -R 777 /var/www/bootstrap/cache

# Copy environment file
echo "Configuring Laravel environment..."
docker-compose exec app cp .env.example .env

# Generate application key
docker-compose exec app php artisan key:generate

# Update .env file with Docker database configuration
echo "Updating database configuration..."
docker-compose exec app sed -i 's/DB_HOST=127.0.0.1/DB_HOST=db/' .env
docker-compose exec app sed -i 's/DB_DATABASE=laravel/DB_DATABASE=laravel_app/' .env
docker-compose exec app sed -i 's/DB_USERNAME=root/DB_USERNAME=laravel_user/' .env
docker-compose exec app sed -i 's/DB_PASSWORD=/DB_PASSWORD=laravel_password/' .env

# Wait for database to be ready
echo "Waiting for database to be ready..."
sleep 10

# Run migrations
echo "Running Laravel migrations..."
docker-compose exec app php artisan migrate

# Install Node.js dependencies (if needed)
echo "Installing frontend dependencies..."
docker-compose exec app npm install

# Build assets
echo "Building frontend assets..."
docker-compose exec app npm run build

echo "Docker setup completed successfully!"
echo "Your Laravel application is now available at: http://localhost:8000"
echo "Your Next.js frontend is now available at: http://localhost:3000"
echo "phpMyAdmin is available at: http://localhost:8080"
echo "MySQL is running on localhost:3306"
echo "Database: laravel_app"
echo "User: laravel_user"
echo "Password: laravel_password"
echo ""
echo "Useful commands:"
echo "  docker-compose up -d          # Start containers"
echo "  docker-compose down           # Stop containers"
echo "  docker-compose logs -f        # View logs"
echo "  docker-compose exec app bash  # Access Laravel container"
echo "  docker-compose exec frontend sh  # Access Next.js container" 