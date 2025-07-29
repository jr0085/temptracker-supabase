#!/bin/bash
# Cross-platform auto-commit script for Claude Code hooks

# Read JSON input from stdin (not used but available)
json=$(cat)

# Simple check if the JSON contains "error"
if echo "$json" | grep -q '"error"'; then
    echo "Skipping commit - tool execution had errors"
    exit 0
fi

# Get current timestamp
timestamp=$(date '+%Y-%m-%d %H:%M:%S')

# Stage all changes
git add -A

# Check if there are any changes to commit
if git diff --cached --quiet; then
    echo "No changes to commit"
    exit 0
fi

# Commit with descriptive message
if git commit -m "Auto-commit: Code changes via Claude Code - $timestamp"; then
    echo "Changes committed successfully"
    
    # Push to GitHub
    if git push origin main; then
        echo "Changes successfully pushed to GitHub!"
    else
        echo "Push failed - changes committed locally"
    fi
else
    echo "Commit failed"
fi