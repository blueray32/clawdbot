# TACTICS.md - Paddy's Agentic Engineering Laws

This file codifies the combined best practices of **Cole Medin (Dynamous)**, **IndieDevDan (Agentic Engineer)**, and **Rasmus Widing (PRP Framework)**. These laws govern every task Paddy performs.

## 1. The Core Lifecycle: The PIV Loop (Cole)

Every task follows the cycle: **Plan → Implement → Validate → Iterate**.

### Phase 1: Planning (The PRP Framework - Rasmus Widing)

"Sharpen the axe" before cutting. Never skip to code.

1.  **Mission Briefing (INITIAL.md):** Define the problem and feature goals in plain English. Include as much detail as possible.
2.  **The PRP (Product Requirements Prompt):** Generate a structured, actionable spec from the `INITIAL.md`.
    - **Context Layer:** Project background, tech stack, and existing patterns.
    - **Requirements Layer:** Features and Acceptance Criteria.
    - **Implementation Layer:** **Contract-First Chain** and a step-by-step Task List (Dan).
    - **Validation Layer:** Defined test cases and success metrics.
3.  **Research (Context Engineering):**
    - **Pocket-Pick:** Search for the exact code snippets or patterns needed before starting (Dan).
    - Perform a root-cause analysis (RCA) for bugs.
    - Explore the codebase to find existing constraints.

### Phase 2: Implementation (The Swarm & The Loop)

Delegate the plan to specialized agents and iterate until verifiably complete.

- **Multi-Agent Patterns (Cole):**
  - **Agent-as-Tool:** Hierarchical control where the lead agent invokes others.
  - **Supervisor Pattern:** Dynamic delegation to a swarm of sub-agents.
- **Collaborative implementation (Dan):**
  - **Agent Teams:** Spawn a collaborative team working on the same task list.
  - **Contract-First Spawning:** Spawn "Upstream" agents (DB) before "Downstream" agents (UI).
- **The Ralph Loop:** For autonomous work, run a self-feeding loop (Pick Task → Implement → Validate → Repeat).
- **Zero Touch Engineering (ZTE):** Build pipelines that run autonomously toward the Gold Medal state.

### Phase 3: Validation (The Pyramid & The Judge)

Verify at 5 levels of rigor (Cole):

1.  **Syntax/Lint:** Basic code quality.
2.  **Type Checking:** Correctness of data structures.
3.  **Unit Tests:** Logic verification.
4.  **Integration Tests:** Behavioral verification.
5.  **Human Review:** Intent check (Paddy prompts Ciaran for sign-off).

- **Guardrail Agent:** Use a validator agent for correction loops if output fails.

## 2. Command Design: The IPO Model (Cole)

When designing internal workflows or "Commands," follow **Input → Process → Output**.

## 3. Pillar Optimization: The Core Four (Dan)

Constantly re-evaluate these four pillars:

1.  **Context:** Principles in Rules; Processes in Commands. Keep it clean.
2.  **Model:** Use the right brain (Opus for brain, Flash for work).
3.  **Prompt:** Directive and information-dense.
4.  **Tools:** Only enable what is needed for the current phase.

## 4. Observability & Memory

- **Observability:** Every tool call traceable in real-time (Dan).
- **Persistent Memory:** Text > Brain. No "mental notes" (AGENTS.md).
- **Archon Sync:** Central task management for swarm progress.

---

_“Technological revolutions are a forcing function for growth. You evolve, or you die.”_ - @IndyDevDan
_“Context engineering is the new vibe coding.”_ - @ColeMedin
_“Global rules are for things that will be true forever. PRPs are for the specific work you're doing right now.”_ - @RasmusWiding
