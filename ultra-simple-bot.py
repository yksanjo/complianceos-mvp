#!/usr/bin/env python3
"""
ULTRA Simple Telegram Bot - Minimal version
"""

import asyncio
import logging
from telegram import Update
from telegram.ext import Application, CommandHandler, MessageHandler, filters

# Your bot token
BOT_TOKEN = "8208452855:AAGdgNAUCJ6Lgq_un5Lh86iTW8XTbHc12Lg"

# Setup logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

async def start(update: Update, context):
    """Handle /start command."""
    await update.message.reply_text("🚀 Bot is ALIVE! Send me any message!")

async def echo(update: Update, context):
    """Echo user message."""
    text = update.message.text
    user = update.effective_user
    logger.info(f"Message from {user.username}: {text}")
    await update.message.reply_text(f"✅ Received: {text}")

def main():
    """Start bot."""
    print("🤖 Starting ULTRA Simple Telegram Bot...")
    
    # Create application
    app = Application.builder().token(BOT_TOKEN).build()
    
    # Add handlers
    app.add_handler(CommandHandler("start", start))
    app.add_handler(MessageHandler(filters.TEXT & ~filters.COMMAND, echo))
    
    # Start polling
    print("✅ Bot started! Go to Telegram and message @Omamoribotbot")
    print("🛑 Press Ctrl+C to stop")
    app.run_polling()

if __name__ == "__main__":
    main()