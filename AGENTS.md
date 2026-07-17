# xuan-daliuren Agents

## Core Repositories
- Domain: `lib/domain/`
- Data: `lib/data/`
- Presentation: `lib/presentation/`

## Active Specifications
- [Story 7: Multi-School Architecture Refactor](openspec/specs/daliuren-story-7-refactor.md)

## Memory Banks
- Hindsight Bank: `S:P:xuan-daliuren`

## Command Handles
- ZenTao Project: 11
- ZenTao Product: 12
- Active Execution: 12

## Sensitive Areas
- `lib/data/repositories/da_liu_ren_repository_impl.dart`: Hardcoded asset paths.
- `assets/da_liu_ren/`: Legacy data files.



## 铁律：主分支代码操作
当需要进行操作的时候，只有人类下达命令让他们操作的时候，才可以进行操作。

<!-- gitnexus:start -->
# GitNexus — Code Intelligence

This project is indexed by GitNexus as **xuan-daliuren** (4067 symbols, 8000 relationships, 274 execution flows). Use the GitNexus MCP tools to understand code, assess impact, and navigate safely.

> Index stale? Run `node .gitnexus/run.cjs analyze` from the project root — it auto-selects an available runner. No `.gitnexus/run.cjs` yet? `npx gitnexus analyze` (npm 11 crash → `npm i -g gitnexus`; #1939).

## Always Do

- **MUST run impact analysis before editing any symbol.** Before modifying a function, class, or method, run `impact({target: "symbolName", direction: "upstream"})` and report the blast radius (direct callers, affected processes, risk level) to the user.
- **MUST run `detect_changes()` before committing** to verify your changes only affect expected symbols and execution flows. For regression review, compare against the default branch: `detect_changes({scope: "compare", base_ref: "main"})`.
- **MUST warn the user** if impact analysis returns HIGH or CRITICAL risk before proceeding with edits.
- When exploring unfamiliar code, use `query({query: "concept"})` to find execution flows instead of grepping. It returns process-grouped results ranked by relevance.
- When you need full context on a specific symbol — callers, callees, which execution flows it participates in — use `context({name: "symbolName"})`.

## Never Do

- NEVER edit a function, class, or method without first running `impact` on it.
- NEVER ignore HIGH or CRITICAL risk warnings from impact analysis.
- NEVER rename symbols with find-and-replace — use `rename` which understands the call graph.
- NEVER commit changes without running `detect_changes()` to check affected scope.

## Resources

| Resource | Use for |
|----------|---------|
| `gitnexus://repo/xuan-daliuren/context` | Codebase overview, check index freshness |
| `gitnexus://repo/xuan-daliuren/clusters` | All functional areas |
| `gitnexus://repo/xuan-daliuren/processes` | All execution flows |
| `gitnexus://repo/xuan-daliuren/process/{name}` | Step-by-step execution trace |

## CLI

| Task | Read this skill file |
|------|---------------------|
| Understand architecture / "How does X work?" | `.claude/skills/gitnexus/gitnexus-exploring/SKILL.md` |
| Blast radius / "What breaks if I change X?" | `.claude/skills/gitnexus/gitnexus-impact-analysis/SKILL.md` |
| Trace bugs / "Why is X failing?" | `.claude/skills/gitnexus/gitnexus-debugging/SKILL.md` |
| Rename / extract / split / refactor | `.claude/skills/gitnexus/gitnexus-refactoring/SKILL.md` |
| Tools, resources, schema reference | `.claude/skills/gitnexus/gitnexus-guide/SKILL.md` |
| Index, status, clean, wiki CLI commands | `.claude/skills/gitnexus/gitnexus-cli/SKILL.md` |

<!-- gitnexus:end -->
