#!/bin/bash
# Extract game from JSON file

JSON_FILE="simple_game.json"
HTML_FILE="game.html"

if [ ! -f "$JSON_FILE" ]; then
    echo "❌ Error: $JSON_FILE not found!"
    exit 1
fi

# Extract using Python (if available)
if command -v python3 &> /dev/null; then
    python3 -c "
import json
import sys

try:
    with open('$JSON_FILE', 'r') as f:
        data = json.load(f)
    
    if 'html_content' in data:
        with open('$HTML_FILE', 'w') as f:
            f.write(data['html_content'])
        print('✅ Game extracted to $HTML_FILE')
    else:
        print('❌ Error: html_content not found in JSON')
        sys.exit(1)
except Exception as e:
    print(f'❌ Error: {e}')
    sys.exit(1)
"
elif command -v jq &> /dev/null; then
    # Alternative using jq
    jq -r '.html_content' "$JSON_FILE" > "$HTML_FILE"
    echo "✅ Game extracted to $HTML_FILE (using jq)"
else
    echo "❌ Error: Need either python3 or jq installed"
    echo "   Install python3: brew install python3"
    echo "   Install jq: brew install jq"
    exit 1
fi

echo ""
echo "🎮 To play the game:"
echo "   open $HTML_FILE"
echo "   or double-click $HTML_FILE in Finder"
