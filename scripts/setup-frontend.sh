#!/bin/bash

# Next.js Frontend Setup Script
# This script sets up the Next.js frontend for local development

set -e

echo "Starting Next.js frontend setup..."

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo "Node.js is not installed. Please install Node.js 18+ first."
    exit 1
fi

# Check Node.js version
NODE_VERSION=$(node -v | cut -d'v' -f2 | cut -d'.' -f1)
if [ "$NODE_VERSION" -lt 18 ]; then
    echo "Node.js version 18+ is required. Current version: $(node -v)"
    exit 1
fi

# Navigate to frontend directory
cd frontend

# Install dependencies
echo "Installing dependencies..."
npm install

# Copy environment file
if [ ! -f .env.local ]; then
    echo "Creating environment file..."
    cp env.local.example .env.local
fi

# Build the application
echo "Building the application..."
npm run build

echo "Next.js frontend setup completed successfully!"
echo "Your Next.js application is now available at: http://localhost:3000"
echo ""
echo "Useful commands:"
echo "  npm run dev          # Start development server"
echo "  npm run build        # Build for production"
echo "  npm run start        # Start production server"
echo "  npm run lint         # Run ESLint"
echo "  npm run type-check   # Run TypeScript type checking" 