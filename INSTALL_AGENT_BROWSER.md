# Installation Guide: Vercel Labs Agent Browser

## What is Agent Browser?
Agent Browser is a browser automation CLI for AI agents from Vercel Labs. It allows AI agents to control and interact with web browsers programmatically.

## Prerequisites

### 1. Check Current Environment
```bash
# Check Node.js and npm versions
node --version  # Should be v14 or higher
npm --version   # Should be v6 or higher

# Check if you're in the right directory
pwd
```

### 2. Installation Methods

## Method 1: Install via npm (Recommended)

### Step 1: Create a project directory
```bash
# Create a new directory for the agent browser
mkdir agent-browser-project
cd agent-browser-project

# Initialize a new Node.js project
npm init -y
```

### Step 2: Install the package
```bash
# Install agent-browser as a dependency
npm install @vercel-labs/agent-browser

# Or install it globally
npm install -g @vercel-labs/agent-browser
```

### Step 3: Verify installation
```bash
# Check if installed locally
npx agent-browser --version

# If installed globally
agent-browser --version
```

## Method 2: Clone from GitHub

### Step 1: Clone the repository
```bash
# Clone the repository
git clone https://github.com/vercel-labs/agent-browser.git
cd agent-browser
```

### Step 2: Install dependencies
```bash
# Install all dependencies
npm install

# Build the project (if needed)
npm run build
```

### Step 3: Link for global usage (optional)
```bash
# Link for global CLI usage
npm link

# Now you can use it from anywhere
agent-browser --help
```

## Method 3: Using npx (No Installation)

```bash
# Run directly without installation
npx @vercel-labs/agent-browser --help

# Or run specific commands
npx @vercel-labs/agent-browser <command>
```

## Quick Start Examples

### Example 1: Basic Usage
```bash
# Check available commands
agent-browser --help

# Run a simple automation
agent-browser navigate --url https://google.com

# Take a screenshot
agent-browser screenshot --url https://google.com --output google.png
```

### Example 2: Create a Simple Script
Create a file `automate.js`:
```javascript
const { AgentBrowser } = require('@vercel-labs/agent-browser');

async function main() {
  const browser = new AgentBrowser();
  
  await browser.launch();
  await browser.navigate('https://google.com');
  
  // Take screenshot
  await browser.screenshot('google_homepage.png');
  
  // Type in search box
  await browser.type('input[name="q"]', 'Vercel Agent Browser');
  
  // Click search button
  await browser.click('input[value="Google Search"]');
  
  await browser.close();
}

main().catch(console.error);
```

Run it:
```bash
node automate.js
```

### Example 3: Using with TypeScript
```typescript
import { AgentBrowser } from '@vercel-labs/agent-browser';

async function automate() {
  const browser = new AgentBrowser();
  
  try {
    await browser.launch();
    await browser.navigate('https://github.com/vercel-labs/agent-browser');
    
    // Get page content
    const content = await browser.getContent();
    console.log('Page title:', content.title);
    
    // Extract specific elements
    const readme = await browser.extract('.readme');
    console.log('README section found:', !!readme);
    
  } finally {
    await browser.close();
  }
}

automate();
```

## Common Commands

### Basic Commands
```bash
# Launch browser
agent-browser launch

# Navigate to URL
agent-browser navigate --url <url>

# Take screenshot
agent-browser screenshot --url <url> --output <file>

# Get page content
agent-browser content --url <url>

# Click element
agent-browser click --selector <css-selector>

# Type text
agent-browser type --selector <css-selector> --text <text>
```

### Advanced Commands
```bash
# Run with headless mode
agent-browser --headless navigate --url <url>

# Set viewport size
agent-browser --viewport 1920x1080 navigate --url <url>

# Add delay between actions
agent-browser --delay 1000 navigate --url <url>

# Use specific browser
agent-browser --browser chromium navigate --url <url>
```

## Configuration

### Configuration File
Create `agent-browser.config.json`:
```json
{
  "headless": true,
  "viewport": {
    "width": 1920,
    "height": 1080
  },
  "delay": 1000,
  "browser": "chromium",
  "timeout": 30000
}
```

### Environment Variables
```bash
# Set browser path
export AGENT_BROWSER_PATH=/path/to/chromium

# Enable debug mode
export DEBUG=agent-browser:*

# Set timeout
export AGENT_BROWSER_TIMEOUT=60000
```

## Integration Examples

