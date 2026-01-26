# Feature: Configure Model Fallback Chain

The following plan should be complete, but it's important that you validate documentation and codebase patterns and task sanity before you start implementing.

Pay special attention to naming of existing utils types and models. Import from the right files etc.

## Feature Description

Configure the Clawdbot model stack with OpenAI OAuth as the primary model, followed by a fallback chain of Gemini Pro 3 High, Gemini Pro 3 Flash (low), and Claude Opus 4.5. This establishes a resilient multi-provider model configuration that automatically fails over between providers.

## User Story

As a Clawdbot user
I want to use OpenAI as my primary model with Gemini and Claude as fallbacks
So that I have resilient AI responses across multiple providers

## Problem Statement

The current default configuration uses Anthropic Claude Opus 4.5 as the sole model. The user wants to:
1. Switch primary model to OpenAI (via OAuth authentication)
2. Add Gemini Pro 3 (high/pro variant) as first fallback
3. Add Gemini Pro 3 (low/flash variant) as second fallback
4. Keep Claude Opus 4.5 as final fallback

## Solution Statement

Configure the model fallback chain through:
1. Running OpenAI Codex OAuth authentication flow
2. Updating `~/.clawdbot/config.yaml` to set model primary and fallbacks
3. Optionally setting up Google Gemini authentication for fallback

## Feature Metadata

**Feature Type**: Enhancement
**Estimated Complexity**: Low
**Primary Systems Affected**: Model configuration, Auth profiles
**Dependencies**: OpenAI Codex OAuth, Gemini API (optional for fallback)

---

## CONTEXT REFERENCES

### Relevant Codebase Files IMPORTANT: YOU MUST READ THESE FILES BEFORE IMPLEMENTING!

- `src/agents/defaults.ts` (lines 1-6) - Why: Current default model configuration
- `src/config/types.agent-defaults.ts` (lines 21-24) - Why: AgentModelListConfig type definition (primary + fallbacks)
- `src/commands/openai-codex-model-default.ts` (lines 1-50) - Why: Pattern for setting OpenAI as default model
- `src/commands/google-gemini-model-default.ts` (lines 1-42) - Why: Pattern for Gemini model configuration
- `src/agents/model-fallback.ts` (lines 1-100) - Why: Fallback resolution logic
- `src/commands/auth-choice.apply.openai.ts` (lines 74-147) - Why: OpenAI Codex OAuth flow
- `src/agents/models-config.providers.ts` (lines 163-164) - Why: Gemini model ID normalization

### Model Identifiers

| Provider | Model ID | Description |
|----------|----------|-------------|
| OpenAI Codex | `openai-codex/gpt-5.2` | Primary - OpenAI OAuth model |
| Google | `google/gemini-3-pro-preview` | Fallback 1 - Gemini Pro 3 (high) |
| Google | `google/gemini-3-flash-preview` | Fallback 2 - Gemini Pro 3 (low/flash) |
| Anthropic | `anthropic/claude-opus-4-5` | Fallback 3 - Claude Opus 4.5 |

### Configuration Location

- Config file: `~/.clawdbot/config.yaml`
- Auth profiles: `~/.clawdbot/agents/<agentId>/auth-profiles.json`

### Patterns to Follow

**Model Configuration Pattern** (from `types.agent-defaults.ts`):
```typescript
type AgentModelListConfig = {
  primary?: string;      // e.g., "openai-codex/gpt-5.2"
  fallbacks?: string[];  // e.g., ["google/gemini-3-pro-preview", ...]
};
```

**Config YAML Structure**:
```yaml
agents:
  defaults:
    model:
      primary: "openai-codex/gpt-5.2"
      fallbacks:
        - "google/gemini-3-pro-preview"
        - "google/gemini-3-flash-preview"
        - "anthropic/claude-opus-4-5"
```

---

## IMPLEMENTATION PLAN

### Phase 1: Authentication Setup

Set up OpenAI Codex OAuth authentication to enable the primary model.

**Tasks:**
- Run `clawdbot onboard --auth-choice openai-codex` to authenticate with OpenAI
- Verify OAuth credentials are stored in auth-profiles.json

### Phase 2: Model Configuration

Configure the model fallback chain in the Clawdbot config.

**Tasks:**
- Update config.yaml with the model fallback chain
- Optionally set up Gemini API key for fallback reliability

### Phase 3: Validation

Verify the configuration is working correctly.

**Tasks:**
- Test primary model (OpenAI)
- Test fallback triggers by simulating auth failure
- Verify each model in the chain works

---

## STEP-BY-STEP TASKS

### Task 1: SET UP OpenAI Codex OAuth

Run the onboarding flow to authenticate with OpenAI Codex.

```bash
clawdbot onboard --auth-choice openai-codex
```

- **IMPLEMENT**: Complete the OAuth flow in browser when prompted
- **PATTERN**: OAuth flow from `src/commands/auth-choice.apply.openai.ts:74-147`
- **VALIDATE**: Check `~/.clawdbot/agents/main/auth-profiles.json` contains `openai-codex:default` profile

### Task 2: UPDATE config.yaml with model fallback chain

Manually edit or use `clawdbot config set` to update the model configuration.

