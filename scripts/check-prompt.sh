#!/bin/sh
# Checks PROMPT.md for mistakes that are easy to make while editing it.
# Usage: sh scripts/check-prompt.sh [folder]   (default: this repository)
set -u
dir="${1:-$(dirname "$0")/..}"
prompt="$dir/PROMPT.md"
readme="$dir/README.md"
fail=0
problem() {
  echo "PROMPT CHECK FAILED: $1" >&2
  fail=1
}

if [ ! -f "$prompt" ]; then
  problem "PROMPT.md is missing"
  exit 1
fi

# 1. The fill-in lines people must complete are still there.
for label in "What I'm building: [" "Where the code lives: [" "if people will sign in: ["; do
  grep -qF -- "$label" "$prompt" || problem "the fill-in line \"$label...]\" is missing"
done

# 2. Section numbers run 1, 2, 3, ... with no gaps; "5a" may only follow "5".
if ! awk '
  /^## [0-9]+[a-z]?\. / {
    h = $2; sub(/\.$/, "", h)
    n = h; sub(/[a-z]$/, "", n); n = n + 0
    lettered = (h ~ /[a-z]$/)
    if (!lettered && n != prev + 1) { printf "section %s comes after section %s\n", h, last; bad = 1 }
    if (lettered && n != prev) { printf "section %s must come right after section %d\n", h, n; bad = 1 }
    prev = n; last = h
  }
  END { if (prev == 0) { print "no numbered sections found"; bad = 1 } exit bad }
' "$prompt" >&2; then
  problem "section numbers are out of order"
fi

# 3. The version in the title has an entry in the README's version list.
version=$(sed -n 's/^# Project guardrails prompt (v\([0-9][0-9.]*\)).*/\1/p' "$prompt" | head -n 1)
if [ -z "$version" ]; then
  problem "the title has no version, e.g. \"# Project guardrails prompt (v1.0)\""
elif [ ! -f "$readme" ] || ! grep -qF -- "**$version**" "$readme"; then
  problem "README.md's version list has no entry for $version"
fi

# 4. The safety rules that matter most have not been removed or reworded away.
while IFS= read -r rule; do
  [ -n "$rule" ] || continue
  grep -qF -- "$rule" "$prompt" || problem "the safety rule \"$rule\" is missing"
done <<'RULES'
Never approve or merge a pull request yourself
Never weaken, skip or delete a test
Never write passwords, keys or tokens
wait for my OK
Never create tokens yourself
Never work around a rule
RULES

exit $fail
