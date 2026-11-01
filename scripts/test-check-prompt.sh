#!/bin/sh
# Tests scripts/check-prompt.sh: the real files must pass, and each kind of mistake
# must be caught. Usage: sh scripts/test-check-prompt.sh
set -u
here=$(dirname "$0")
root="$here/.."
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
passed=0
failed=0

fresh() {
  rm -rf "$tmp/case"
  mkdir -p "$tmp/case"
  cp "$root/PROMPT.md" "$root/README.md" "$tmp/case/" 2>/dev/null || true
}
# Rewrites the case's PROMPT.md with an awk program.
mutate() {
  awk "$1" "$root/PROMPT.md" > "$tmp/case/PROMPT.md"
}
expect() {
  if sh "$here/check-prompt.sh" "$tmp/case" > /dev/null 2>&1; then got=pass; else got=fail; fi
  if [ "$got" = "$1" ]; then
    echo "ok   - $2"
    passed=$((passed + 1))
  else
    echo "FAIL - $2 (expected $1, got $got)"
    failed=$((failed + 1))
  fi
}

fresh
expect pass "the real PROMPT.md and README.md pass"

fresh
rm -f "$tmp/case/PROMPT.md"
expect fail "a missing PROMPT.md is caught"

fresh
mutate '!/Where the code lives: \[/'
expect fail "a missing fill-in line is caught"

fresh
mutate '!/^## 11\. /'
expect fail "a skipped section number is caught (the original prompt skipped 11)"

fresh
mutate '{ sub(/^## 5a\. /, "## 6a. "); print }'
expect fail "a lettered section in the wrong place is caught"

fresh
mutate '{ sub(/\(v[0-9.]+\)/, "(v9.9)"); print }'
expect fail "a version missing from the README is caught"

fresh
mutate '!/Never approve or merge a pull request yourself/'
expect fail "a deleted safety rule is caught"

echo "$passed passed, $failed failed"
[ "$failed" -eq 0 ]
