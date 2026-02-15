#!/usr/bin/env python3
"""
Simple test to verify bot dependencies are installed
"""

import sys

def test_imports():
    """Test that all required imports work"""
    imports = [
        ('discord', 'discord.py'),
        ('requests', 'requests'),
        ('dotenv', 'python-dotenv'),
        ('json', 'standard library'),
        ('asyncio', 'standard library'),
        ('logging', 'standard library'),
    ]
    
    print("Testing imports...")
    all_ok = True
    
    for module_name, package_name in imports:
        try:
            __import__(module_name)
            print(f"✅ {module_name} ({package_name})")
        except ImportError as e:
            print(f"❌ {module_name} ({package_name}) - {e}")
            all_ok = False
    
    return all_ok

def test_python_version():
    """Check Python version"""
    print(f"\nPython version: {sys.version}")
    
    version_info = sys.version_info
    if version_info.major == 3 and version_info.minor >= 8:
        print("✅ Python 3.8+ detected")
        return True
    else:
        print(f"❌ Python 3.8+ required, found {version_info.major}.{version_info.minor}")
        return False

def main():
    print("=" * 50)
    print("Music Hall Discord Bot - Dependency Test")
    print("=" * 50)
    
    py_ok = test_python_version()
    imports_ok = test_imports()
    
    print("\n" + "=" * 50)
    
    if py_ok and imports_ok:
        print("✅ All dependencies are installed correctly!")
        print("\nNext steps:")
        print("1. Create a .env file with your Discord bot token")
        print("2. Run: python3 music_hall_discord_bot.py")
        print("3. Use !setup in your music channel to activate the bot")
    else:
        print("❌ Some dependencies are missing")
        print("\nTo install missing dependencies:")
        print("  pip3 install -r requirements.txt")
        print("\nOr install manually:")
        print("  pip3 install discord.py requests python-dotenv")
    
    print("=" * 50)

if __name__ == "__main__":
    main()