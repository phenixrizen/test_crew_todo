#!/bin/sh
# The checks of todo.sh: each case prints ok or FAIL, and the script exits 1 when any failed.
set -u
fail=0
t=$(mktemp -d)
trap 'rm -rf "$t"' EXIT
export TODO_FILE="$t/todo.txt"
check() {
  name=$1
  shift
  if "$@" >/dev/null 2>&1; then echo "ok   $name"; else echo "FAIL $name"; fail=1; fi
}
check "add keeps a title" sh -c 'sh todo.sh add "buy milk" && grep -qx "buy milk" "$TODO_FILE"'
check "list numbers the items" sh -c 'sh todo.sh list | grep -q "^1\. buy milk$"'
check "done removes an item" sh -c 'sh todo.sh done 1 && [ ! -s "$TODO_FILE" ]'
check "add refuses an empty title" sh -c 'sh todo.sh add "" 2>/dev/null; [ $? -eq 2 ] && [ ! -s "$TODO_FILE" ]'
check "add refuses a title of spaces" sh -c 'sh todo.sh add "   " 2>/dev/null; [ $? -eq 2 ] && [ ! -s "$TODO_FILE" ]'
exit $fail
