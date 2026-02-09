# MEMORY.md

## User Profile: Ciaran Cox

- Location: Dublin, Ireland
- Occupation/Interests: BIM, Revit, AI Coding, Web Development
- Tech Stack: Docker, Python, JavaScript/TypeScript, Obsidian
- **AI Learning:** Dynamous AI Mastery community (Cole Medin) - see `memory/dynamous-ai.md` for detailed tracking

## Messaging Preferences

- Mark Mcweeney: treat as high-priority (IT expert + good friend). Banter ok, but keep replies respectful; always explicitly alert Ciaran when Mark messages.

## Workflows & Procedures

### MirrorLingo (dynamous-kiro-hackathon) Local Auth/Nav Setup

- Docker Compose project: `/Users/ciarancox/dynamous-kiro-hackathon` (frontend on `localhost:3001`)
- Implemented login-first UX:
  - Route guard in `frontend/src/pages/_app.tsx` (public: `/login`, `/signup`, `/confirm`; everything else redirects to `/login`)
  - Auth-aware nav in `frontend/src/components/Navigation.tsx` (logged out: Login/Sign up only; logged in: app links + Logout)
- Dev auth flag: `NEXT_PUBLIC_DEV_AUTH`
  - If `true`, demo user id acts as authenticated (Dev mode panel appears on `/login` when Cognito not configured)
  - If `false`, only Cognito token auth allowed
- Gotcha: Next build reads `.env.local`; for local dev auth in Docker, ensure `frontend/.env.local` includes `NEXT_PUBLIC_DEV_AUTH=true`.

### Viewpoint Comment Downloading

1. Click on **four-minute**.
2. Click on **Public**.
3. Click on **xContractors**.
4. Click on the **blue clip** in the center.
5. Select the sheets/comments you want to download.
6. Choose the option to **download all sheets**.

### LiveKit Spanish Tutor Setup

- Ensure `.env` variables are on separate lines:
  ```
  VOICE_STACK=auto
  OPENAI_API_KEY=sk-...
  ```
- Recreate the agent container: `docker compose up -d --force-recreate agent`
- Verify worker is "Online/Idle" in LiveKit Cloud dashboard under "Agents".

### Docker Troubleshooting (Redis)

- If containers fail to start because of Redis exiting (exit 0):
  - Check status: `docker compose ps -a`
  - Check logs: `docker compose logs --no-color --tail=200 redis`
  - Check for port conflicts: `lsof -nP -iTCP:6379 -sTCP:LISTEN`
  - Stop local Redis if needed: `brew services stop redis`

## Knowledge Base

- **IndieDevDan (IndyDevDan):** Ciaran wants us to study his YouTube + GitHub to learn agentic engineering concepts/patterns and integrate what’s useful into our workflows.
- **PDF Comparison:** Tools for comparing PDF drawings are essential for AEC professionals (Architecture, Engineering, Construction). They use OCR or image recognition to identify version differences.
- **Obsidian Agent (Paddy):** A local AI agent for managing Obsidian vaults via Pydantic AI and FastAPI.
