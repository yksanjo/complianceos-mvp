#!/usr/bin/env python3
"""
Music Hall Discord Bot
A Discord bot for monitoring and commenting in music hall channels
Integrated with DeepSeek AI for intelligent responses
"""

import os
import asyncio
import json
import logging
from typing import Optional, List, Dict
from datetime import datetime

import discord
from discord.ext import commands
import requests
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

# Configuration
DISCORD_TOKEN = os.getenv('DISCORD_BOT_TOKEN')
DEEPSEEK_API_KEY = os.getenv('DEEPSEEK_API_KEY')
DEEPSEEK_API_URL = "https://api.deepseek.com/v1/chat/completions"

# Music hall specific configuration
MUSIC_HALL_CHANNEL_IDS = []  # Add your channel IDs here
MUSIC_KEYWORDS = [
    'music', 'song', 'album', 'artist', 'band', 'track', 'playlist',
    'genre', 'concert', 'festival', 'vinyl', 'stream', 'spotify',
    'apple music', 'youtube music', 'soundcloud', 'bandcamp',
    'jazz', 'rock', 'pop', 'hip hop', 'electronic', 'classical',
    'indie', 'metal', 'folk', 'blues', 'r&b', 'soul', 'funk'
]

class DeepSeekClient:
    """Client for interacting with DeepSeek API"""
    
    def __init__(self, api_key: str):
        self.api_key = api_key
        self.headers = {
            "Authorization": f"Bearer {api_key}",
            "Content-Type": "application/json"
        }
    
    def generate_response(self, prompt: str, context: str = "", model: str = "deepseek-chat") -> str:
        """Generate a response using DeepSeek API"""
        try:
            messages = []
            
            # Add system prompt for music context
            system_prompt = """You are a music expert assistant in a Discord music hall channel. 
            You're knowledgeable about all genres of music, artists, albums, and music culture.
            You provide helpful, engaging, and informative responses about music.
            Keep responses conversational and friendly."""
            
            messages.append({"role": "system", "content": system_prompt})
            
            # Add context if provided
            if context:
                messages.append({"role": "user", "content": context})
            
            # Add the current prompt
            messages.append({"role": "user", "content": prompt})
            
            payload = {
                "model": model,
                "messages": messages,
                "max_tokens": 500,
                "temperature": 0.7,
                "stream": False
            }
            
            response = requests.post(
                DEEPSEEK_API_URL,
                headers=self.headers,
                json=payload,
                timeout=30
            )
            
            if response.status_code == 200:
                result = response.json()
                return result['choices'][0]['message']['content']
            else:
                logger.error(f"DeepSeek API error: {response.status_code} - {response.text}")
                return "I'm having trouble connecting to my music knowledge base right now. 🎵"
                
        except Exception as e:
            logger.error(f"Error generating response: {e}")
            return "Oops! Something went wrong with my music brain. 🎶"

class MusicHallBot(commands.Bot):
    """Main Discord bot for music hall"""
    
    def __init__(self):
        intents = discord.Intents.default()
        intents.message_content = True
        intents.members = True
        intents.guilds = True
        
        super().__init__(command_prefix='!', intents=intents)
        
        # Initialize DeepSeek client
        if DEEPSEEK_API_KEY:
            self.deepseek = DeepSeekClient(DEEPSEEK_API_KEY)
            logger.info("DeepSeek client initialized")
        else:
            self.deepseek = None
            logger.warning("No DeepSeek API key provided - AI features disabled")
        
        # Music statistics
        self.music_stats = {
            'songs_discussed': 0,
            'artists_mentioned': 0,
            'genres_talked_about': 0,
            'recommendations_given': 0
        }
        
        # Load/save stats
        self.load_stats()
    
    async def setup_hook(self):
        """Setup hook for bot initialization"""
        logger.info(f"Logged in as {self.user} (ID: {self.user.id})")
        logger.info("------")
        
        # Load cogs/extensions here if needed
        # await self.load_extension('cogs.music_cog')
    
    def load_stats(self):
        """Load music statistics from file"""
        try:
            with open('music_stats.json', 'r') as f:
                self.music_stats = json.load(f)
            logger.info("Loaded music statistics")
        except FileNotFoundError:
            logger.info("No existing stats file found, starting fresh")
    
    def save_stats(self):
        """Save music statistics to file"""
        with open('music_stats.json', 'w') as f:
            json.dump(self.music_stats, f, indent=2)
    
    def is_music_related(self, content: str) -> bool:
        """Check if message is music-related"""
        content_lower = content.lower()
        return any(keyword in content_lower for keyword in MUSIC_KEYWORDS)
    
    def extract_music_info(self, content: str) -> Dict:
        """Extract music-related information from message"""
        # This is a simple implementation - could be enhanced with NLP
        info = {
            'artists': [],
            'songs': [],
            'genres': [],
            'platforms': []
        }
        
        content_lower = content.lower()
        
        # Simple keyword matching (would be better with proper NLP)
        for keyword in MUSIC_KEYWORDS:
            if keyword in content_lower:
                if keyword in ['spotify', 'apple music', 'youtube music', 'soundcloud', 'bandcamp']:
                    info['platforms'].append(keyword)
                elif keyword in ['jazz', 'rock', 'pop', 'hip hop', 'electronic', 'classical', 
                                'indie', 'metal', 'folk', 'blues', 'r&b', 'soul', 'funk']:
                    info['genres'].append(keyword)
        
        return info

