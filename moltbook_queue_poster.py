#!/usr/bin/env python3
"""
Queue-based Moltbook poster - retries every 10 minutes until successful
"""

import time
import json
from datetime import datetime
from share_on_moltbook import (
    share_agentmem,
    share_agentgate,
    share_agentchat_integration,
    share_death_of_saas
)

QUEUE_FILE = ".moltbook_queue.json"

POSTS = {
    "agentmem": ("🧠 AgentMem", share_agentmem),
    "agentgate": ("🔐 AgentGate", share_agentgate),
    "agentchat": ("🤝 AgentChat", share_agentchat_integration),
    "deathofsaas": ("🚨 Death of SaaS", share_death_of_saas),
}


def load_queue():
    try:
        with open(QUEUE_FILE) as f:
            return json.load(f)
    except:
        return {"pending": list(POSTS.keys()), "posted": [], "last_try": None}


def save_queue(q):
    with open(QUEUE_FILE, 'w') as f:
        json.dump(q, f, indent=2)


def try_post(post_key):
    """Try to post, return True if successful"""
    name, func = POSTS[post_key]
    print(f"[{datetime.now().strftime('%H:%M:%S')}] Attempting: {name}")
    
    try:
        result = func()
        if result:
            print(f"  ✅ SUCCESS! Posted: {name}")
            return True
    except Exception as e:
        if "429" in str(e):
            print(f"  ⏳ Rate limited (429) - will retry later")
        else:
            print(f"  ❌ Error: {e}")
    return False


def main():
    queue = load_queue()
    
    print("=" * 60)
    print("🚀 Moltbook Queue Poster")
    print("=" * 60)
    print(f"Pending: {len(queue['pending'])} posts")
    print(f"Posted: {len(queue['posted'])} posts")
    print("-" * 60)
    
    while queue["pending"]:
        current = queue["pending"][0]
        
        if try_post(current):
            queue["posted"].append(current)
            queue["pending"] = queue["pending"][1:]
            queue["last_try"] = datetime.now().isoformat()
            save_queue(queue)
            
            if queue["pending"]:
                print(f"\n⏳ Waiting 1 hour before next post...")
                print(f"Next: {POSTS[queue['pending'][0]][0]}")
                time.sleep(3600)  # 1 hour between successful posts
        else:
            # Failed - wait 10 minutes and retry
            print(f"\n⏳ Waiting 10 minutes before retry...")
            time.sleep(600)  # 10 minutes
    
    print("\n" + "=" * 60)
    print("🎉 All posts completed!")
    print(f"Posted: {', '.join(queue['posted'])}")
    print("=" * 60)


if __name__ == "__main__":
    main()
