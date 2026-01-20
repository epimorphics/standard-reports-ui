#!/bin/bash
# Common utilities and functions for git hooks
#
# Environment variables:
#   NO_COLOR - Set to any value to disable colored output (e.g., NO_COLOR=1 git commit)

# Check if color output is disabled (set NO_COLOR=1 to disable)
: "${NO_COLOR:=}"

# Initialize branch name from filtered branch list
init_branch_name() {
  local list="issue spike task"
  local listRE="^($(printf '%s\n' "$list" | tr ' ' '|'))/"

  BRANCH_NAME=$(git branch --show-current | grep -E "$listRE" | sed 's/* //')
}

# Check if hook should be skipped based on branch name, --no-verify, or --amend flags
should_skip_hook() {
  # Skip on specific branches, with --no-verify flag, or when amending
  if echo "$BRANCH_NAME" | grep -qE '^(hotfix|rebase|prod(uction)?)$' || [[ $(ps -ocommand= -p $PPID) == *"--no-verify"* ]] || [[ $(ps -ocommand= -p $PPID) == *"--amend"* ]]; then
    return 0  # true - should skip
  fi
  return 1  # false - should not skip
}

# Print colored status messages (respects NO_COLOR environment variable)
print_header() {
  if [ -z "$NO_COLOR" ]; then
    printf '\n\033[0;105m%s\033[0m\n' "$1"
  else
    printf '\n%s\n' "$1"
  fi
}

print_success() {
  if [ -z "$NO_COLOR" ]; then
    printf '\n\033[0;32m%s\033[0m\n' "$1"
  else
    printf '\n%s\n' "$1"
  fi
}

print_warning() {
  if [ -z "$NO_COLOR" ]; then
    printf '\n\033[0;33m%s\033[0m\n' "$1"
  else
    printf '\n%s\n' "$1"
  fi
}

print_error() {
  if [ -z "$NO_COLOR" ]; then
    printf '\n\033[0;31m%s\033[0m\n' "$1"
  else
    printf '\n%s\n' "$1"
  fi
}

print_info() {
  if [ -z "$NO_COLOR" ]; then
    printf '\033[0;33m%s\033[0m\n' "$1"
  else
    printf '%s\n' "$1"
  fi
}
