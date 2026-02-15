# Stripe Products Suite

A collection of 8 products designed to address gaps in the Stripe ecosystem and demonstrate value to Stripe.

## Products

### 1. [stripe-integration-risk-scanner](./stripe-integration-risk-scanner)
**CLI tool that scans Stripe integrations for security risks and best practice violations**

- Scans for dangerous API usage, missing idempotency keys, insecure webhooks, PCI/SCA misconfigurations
- Outputs risk score and detailed checklist
- Multiple output formats: console, JSON, HTML

**Quick Start:**
```bash
cd stripe-integration-risk-scanner
npm install
npm run build
stripe-audit --key sk_test_...
```

**Why Stripe Cares:** Reduces platform-wide fraud, improves developer quality, lowers support load

---

### 2. [stripe-revenue-leak-detector](./stripe-revenue-leak-detector)
**Dashboard that detects silent revenue loss in Stripe integrations**

- Detects failed payments not retried, expired cards, unpaid invoices, subscription downgrades, refund abuse
- Shows "you lost $X last month because of Y"
- One-click suggestions to enable Stripe features

**Quick Start:**
```bash
cd stripe-revenue-leak-detector
npm install
# Set STRIPE_SECRET_KEY in .env.local
npm run dev
```

**Why Stripe Cares:** Directly increases merchant GMV → more Stripe fees

---

### 3. [stripe-compliance-as-code](./stripe-compliance-as-code)
**Config-based compliance engine for Stripe payments**

- Define rules in YAML/JSON: country blocks, 3DS requirements, prepaid card blocks
- Automatic enforcement via Radar, Payment Intents, and webhooks
- CLI tool + webhook server

**Quick Start:**
```bash
cd stripe-compliance-as-code
npm install
npm run build
stripe-compliance validate examples/compliance.yaml
```

**Why Stripe Cares:** Helps enterprises maintain compliance, reduces regulatory exposure

---

### 4. [stripe-account-health-scoring](./stripe-account-health-scoring)
**Account health "credit score" dashboard for Stripe accounts**

- Calculates health score from chargebacks, refunds, volume spikes, cross-border risk, webhook failures
- Predictive alerts: "what Stripe might flag next"
- Historical trend visualization

**Quick Start:**
```bash
cd stripe-account-health-scoring
npm install
# Set STRIPE_SECRET_KEY in .env.local
npm run dev
```

**Why Stripe Cares:** Early fraud detection, prevents last-minute account shutdowns

---

### 5. [stripe-reconciliation-engine](./stripe-reconciliation-engine)
**Reconciliation layer that balances Stripe vs accounting books**

- Handles partial refunds, fees vs gross, multi-currency FX drift, disputes timing mismatch
- Export reconciliation reports (CSV/JSON)
- Webhook integration for real-time sync

**Quick Start:**
```bash
cd stripe-reconciliation-engine
npm install
npm run build
npm start
# Visit http://localhost:3000/reconcile
```

**Why Stripe Cares:** Biggest enterprise complaint - CFOs need accurate reconciliation

---

### 6. [stripe-webhook-chaos-tester](./stripe-webhook-chaos-tester)
**Chaos testing tool for Stripe webhooks**

- Tests delayed delivery, duplicate events, out-of-order events, partial payload failures
- Scenario-based testing
- GitHub Action integration

**Quick Start:**
```bash
cd stripe-webhook-chaos-tester
npm install
npm run build
stripe-chaos test --url https://your-webhook.com/webhook --scenario delayed
```

**Why Stripe Cares:** Reduces outages blamed on Stripe, improves platform resilience

---

### 7. [stripe-kill-switch](./stripe-kill-switch)
**Emergency control panel for Stripe accounts**

- Instantly pause payments, block products, lock refunds, freeze subscriptions
- Audit logging for all emergency actions
- One-click panic buttons

**Quick Start:**
```bash
cd stripe-kill-switch
npm install
# Set STRIPE_SECRET_KEY in .env.local
npm run dev
```

**Why Stripe Cares:** Reduces fraud cascades, saves Stripe from emergency account shutdowns

---

### 8. [stripe-ai-policy-explainer](./stripe-ai-policy-explainer)
**AI-powered policy explanation tool**

- Explains "Why was my account flagged?", "Why is Radar blocking this payment?", "What behavior will get me shut down?"
- Interpretable summaries (no secrets exposed)
- Chat interface with context-aware explanations

**Quick Start:**
```bash
cd stripe-ai-policy-explainer
npm install
# Set OPENAI_API_KEY and STRIPE_SECRET_KEY in .env.local
npm run dev
```

**Why Stripe Cares:** Reduces support tickets, improves trust, prevents merchants gaming blindly

---

## Common Setup

All products require:
- Node.js 18+
- Stripe API key (test or live)
- npm or yarn

Most Next.js products also need:
- Environment variables in `.env.local`
- `npm install` then `npm run dev`

CLI tools need:
- `npm install` then `npm run build`
- Run via `npm start` or the binary command

## Status

All products are MVP-ready with:
- ✅ Full implementation
- ✅ README documentation
- ✅ Proper project structure
- ✅ TypeScript types
- ✅ Error handling
- ✅ MIT License

## Next Steps

1. Push each repo to GitHub as separate repositories
2. Add Stripe API keys for testing
3. Deploy Next.js apps to Vercel
4. Publish CLI tools to npm
5. Create demo videos/GIFs
6. Share with Stripe team

## License

All products are MIT licensed.


