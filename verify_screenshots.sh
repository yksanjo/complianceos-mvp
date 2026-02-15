#!/bin/bash
# Verify screenshot placeholders exist

echo "🔍 Checking screenshot placeholders..."
echo ""

for project in topoguard tinyguardian captcha-fights-back; do
    echo "📁 $project:"
    if [ -d "$project/docs/screenshots" ]; then
        count=$(ls -1 "$project/docs/screenshots"/*.png 2>/dev/null | wc -l)
        echo "   ✅ Found $count placeholder images"
        ls -1 "$project/docs/screenshots"/*.png 2>/dev/null | sed 's/^/      - /'
    else
        echo "   ❌ Screenshots directory not found"
    fi
    echo ""
done

echo "✅ Verification complete!"
