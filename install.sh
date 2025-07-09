#!/bin/bash

REPO_CONFIG_DIR="$(pwd)/.config"
TARGET_CONFIG_DIR="$HOME/.config"
LIST_FILE="config-list.txt"

backup_dir="$HOME/.config_backups/.config_backup_$(date +%Y%m%d_%H%M%S)"

backup_config() {
    local config_name="$1"
    local target_path="$2"

    if [ ! -d "$backup_dir" ]; then
        mkdir -p "$backup_dir"
        echo "[INFO] - Created backup directory: $backup_dir"
    fi

    cp -r "$target_path" "$backup_dir/"
    echo "[SUCCESS] - Backed up $config_name to $backup_dir"
}

if [ ! -f "$LIST_FILE" ]; then
    echo "[ERROR] - Configuration list file not found: $LIST_FILE"
    exit 1
fi

if [ ! -d "$REPO_CONFIG_DIR" ]; then
    echo "[ERROR] - Repository configuration directory not found: $REPO_CONFIG_DIR"
    exit 1
fi

echo "[INFO] - Starting configuration setup from $LIST_FILE..."
echo "[INFO] - Using repository configuration directory: $REPO_CONFIG_DIR"
echo "[INFO] - Target configuration directory: $TARGET_CONFIG_DIR"

if [ ! -d "$TARGET_CONFIG_DIR" ]; then
    echo "[INFO] - Creating target configuration directory: $TARGET_CONFIG_DIR"
    mkdir -p "$TARGET_CONFIG_DIR"
fi

while read -r name; do
    if [ -z "$name" ]; then
        continue
    fi

    source="$REPO_CONFIG_DIR/$name"
    target="$TARGET_CONFIG_DIR/$name"

    if [ ! -d "$source" ]; then
        echo "[WARNING] - Skipping $name: Source directory does not exist: $source"
        continue
    fi

    if [ -e "$target" ]; then
        echo "[INFO] - Updating: $name"
        backup_config "$name" "$target"
        rm -rf "$target"
    else
        echo "[INFO] - Creating: $name"
    fi

    cp -r "$source" "$target"
    echo "[SUCCESS] - Copied $name from $source to $target"
done < "$LIST_FILE"

echo "[SUCCESS] - Configuration setup completed"