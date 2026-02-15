#!/usr/bin/env python3
"""
WORKING Telegram Bot - This WILL work
"""

import asyncio
from telegram import Bot, Update
from telegram.ext import Application, CommandHandler, MessageHandler, filters

BOT_TOKEN = "8208452855:AAGdgNAUCJ6Lgq_un5Lh86iTW8XTbHc12Lg"

print("=" * 50)
print("🤖 WORKING TELEGRAM BOT")
print("=" * 50)
print(f"Token: {BOT_TOKEN[:10]}...{BOT_TOKEN[-10:]}")
print("Bot: お守り (@Omamoribotbot)")
print("=" * 50)

async def handle_start(update: Update, context):
    await update.message.reply_text("🎉 BOT IS WORKING! Send me any message!")

async def handle_message(update: Update, context):
    text = update.message.text
    user = update.effective_user
    print(f"📨 Message from {user.username or user.id}: {text}")
    await update.message.reply_text(f"✅ Got it: '{text}'")

def main():
    app = Application.builder().token(BOT_TOKEN).build()
    
    # Add handlers
    app.add_handler(CommandHandler("start", handle_start))
    app.add_handler(MessageHandler(filters.TEXT & ~filters.COMMAND, handle_message))
    
    print("\n✅ Bot is starting...")
    print("📱 Go to Telegram and message @Omamoribotbot")
    print("💬 Send /start or any message")
    print("🛑 Press Ctrl+C to stop\n")
    print("=" * 50)
    
    app.run_polling()

if __name__ == "__main__":
    main()