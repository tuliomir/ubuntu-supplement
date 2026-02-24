#!/bin/bash

set -e

echo "Configuring git defaults..."

if [ -z "$GIT_USER_NAME" ] || [ -z "$GIT_USER_EMAIL" ]; then
  echo "ERROR: Set GIT_USER_NAME and GIT_USER_EMAIL environment variables before running this script."
  echo "Example: GIT_USER_NAME='Your Name' GIT_USER_EMAIL='you@example.com' ./scripts/setup-git.sh"
  exit 1
fi

git config --global user.name "$GIT_USER_NAME"
git config --global user.email "$GIT_USER_EMAIL"
git config --global init.defaultBranch main
git config --global pull.rebase true

echo "Git configured (identity, default branch, pull.rebase)."
