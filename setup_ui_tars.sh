#!/bin/bash
# Setup UI-TARS 7B on M1 Mac using Ollama

set -e

echo "🚀 Setting up UI-TARS 7B on your M1 Mac..."

# Step 1: Start Ollama
echo "📦 Starting Ollama..."
open -a Ollama &
sleep 3

# Step 2: Check if UI-TARS GGUF exists, if not download it
MODEL_DIR="$HOME/.ollama/models/ui-tars-7b"
mkdir -p "$MODEL_DIR"

if [ ! -f "$MODEL_DIR/ui-tars-7b-q4_k_m.gguf" ]; then
    echo "⬇️ Downloading UI-TARS-7B GGUF model..."
    echo "This may take 10-20 minutes (~4GB download)..."
    
    # Using huggingface-cli or curl to download
    if command -v huggingface-cli &> /dev/null; then
        huggingface-cli download TheBloke/UI-TARS-7B-GGUF ui-tars-7b.Q4_K_M.gguf --local-dir "$MODEL_DIR"
    else
        echo "Installing huggingface-hub..."
        pip install huggingface-hub
        huggingface-cli download TheBloke/UI-TARS-7B-GGUF ui-tars-7b.Q4_K_M.gguf --local-dir "$MODEL_DIR"
    fi
fi

# Step 3: Create Modelfile
echo "📝 Creating Ollama Modelfile..."
cat > "$MODEL_DIR/Modelfile" << 'EOF'
FROM ./ui-tars-7b.Q4_K_M.gguf

PARAMETER temperature 0.7
PARAMETER num_ctx 4096

SYSTEM You are UI-TARS, a multimodal AI agent capable of controlling computers through visual understanding. You can see the screen and perform actions like clicking, typing, and navigating.
EOF

# Step 4: Create the model in Ollama
echo "🔨 Building Ollama model..."
cd "$MODEL_DIR"
ollama create ui-tars-7b -f Modelfile

echo "✅ UI-TARS-7B is ready!"
echo ""
echo "Test it with:"
echo "  ollama run ui-tars-7b"
echo ""
echo "Or use with Agent TARS CLI:"
echo "  agent-tars --provider ollama --baseURL http://localhost:11434 --model ui-tars-7b --input 'Your task'"
