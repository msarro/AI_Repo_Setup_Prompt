# AI Repo Setup Prompt

A simple prompt for developing with an AI assistant to implement basic guardrails and best
practices. This is to help protect new developers from themselves and the world.

Paste [`PROMPT.md`](PROMPT.md) into an AI coding agent at the start of a new project. Before
any features are written, the agent sets up, and explains in plain language:

- an issue for every change, and a locked main branch that only accepts pull requests
- tests written first and shown failing
- an automated pipeline: formatting, linting, tests, scans for leaked secrets and
  vulnerable dependencies, a license check, and a software bill of materials (SBOM)
- the same checks on your own computer before every push
- automatic dependency-update pull requests and a weekly vulnerability scan
- documentation for users and maintainers, and one rules file (`AGENTS.md`) that every AI
  tool follows

It then proves the protections work by showing a failing test, a fake password and a direct
push to main being rejected.

## Before you start

- **git** and a **GitHub account**.
- The **GitHub command-line tool**, signed in: `gh auth login`. The agent uses it to create
  issues and pull requests and to lock your main branch. **It acts as you, with your
  permissions.**
- A **new repository** that you administer. On GitHub Free, branch protection works only on
  **public** repositories; private repositories need a paid plan.
- An AI coding agent such as **Claude Code**, started inside the project's folder.
- The agent may need to install tools (for example a language runtime or the gitleaks
  secret scanner). It should ask you first.

## How to use it

1. Open [`PROMPT.md`](PROMPT.md), copy everything below the line, and fill in the three
   `[BRACKETED]` lines.
2. Paste it into your agent as the first message in the new project.
3. Answer its questions carefully. How the software will be used decides which dependency
   licenses are allowed.
4. Review and merge its pull requests yourself. The agent never merges.
5. If you work alone, consider a colleague or a second account as a reviewer. Otherwise
   "review" means reading your own pull requests.

## What it does not do for you

- **It does not replace reading the pull requests.** Tests written by the same AI that wrote
  the code can share its blind spots.
- **It does not check that things look right.** The prompt asks the agent to run the app
  and show you; look at what it shows.
- **It does not verify facts.** The agent flags claims to check; check them.
- **It brings decisions to you.** Expect questions about how the software will be used, who
  approves changes, and its license.

## Adapting it for your organization

This is the general edition: it relies only on GitHub and free tools. An organization can
make its own edition by changing a few lines, for example to name:

- its code hosting platform and that platform's command-line tool
- its secrets manager, and the client the agent should use to read secrets from it
- its dependency-update bot (Dependabot, Renovate, or another)
- its single sign-on system and approval rules
- internal standards documents, such as security foundations or SBOM instructions, for
  the agent to read and follow

Keep the safety rules. `scripts/check-prompt.sh` lists the ones it requires.

## Example

The prompt was demonstrated by building
[Runny Hound 2](https://github.com/msarro/Runny_Hound_2), a small browser game. Setup took
about 12 minutes from first issue to merge; every later feature then arrived with tests,
documentation, checks and a reviewed pull request.

## Contributing

Changes go through an issue and a pull request that the owner merges; `main` is locked.
Every change to `PROMPT.md` raises the version in its title and adds an entry below. Before
pushing, run:

```sh
git config core.hooksPath .githooks   # once: turns on the local checks
sh scripts/test-check-prompt.sh && sh scripts/check-prompt.sh
```

The pipeline also checks Markdown formatting, links, and leaked secrets. See
[`AGENTS.md`](AGENTS.md) for the full rules.

## License

AI Repo Setup Prompt © 2026 Matty Sarro, licensed under
[CC BY 4.0](LICENSE). You may copy, adapt and share it, including inside your organization,
as long as you give credit, for example:

> Based on [AI Repo Setup Prompt](https://github.com/msarro/AI_Repo_Setup_Prompt) by Matty
> Sarro, CC BY 4.0.

## Versions

- **1.0**: first public edition, from the Runny Hound 2 lecture demonstration. Includes
  dependency-update pull requests (Dependabot or Renovate) and a weekly vulnerability scan.
