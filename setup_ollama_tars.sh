#!/bin/bash
# Setup Ollama + Agent TARS (100% FREE, local)

set -e

echo "🚀 Setting up Ollama + Agent TARS (Free Local Setup)"
echo "===================================================="
echo ""

# Step 1: Check/Start Ollama
echo "📦 Checking Ollama..."
if ! pgrep -x "ollama" > /dev/null; then
    echo "   Starting Ollama..."
    open -a Ollama
    sleep 5
else
    echo "   ✅ Ollama already running"
fi

# Step 2: Check if llava model exists
echo ""
echo "🤖 Checking vision models..."
MODELS=$(ollama list 2>/dev/null | grep -E "llava|bakllava" || echo "")

if [ -z "$MODELS" ]; then
    echo "   ⬇️ Downloading llava (vision model)..."
    echo "   This is ~4.5GB and may take 10-20 minutes..."
    ollama pull llava
else
    echo "   ✅ Vision model already downloaded"
    echo "$MODELS"
fi

# Step 3: Create Agent TARS config for Ollama
echo ""
echo "📝 Creating Agent TARS config for Ollama..."
cat > ~/agent.config.json << 'EOF'
{
  "model": {
    "provider": "ollama",
    "id": "llava",
    "baseURL": "http://localhost:11434"
  },
  "maxIterations": 50,
  "logLevel": "info",
  "workspace": "/Users/yoshikondo"
}
EOF

echo "   ✅ Config created at ~/agent.config.json"

# Step 4: Show usage
echo ""
echo "🎉 Setup Complete!"
echo ""
echo "📋 Quick Commands:"
echo ""
echo "1️⃣  Start interactive mode:"
echo "   cd ~ && agent-tars"
echo ""
echo "2️⃣  Run headless (YOLO mode):"
echo "   cd ~ && agent-tars --headless --input 'List files in current directory'"
echo ""
echo "3️⃣  Run with different models:"
echo "   # Use llava (vision - can see screenshots)"
echo "   agent-tars --model llava --input 'Take a screenshot and describe it'"
echo ""
echo "   # Use llama3.2 (faster, text-only)"
echo "   ollama pull llama3.2"
echo "   agent-tars --model llama3.2 --input 'Write a Python script'"
echo ""
echo "4️⃣  List available models:"
echo "   ollama list"
echo ""
echo "🔧 Manage Ollama:"
echo "   ollama serve     # Start server"
echo "   ollama stop      # Stop server"
echo "   ollama ps        # List running models"
echo ""
