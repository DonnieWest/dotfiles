#!/bin/sh

set -eu

test_dir=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
yay=$test_dir/../yay
fixtures=$test_dir/fixtures
tmp=${TMPDIR:-/tmp}/yay-test.$$
mkdir -p "$tmp"
trap 'rm -rf "$tmp"' EXIT HUP INT TERM

export PATH="$fixtures:/usr/bin:/bin"
export PRIVILEGES_CLI="$fixtures/privileges"
export YAY_TEST_LOG="$tmp/log"

failures=0
tests=0

reset_test() {
  : >"$YAY_TEST_LOG"
  stdout=$tmp/stdout
  stderr=$tmp/stderr
  : >"$stdout"
  : >"$stderr"
  YAY_TEST_ADMIN=false
  export YAY_TEST_ADMIN
}

assert_log() {
  expected=$1
  actual=$(cat "$YAY_TEST_LOG")
  if [ "$actual" != "$expected" ]; then
    printf 'not ok %d - %s\nexpected log:\n%s\nactual log:\n%s\n' "$tests" "$test_name" "$expected" "$actual"
    failures=$((failures + 1))
    return 1
  fi
}

assert_stdout() {
  expected=$1
  actual=$(cat "$stdout")
  if [ "$actual" != "$expected" ]; then
    printf 'not ok %d - %s\nexpected stdout:\n%s\nactual stdout:\n%s\n' "$tests" "$test_name" "$expected" "$actual"
    failures=$((failures + 1))
    return 1
  fi
}

run_test() {
  tests=$((tests + 1))
  test_name=$1
  shift
  reset_test
  if "$@"; then
    printf 'ok %d - %s\n' "$tests" "$test_name"
  fi
}

test_bare_upgrade() {
  "$yay" >"$stdout" 2>"$stderr"
  assert_log 'privileges <--add>
brew <update>
brew <upgrade> <--formula>
brew <upgrade> <--cask>
privileges <--remove>'
}

test_existing_admin() {
  YAY_TEST_ADMIN=true
  export YAY_TEST_ADMIN
  "$yay" -S foo >"$stdout" 2>"$stderr"
  assert_log 'brew <info> <--formula> <foo>
brew <install> <--formula> <foo>'
}

test_query_modes() {
  "$yay" -Q >"$stdout" 2>"$stderr"
  assert_stdout 'foo 1.0
libfoo 1.0
beta-app 2.0' || return 1
  assert_log 'brew <list> <--formula> <--versions>
brew <list> <--cask> <--versions>' || return 1

  reset_test
  "$yay" -Qe >"$stdout" 2>"$stderr"
  assert_stdout 'foo 1.0
beta-app 2.0' || return 1
  assert_log 'brew <list> <--formula> <--installed-on-request>
brew <list> <--formula> <--versions> <foo>
brew <list> <--cask> <--versions>'
}

test_recursive_remove() {
  "$yay" -Rs foo >"$stdout" 2>"$stderr"
  assert_log 'privileges <--add>
brew <list> <--formula> <foo>
brew <uninstall> <--formula> <foo>
brew <autoremove>
privileges <--remove>'
}

test_forced_upgrade_target() {
  "$yay" -Syyu --noconfirm beta-app >"$stdout" 2>"$stderr"
  assert_log 'privileges <--add>
brew <update> <--force>
brew <upgrade> <--formula> <--yes>
brew <upgrade> <--cask> <--yes>
brew <info> <--formula> <beta-app>
brew <info> <--cask> <beta-app>
brew <install> <--cask> <--yes> <beta-app>
privileges <--remove>'
}

test_interactive_ranges() {
  printf '1 3-4\n' | "$yay" alpha >"$stdout" 2>"$stderr"
  assert_log 'brew <search> <--formula> <alpha>
brew <search> <--cask> <alpha>
privileges <--add>
brew <install> <--formula> <alpha>
brew <install> <--cask> <alpha-app> <alpine-app>
privileges <--remove>'
}

test_orphans() {
  "$yay" -Qdt >"$stdout" 2>"$stderr"
  assert_stdout 'libfoo' || return 1
  assert_log 'brew <autoremove> <--dry-run>'
}

run_test 'bare invocation upgrades everything' test_bare_upgrade
run_test 'existing admin privileges are preserved' test_existing_admin
run_test 'query modes retain versions and intent' test_query_modes
run_test 'recursive removal runs autoremove' test_recursive_remove
run_test 'forced refresh accepts package targets' test_forced_upgrade_target
run_test 'interactive selection accepts ranges' test_interactive_ranges
run_test 'orphan query is a dry run' test_orphans

if [ "$failures" -gt 0 ]; then
  printf '%d of %d tests failed\n' "$failures" "$tests" >&2
  exit 1
fi

printf 'all %d tests passed\n' "$tests"