# Create bot instance
bot = MusicHallBot()

@bot.event
async def on_ready():
    """Called when bot is ready"""
    logger.info(f'{bot.user} has connected to Discord!')
    
    # Set bot status
    await bot.change_presence(
        activity=discord.Activity(
            type=discord.ActivityType.listening,
            name="music discussions 🎵"
        )
    )
    
    logger.info(f"Bot is in {len(bot.guilds)} guild(s)")
    for guild in bot.guilds:
        logger.info(f"  - {guild.name} (id: {guild.id})")

@bot.event
async def on_message(message):
    """Handle incoming messages"""
    # Ignore messages from the bot itself
    if message.author == bot.user:
        return
    
    # Check if message is in a music hall channel
    is_music_channel = not MUSIC_HALL_CHANNEL_IDS or message.channel.id in MUSIC_HALL_CHANNEL_IDS
    
    # Process music-related messages
    if is_music_channel and bot.is_music_related(message.content):
        logger.info(f"Music-related message in {message.channel.name}: {message.content[:100]}...")
        
        # Extract music info
        music_info = bot.extract_music_info(message.content)
        
        # Update statistics
        if music_info['artists']:
            bot.music_stats['artists_mentioned'] += len(music_info['artists'])
        if music_info['songs']:
            bot.music_stats['songs_discussed'] += len(music_info['songs'])
        if music_info['genres']:
            bot.music_stats['genres_talked_about'] += len(music_info['genres'])
        
        bot.save_stats()
        
        # Generate AI response if DeepSeek is available
        if bot.deepseek and len(message.content) > 10:  # Only respond to substantial messages
            # Check if message is asking a question or seems to want a response
            if any(q in message.content.lower() for q in ['?', 'what', 'who', 'where', 'when', 'why', 'how', 'recommend', 'suggest']):
                async with message.channel.typing():
                    # Generate response
                    response = bot.deepseek.generate_response(
                        prompt=message.content,
                        context=f"User {message.author.name} said in a music channel:"
                    )
                    
                    # Send response
                    if response:
                        # Add some emoji flair
                        emoji_response = f"🎵 {response} 🎶"
                        await message.reply(emoji_response[:2000])  # Discord limit
                        bot.music_stats['recommendations_given'] += 1
                        bot.save_stats()
    
    # Process commands
    await bot.process_commands(message)

@bot.command(name='musicstats', help='Show music discussion statistics')
async def music_stats_command(ctx):
    """Display music statistics"""
    stats = bot.music_stats
    
    embed = discord.Embed(
        title="🎵 Music Hall Statistics",
        color=discord.Color.purple(),
        timestamp=datetime.now()
    )
    
    embed.add_field(name="Songs Discussed", value=str(stats['songs_discussed']), inline=True)
    embed.add_field(name="Artists Mentioned", value=str(stats['artists_mentioned']), inline=True)
    embed.add_field(name="Genres Talked About", value=str(stats['genres_talked_about']), inline=True)
    embed.add_field(name="Recommendations Given", value=str(stats['recommendations_given']), inline=True)
    
    embed.set_footer(text="Music Hall Bot")
    
    await ctx.send(embed=embed)

