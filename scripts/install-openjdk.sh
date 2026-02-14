#!/bin/bash

set -e

if dpkg -s openjdk-21-jdk &>/dev/null; then
    echo "OpenJDK 21 is already installed."
    exit 0
fi

echo "Installing OpenJDK 21..."

sudo apt update && sudo apt install -y openjdk-21-jdk

echo "OpenJDK 21 installed."
echo "JAVA_HOME is /usr/lib/jvm/java-21-openjdk-amd64"
