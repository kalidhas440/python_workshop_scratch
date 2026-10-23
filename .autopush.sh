#!/usr/bin/env bash

# Configurable settings
WATCH_DIR="."           # Directory to watch
DEBOUNCE_DELAY=10       # Waiting period in seconds

echo "Watching directory '$WATCH_DIR' for changes..."

# Function to execute git push sequence
do_sync() {
    echo "[$(date +'%H:%M:%S')] Changes detected. Syncing with GitHub..."
    
    # Stage all tracked and untracked changes
    git add -A
    
    # Check if there are actual changes staged before committing
    if ! git diff-index --quiet HEAD --; then
        # Commit with no message prompt
        git commit -m "auto commit"
        
        # Push to remote (uses existing branch upstream tracking)
        git push
        echo "[$(date +'%H:%M:%S')] Successfully pushed to GitHub."
    else
        echo "No changes to commit."
    fi
}

# Detecting OS for watcher tool selection
if command -v fswatch &> /dev/null; then
    # macOS / Linux (using fswatch)
    fswatch -o --exclude='\.git/' "$WATCH_DIR" | while read -r event; do
        sleep "$DEBOUNCE_DELAY"
        # Drain any secondary file events buffered during the sleep delay
        read -t 0.1 -n 1000000 _ || true
        do_sync
    done

elif command -v inotifywait &> /dev/null; then
    # Linux (using inotify-tools)
    while true; do
        inotifywait -r -e modify,create,delete,move --exclude '\.git' "$WATCH_DIR"
        sleep "$DEBOUNCE_DELAY"
        do_sync
    done

else
    echo "Error: Neither 'fswatch' nor 'inotifywait' was found."
    echo "Install 'fswatch' via brew (macOS) or 'inotify-tools' via apt/yum (Linux)."
    exit 1
fi
