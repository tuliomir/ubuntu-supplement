#!/bin/bash

set -e

echo "Configuring git defaults..."

git config --global pull.rebase true

echo "git pull.rebase set to true."
