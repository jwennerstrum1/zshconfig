#!/usr/bin/env sh

# Usage: has <command>
#
# Returns 0 if the <command> is available. Returns 1 otherwise. It can be a
# binary in the PATH or a shell function.
has() {
  type "$1" > /dev/null 2>&1
}
