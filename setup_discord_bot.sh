#!/bin/bash

# Music Hall Discord Bot Setup Script

set -e

echo "=========================================="
echo "  Music Hall Discord Bot Setup"
echo "=========================================="
echo ""

# Check for Python
if ! command -v python3 &> /dev/null; then
    echo "❌ Python 3 is not installed. Please install Python 3.8 or higher."
    exit 1
fi

echo "✅ Python 3 is installed"

# Check for pip
if ! command -v pip3 &> /dev/null; then
    echo "❌ pip3 is not installed. Please install pip."
    exit 1
fi

echo "✅ pip3 is installed"

# Install requirements
echo ""
echo "Installing Python dependencies..."
pip3 install -r requirements.txt

# Create .env file if it doesn't exist
if [ ! -f ".env" ]; then
    echo ""
    echo "Creating .env file from template..."
    cp .env.example .env
    echo ""
    echo "⚠️  Please edit the .env file and add your credentials:"
    echo ""
    echo "1. DISCORD_BOT_TOKEN - Get this from Discord Developer Portal"
    echo "2. DEEPSEEK_API_KEY - Optional, for AI responses (get from https://platform.deepseek.com)"
    echo ""
    echo "Edit .env file and then run the bot with:"
    echo "  python3 music_hall_discord_bot.py"
    echo ""
else
    echo ""
    echo "✅ .env file already exists"
    echo ""
    echo "To run the bot:"
    echo "  python3 music_hall_discord_bot.py"
fi

echo ""
echo "=========================================="
echo "  Discord Bot Creation Instructions"
echo "=========================================="
echo ""
echo "If you don't have a Discord bot yet, follow these steps:"
echo ""
echo "1. Go to https://discord.com/developers/applications"
echo "2. Click 'New Application' and give it a name (e.g., 'Music Hall Bot')"
echo "3. Go to the 'Bot' section in the left sidebar"
echo "4. Click 'Add Bot' and confirm"
echo "5. Under the 'TOKEN' section, click 'Copy' to get your bot token"
echo "6. Paste the token in your .env file as DISCORD_BOT_TOKEN"
echo "7. Go to 'OAuth2' → 'URL Generator'"
echo "8. Select 'bot' and 'applications.commands' scopes"
echo "9. Select these bot permissions:"
echo "   - Read Messages/View Channels"
echo "   - Send Messages"
echo "   - Read Message History"
echo "   - Use Slash Commands"
echo "10. Copy the generated URL and open it in your browser"
echo "11. Add the bot to your Discord server"
echo ""
echo "=========================================="
echo "  Bot Features"
echo "=========================================="
echo ""
echo "Once running, your bot will:"
echo "• Monitor music-related discussions automatically"
echo "• Respond to music questions with AI insights (if DeepSeek API is set)"
echo "• Track music statistics (!musicstats command)"
echo "• Provide music recommendations (!recommend command)"
echo "• Allow users to share what they're listening to (!nowplaying command)"
echo ""
echo "To set up a channel as a music hall channel, use:"
echo "  !setup  (in the desired channel)"
echo ""
echo "=========================================="
echo "  Setup Complete!"
echo "=========================================="
echo ""
echo "Next steps:"
echo "1. Edit .env file with your credentials"
echo "2. Run the bot: python3 music_hall_discord_bot.py"
echo "3. Use !setup in your music channel to activate monitoring"
echo "4. Use !helpme to see all available commands"
echo ""