### Example 1: Integration with AI Agent
```javascript
// ai-agent.js
const { AgentBrowser } = require('@vercel-labs/agent-browser');
const { OpenAI } = require('openai');

class AIAgent {
  constructor() {
    this.browser = new AgentBrowser();
    this.openai = new OpenAI({ apiKey: process.env.OPENAI_API_KEY });
  }

  async research(topic) {
    await this.browser.launch();
    
    // Navigate to Google
    await this.browser.navigate('https://google.com');
    await this.browser.type('input[name="q"]', topic);
    await this.browser.click('input[value="Google Search"]');
    
    // Get search results
    const results = await this.browser.extract('.g');
    
    // Analyze with AI
    const analysis = await this.openai.chat.completions.create({
      model: 'gpt-4',
      messages: [
        { role: 'user', content: `Analyze these search results: ${JSON.stringify(results)}` }
      ]
    });
    
    await this.browser.close();
    return analysis.choices[0].message.content;
  }
}
```

### Example 2: Web Scraping Automation
```javascript
// scraper.js
const { AgentBrowser } = require('@vercel-labs/agent-browser');

async function scrapeEcommerce() {
  const browser = new AgentBrowser({ headless: true });
  
  await browser.launch();
  await browser.navigate('https://example.com/products');
  
  // Extract product data
  const products = await browser.extractAll('.product', {
    name: '.product-name',
    price: '.product-price',
    description: '.product-description'
  });
  
  await browser.close();
  return products;
}
```

## Troubleshooting

### Common Issues

1. **Browser not launching**
   ```bash
   # Install browser binaries
   npx playwright install
   
   # Or specify browser path
   agent-browser --browser-path /path/to/chrome navigate --url <url>
   ```

2. **Permission errors**
   ```bash
   # Fix npm permissions
   sudo chown -R $(whoami) ~/.npm
   
   # Or use npx instead
   npx @vercel-labs/agent-browser --help
   ```

3. **Timeout errors**
   ```bash
   # Increase timeout
   agent-browser --timeout 60000 navigate --url <url>
   
   # Or in config
   export AGENT_BROWSER_TIMEOUT=60000
   ```

4. **Missing dependencies**
   ```bash
   # Reinstall dependencies
   rm -rf node_modules package-lock.json
   npm install
   ```

### Debug Mode
```bash
# Enable verbose logging
DEBUG=agent-browser:* agent-browser navigate --url https://google.com

# Or in code
const browser = new AgentBrowser({ debug: true });
```

## Best Practices

1. **Always close the browser**
   ```javascript
   try {
     await browser.launch();
     // ... your code ...
   } finally {
     await browser.close();
   }
   ```

2. **Use appropriate delays**
   ```javascript
   const browser = new AgentBrowser({ delay: 1000 }); // 1 second delay
   ```

3. **Handle errors gracefully**
   ```javascript
   try {
     await browser.navigate(url);
   } catch (error) {
     console.error('Navigation failed:', error);
     // Retry or fallback
   }
   ```

4. **Cache browser instances** for repeated use
   ```javascript
   class BrowserManager {
     constructor() {
       this.browser = null;
     }
     
     async getBrowser() {
       if (!this.browser) {
         this.browser = new AgentBrowser();
         await this.browser.launch();
       }
       return this.browser;
     }
   }
   ```

## Next Steps

1. **Explore the API documentation**
   ```bash
   # View built-in documentation
   agent-browser --help
   
   # Check specific command help
   agent-browser navigate --help
   ```

2. **Try the examples**
   ```bash
   # Clone examples
   git clone https://github.com/vercel-labs/agent-browser-examples.git
   cd agent-browser-examples
   npm install
   ```

3. **Join the community**
   - GitHub Issues: https://github.com/vercel-labs/agent-browser/issues
   - Discussions: https://github.com/vercel-labs/agent-browser/discussions

## Additional Resources

- **Official Documentation**: https://github.com/vercel-labs/agent-browser#readme
- **API Reference**: Check the `docs/` directory in the repository
- **Examples**: https://github.com/vercel-labs/agent-browser/tree/main/examples
- **Changelog**: https://github.com/vercel-labs/agent-browser/releases

## Quick Reference Card

```bash
# Installation
npm install @vercel-labs/agent-browser

# Basic usage
agent-browser navigate --url https://example.com
agent-browser screenshot --url https://example.com --output page.png

# With npx (no install)
npx @vercel-labs/agent-browser --help

# Common options
--headless      # Run without UI
--viewport      # Set window size (e.g., 1920x1080)
--delay         # Delay between actions (ms)
--timeout       # Operation timeout (ms)
--debug         # Enable debug logging
```

Now you're ready to start automating browsers with AI agents! 🚀