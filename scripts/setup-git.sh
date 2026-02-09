#!/bin/bash

set -e

echo "Configuring git defaults..."

git config --global user.name "Tulio Miranda"
git config --global user.email "tulio.mir@gmail.com"
git config --global init.defaultBranch main
git config --global pull.rebase true

echo "Git configured (identity, default branch, pull.rebase)."
