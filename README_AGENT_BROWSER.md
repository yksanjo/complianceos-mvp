# Vercel Labs Agent Browser Installation

This directory contains everything you need to install and use the Vercel Labs Agent Browser in DeepSeek Code.

## 📦 What's Included

1. **`INSTALL_AGENT_BROWSER.md`** - Comprehensive installation guide
2. **`install_agent_browser.sh`** - Automated installation script
3. **`example_agent_browser.js`** - Example usage script
4. **`README_AGENT_BROWSER.md`** - This file

## 🚀 Quick Start

### Option 1: Automated Installation (Recommended)
```bash
# Make the script executable
chmod +x install_agent_browser.sh

# Run the installer
./install_agent_browser.sh
```

### Option 2: Manual Installation
```bash
# Install globally
npm install -g @vercel-labs/agent-browser

# Or install locally
npm install @vercel-labs/agent-browser
```

### Option 3: Using npx (No Installation)
```bash
# Run directly without installing
npx @vercel-labs/agent-browser --help
```

## 🎯 What is Agent Browser?

Agent Browser is a **browser automation CLI for AI agents** from Vercel Labs. It allows you to:

- 🤖 Automate browser interactions programmatically
- 📸 Take screenshots of web pages
- 🔍 Extract content from websites
- ⌨️ Fill forms and click buttons
- 📊 Scrape data from web pages
- 🎭 Simulate user interactions

## 📋 Prerequisites

- Node.js v14 or higher
- npm v6 or higher
- Internet connection

## 🔧 Basic Usage

After installation, try these commands:

```bash
# Check version
agent-browser --version

# Get help
agent-browser --help

# Navigate to a website
agent-browser navigate --url https://google.com

# Take a screenshot
agent-browser screenshot --url https://google.com --output google.png

# Get page content
agent-browser content --url https://github.com
```

## 💻 Example Script

Run the example script to see Agent Browser in action:

```bash
# First install agent-browser
npm install @vercel-labs/agent-browser

# Then run the example
node example_agent_browser.js
```

The example script will:
1. Launch a headless browser
2. Navigate to Google
3. Take screenshots
4. Extract page content
5. Demonstrate form filling

## 🛠️ Common Commands

| Command | Description |
|---------|-------------|
| `agent-browser navigate --url <url>` | Navigate to a URL |
| `agent-browser screenshot --url <url> --output <file>` | Take screenshot |
| `agent-browser content --url <url>` | Get page content |
| `agent-browser click --selector <css>` | Click an element |
| `agent-browser type --selector <css> --text <text>` | Type text |
| `agent-browser extract --selector <css>` | Extract element |

## ⚙️ Configuration Options

```bash
# Run in headless mode (no UI)
agent-browser --headless navigate --url <url>

# Set viewport size
agent-browser --viewport 1920x1080 navigate --url <url>

# Add delay between actions
agent-browser --delay 1000 navigate --url <url>

# Set timeout
agent-browser --timeout 30000 navigate --url <url>
```

## 🔗 Useful Links

- **GitHub Repository**: https://github.com/vercel-labs/agent-browser
- **Official Documentation**: https://github.com/vercel-labs/agent-browser#readme
- **Examples**: https://github.com/vercel-labs/agent-browser/tree/main/examples
- **Issues & Discussions**: https://github.com/vercel-labs/agent-browser/issues

## 🚨 Troubleshooting

### Common Issues:

1. **"Command not found" after installation**
   ```bash
   # Try npx instead
   npx agent-browser --help
   
   # Or check npm global path
   npm list -g --depth=0
   ```

2. **Browser won't launch**
   ```bash
   # Install browser binaries
   npx playwright install
   ```

3. **Permission errors**
   ```bash
   # Fix npm permissions
   sudo chown -R $(whoami) ~/.npm
   ```

### Debug Mode:
```bash
# Enable verbose logging
DEBUG=agent-browser:* agent-browser navigate --url https://google.com
```

## 🎨 Advanced Usage

### JavaScript API:
```javascript
const { AgentBrowser } = require('@vercel-labs/agent-browser');

async function automate() {
  const browser = new AgentBrowser({ headless: true });
  
  await browser.launch();
  await browser.navigate('https://google.com');
  await browser.screenshot('google.png');
  await browser.close();
}
```

### Integration with AI Agents:
```javascript
// Combine with OpenAI API for intelligent automation
const { AgentBrowser } = require('@vercel-labs/agent-browser');
const { OpenAI } = require('openai');

class AIWebAgent {
  constructor() {
    this.browser = new AgentBrowser();
    this.ai = new OpenAI({ apiKey: process.env.OPENAI_API_KEY });
  }
  
  async research(topic) {
    await this.browser.navigate(`https://google.com/search?q=${topic}`);
    const content = await this.browser.getContent();
    // Analyze with AI...
  }
}
```

## 📝 Next Steps

1. **Run the installer**: `./install_agent_browser.sh`
2. **Try the example**: `node example_agent_browser.js`
3. **Explore the docs**: Read `INSTALL_AGENT_BROWSER.md`
4. **Build something**: Create your own automation scripts!

## 🤝 Need Help?

- Check the [GitHub Issues](https://github.com/vercel-labs/agent-browser/issues)
- Read the [detailed guide](INSTALL_AGENT_BROWSER.md)
- Run with debug mode: `DEBUG=agent-browser:* your-command`

---

**Happy automating! 🚀**