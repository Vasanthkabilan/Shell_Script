#!/bin/bash

# Validate argument
if [ -z "$1" ]; then
    echo "Usage: ./log-stats.sh <access.log>"
    exit 1
fi

LOG_FILE=$1

# Helper function to parse, sort, count, and display top 5
analyze() {
    local column=$1
    echo "--- Top 5 $2 ---"
    awk -v col="$column" '{print $col}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -5
}

# 1. IP Addresses ($1)
analyze 1 "IP Addresses"

# 2. Paths ($7 is usually the request path in Nginx logs)
analyze 7 "Most Requested Paths"

# 3. Status Codes ($9)
analyze 9 "Response Status Codes"

# 4. User Agents (starts at $12, usually ends at end of line)
echo "--- Top 5 User Agents ---"
awk -F'"' '{print $6}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -5