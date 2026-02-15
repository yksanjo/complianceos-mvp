#!/bin/bash

echo "🚀 Deploying MCP Curator..."

# Deploy backend (MCP Discovery with Curator API)
echo "1. Deploying backend API..."
cd mcp-discovery
vercel --prod --yes

# Get the deployment URL
API_URL=$(vercel --prod --yes 2>&1 | grep -o 'https://[^ ]*' | head -1)
echo "   ✅ Backend deployed to: $API_URL"

# Deploy frontend
echo "2. Deploying frontend dashboard..."
cd ../mcp-curator-dashboard

# Update environment variable with actual API URL
if [ -n "$API_URL" ]; then
    echo "NEXT_PUBLIC_API_URL=$API_URL/api/v1/curator" > .env.production
fi

vercel --prod --yes
FRONTEND_URL=$(vercel --prod --yes 2>&1 | grep -o 'https://[^ ]*' | head -1)
echo "   ✅ Frontend deployed to: $FRONTEND_URL"

echo ""
echo "🎉 Deployment complete!"
echo "Frontend: $FRONTEND_URL"
echo "API: $API_URL/api/v1/curator"
echo ""
echo "Next steps:"
echo "1. Update Supabase RLS policies if needed"
echo "2. Add cost data to more MCP servers"
echo "3. Test the full flow"
echo "4. Share with early users!"
