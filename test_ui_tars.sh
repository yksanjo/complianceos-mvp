#!/bin/bash
# Quick test for UI-TARS

echo "🧪 Testing UI-TARS..."
echo ""

# Check if agent-tars is installed
if ! command -v agent-tars &> /dev/null; then
    echo "❌ agent-tars not found. Installing..."
    npm install -g @agent-tars/cli@latest
fi

# Check for config file
if [ -f ~/agent.config.json ]; then
    echo "✅ Config file found"
    echo ""
    echo "📝 Current config:"
    cat ~/agent.config.json
    echo ""
    echo "🚀 To test, run:"
    echo "   cd ~ && agent-tars --headless --input 'Hello'"
else
    echo "❌ Config file not found. Creating template..."
    cat > ~/agent.config.json << 'CONFIG'
{
  "model": {
    "provider": "volcengine",
    "id": "doubao-1-5-thinking-vision-pro-250428",
    "apiKey": "YOUR_API_KEY_HERE"
  }
}
CONFIG
    echo "✅ Created ~/agent.config.json"
    echo ""
    echo "🔑 Edit the file and add your API key:"
    echo "   nano ~/agent.config.json"
fi
