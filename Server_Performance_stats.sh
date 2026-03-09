#!/bin/bash

echo "------------------------------------------"
echo " SERVER PERFORMANCE STATS (Optimized) "
echo "------------------------------------------"

# --- OS Version (Single awk process) ---
# Using awk to find the line AND clean the quotes in one go
OS_VERSION=$(awk -F'="' '/PRETTY_NAME/ {gsub(/"/, "", $2); print $2}' /etc/os-release)
echo "OS Version: $OS_VERSION"
echo "Uptime: $(uptime -p)"
echo "------------------------------------------"

# --- CPU Usage (Replacing grep/sed/awk chain) ---
# top -bn1 provides the snapshot; awk extracts the idle time ($8) and subtracts from 100
echo -n "Total CPU Usage: "
top -bn1 | awk '/Cpu\(s\)/ {for(i=1;i<=NF;i++) if($i ~ /id/) print 100 - $(i-1) "%"}'

# --- Memory Usage---
echo "--- Memory Usage ---"
free -m | awk 'NR==2 {printf "Used: %dMB | Free: %dMB | Usage: %.2f%%\n", $3, $4, $3*100/$2}'

# --- Disk Usage ---
echo "--- Disk Usage ---"
df -h --total | awk '/total/ {printf "Used: %s | Free: %s | Usage: %s\n", $3, $4, $5}'

# --- Top 5 Processes (CPU & Memory) ---
# We use ps with custom formatting and sort
echo "--- Top 5 Processes by CPU Usage ---"
ps -eo pid,ppid,cmd,%cpu --sort=-%cpu | awk 'NR<=6'

echo "--- Top 5 Processes by Memory Usage ---"
ps -eo pid,ppid,cmd,%mem --sort=-%mem | awk 'NR<=6'
echo "------------------------------------------"