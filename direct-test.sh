#!/bin/bash

echo "🔧 DIRECT TELEGRAM BOT TEST"
echo "============================"

BOT_TOKEN="8208452855:AAGdgNAUCJ6Lgq_un5Lh86iTW8XTbHc12Lg"

echo ""
echo "1. Testing if YOU have messaged the bot recently..."
echo "   (Checking for your messages in updates)"

# Get updates to see if you've messaged the bot
UPDATES=$(curl -s "https://api.telegram.org/bot${BOT_TOKEN}/getUpdates")
echo "$UPDATES" | python3 -c "
import json, sys
data = json.load(sys.stdin)
if data['ok'] and data['result']:
    print('   📨 RECENT MESSAGES FOUND!')
    for update in data['result'][-3:]:  # Show last 3 messages
        msg = update.get('message', {})
        if msg:
            user = msg.get('from', {})
            text = msg.get('text', '')
            print(f'   👤 {user.get(\"first_name\", \"Unknown\")}: {text}')
else:
    print('   📭 No recent messages from you')
    print('   Have you messaged @Omamoribotbot on Telegram?')
"

echo ""
echo "2. Can YOU send a message RIGHT NOW?"
echo ""
echo "📱 DO THIS NOW:"
echo "1. Open Telegram on your phone/desktop"
echo "2. Search for @Omamoribotbot"
echo "3. Click 'Start' or send /start"
echo "4. Send 'Test' or 'Hello'"
echo ""
echo "Then press Enter here to check..."
read -p "Press Enter after sending a message..."

echo ""
echo "3. Checking for your new message..."
sleep 2
NEW_UPDATES=$(curl -s "https://api.telegram.org/bot${BOT_TOKEN}/getUpdates")
echo "$NEW_UPDATES" | python3 -c "
import json, sys
data = json.load(sys.stdin)
if data['ok'] and data['result']:
    last_msg = data['result'][-1] if data['result'] else None
    if last_msg:
        msg = last_msg.get('message', {})
        user = msg.get('from', {})
        text = msg.get('text', '')
        print(f'   ✅ GOT YOUR MESSAGE!')
        print(f'   👤 From: {user.get(\"first_name\", \"Unknown\")}')
        print(f'   💬 Text: {text}')
        
        # Try to send a response
        chat_id = msg.get('chat', {}).get('id')
        if chat_id:
            import subprocess
            response = f'Hello! I received: {text}'
            cmd = f'curl -s -X POST https://api.telegram.org/bot{BOT_TOKEN}/sendMessage -d \"chat_id={chat_id}\" -d \"text={response}\"'
            result = subprocess.run(cmd, shell=True, capture_output=True, text=True)
            if '\"ok\":true' in result.stdout:
                print('   📤 SENT RESPONSE BACK! Check Telegram')
            else:
                print('   ❌ Could not send response')
else:
    print('   ❌ Still no messages. Did you message the bot?')
"

echo ""
echo "============================"
echo "SUMMARY:"
echo "If you see 'GOT YOUR MESSAGE!' above, the bot IS working."
echo "If not, there might be:"
echo "1. Network/firewall issues"
echo "2. Wrong Telegram account"
echo "3. Bot blocked/deleted"
echo ""
echo "Try messaging @Omamoribotbot from a DIFFERENT device/account"
echo "============================"