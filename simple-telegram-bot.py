#!/usr/bin/env python3
"""
Simple Telegram Bot that actually works
No OpenClaw dependencies, just pure Python
"""

import asyncio
import logging
from telegram import Bot, Update
from telegram.ext import Application, CommandHandler, MessageHandler, filters, ContextTypes

# Your bot token
BOT_TOKEN = "8208452855:AAGdgNAUCJ6Lgq_un5Lh86iTW8XTbHc12Lg"

# Enable logging
logging.basicConfig(
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    level=logging.INFO
)
logger = logging.getLogger(__name__)

# Command handlers
async def start_command(update: Update, context: ContextTypes.DEFAULT_TYPE):
    """Send a message when the command /start is issued."""
    user = update.effective_user
    await update.message.reply_html(
        f"Hi {user.mention_html()}! 👋\n"
        f"I'm your simple Telegram bot!\n"
        f"Your ID: {user.id}\n"
        f"Send me any message and I'll echo it back."
    )

async def help_command(update: Update, context: ContextTypes.DEFAULT_TYPE):
    """Send a message when the command /help is issued."""
    await update.message.reply_text(
        "Available commands:\n"
        "/start - Start the bot\n"
        "/help - Show this help message\n"
        "/status - Check bot status\n"
        "Or just send me any message!"
    )

async def status_command(update: Update, context: ContextTypes.DEFAULT_TYPE):
    """Send bot status."""
    await update.message.reply_text(
        "✅ Bot is running!\n"
        "🤖 Name: お守り (Omamori)\n"
        "👤 Username: @Omamoribotbot\n"
        "🆔 Bot ID: 8208452855\n"
        "📡 Status: Active and listening"
    )

async def echo_message(update: Update, context: ContextTypes.DEFAULT_TYPE):
    """Echo the user message."""
    text = update.message.text
    user = update.effective_user
    
    # Log the message
    logger.info(f"Message from {user.username} ({user.id}): {text}")
    
    # Echo back
    await update.message.reply_text(
        f"📝 You said: {text}\n"
        f"👤 Your ID: {user.id}\n"
        f"📊 Message length: {len(text)} characters"
    )

async def error_handler(update: Update, context: ContextTypes.DEFAULT_TYPE):
    """Log errors."""
    logger.error(f"Update {update} caused error {context.error}")

def main():
    """Start the bot."""
    print("🤖 Starting Simple Telegram Bot...")
    print(f"🔑 Token: {BOT_TOKEN[:10]}...{BOT_TOKEN[-10:]}")
    
    # Create the Application
    application = Application.builder().token(BOT_TOKEN).build()
    
    # Add command handlers
    application.add_handler(CommandHandler("start", start_command))
    application.add_handler(CommandHandler("help", help_command))
    application.add_handler(CommandHandler("status", status_command))
    
    # Add message handler
    application.add_handler(MessageHandler(filters.TEXT & ~filters.COMMAND, echo_message))
    
    # Add error handler
    application.add_error_handler(error_handler)
    
    # Start the bot
    print("✅ Bot started! Press Ctrl+C to stop.")
    print("📱 Go to Telegram and message @Omamoribotbot")
    
    # Run the bot until you press Ctrl-C
    application.run_polling(allowed_updates=Update.ALL_TYPES)

if __name__ == '__main__':
    main()