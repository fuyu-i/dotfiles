#!/bin/bash

REPO_CONFIG_DIR="$(pwd)/.config"
SOURCE_CONFIG_DIR="$HOME/.config"
LIST_FILE="config-list.txt"

if [ ! -f "$LIST_FILE" ]; then
    echo "[ERROR] - Configuration list file not found: $LIST_FILE"
    exit 1
fi

echo "[INFO] - Starting configuration setup from $LIST_FILE..."

if [ ! -d "$REPO_CONFIG_DIR" ]; then
    echo "[INFO] - Creating repository configuration directory: $REPO_CONFIG_DIR"
    mkdir -p "$REPO_CONFIG_DIR"
fi

while read -r name; do

    echo "[INFO] - Processing: $name"

    if [ -z "$name" ]; then
        continue
    fi

    source="$SOURCE_CONFIG_DIR/$name"
    target="$REPO_CONFIG_DIR/$name"

    if [ ! -d "$source" ]; then
        echo "[WARNING] - Skipping $name: Source directory does not exist: $source"
        continue
    fi

    if [ -e "$target" ]; then
        echo "[INFO] - Updating: $name"
        rm -rf "$target"
    else
        echo "[INFO] - Creating: $name"
    fi

    cp -r "$source" "$target"
    echo "[SUCCESS] - Copied $name from $source to $target"
done < "$LIST_FILE"

echo "[SUCCESS] - Configuration setup completed"