**Option A: Using CLI**
```bash
clawdbot config set agents.defaults.model.primary "openai-codex/gpt-5.2"
clawdbot config set agents.defaults.model.fallbacks '["google/gemini-3-pro-preview", "google/gemini-3-flash-preview", "anthropic/claude-opus-4-5"]'
```

**Option B: Direct YAML edit**
Edit `~/.clawdbot/config.yaml`:
```yaml
agents:
  defaults:
    model:
      primary: "openai-codex/gpt-5.2"
      fallbacks:
        - "google/gemini-3-pro-preview"
        - "google/gemini-3-flash-preview"
        - "anthropic/claude-opus-4-5"
```

- **PATTERN**: Config structure from `src/config/types.agent-defaults.ts:21-24`
- **GOTCHA**: Model IDs must use exact format with provider prefix
- **VALIDATE**: `clawdbot config get agents.defaults.model`

### Task 3: (OPTIONAL) SET UP Gemini API key for fallback

If you want Gemini fallback to work reliably, set up a Gemini API key.

**Option A: Via onboarding**
```bash
clawdbot onboard --auth-choice gemini-api-key
```

**Option B: Via environment variable**
```bash
export GEMINI_API_KEY="your-api-key"
```

- **PATTERN**: Gemini auth from `src/commands/auth-choice-options.ts:77-81`
- **VALIDATE**: `clawdbot doctor` should show Google/Gemini as available

### Task 4: (OPTIONAL) VERIFY Anthropic credentials for final fallback

Ensure Claude Opus 4.5 is available as the final fallback.

```bash
# Check if Claude CLI credentials exist
clawdbot doctor
```

If not configured:
```bash
clawdbot onboard --auth-choice claude-cli
```

- **VALIDATE**: `clawdbot models list` should show anthropic provider

### Task 5: VALIDATE full configuration

Test the complete model configuration.

```bash
# Check current model configuration
clawdbot config get agents.defaults.model

# Test agent with primary model
clawdbot agent --message "Hello, test message" --thinking low

# Check model status
clawdbot status --all
```

- **VALIDATE**: Response comes from OpenAI (check logs or response metadata)

---

## TESTING STRATEGY

**Testing Prioritization:**
- **Essential Tests**: Primary model responds, fallback chain configured
- **Demo Tests**: Basic agent interaction works
- **Production Tests**: Simulate auth failures to test failover

### Manual Tests

1. **Primary Model Test**:
   ```bash
   clawdbot agent --message "What model are you?"
   ```
   Expected: Response from OpenAI GPT model

2. **Config Verification**:
   ```bash
   clawdbot config get agents.defaults.model
   ```
   Expected: Shows primary + 3 fallbacks

3. **Status Check**:
   ```bash
   clawdbot status
   ```
   Expected: Shows active model configuration

---

## VALIDATION COMMANDS

Execute every command to ensure zero regressions and 100% feature correctness.

### Level 1: Config Validation

```bash
# Verify model config structure
clawdbot config get agents.defaults.model
```

Expected output:
```yaml
primary: openai-codex/gpt-5.2
fallbacks:
  - google/gemini-3-pro-preview
  - google/gemini-3-flash-preview
  - anthropic/claude-opus-4-5
```

### Level 2: Auth Profile Validation

```bash
# Check auth profiles exist
clawdbot doctor
```

Expected: OpenAI Codex credentials should show as valid

### Level 3: Integration Test

```bash
# Send test message
clawdbot agent --message "Respond with just: OK"
```

Expected: Response from primary model (OpenAI)

### Level 4: Fallback Test (Optional)

To test fallback behavior, temporarily invalidate OpenAI credentials and verify Gemini takes over.

---

## DOCUMENTATION UPDATES

**Required Documentation Changes:**
- None required for personal configuration

---

## ACCEPTANCE CRITERIA

- [x] OpenAI Codex OAuth authentication completed
- [x] Config.yaml updated with model fallback chain
- [x] Primary model set to `openai-codex/gpt-5.2`
- [x] First fallback set to `google/gemini-3-pro-preview`
- [x] Second fallback set to `google/gemini-3-flash-preview`
- [x] Third fallback set to `anthropic/claude-opus-4-5`
- [x] Agent responds successfully with primary model
- [x] `clawdbot doctor` shows no auth issues

---

## COMPLETION CHECKLIST

- [ ] OpenAI Codex OAuth completed
- [ ] Model config updated in config.yaml
- [ ] Config get shows correct model chain
- [ ] Agent test message works
- [ ] (Optional) Gemini API key configured
- [ ] (Optional) Anthropic credentials verified

---

## NOTES

**Fallback Trigger Conditions** (from `src/agents/model-fallback.ts`):
- HTTP 401 (unauthorized)
- HTTP 402 (payment required)
- Billing/credit errors
- Credential validation errors
- Timeout errors

**Model ID Normalization**:
- `gemini-3-pro` → `gemini-3-pro-preview` (automatic)
- `gemini-3-flash` → `gemini-3-flash-preview` (automatic)

**Alternative: Quick Setup Commands**:
```bash
# One-liner to set all at once (if using jq-style config)
clawdbot config set agents.defaults.model '{"primary":"openai-codex/gpt-5.2","fallbacks":["google/gemini-3-pro-preview","google/gemini-3-flash-preview","anthropic/claude-opus-4-5"]}'
```
