#!/usr/bin/env python3
"""
Test Telegram bot connection
"""

import asyncio
from telegram import Bot

BOT_TOKEN = "8208452855:AAGdgNAUCJ6Lgq_un5Lh86iTW8XTbHc12Lg"

async def test():
    """Test bot connection."""
    print("🔍 Testing Telegram bot connection...")
    
    try:
        bot = Bot(token=BOT_TOKEN)
        
        # Get bot info
        me = await bot.get_me()
        print(f"✅ Bot connected successfully!")
        print(f"🤖 Name: {me.first_name}")
        print(f"👤 Username: @{me.username}")
        print(f"🆔 ID: {me.id}")
        
        # Test sending (won't actually send without chat_id)
        print(f"📡 Bot is ready to receive messages!")
        
    except Exception as e:
        print(f"❌ Error: {e}")
        print("Check your internet connection and bot token")

# Run test
if __name__ == "__main__":
    asyncio.run(test())