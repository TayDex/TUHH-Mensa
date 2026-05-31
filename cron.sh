#!/bin/bash

# 1. Get the directory where THIS script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 2. Define names relative to that directory
BINARY_NAME="mensa-bot"
LOGFILE="cron.log"

# 3. Change directory to the script's folder
cd "$SCRIPT_DIR" || exit 1

# Append the morning timestamp to the log
echo "==== $(date '+%Y-%m-%d %H:%M:%S') ====" >> "$LOGFILE"

# Check if the binary already exists right next to this script
if [ ! -f "./$BINARY_NAME" ]; then
    echo "Binary not found. Compiling main.go..." >> "$LOGFILE"
    
    # Include standard Go path just in case cron environment misses it
    export PATH=$PATH:/usr/local/go/bin
    
    go build -o "$BINARY_NAME" main.go >> "$LOGFILE" 2>&1
    
    if [ $? -eq 0 ]; then
        echo "Compilation successful." >> "$LOGFILE"
    else
        echo "Error: Compilation failed!" >> "$LOGFILE"
        exit 1
    fi
fi

# Run the compiled binary
./$BINARY_NAME >> "$LOGFILE" 2>&1