@bot.command(name='recommend', help='Get a music recommendation')
async def recommend_command(ctx, *, genre: Optional[str] = None):
    """Get a music recommendation"""
    if not bot.deepseek:
        await ctx.send("AI features are not enabled. Please set up DeepSeek API key.")
        return
    
    async with ctx.channel.typing():
        prompt = "Give me a music recommendation"
        if genre:
            prompt = f"Give me a {genre} music recommendation"
        
        response = bot.deepseek.generate_response(prompt)
        
        if response:
            embed = discord.Embed(
                title="🎧 Music Recommendation",
                description=response,
                color=discord.Color.green()
            )
            
            if genre:
                embed.add_field(name="Genre", value=genre.capitalize(), inline=True)
            
            embed.set_footer(text="Powered by DeepSeek AI")
            
            await ctx.send(embed=embed)
            bot.music_stats['recommendations_given'] += 1
            bot.save_stats()

@bot.command(name='nowplaying', help='Share what you\'re listening to')
async def now_playing_command(ctx, *, song_info: str):
    """Share what you're listening to"""
    # Log the listening activity
    logger.info(f"{ctx.author.name} is listening to: {song_info}")
    
    embed = discord.Embed(
        title="🎶 Now Playing",
        description=f"**{ctx.author.name}** is listening to:\n{song_info}",
        color=discord.Color.blue()
    )
    
    embed.set_thumbnail(url=ctx.author.avatar.url if ctx.author.avatar else None)
    embed.set_footer(text=f"Shared at {datetime.now().strftime('%H:%M')}")
    
    await ctx.send(embed=embed)

@bot.command(name='setup', help='Setup music hall channel monitoring')
async def setup_command(ctx):
    """Setup the current channel as a music hall channel"""
    if ctx.channel.id not in MUSIC_HALL_CHANNEL_IDS:
        MUSIC_HALL_CHANNEL_IDS.append(ctx.channel.id)
        
        # Save to config file
        config = {
            'music_hall_channels': MUSIC_HALL_CHANNEL_IDS,
            'music_keywords': MUSIC_KEYWORDS
        }
        
        with open('bot_config.json', 'w') as f:
            json.dump(config, f, indent=2)
        
        await ctx.send(f"✅ {ctx.channel.mention} has been set up as a music hall channel! I'll now monitor music discussions here.")
    else:
        await ctx.send(f"ℹ️ {ctx.channel.mention} is already set up as a music hall channel.")

@bot.command(name='ping', help='Check bot latency')
async def ping_command(ctx):
    """Check bot latency"""
    latency = round(bot.latency * 1000)
    await ctx.send(f'🏓 Pong! Latency: {latency}ms')

@bot.command(name='helpme', help='Show all available commands')
async def help_command(ctx):
    """Show help information"""
    embed = discord.Embed(
        title="🎵 Music Hall Bot Help",
        description="Here are all the available commands:",
        color=discord.Color.orange()
    )
    
    commands_list = [
        ("!musicstats", "Show music discussion statistics"),
        ("!recommend [genre]", "Get a music recommendation (optional genre)"),
        ("!nowplaying <song info>", "Share what you're listening to"),
        ("!setup", "Setup current channel as music hall channel"),
        ("!ping", "Check bot latency"),
        ("!helpme", "Show this help message")
    ]
    
    for cmd, desc in commands_list:
        embed.add_field(name=cmd, value=desc, inline=False)
    
    embed.add_field(
        name="Automatic Features",
        value="• I automatically respond to music-related questions\n• I track music discussion statistics\n• I provide AI-powered music insights",
        inline=False
    )
    
    embed.set_footer(text="Music Hall Bot - Keeping the music conversation going!")
    
    await ctx.send(embed=embed)

def main():
    """Main entry point"""
    if not DISCORD_TOKEN:
        logger.error("DISCORD_BOT_TOKEN environment variable is not set!")
        logger.info("Please create a .env file with:")
        logger.info("DISCORD_BOT_TOKEN=your_discord_bot_token_here")
        logger.info("DEEPSEEK_API_KEY=your_deepseek_api_key_here (optional)")
        return
    
    # Load configuration if exists
    try:
        with open('bot_config.json', 'r') as f:
            config = json.load(f)
            MUSIC_HALL_CHANNEL_IDS.extend(config.get('music_hall_channels', []))
            logger.info(f"Loaded {len(MUSIC_HALL_CHANNEL_IDS)} music hall channels from config")
    except FileNotFoundError:
        logger.info("No config file found, starting fresh")
    
    # Run the bot
    try:
        bot.run(DISCORD_TOKEN)
    except discord.LoginFailure:
        logger.error("Invalid Discord token. Please check your DISCORD_BOT_TOKEN.")
    except Exception as e:
        logger.error(f"Error running bot: {e}")

if __name__ == "__main__":
    main()