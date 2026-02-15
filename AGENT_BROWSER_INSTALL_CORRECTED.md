# CORRECTED: Vercel Labs Agent Browser Installation

## Important Correction
The package name is **`agent-browser`** (not `@vercel-labs/agent-browser`)

## Quick Installation

### Method 1: Global Installation
```bash
npm install -g agent-browser
```

### Method 2: Local Installation
```bash
npm install agent-browser
```

### Method 3: Using npx
```bash
npx agent-browser --help
```

## Verify Installation
```bash
# Check if installed
agent-browser --version

# Or with npx
npx agent-browser --version
```

## What is Agent Browser?

Agent Browser is a browser automation CLI tool from Vercel Labs that allows AI agents to control web browsers programmatically.

## Basic Usage Examples

```bash
# Navigate to a website
agent-browser navigate --url https://google.com

# Take a screenshot
agent-browser screenshot --url https://google.com --output google.png

# Get page content
agent-browser content --url https://github.com
```

## If Installation Fails

If you get permission errors or the package isn't found:

### Option 1: Clone from GitHub
```bash
git clone https://github.com/vercel-labs/agent-browser.git
cd agent-browser
npm install
npm run build

# Use locally
node bin/agent-browser.js --help

# Or link globally
npm link
agent-browser --help
```

### Option 2: Check npm registry
```bash
# Search for the package
npm search agent-browser

# View package info
npm view agent-browser
```

### Option 3: Manual download
1. Visit: https://github.com/vercel-labs/agent-browser
2. Download the latest release
3. Extract and run: `npm install` in the directory

## Package Information
- **Name**: agent-browser
- **Repository**: https://github.com/vercel-labs/agent-browser
- **Version**: Latest is 0.4.4 (as of checking)
- **Description**: Browser automation CLI for AI agents

## Quick Start Script

Create `test_agent.js`:
```javascript
// Test if agent-browser works
try {
  const { AgentBrowser } = require('agent-browser');
  console.log('✅ Agent Browser is available!');
  
  // Quick test
  async function test() {
    const browser = new AgentBrowser({ headless: true });
    await browser.launch();
    console.log('Browser launched successfully!');
    await browser.close();
  }
  
  test().catch(console.error);
  
} catch (error) {
  console.log('❌ Agent Browser not installed or error:', error.message);
  console.log('\nTo install: npm install agent-browser');
}
```

Run it:
```bash
node test_agent.js
```

## Common Issues & Solutions

1. **"Package not found"**: Use `npm install agent-browser` (without @vercel-labs/)
2. **Permission errors**: Use `sudo` or fix npm permissions
3. **Command not found**: Use `npx agent-browser` instead
4. **Browser won't launch**: Run `npx playwright install`

## Resources
- GitHub: https://github.com/vercel-labs/agent-browser
- Issues: https://github.com/vercel-labs/agent-browser/issues
- Examples: https://github.com/vercel-labs/agent-browser/tree/main/examples

## Summary
The correct package name is **`agent-browser`**. Install with:
```bash
npm install agent-browser
```