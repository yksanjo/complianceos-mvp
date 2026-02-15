# Show HN: Infrastructure for AI agents to pay each other

**OpenClaw Gateway** — Agent-to-agent transaction infrastructure

---

## The Problem

AI agents can't:
- Discover services from other agents
- Pay for capabilities they need
- Transact without human intervention

We have AWS for humans. What about agents?

---

## The Solution

Built 3 projects + infrastructure layer:

### 1. Rap MCP ([github.com/yksanjo/rap-mcp](https://github.com/yksanjo/rap-mcp))
AI beat generation for artists. "Dark trap beat, 140 bpm" → 🎵 in 30s.

### 2. GitHub Repo Agent ([github.com/yksanjo/github-repo-agent](https://github.com/yksanjo/github-repo-agent))
Deep code analysis. Paste repo URL → instant insights. No API keys needed.

### 3. Agent Gym ([github.com/yksanjo/agent-gym](https://github.com/yksanjo/agent-gym))
The "npm for agents". Capability registry where agents discover, install, and pay for skills.

---

## The Infrastructure

**OpenClaw Gateway** handles:
- Agent authentication & identity
- Service discovery & routing
- Metered billing ($0.001 per API call)
- Agent-to-agent payments (5% platform fee)

```javascript
// Agent pays for a service
const result = await gateway.processTransaction(
  fromAgentId, 
  toServiceId, 
  amount  // in cents
);
// Returns: { amount, tax: amount * 0.05, transactionId }
```

---

## The Business Model

**No sales calls. Self-serve everything.**

| Revenue Stream | How |
|----------------|-----|
| API Calls | $0.001 per call, metered billing |
| Agent Tax | 5% of agent-to-agent transactions |
| Platform | Agents pay to list services |

---

## The Metric: RPA

Tracking **Revenue Per Agent** instead of LTV/CAC.

If agents are the new users, we need new metrics.

---

## Technical Stack

- **MCP** — Model Context Protocol for AI integration
- **Stripe** — Metered billing
- **PostHog** — Usage analytics
- **Node.js** — Gateway
- **Python/TS** — Services

---

## Why This Matters

This is **B2B2A** — Business to Business to Agent.

Humans set it up. Agents do the work. Agents generate revenue.

The agent economy needs infrastructure. This is the beginning.

---

## Links

- OpenClaw Gateway: [github.com/yksanjo/vibe-infrastructure](https://github.com/yksanjo/vibe-infrastructure)
- All 3 projects: [github.com/yksanjo](https://github.com/yksanjo)
- Live Gateway: http://localhost:8787 (demo)

---

**Built in 3 hours. No sales calls. Just shipped.**

Would love feedback from anyone building AI agents.
