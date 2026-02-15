#!/usr/bin/env python3
"""
Simple Moltbook Claim Page Inspector
"""

import asyncio
from playwright.async_api import async_playwright

async def inspect_claim_page():
    async with async_playwright() as p:
        browser = await p.chromium.launch(headless=True)
        page = await browser.new_page()
        
        print("🚀 Loading claim page...")
        await page.goto("https://moltbook.com/claim/moltbook_claim_WgCaR8DMRF_tccwZlNdqfLLoTAWzPtzr", timeout=30000)
        await page.wait_for_load_state('networkidle', timeout=10000)
        
        # Get page text content
        text = await page.inner_text('body')
        print("\n📄 Page content:")
        print("-" * 60)
        print(text[:2000])  # First 2000 chars
        print("-" * 60)
        
        # Check for verification requirements
        text_lower = text.lower()
        if "tweet" in text_lower or "twitter" in text_lower or "x.com" in text_lower:
            print("\n🐦 VERIFICATION METHOD: Twitter/X tweet required")
        elif "email" in text_lower:
            print("\n📧 VERIFICATION METHOD: Email verification available")
        elif "code" in text_lower:
            print("\n🔑 VERIFICATION METHOD: Code verification available")
        
        # Look for input fields
        inputs = await page.query_selector_all('input')
        print(f"\n📝 Found {len(inputs)} input fields")
        
        buttons = await page.query_selector_all('button')
        print(f"🖱️ Found {len(buttons)} buttons")
        
        await browser.close()

if __name__ == "__main__":
    asyncio.run(inspect_claim_page())
