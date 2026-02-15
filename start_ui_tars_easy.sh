#!/bin/bash

echo "================================================"
echo "🚀 STARTING UI-TARS - EASY METHOD"
echo "================================================"

# Step 1: Check if Ollama is running
echo "1. Checking Ollama..."
if ! ollama list &> /dev/null; then
    echo "   Starting Ollama..."
    brew services start ollama 2>&1 || echo "Service start failed, trying direct..."
    sleep 3
fi

# Step 2: Pull the UI-TARS model
echo "2. Downloading UI-TARS model (this may take 10-20 minutes)..."
echo "   Model size: ~4GB"
ollama pull ui-tars-7b 2>&1 | grep -v "pulling" || {
    echo "   Model not found in Ollama library, trying alternative..."
    echo "   You may need to build it manually from GGUF"
}

# Step 3: Create a simple test
echo "3. Creating test script..."
cat > test_ui_tars_simple.py << 'EOF'
#!/usr/bin/env python3
"""
Simple UI-TARS test using Ollama
"""

import requests
import json
import time

def test_ui_tars_ollama():
    """Test UI-TARS through Ollama API"""
    
    print("Testing UI-TARS via Ollama...")
    
    # Ollama API endpoint
    url = "http://localhost:11434/api/generate"
    
    # Test prompt
    payload = {
        "model": "ui-tars-7b",
        "prompt": "Hello! I'm testing UI-TARS. Can you introduce yourself?",
        "stream": False,
        "options": {
            "temperature": 0.7,
            "num_predict": 100
        }
    }
    
    try:
        print("Sending request to Ollama...")
        response = requests.post(url, json=payload, timeout=30)
        
        if response.status_code == 200:
            result = response.json()
            print("\n✅ UI-TARS Response:")
            print("=" * 50)
            print(result.get("response", "No response"))
            print("=" * 50)
            return True
        else:
            print(f"❌ Error: HTTP {response.status_code}")
            print(f"Response: {response.text}")
            return False
            
    except Exception as e:
        print(f"❌ Error: {e}")
        print("\nTroubleshooting tips:")
        print("1. Make sure Ollama is running: ollama serve")
        print("2. Check if model exists: ollama list")
        print("3. If model doesn't exist, you may need to build it")
        return False

if __name__ == "__main__":
    print("=" * 60)
    print("UI-TARS Quick Test")
    print("=" * 60)
    
    success = test_ui_tars_ollama()
    
    if success:
        print("\n🎉 SUCCESS! UI-TARS is working!")
        print("\nNext steps:")
        print("1. Try interactive mode: ollama run ui-tars-7b")
        print("2. For GUI automation, check the desktop app:")
        print("   https://github.com/bytedance/UI-TARS-desktop")
    else:
        print("\n⚠️  Test failed. Let's try Method 2...")
        print("\nRunning Python transformers test instead...")
        import subprocess
        subprocess.run(["python3", "minimal_ui_tars_test.py"])
EOF

chmod +x test_ui_tars_simple.py

# Step 4: Run the test
echo "4. Running test..."
python3 test_ui_tars_simple.py

echo ""
echo "================================================"
echo "📚 QUICK COMMANDS TO USE UI-TARS:"
echo "================================================"
echo ""
echo "1. Chat with UI-TARS:"
echo "   ollama run ui-tars-7b"
echo ""
echo "2. Use with Python:"
echo "   python minimal_ui_tars_test.py"
echo ""
echo "3. Try GUI automation (if installed):"
echo "   python ui_tars_example.py"
echo ""
echo "4. Check available models:"
echo "   ollama list"
echo ""
echo "================================================"
echo "🔧 If Ollama method doesn't work, try:"
echo "================================================"
echo "1. Install Python version:"
echo "   pip install transformers torch"
echo "   python minimal_ui_tars_test.py"
echo ""
echo "2. Or use the desktop app:"
echo "   https://github.com/bytedance/UI-TARS-desktop"
echo "================================================"