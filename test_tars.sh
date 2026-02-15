#!/bin/bash
# Test Agent TARS with Ollama - Using prompt-based tool calling

cd ~

agent-tars \
  --headless \
  --provider openai \
  --model llama3 \
  --baseURL "http://localhost:11434/v1" \
  --apiKey "ollama" \
  --toolCallEngine prompt_engineering \
  --input "Hello! What can you do?"
