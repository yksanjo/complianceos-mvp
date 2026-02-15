#!/bin/bash

echo "🔍 UI-TARS Download Monitor"
echo "=========================="

while true; do
    clear
    echo "📊 Download Progress - $(date)"
    echo "================================"
    
    # Check cache size
    if [ -d "UI-TARS-1.5-7B/.cache" ]; then
        echo -n "📁 Cache size: "
        du -sh UI-TARS-1.5-7B/.cache 2>/dev/null | cut -f1
    else
        echo "📁 Cache: Not created yet"
    fi
    
    # Check model files
    echo -n "📦 Model files: "
    count=$(ls -1 UI-TARS-1.5-7B/*.safetensors 2>/dev/null | wc -l)
    echo "$count/7"
    
    if [ $count -gt 0 ]; then
        echo "   Files found:"
        ls -1 UI-TARS-1.5-7B/*.safetensors 2>/dev/null | xargs -I {} basename {}
    fi
    
    # Check incomplete files
    echo -n "⬇️  Active downloads: "
    incomplete=$(find UI-TARS-1.5-7B/.cache -name "*.incomplete" 2>/dev/null | wc -l)
    echo "$incomplete"
    
    if [ $incomplete -gt 0 ]; then
        echo "   Checking if growing..."
        # Check if files are growing
        for file in $(find UI-TARS-1.5-7B/.cache -name "*.incomplete" 2>/dev/null | head -2); do
            size1=$(stat -f%z "$file" 2>/dev/null || echo "0")
            sleep 2
            size2=$(stat -f%z "$file" 2>/dev/null || echo "0")
            
            if [ "$size2" -gt "$size1" ]; then
                growth=$((size2 - size1))
                echo "   ✓ Growing: $((growth / 1024)) KB/2s"
            else
                echo "   ⏸️  Paused"
            fi
        done
    fi
    
    echo ""
    echo "⏳ Next update in 10 seconds..."
    echo "Press Ctrl+C to stop monitoring"
    sleep 10
done