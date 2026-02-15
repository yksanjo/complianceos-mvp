#!/bin/bash
# Quick start script for UI-TARS via Volcengine API

echo "🚀 UI-TARS Quick Start with Volcengine API"
echo "=========================================="
echo ""
echo "Step 1: Get your API key from:"
echo "  https://console.volcengine.com/ark/"
echo ""
echo "Step 2: Run one of these commands:"
echo ""
echo "--- Simple headless test ---"
echo 'agent-tars --headless --provider volcengine --model doubao-1-5-thinking-vision-pro-250428 --apiKey "YOUR_API_KEY" --input "List files in current directory"'
echo ""
echo "--- Interactive mode with Web UI ---"
echo 'agent-tars --provider volcengine --model doubao-1-5-thinking-vision-pro-250428 --apiKey "YOUR_API_KEY"'
echo ""
echo "--- YOLO mode (headless with complex task) ---"
echo 'agent-tars --headless --provider volcengine --model doubao-1-5-thinking-vision-pro-250428 --apiKey "YOUR_API_KEY" --input "Create a React todo app in ./my-todo-app"'
echo ""
