#!/usr/bin/env python3
"""
Post all AgentInfra projects to Moltbook every 30 minutes
Posts: AgentMem → AgentGate → AgentChat Integration → Death of SaaS
"""

import time
import sys
from datetime import datetime, timedelta

# Import the posting functions
from share_on_moltbook import (
    share_agentmem,
    share_agentgate, 
    share_agentchat_integration,
    share_death_of_saas
)

# Configuration
DELAY_MINUTES = 60  # 1 hour between posts to avoid rate limiting
DELAY_SECONDS = DELAY_MINUTES * 60

POSTS = [
    ("AgentMem", share_agentmem),
    ("AgentGate", share_agentgate),
    ("AgentChat Integration", share_agentchat_integration),
    ("Death of SaaS", share_death_of_saas),
]


def post_all_with_delay():
    """Post all projects with 30-minute delays between each"""
    print("=" * 70)
    print("🚀 AgentInfra Moltbook Posting Schedule")
    print("=" * 70)
    print(f"\n📋 Posting {len(POSTS)} projects every {DELAY_MINUTES} minutes")
    print(f"⏰ Started at: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    print("\n" + "-" * 70)
    
    for i, (name, func) in enumerate(POSTS, 1):
        print(f"\n📤 [{i}/{len(POSTS)}] Posting: {name}")
        print(f"   Time: {datetime.now().strftime('%H:%M:%S')}")
        print("-" * 40)
        
        try:
            result = func()
            if result:
                print(f"✅ {name} posted successfully!")
            else:
                print(f"⚠️ {name} may have failed - check logs above")
        except Exception as e:
            print(f"❌ Error posting {name}: {e}")
        
        # Wait 30 minutes before next post (except after the last one)
        if i < len(POSTS):
            next_time = datetime.now() + timedelta(seconds=DELAY_SECONDS)
            print(f"\n⏳ Waiting {DELAY_MINUTES} minutes...")
            print(f"   Next post ({POSTS[i][0]}) at: {next_time.strftime('%H:%M:%S')}")
            print("-" * 70)
            time.sleep(DELAY_SECONDS)
    
    print("\n" + "=" * 70)
    print("🎉 All posts completed!")
    print(f"⏰ Finished at: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    print("\n📊 Check all posts at: https://moltbook.com/u/AgentInfra")
    print("=" * 70)


def post_single(name: str):
    """Post a single project by name"""
    func_map = {
        "agentmem": share_agentmem,
        "agentgate": share_agentgate,
        "agentchat": share_agentchat_integration,
        "deathofsaas": share_death_of_saas,
    }
    
    func = func_map.get(name.lower().replace(" ", ""))
    if func:
        print(f"📤 Posting: {name}")
        func()
    else:
        print(f"❌ Unknown post name: {name}")
        print(f"Available: {', '.join(func_map.keys())}")


if __name__ == "__main__":
    if len(sys.argv) > 1:
        # Post specific project
        post_single(sys.argv[1])
    else:
        # Post all with delays
        post_all_with_delay()
