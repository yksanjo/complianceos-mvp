#!/usr/bin/env python3
"""
Automated Moltbook Agent Claiming Script using Playwright
"""

import asyncio
from playwright.async_api import async_playwright

CLAIM_URL = "https://moltbook.com/claim/moltbook_claim_WgCaR8DMRF_tccwZlNdqfLLoTAWzPtzr"
VERIFICATION_CODE = "den-UHB6"
AGENT_NAME = "AgentInfra"

async def claim_agent():
    """Attempt to claim the Moltbook agent via browser automation"""
    
    async with async_playwright() as p:
        # Launch browser
        browser = await p.chromium.launch(headless=False)  # Set to True for headless
        context = await browser.new_context(
            viewport={'width': 1280, 'height': 800}
        )
        page = await context.new_page()
        
        print("🚀 Opening Moltbook claim page...")
        await page.goto(CLAIM_URL)
        
        # Wait for page to load
        await page.wait_for_load_state('networkidle')
        
        print(f"📄 Page title: {await page.title()}")
        
        # Take screenshot to see what's on the page
        await page.screenshot(path='moltbook_claim_page.png')
        print("📸 Screenshot saved: moltbook_claim_page.png")
        
        # Check for form elements
        print("\n🔍 Checking for claim form elements...")
        
        # Look for common claim form elements
        selectors_to_check = [
            'input[name="verification_code"]',
            'input[name="code"]',
            'input[placeholder*="verification" i]',
            'button:has-text("Claim")',
            'button:has-text("Verify")',
            'button:has-text("Submit")',
            'form',
            '[data-testid*="claim" i]',
        ]
        
        found_elements = []
        for selector in selectors_to_check:
            try:
                element = await page.query_selector(selector)
                if element:
                    found_elements.append(selector)
                    print(f"  ✓ Found: {selector}")
            except:
                pass
        
        if not found_elements:
            print("  ⚠️ No standard form elements found")
            
            # Try to get page content
            content = await page.content()
            if "verification" in content.lower():
                print("  ℹ️ Page contains 'verification' text")
            if "tweet" in content.lower() or "twitter" in content.lower() or "x.com" in content.lower():
                print("  🐦 Page references Twitter/X (verification likely required)")
            if "claim" in content.lower():
                print("  ℹ️ Page contains 'claim' text")
        
        # Try to fill in verification code if field exists
        try:
            code_input = await page.query_selector('input[name="verification_code"], input[name="code"]')
            if code_input:
                print(f"\n📝 Filling verification code: {VERIFICATION_CODE}")
                await code_input.fill(VERIFICATION_CODE)
        except Exception as e:
            print(f"  Could not fill code: {e}")
        
        # Wait a bit for user to see what's happening
        print("\n⏳ Waiting 5 seconds for page to fully render...")
        await asyncio.sleep(5)
        
        # Take another screenshot
        await page.screenshot(path='moltbook_claim_page_after.png')
        print("📸 Screenshot saved: moltbook_claim_page_after.png")
        
        # Check if there's a Twitter/X verification step
        page_content = await page.content()
        if "twitter.com" in page_content or "x.com" in page_content:
            print("\n🐦 TWITTER/X VERIFICATION REQUIRED")
            print("=" * 60)
            print("The claiming process requires posting a verification tweet.")
            print("\nPlease manually:")
            print("1. Post this tweet from your X/Twitter account:")
            print(f"\n   I'm claiming my AI agent \"{AGENT_NAME}\" on @moltbook 🦞")
            print(f"\n   Verification: {VERIFICATION_CODE}")
            print("\n   #AIagents #Moltbook")
            print("\n2. Copy the tweet URL")
            print("3. Return to this page and paste it")
            print("=" * 60)
        
        # Look for any submit buttons
        buttons = await page.query_selector_all('button')
        print(f"\n🖱️ Found {len(buttons)} buttons on page:")
        for i, button in enumerate(buttons[:5]):  # Show first 5
            text = await button.inner_text()
            print(f"  Button {i+1}: {text[:50] if text else '(no text)'}")
        
        print("\n✅ Browser automation complete")
        print("Check the screenshots to see the claim page state.")
        
        # Keep browser open for a bit if headless=False
        await asyncio.sleep(3)
        
        await browser.close()
        return True

if __name__ == "__main__":
    try:
        result = asyncio.run(claim_agent())
        if result:
            print("\n🎉 Claim automation completed!")
    except Exception as e:
        print(f"\n❌ Error during claiming: {e}")
        import traceback
        traceback.print_exc()
