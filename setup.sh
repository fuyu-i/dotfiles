#!/bin/bash

REPO_CONFIG_DIR="$(pwd)/.config"
SOURCE_CONFIG_DIR="$HOME/.config"
LIST_FILE="config-list.txt"

if [ ! -f "$LIST_FILE" ]; then
    echo "Configuration list file not found: $LIST_FILE"
    exit 1
fi

echo "Starting configuration setup from $LIST_FILE..."

if [ ! -d "$REPO_CONFIG_DIR" ]; then
    echo "Creating repository configuration directory: $REPO_CONFIG_DIR"
    mkdir -p "$REPO_CONFIG_DIR"
fi

while read -r name; do

    echo "Processing: $name"

    if [ -z "$name" ]; then
        continue
    fi

    source="$SOURCE_CONFIG_DIR/$name"
    target="$REPO_CONFIG_DIR/$name"

    if [ ! -d "$source" ]; then
        echo "Skipping $name: Source directory does not exist: $source"
        continue
    fi

    if [ -e "$target" ]; then
        echo "Updating: $name"
        rm -rf "$target"
    else
        echo "Creating: $name"
    fi

    cp -r "$source" "$target"
    echo "Copied $name from $source to $target"
done < "$LIST_FILE"

echo "Configuration setup completed"