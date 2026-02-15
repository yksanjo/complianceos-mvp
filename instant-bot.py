#!/usr/bin/env python3
"""
INSTANT Telegram Bot - Non-blocking version
"""

import sys
import threading
from telegram.ext import Application, CommandHandler, MessageHandler, filters

BOT_TOKEN = "8208452855:AAGdgNAUCJ6Lgq_un5Lh86iTW8XTbHc12Lg"

def start_bot():
    """Start the bot in a separate thread."""
    
    async def handle_start(update, context):
        await update.message.reply_text("⚡ INSTANT BOT IS WORKING! Try: 'Hello' or 'Test'")
    
    async def handle_message(update, context):
        text = update.message.text
        user = update.effective_user
        print(f"📨 {user.username or user.id}: {text}")
        await update.message.reply_text(f"✅ Echo: {text}")
    
    # Create and configure app
    app = Application.builder().token(BOT_TOKEN).build()
    app.add_handler(CommandHandler("start", handle_start))
    app.add_handler(MessageHandler(filters.TEXT & ~filters.COMMAND, handle_message))
    
    # Start polling
    print("🔄 Starting bot polling...")
    app.run_polling()

if __name__ == "__main__":
    print("=" * 50)
    print("🤖 INSTANT TELEGRAM BOT")
    print("=" * 50)
    print("Bot: @Omamoribotbot")
    print("Status: Starting...")
    print("=" * 50)
    print("\n📱 INSTRUCTIONS:")
    print("1. Open Telegram")
    print("2. Search for @Omamoribotbot")
    print("3. Click 'Start' or send /start")
    print("4. Send any message")
    print("\n⏳ Bot is starting...\n")
    
    # Start bot in thread
    bot_thread = threading.Thread(target=start_bot, daemon=True)
    bot_thread.start()
    
    # Keep main thread alive
    try:
        while True:
            pass
    except KeyboardInterrupt:
        print("\n🛑 Bot stopped by user")
        sys.exit(0)