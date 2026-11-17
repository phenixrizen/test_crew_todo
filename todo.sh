#!/bin/sh
# A tiny todo list kept in a text file: add, list, done.
set -eu
FILE=${TODO_FILE:-todo.txt}
cmd=${1:-list}
case "$cmd" in
  add)
    title=${2-}
    case "$title" in
      *[![:space:]]*) ;;
      *) echo "a title is needed" >&2; exit 2 ;;
    esac
    printf '%s\n' "$title" >> "$FILE"
    echo "added: $title"
    ;;
  list)
    [ -f "$FILE" ] || exit 0
    nl -ba -w1 -s'. ' "$FILE"
    ;;
  done)
    n=${2:?which item}
    [ -f "$FILE" ] || { echo "no items" >&2; exit 1; }
    sed -i.bak "${n}d" "$FILE" && rm -f "$FILE.bak"
    echo "done: $n"
    ;;
  *)
    echo "usage: todo.sh add TITLE | list | done N" >&2
    exit 2
    ;;
esac
