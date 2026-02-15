#!/bin/bash

# Vercel Labs Agent Browser Installation Script
# This script installs the Agent Browser CLI tool

set -e  # Exit on error

echo "========================================="
echo "Vercel Labs Agent Browser Installer"
echo "========================================="
echo ""

# Check prerequisites
echo "Checking prerequisites..."
echo ""

# Check Node.js
if ! command -v node &> /dev/null; then
    echo "❌ Node.js is not installed!"
    echo "Please install Node.js v14 or higher from: https://nodejs.org/"
    exit 1
else
    NODE_VERSION=$(node --version | cut -d'v' -f2)
    echo "✓ Node.js $NODE_VERSION is installed"
fi

# Check npm
if ! command -v npm &> /dev/null; then
    echo "❌ npm is not installed!"
    exit 1
else
    NPM_VERSION=$(npm --version)
    echo "✓ npm $NPM_VERSION is installed"
fi

echo ""
echo "========================================="
echo "Installation Options"
echo "========================================="
echo ""
echo "1. Install globally (recommended for CLI use)"
echo "2. Install locally in current directory"
echo "3. Clone from GitHub and build from source"
echo "4. Exit"
echo ""
read -p "Choose an option (1-4): " choice

case $choice in
    1)
        echo ""
        echo "Installing globally..."
        echo ""
        npm install -g @vercel-labs/agent-browser
        echo ""
        echo "✅ Agent Browser installed globally!"
        echo ""
        echo "Usage:"
        echo "  agent-browser --help"
        echo "  agent-browser navigate --url https://google.com"
        ;;
    2)
        echo ""
        echo "Installing locally..."
        echo ""
        # Initialize package.json if it doesn't exist
        if [ ! -f "package.json" ]; then
            echo "Initializing package.json..."
            npm init -y
        fi
        
        npm install @vercel-labs/agent-browser
        echo ""
        echo "✅ Agent Browser installed locally!"
        echo ""
        echo "Usage:"
        echo "  npx agent-browser --help"
        echo "  npx agent-browser navigate --url https://google.com"
        ;;
    3)
        echo ""
        echo "Cloning from GitHub..."
        echo ""
        
        # Check if git is installed
        if ! command -v git &> /dev/null; then
            echo "❌ git is not installed!"
            exit 1
        fi
        
        # Clone repository
        git clone https://github.com/vercel-labs/agent-browser.git
        cd agent-browser
        
        echo "Installing dependencies..."
        npm install
        
        echo "Building from source..."
        npm run build
        
        echo ""
        echo "✅ Agent Browser built from source!"
        echo ""
        echo "To use locally:"
        echo "  node bin/agent-browser.js --help"
        echo ""
        echo "To install globally from source:"
        echo "  npm link"
        echo "  agent-browser --help"
        ;;
    4)
        echo "Exiting..."
        exit 0
        ;;
    *)
        echo "Invalid option. Exiting..."
        exit 1
        ;;
esac

echo ""
echo "========================================="
echo "Quick Test"
echo "========================================="
echo ""
echo "To test your installation, try:"
echo ""
echo "1. Check version:"
echo "   agent-browser --version"
echo ""
echo "2. Get help:"
echo "   agent-browser --help"
echo ""
echo "3. Try a simple command:"
echo "   agent-browser navigate --url https://google.com --headless"
echo ""
echo "========================================="
echo "Next Steps"
echo "========================================="
echo ""
echo "1. Read the documentation:"
echo "   https://github.com/vercel-labs/agent-browser#readme"
echo ""
echo "2. Check out examples:"
echo "   https://github.com/vercel-labs/agent-browser/tree/main/examples"
echo ""
echo "3. Create your first automation script!"
echo ""
echo "Installation complete! 🎉"