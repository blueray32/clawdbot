---
name: model-stack
description: Configure model fallback chain with primary and backup models across providers (OpenAI, Google, Anthropic). Set up OAuth/API keys and test the stack.
homepage: https://docs.clawd.bot/concepts/model-failover
metadata: {"clawdbot":{"emoji":"🔄"}}
---

# Model Stack Configuration

Configure a resilient multi-provider model fallback chain.

## Quick Setup

### Step 1: Choose Your Stack

Common configurations:

**OpenAI-first (ChatGPT subscription)**
```
Primary: openai-codex/gpt-5.2
Fallbacks: google-antigravity/gemini-3-pro-high, google-antigravity/gemini-3-pro-low, anthropic/claude-opus-4-5
```

**Gemini-first (Google account)**
```
Primary: google-antigravity/gemini-3-pro-high
Fallbacks: google-antigravity/gemini-3-pro-low, anthropic/claude-opus-4-5, openai-codex/gpt-5.2
```

**Claude-first (Anthropic subscription)**
```
Primary: anthropic/claude-opus-4-5
Fallbacks: google-antigravity/gemini-3-pro-high, google-antigravity/gemini-3-pro-low, openai-codex/gpt-5.2
```

### Step 2: Authenticate Providers

Run these commands interactively for each provider you want to use:

**OpenAI (OAuth - uses ChatGPT subscription)**
```bash
clawdbot onboard --auth-choice openai-codex
```

**Google Antigravity (OAuth)**
```bash
clawdbot onboard --auth-choice google-antigravity
```

**Anthropic (Claude CLI OAuth)**
```bash
clawdbot onboard --auth-choice claude-cli
```

**API Key alternatives:**
```bash
clawdbot onboard --auth-choice openai-api-key
clawdbot onboard --auth-choice gemini-api-key
clawdbot onboard --auth-choice apiKey  # Anthropic
```

### Step 3: Configure the Stack

Set primary model:
```bash
clawdbot config set agents.defaults.model.primary "openai-codex/gpt-5.2"
```

Set fallbacks:
```bash
clawdbot config set agents.defaults.model.fallbacks '["google-antigravity/gemini-3-pro-high", "google-antigravity/gemini-3-pro-low", "anthropic/claude-opus-4-5"]'
```

Or edit `~/.clawdbot/clawdbot.json` directly:
```json
{
  "agents": {
    "defaults": {
      "model": {
        "primary": "openai-codex/gpt-5.2",
        "fallbacks": [
          "google-antigravity/gemini-3-pro-high",
          "google-antigravity/gemini-3-pro-low",
          "anthropic/claude-opus-4-5"
        ]
      }
    }
  }
}
```

### Step 4: Verify & Test

Check configuration:
```bash
clawdbot config get agents.defaults.model
```

List available models:
```bash
clawdbot models list
```

Test the stack:
```bash
clawdbot agent --agent main --message "What model are you?"
```

## Available Models

### OpenAI Codex (OAuth)
- `openai-codex/gpt-5.2` - Latest GPT model

### Google Antigravity (OAuth)
- `google-antigravity/gemini-3-pro-high` - Gemini 3 Pro (high capability)
- `google-antigravity/gemini-3-pro-low` - Gemini 3 Pro (faster/cheaper)
- `google-antigravity/gemini-3-flash` - Gemini 3 Flash (fastest)

### Anthropic
- `anthropic/claude-opus-4-5` - Claude Opus 4.5 (most capable)
- `anthropic/claude-sonnet-4` - Claude Sonnet 4

### Google (API key)
- `google/gemini-3-pro-preview` - Gemini 3 Pro
- `google/gemini-3-flash-preview` - Gemini 3 Flash

## Fallback Behavior

Fallback triggers automatically on:
- HTTP 401 (unauthorized)
- HTTP 402 (payment required)
- Billing/credit errors
- API key validation failures
- Timeout errors

## Model Aliases

Add aliases for quick switching:
```json
{
  "agents": {
    "defaults": {
      "models": {
        "openai-codex/gpt-5.2": { "alias": "gpt" },
        "google-antigravity/gemini-3-pro-high": { "alias": "gemini" },
        "anthropic/claude-opus-4-5": { "alias": "opus" }
      }
    }
  }
}
```

Use inline: `@gpt`, `@gemini`, `@opus`

## Troubleshooting

**Model shows as "missing"**
- Run the auth command for that provider
- Check `clawdbot models list` for exact model IDs

**Fallback not triggering**
- Check `clawdbot doctor` for auth issues
- Verify fallback models are authenticated

**OAuth expired**
- Re-run the onboard command for that provider
