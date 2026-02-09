#!/bin/bash
# Paddy-fy Script - Surgical Rebranding of OpenClaw to Paddy
# Run this from the OpenClaw root directory after updates.

echo "🍀 Applying Paddy's Surgical Rebranding..."

# 1. Update UI Window Title
if [ -f ui/index.html ]; then
  sed -i '' 's/<title>OpenClaw Control<\/title>/<title>Paddy Control<\/title>/g' ui/index.html
fi

# 1.1 Update App Icon to Shamrock (SKIPPED - USING LEPRECHAUN)
# if [ -d ui/public ]; then
# cat <<EOF > ui/public/favicon.svg
# <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100">
#   <path fill="#2e7d32" d="M50 50 L50 90 M50 50 Q30 50 30 30 Q30 10 50 10 Q70 10 70 30 Q70 50 50 50 M50 50 Q50 30 70 30 Q90 30 90 50 Q90 70 70 70 Q50 70 50 50 M50 50 Q50 70 30 70 Q10 70 10 50 Q10 30 30 30 Q50 30 50 50" />
# </svg>
# EOF
# fi

# 2. Update UI Dashboard Header and Labels
if [ -f ui/src/ui/app-render.ts ]; then
  sed -i '' 's/<div class="brand-title">OPENCLAW<\/div>/<div class="brand-title">PADDY<\/div>/g' ui/src/ui/app-render.ts
  sed -i '' "s/brand-sub\">Gateway Dashboard/brand-sub\">Paddy's Hearth/g" ui/src/ui/app-render.ts
  sed -i '' 's/alt="OpenClaw"/alt="Paddy"/g' ui/src/ui/app-render.ts
fi

# 2.1 Update Navigation Group Labels
if [ -f ui/src/ui/navigation.ts ]; then
  sed -i '' 's/label: "Chat"/label: "Paddy"/g' ui/src/ui/navigation.ts
  sed -i '' 's/label: "Control"/label: "Hearth"/g' ui/src/ui/navigation.ts
  sed -i '' 's/label: "Agent"/label: "The Clan"/g' ui/src/ui/navigation.ts
  sed -i '' 's/label: "Settings"/label: "The Keep"/g' ui/src/ui/navigation.ts
  
  # Update Navigation Icons
  sed -i '' 's/case "agents":\n      return "folder"/case "agents":\n      return "users"/g' ui/src/ui/navigation.ts
  sed -i '' 's/case "chat":\n      return "messageSquare"/case "chat":\n      return "shamrock"/g' ui/src/ui/navigation.ts
  sed -i '' 's/case "overview":\n      return "barChart"/case "overview":\n      return "home"/g' ui/src/ui/navigation.ts
  sed -i '' 's/case "config":\n      return "settings"/case "config":\n      return "shield"/g' ui/src/ui/navigation.ts
fi

# 2.3 Systematic String Replacements in Source (User-facing ONLY)
# We target specific common display strings in the CLI and auto-reply outputs
if [ -f src/auto-reply/status.ts ]; then
  sed -i '' "s/\"OpenClaw status\"/\"Paddy status\"/g" src/auto-reply/status.ts
  sed -i '' "s/🦞/🍀/g" src/auto-reply/status.ts
fi
if [ -f src/commands/status.command.ts ]; then
  sed -i '' "s/OpenClaw status/Paddy status/g" src/commands/status.command.ts
  sed -i '' "s/openclaw status/paddy status/g" src/commands/status.command.ts
  sed -i '' "s/openclaw logs/paddy logs/g" src/commands/status.command.ts
  sed -i '' "s/openclaw security/paddy security/g" src/commands/status.command.ts
fi

# CLI Banner & Tagline
if [ -f src/cli/banner.ts ]; then
  sed -i '' 's/const title = "🦞 OpenClaw";/const title = "🍀 Paddy";/g' src/cli/banner.ts
  sed -i '' 's/title = "🦞 OpenClaw"/title = "🍀 Paddy"/g' src/cli/banner.ts
fi
if [ -f src/cli/tagline.ts ]; then
  sed -i '' 's/DEFAULT_TAGLINE = ".*"/DEFAULT_TAGLINE = "Paddy'\''s Hearth - Your Agentic Irish Home."/g' src/cli/tagline.ts
fi

# Rebrand Bonjour/Network strings
if [ -f src/infra/bonjour.ts ]; then
  sed -i '' 's/return trimmed.length > 0 ? trimmed : "OpenClaw";/return trimmed.length > 0 ? trimmed : "Paddy";/g' src/infra/bonjour.ts
  sed -i '' 's/ (OpenClaw)/ (Paddy)/g' src/infra/bonjour.ts
fi

# 2.4 Update Chat Input Placeholders
if [ -f ui/src/ui/views/chat.ts ]; then
  sed -i '' 's/Connect to the gateway to start chatting…/Welcome to the Hearth, start chatting…/g' ui/src/ui/views/chat.ts
  sed -i '' 's/Message (↩ to send, Shift+↩ for line breaks, paste images)/Speak to Paddy (↩ to send)/g' ui/src/ui/views/chat.ts
fi

# 2.5 Apply Celtic Night Branding (Deep Moss & Glass)
if [ -f ui/src/styles/base.css ]; then
  sed -i '' 's/--bg: #12141a;/--bg: #0b0d0c;/g' ui/src/styles/base.css
  sed -i '' 's/--ring: #ff5c5c;/--ring: #2e7d32;/g' ui/src/styles/base.css
  sed -i '' 's/--accent: #ff5c5c;/--accent: #2e7d32;/g' ui/src/styles/base.css
  sed -i '' 's/rgba(255, 92, 92,/rgba(46, 125, 50,/g' ui/src/styles/base.css
  sed -i '' 's/--card: #181b22;/--card: rgba(20, 24, 22, 0.7);/g' ui/src/styles/base.css
  if ! grep -q "radial-gradient" ui/src/styles/base.css; then
    sed -i '' "s/background: var(--bg);/background: var(--bg); background-image: radial-gradient(circle at 50% -20%, rgba(46, 125, 50, 0.15) 0%, transparent 60%);/g" ui/src/styles/base.css
  fi
fi

# 3. Add 'paddy' to CLI binaries in package.json
if ! grep -q '"paddy":' package.json; then
  sed -i '' 's/"openclaw": "openclaw.mjs"/"openclaw": "openclaw.mjs",\n    "paddy": "openclaw.mjs"/g' package.json
fi

# 4. Rebuild UI
pnpm ui:build

# 5. Update global install
npm install -g .

echo "🍀 Done! The system has been surgically Paddy-fied."
