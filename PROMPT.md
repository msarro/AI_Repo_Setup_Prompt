# Project guardrails prompt (v1.1)

<!--
Paste everything below the line into Claude Code (or another coding agent) at the
start of a NEW project, from inside the project's folder. Fill in the two
[BRACKETED] lines first. See README.md for what you need installed beforehand.
Licensed under CC BY 4.0: https://github.com/msarro/AI_Repo_Setup_Prompt
-->

---

## About this project

- What I'm building: [ONE OR TWO SENTENCES]
- Where the code lives: [GITHUB REPOSITORY URL]

## How to work with me

I may not be a professional developer. Explain each step in plain language as you go.

Before you change anything, ask me all of your questions at once. Include at least:

- How will this software be used: internal only, shared outside my organization, open
  source, or commercial? Record my answer. If commercial use is possible at all, assume it.
- What license should this project itself have? Do not choose one for me.
- Am I the only person with access to the repository? (GitHub does not let anyone approve
  their own pull request.)
- Which language and tools? If I have no preference, pick the simplest that fits and
  record why.

Never ask me to paste passwords, keys, tokens or sign-in details into this conversation.
If something needs one, tell me where to put it myself.

Do not assume I have any tools installed or know how to use them. First check what I have
(git, a GitHub account, and the GitHub command-line tool `gh`), then:

- If `gh` is missing, ask whether I want your help installing it and signing in (one
  command, then a login in my web browser), or whether I would rather do the GitHub steps
  myself in my web browser.
- If I choose the browser, give me numbered, click-by-click steps for each GitHub step,
  and help me confirm it worked before you continue.
- Never install anything without asking me first.
- If the code is not on GitHub, tell me, and use that platform's equivalent steps.

Then set up the project as described below **before writing any features**.

## 1. Issues first

Every change starts as an issue in the repository. Comment on the issue as the work
progresses: test written and failing, pull request opened, and so on.

## 2. Branches and pull requests

- Work on one short-lived branch per issue, named `<issue-number>-<short-name>`.
- Protect the default branch: changes arrive only through a pull request with every
  check passing; no direct pushes, no force pushes, no deletion; the rules apply to
  administrators too.
- Require one approval from someone other than the author. If I am the only
  collaborator, ask me whether to add a reviewer or to let me merge by hand.
- **Never approve or merge a pull request yourself, and never push to the default branch.**
- On GitHub Free, branch protection works only on public repositories. If you cannot
  turn it on, stop and tell me.

## 3. Tests first

- Every change comes with automated tests. Write the test first, run it, and show me it
  failing before you write the code.
- **Never weaken, skip or delete a test, or turn off a check, to make something pass.**
  If a requirement change means a test's expectation must change, tell me which test and
  why before changing it, and list it in the pull request.
- Passing tests are not enough for anything people see or hear: run the app and look at
  it (for example, take screenshots) before saying it works.

## 4. Automated checks

Run these on every pull request, and on my machine before every push. Install the local
checks automatically for anyone who clones the project (for example, git hooks set up by
the install step).

- formatting
- linting
- tests
- a scan for passwords, keys and tokens in every file and the whole git history
- a scan for dependencies with known vulnerabilities, failing at any severity. If no fix
  exists, ask me.
- the license check (section 6)
- a check that the software bill of materials is current (section 5)

Make each check its own pipeline job so I can see which one failed, and make every job
required on the default branch. Pin pipeline actions and downloaded tools to exact
versions (commit SHAs, checksums), and give each job only the permissions it needs.

## 5. Dependencies

- List every dependency in a manifest with a lockfile, at exact versions.
- Prefer fewer dependencies. Ask me before adding one that ships to users.
- Commit a software bill of materials (CycloneDX or SPDX). Generate it from the lockfile
  so it comes out the same on every machine, and fail the check if it is out of date.

## 5a. Keeping dependencies up to date

Set up automatic dependency-update pull requests with what this platform supports:

- **GitHub:** add `.github/dependabot.yml` for every package ecosystem in use and for the
  pipeline's actions, and turn on Dependabot alerts and security updates. If you cannot
  change those settings, tell me exactly where to click.
- **Other platforms:** use Renovate with a `renovate.json`. Tell me exactly what I must
  install or authorize (the Renovate app, or a scheduled job with a bot token).
  Never create tokens yourself.
- **Neither available:** tell me, and rely on the scheduled scan below.

On every platform, also run the vulnerability scan on a schedule (for example weekly), so
newly published vulnerabilities are found even when nobody is committing.

Rules for update pull requests:

- They are exempt from "issue first" and "test first", but must pass every check, and a
  person merges them. Never turn on auto-merge.
- Group minor and patch updates into one pull request a week to limit noise.
- If an update changes the lockfile, regenerate the software bill of materials on that
  branch before merging. Write a runbook for this.

## 6. Licenses

Keep two things separate, and record each in a decision record:

- **What we use:** the license check must reject any dependency whose license does not
  allow the recorded use, including a missing, custom or unknown license. Changing the
  allowed list needs a decision record and my OK.
- **What we publish:** this project's own license, as I chose it. Keep the LICENSE file,
  the manifest, the README and the software bill of materials in agreement.

## 7. Secrets

- Never write passwords, keys or tokens into code, configuration, docs or commit
  messages. Use environment variables or a secrets store, and ignore `.env` files.
- If a secret is ever committed, treat it as compromised: tell me at once so it can be
  revoked, then remove it.

## 8. Environments and infrastructure

- Run code only from this project's folder, against this project's own environment.
  Prefer absolute paths to changing directories.
- Before any command that changes infrastructure or data (terraform/tofu, kubectl,
  database tools, cloud command-line tools, deployments), show me the folder, workspace
  or context, and account it will act on, and wait for my OK.
- Ask me before publishing or sending anything outside the repository.

## 9. Sign-in and roles

If people will need to sign in to the app, stop and tell me before building it. Sign-in
must use my organization's single sign-on, set up together with my IT or security team.
Never store passwords in the app. Once sign-in is arranged, define the app's roles and what
each can do in the app itself, with tests, and map people to roles through single sign-on
groups or manual assignment.

## 10. Documentation (both kinds are required)

- **Help for users**, inside the app.
- **Engineering docs for maintainers** in the repository: a README, an architecture page
  with a diagram, a decision record for each significant choice, and runbooks. Publish
  them to the repository wiki automatically on every merge. (A GitHub wiki needs its
  first page created by hand; tell me when to do that.)

## 11. Facts and content

Take facts, quotations, music, data and similar content from a named source, never from
memory, and record the source. Tell me which claims I should check.

## 12. Finishing each piece of work

Close or update the issues, update the README, docs and user help, and remove stale notes
from AGENTS.md.

## 13. Rules for every tool and every person

Write all of these rules into `AGENTS.md` so they apply whatever AI tool is used, and add
a `CLAUDE.md` containing only the line `@AGENTS.md`.

## 14. Prove it works

When setup is done, demonstrate the protections on throwaway branches whose pull requests
you close without merging:

1. A failing test is rejected, on my machine and by the pipeline.
2. A fake password (random text, obviously not real) is rejected, on my machine and by
   the pipeline. You may skip the local hooks with `--no-verify` for this demonstration
   only, and must say so.
3. A direct push to the default branch is refused.

If you are stuck, or a rule blocks you, stop and ask me. Never work around a rule.
