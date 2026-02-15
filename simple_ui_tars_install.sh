#!/bin/bash

# Simple installation script for UI-TARS-1.5-7B

echo "================================================"
echo "Installing ByteDance UI-TARS-1.5-7B"
echo "================================================"

# Check if Python is installed
if ! command -v python3 &> /dev/null; then
    echo "Error: Python3 is not installed. Please install Python 3.8+ first."
    exit 1
fi

# Check Python version
PYTHON_VERSION=$(python3 -c 'import sys; print(f"{sys.version_info.major}.{sys.version_info.minor}")')
echo "Python version: $PYTHON_VERSION"

# Create virtual environment (optional but recommended)
echo -e "\nCreating virtual environment..."
python3 -m venv ui_tars_env
source ui_tars_env/bin/activate

# Upgrade pip
echo -e "\nUpgrading pip..."
pip install --upgrade pip

# Install basic dependencies
echo -e "\nInstalling basic dependencies..."
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu
pip install transformers accelerate sentencepiece Pillow huggingface-hub

# Create a simple test script
echo -e "\nCreating test script..."
cat > test_ui_tars.py << 'EOF'
#!/usr/bin/env python3
"""
Simple test script for UI-TARS-1.5-7B
"""

import torch
from transformers import AutoProcessor, AutoModelForVision2Seq
from PIL import Image
import numpy as np

def test_ui_tars():
    """Test loading and basic inference with UI-TARS"""
    
    model_id = "ByteDance-Seed/UI-TARS-1.5-7B"
    
    print(f"Loading model: {model_id}")
    
    try:
        # Load processor
        print("Loading processor...")
        processor = AutoProcessor.from_pretrained(model_id)
        
        # Load model
        print("Loading model...")
        model = AutoModelForVision2Seq.from_pretrained(
            model_id,
            torch_dtype=torch.bfloat16 if torch.cuda.is_available() else torch.float32,
            device_map="auto" if torch.cuda.is_available() else "cpu"
        )
        
        print(f"✓ Model loaded successfully!")
        print(f"Device: {model.device}")
        print(f"Dtype: {model.dtype}")
        
        # Create a simple test image
        print("\nCreating test image...")
        test_image = Image.new('RGB', (640, 480), color='blue')
        
        # Prepare input
        print("Preparing input...")
        messages = [
            {
                "role": "user",
                "content": [
                    {"type": "image"},
                    {"type": "text", "text": "Describe this image."}
                ]
            }
        ]
        
        text = processor.apply_chat_template(messages, add_generation_prompt=True)
        
        inputs = processor(
            images=[test_image],
            text=text,
            return_tensors="pt"
        )
        
        # Move to device
        inputs = {k: v.to(model.device) for k, v in inputs.items()}
        
        # Generate
        print("Generating response...")
        with torch.no_grad():
            generated_ids = model.generate(
                **inputs,
                max_new_tokens=100,
                do_sample=True,
                temperature=0.7
            )
        
        # Decode
        generated_text = processor.batch_decode(generated_ids, skip_special_tokens=True)[0]
        
        print(f"\nGenerated response: {generated_text}")
        
        return True
        
    except Exception as e:
        print(f"✗ Error: {e}")
        return False

if __name__ == "__main__":
    print("=" * 50)
    print("UI-TARS-1.5-7B Test")
    print("=" * 50)
    
    success = test_ui_tars()
    
    if success:
        print("\n✓ Test completed successfully!")
        print("\nNext steps:")
        print("1. Check the official repositories:")
        print("   - https://github.com/bytedance/UI-TARS")
        print("   - https://github.com/bytedance/UI-TARS-desktop")
        print("2. For GUI automation, install additional packages:")
        print("   pip install opencv-python pyautogui pynput mss")
    else:
        print("\n✗ Test failed. Please check the error message above.")
EOF

# Make the test script executable
chmod +x test_ui_tars.py

echo -e "\n================================================"
echo "Installation complete!"
echo "================================================"
echo -e "\nTo test the installation:"
echo "1. Activate the virtual environment:"
echo "   source ui_tars_env/bin/activate"
echo "2. Run the test script:"
echo "   python test_ui_tars.py"
echo -e "\nNote: The first run will download the model (~14GB)"
echo "This may take some time depending on your internet connection."
echo -e "\nFor GUI automation capabilities, you'll need to install:"
echo "  pip install opencv-python pyautogui pynput mss"
echo -e "\nOfficial resources:"
echo "- GitHub: https://github.com/bytedance/UI-TARS"
echo "- Desktop app: https://github.com/bytedance/UI-TARS-desktop"
echo "- Hugging Face: https://huggingface.co/ByteDance-Seed/UI-TARS-1.5-7B"