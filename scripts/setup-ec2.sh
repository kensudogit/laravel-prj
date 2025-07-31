#!/bin/bash

# Laravel Development Environment Setup Script for Amazon Linux 2023
# This script sets up PHP 8.2, Laravel 11, MySQL, and Apache on EC2

set -e

echo "Starting Laravel development environment setup..."

# Update system
echo "Updating system packages..."
sudo yum update -y

# Install EPEL repository
echo "Installing EPEL repository..."
sudo yum install -y epel-release

# Install PHP 8.2 and extensions
echo "Installing PHP 8.2 and extensions..."
sudo yum install -y \
    php82 \
    php82-cli \
    php82-common \
    php82-mysqlnd \
    php82-zip \
    php82-gd \
    php82-mbstring \
    php82-curl \
    php82-xml \
    php82-bcmath \
    php82-json \
    php82-opcache \
    php82-intl \
    php82-fpm

# Install Apache
echo "Installing Apache..."
sudo yum install -y httpd mod_ssl

# Install MySQL 8.0
echo "Installing MySQL 8.0..."
sudo yum install -y mysql mysql-server

# Install Composer
echo "Installing Composer..."
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer
sudo chmod +x /usr/local/bin/composer

# Start and enable services
echo "Starting and enabling services..."
sudo systemctl start httpd
sudo systemctl enable httpd
sudo systemctl start mysqld
sudo systemctl enable mysqld

# Configure MySQL
echo "Configuring MySQL..."
sudo mysql_secure_installation

# Create Laravel application directory
echo "Creating Laravel application directory..."
sudo mkdir -p /var/www/html
cd /var/www/html

# Create Laravel project
echo "Creating Laravel 11 project..."
composer create-project laravel/laravel laravel-app

# Set permissions
echo "Setting permissions..."
sudo chown -R apache:apache /var/www/html/laravel-app
sudo chmod -R 755 /var/www/html/laravel-app
sudo chmod -R 777 /var/www/html/laravel-app/storage
sudo chmod -R 777 /var/www/html/laravel-app/bootstrap/cache

# Copy Apache configuration
echo "Configuring Apache..."
sudo cp /var/www/html/laravel-app/apache/laravel.conf /etc/httpd/conf.d/
sudo systemctl restart httpd

# Configure firewall
echo "Configuring firewall..."
sudo yum install -y firewalld
sudo systemctl start firewalld
sudo systemctl enable firewalld
sudo firewall-cmd --permanent --add-service=http
sudo firewall-cmd --permanent --add-service=https
sudo firewall-cmd --permanent --add-service=ssh
sudo firewall-cmd --reload

# Create database and user
echo "Creating database and user..."
mysql -u root -p << EOF
CREATE DATABASE laravel_app CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'laravel_user'@'localhost' IDENTIFIED BY 'laravel_password';
GRANT ALL PRIVILEGES ON laravel_app.* TO 'laravel_user'@'localhost';
FLUSH PRIVILEGES;
EXIT;
EOF

# Configure Laravel environment
echo "Configuring Laravel environment..."
cd /var/www/html/laravel-app
cp .env.example .env
php artisan key:generate

# Update .env file with database configuration
sed -i 's/DB_HOST=127.0.0.1/DB_HOST=localhost/' .env
sed -i 's/DB_DATABASE=laravel/DB_DATABASE=laravel_app/' .env
sed -i 's/DB_USERNAME=root/DB_USERNAME=laravel_user/' .env
sed -i 's/DB_PASSWORD=/DB_PASSWORD=laravel_password/' .env

# Run migrations
echo "Running Laravel migrations..."
php artisan migrate

# Install Node.js and NPM (for frontend assets)
echo "Installing Node.js and NPM..."
curl -fsSL https://rpm.nodesource.com/setup_18.x | sudo bash -
sudo yum install -y nodejs

# Install Laravel Mix dependencies
echo "Installing frontend dependencies..."
npm install

# Build assets
echo "Building frontend assets..."
npm run build

echo "Setup completed successfully!"
echo "Your Laravel application is now available at: http://your-ec2-public-ip"
echo "MySQL is running on localhost:3306"
echo "Database: laravel_app"
echo "User: laravel_user"
echo "Password: laravel_password" 