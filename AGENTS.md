# AGENTS.md

Rules for everyone working in this repository, people and AI assistants alike. If a rule
blocks you, stop and ask the owner. Never work around it.

## What this repository is

`PROMPT.md` is a prompt that people copy into an AI coding agent to set up a new project
safely. `README.md` explains how to use it. The prompt is the product: treat every word as
something hundreds of people will paste.

## Workflow

1. Every change starts as an issue.
2. One short-lived branch per issue, named `<issue-number>-<short-name>`.
3. Change a check: write or change its test in `scripts/test-check-prompt.sh` first and
   show it failing.
4. Run the local checks before pushing (the pre-push hook does this).
5. Open a pull request with `Closes #<n>`. Only the owner merges. **AI agents never merge
   pull requests and never push to `main`.**

## Rules for the prompt

- **Keep it general.** No organization-specific tools, private links, internal names or
  paid services as requirements. Organizations make their own editions (see the README).
- **Every change to `PROMPT.md`** raises the version in its title and adds an entry to the
  README's version list. `scripts/check-prompt.sh` enforces this.
- **Never remove or weaken a safety rule** in the prompt, or one of the phrases
  `scripts/check-prompt.sh` requires, without the owner's explicit OK in the issue.
- Keep the README's description of the prompt in step with the prompt.
- Plain language: the audience includes people who have never set up a project.

## Hard rules

- Never weaken, skip or delete a check or its tests to make something pass.
- No passwords, keys or tokens anywhere in the repository.
- `LICENSE` is the official CC BY 4.0 legal code; never edit it.

## Checks

| Check      | Where           | What it does                                                 |
| ---------- | --------------- | ------------------------------------------------------------ |
| `prompt`   | local and CI    | `scripts/check-prompt.sh` and its tests                      |
| `secrets`  | local and CI    | gitleaks over every file and the whole history               |
| `markdown` | CI              | markdownlint rules (`.markdownlint-cli2.jsonc`)              |
| `links`    | CI, also weekly | lychee checks every link in the Markdown files               |
