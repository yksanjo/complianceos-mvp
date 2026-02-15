#!/bin/bash

echo "🔍 Checking Stripe Setup in electrical-estimator-ai"
echo "=================================================="

# Check if in correct directory
if [ ! -f "package.json" ]; then
    echo "❌ Not in project root. Run from electrical-estimator-ai directory."
    exit 1
fi

echo ""
echo "1. Checking Stripe dependencies..."
if npm list stripe 2>/dev/null | grep -q "stripe@"; then
    echo "   ✅ Stripe package installed"
else
    echo "   ❌ Stripe package not found"
fi

if npm list @stripe/stripe-js 2>/dev/null | grep -q "@stripe/stripe-js@"; then
    echo "   ✅ @stripe/stripe-js package installed"
else
    echo "   ❌ @stripe/stripe-js package not found"
fi

echo ""
echo "2. Checking environment variables..."
if [ -f ".env.local" ]; then
    echo "   ✅ .env.local file exists"
    
    if grep -q "STRIPE_SECRET_KEY" .env.local; then
        STRIPE_KEY=$(grep "STRIPE_SECRET_KEY" .env.local | cut -d'=' -f2)
        if [[ $STRIPE_KEY == sk_test* ]] || [[ $STRIPE_KEY == sk_live* ]]; then
            echo "   ✅ STRIPE_SECRET_KEY looks valid"
        else
            echo "   ⚠️  STRIPE_SECRET_KEY may be a placeholder: $STRIPE_KEY"
        fi
    else
        echo "   ❌ STRIPE_SECRET_KEY not found in .env.local"
    fi
    
    if grep -q "STRIPE_WEBHOOK_SECRET" .env.local; then
        echo "   ✅ STRIPE_WEBHOOK_SECRET found"
    else
        echo "   ❌ STRIPE_WEBHOOK_SECRET not found"
    fi
    
    if grep -q "NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY" .env.local; then
        PUB_KEY=$(grep "NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY" .env.local | cut -d'=' -f2)
        if [[ $PUB_KEY == pk_test* ]] || [[ $PUB_KEY == pk_live* ]]; then
            echo "   ✅ NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY looks valid"
        else
            echo "   ⚠️  NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY may be a placeholder: $PUB_KEY"
        fi
    else
        echo "   ❌ NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY not found"
    fi
else
    echo "   ❌ .env.local file not found"
fi

echo ""
echo "3. Checking Stripe API routes..."
if [ -f "app/api/stripe/webhook/route.ts" ]; then
    echo "   ✅ Webhook route exists"
else
    echo "   ❌ Webhook route missing"
fi

if [ -f "app/api/stripe/create-checkout-session/route.ts" ]; then
    echo "   ✅ Checkout session route exists"
else
    echo "   ❌ Checkout session route missing"
fi

if [ -f "app/api/stripe/create-portal-session/route.ts" ]; then
    echo "   ✅ Customer portal route exists"
else
    echo "   ❌ Customer portal route missing"
fi

echo ""
echo "4. Checking Stripe configuration..."
if [ -f "lib/stripe.ts" ]; then
    echo "   ✅ Stripe config file exists"
    
    if grep -q "STRIPE_PLANS" lib/stripe.ts; then
        echo "   ✅ Subscription plans defined"
    else
        echo "   ❌ Subscription plans not defined"
    fi
else
    echo "   ❌ Stripe config file missing"
fi

echo ""
echo "5. Checking database schema..."
if [ -f "supabase/schema.sql" ]; then
    if grep -q "subscription_status" supabase/schema.sql; then
        echo "   ✅ Subscription fields in database schema"
    else
        echo "   ❌ Subscription fields missing from schema"
    fi
else
    echo "   ⚠️  Database schema file not found"
fi

echo ""
echo "=================================================="
echo "📋 Summary:"
echo ""
echo "To complete setup:"
echo "1. Get Stripe API keys from https://dashboard.stripe.com/test/apikeys"
echo "2. Update .env.local with your keys"
echo "3. Create products in Stripe Dashboard and update price IDs"
echo "4. Test with: stripe listen --forward-to localhost:3000/api/stripe/webhook"
echo "5. Deploy to Vercel and add environment variables"
echo ""
echo "Run this script again after making changes to verify setup."