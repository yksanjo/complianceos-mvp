#!/usr/bin/env python3
"""
Smart Moltbook poster with rate limit handling and exponential backoff
Posts: AgentMem → AgentGate → AgentChat Integration → Death of SaaS
"""

import time
import sys
from datetime import datetime, timedelta

from share_on_moltbook import (
    share_agentmem,
    share_agentgate, 
    share_agentchat_integration,
    share_death_of_saas
)

POSTS = [
    ("AgentMem", share_agentmem),
    ("AgentGate", share_agentgate),
    ("AgentChat Integration", share_agentchat_integration),
    ("Death of SaaS", share_death_of_saas),
]


def post_with_retry(post_func, max_retries=5):
    """Post with exponential backoff on rate limit"""
    for attempt in range(max_retries):
        try:
            result = post_func()
            if result:
                return True, result
            return False, None
        except Exception as e:
            if "429" in str(e):
                wait_time = min(300 * (2 ** attempt), 3600)  # Exponential backoff, max 1 hour
                print(f"   ⚠️ Rate limited (429). Waiting {wait_time//60} minutes before retry {attempt+1}/{max_retries}...")
                time.sleep(wait_time)
            else:
                print(f"   ❌ Error: {e}")
                return False, None
    return False, None


def post_all():
    """Post all projects with smart rate limit handling"""
    print("=" * 70)
    print("🚀 AgentInfra Smart Moltbook Poster")
    print("=" * 70)
    print(f"\n📋 Posting {len(POSTS)} projects")
    print(f"⏰ Started at: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    print("-" * 70)
    
    for i, (name, func) in enumerate(POSTS, 1):
        print(f"\n📤 [{i}/{len(POSTS)}] Posting: {name}")
        print(f"   Time: {datetime.now().strftime('%H:%M:%S')}")
        
        success, result = post_with_retry(func)
        
        if success:
            print(f"   ✅ {name} posted successfully!")
        else:
            print(f"   ❌ {name} failed after retries")
        
        # Wait 1 hour between posts to be safe
        if i < len(POSTS):
            next_post_time = datetime.now() + timedelta(hours=1)
            print(f"\n   ⏳ Waiting 1 hour before next post...")
            print(f"   Next ({POSTS[i][0]}) at ~{next_post_time.strftime('%H:%M')}")
            print("-" * 70)
            time.sleep(3600)  # 1 hour
    
    print("\n" + "=" * 70)
    print("🎉 All posts completed!")
    print(f"⏰ Finished at: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    print("📊 Check: https://moltbook.com/u/AgentInfra")
    print("=" * 70)


if __name__ == "__main__":
    post_all()
