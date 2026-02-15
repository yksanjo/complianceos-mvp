#!/bin/bash

# Test Agent Browser Commands
# This script shows real command examples

echo "========================================="
echo "🧪 TESTING AGENT BROWSER COMMANDS"
echo "========================================="
echo ""

# Function to run command and show output
run_command() {
    echo "💻 Command: $1"
    echo "📝 Output:"
    eval "$1"
    echo ""
    echo "---"
    echo ""
}

# Check installation
echo "1. Checking installation..."
if command -v agent-browser &> /dev/null; then
    echo "✅ Agent Browser found"
    run_command "agent-browser --version"
else
    echo "❌ Agent Browser not found"
    echo "Install with: npm install -g agent-browser"
    echo "Then run: agent-browser install"
    exit 1
fi

# Show help
echo "2. Showing help..."
run_command "agent-browser --help | head -20"

# List of commands to demonstrate
echo "3. Available command categories:"
echo "   • Navigation: open, goto, navigate, close"
echo "   • Interaction: click, fill, type, press, hover"
echo "   • Information: get text, get title, get url, snapshot"
echo "   • Screenshots: screenshot, pdf"
echo "   • Forms: select, check, uncheck, upload"
echo "   • Scrolling: scroll, scrollintoview"
echo ""

# Example command sequences
echo "4. Example command sequences:"
echo ""
echo "   A. Basic navigation and screenshot:"
echo "      agent-browser --headless open https://httpbin.org/html"
echo "      agent-browser get title"
echo "      agent-browser screenshot test_page.png"
echo "      agent-browser close"
echo ""
echo "   B. Form interaction:"
echo "      agent-browser --headless open https://httpbin.org/forms/post"
echo "      agent-browser fill \"input[name='custname']\" \"Test User\""
echo "      agent-browser select \"select[name='custsize']\" \"large\""
echo "      agent-browser check \"input[value='cheese']\""
echo "      agent-browser screenshot form.png"
echo "      agent-browser close"
echo ""
echo "   C. Element inspection:"
echo "      agent-browser --headless open https://example.com"
echo "      agent-browser get title"
echo "      agent-browser get text \"h1\""
echo "      agent-browser get count \"p\""
echo "      agent-browser get count \"a\""
echo "      agent-browser close"
echo ""

# Quick test
echo "5. Quick test (run in headless mode):"
echo ""
read -p "Run quick test? (y/n): " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Running test..."
    echo ""
    
    # Test 1: Basic page
    echo "Test 1: Basic page load"
    agent-browser --headless open https://httpbin.org/html
    agent-browser get title
    agent-browser get url
    agent-browser close
    echo ""
    
    # Test 2: Take screenshot
    echo "Test 2: Taking screenshot"
    agent-browser --headless open https://httpbin.org/html
    agent-browser screenshot test_screenshot.png
    echo "Screenshot saved: test_screenshot.png"
    agent-browser close
    echo ""
    
    echo "✅ Tests completed!"
else
    echo "Skipping tests."
fi

echo ""
echo "========================================="
echo "🎯 NEXT STEPS"
echo "========================================="
echo ""
echo "1. Try these commands:"
echo "   agent-browser --headless open https://google.com"
echo "   agent-browser get title"
echo "   agent-browser close"
echo ""
echo "2. Explore more commands:"
echo "   agent-browser open --help"
echo "   agent-browser click --help"
echo "   agent-browser get --help"
echo ""
echo "3. Check the full guide:"
echo "   cat AGENT_BROWSER_USAGE_GUIDE.md | head -50"
echo ""
echo "4. Visit GitHub for examples:"
echo "   https://github.com/vercel-labs/agent-browser"
echo ""

echo "========================================="
echo "💡 REMEMBER"
echo "========================================="
echo ""
echo "• Use 'snapshot' to get element references (@e1, @e2, etc.)"
echo "• Chain commands with && for simple scripts"
echo "• Use --headless for automation/CI"
echo "• Check agent-browser <command> --help for options"
echo ""

echo "Happy browsing automation! 🤖"