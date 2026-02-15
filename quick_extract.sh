#!/bin/bash
# Quick one-liner to extract the game

echo "🎮 Extracting game from simple_game.json..."

# Method 1: Using Python (recommended)
python3 -c "
import json
try:
    with open('simple_game.json', 'r') as f:
        data = json.load(f)
    with open('game.html', 'w') as f:
        f.write(data['html_content'])
    print('✅ Game extracted to game.html')
    print('   Open it in your browser to play!')
except Exception as e:
    print(f'❌ Error: {e}')
"

# Alternative: If Python fails, try this manual method
if [ ! -f "game.html" ]; then
    echo ""
    echo "⚠️  Python extraction failed. Try manual method:"
    echo "   1. Open simple_game.json in a text editor"
    echo "   2. Find the 'html_content' section"
    echo "   3. Copy everything between the quotes"
    echo "   4. Paste into a new file called game.html"
fi