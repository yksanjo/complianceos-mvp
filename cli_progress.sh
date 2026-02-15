#!/bin/bash
# CLI Progress Indicators for Bash Scripts

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# Spinner function
spinner() {
    local pid=$1
    local delay=0.1
    local spinstr='|/-\'
    
    # Hide cursor
    printf "\033[?25l"
    
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        local temp=${spinstr#?}
        printf " [%c]  " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    
    # Show cursor
    printf "\033[?25h"
    printf "   \b\b\b"
}

# Start spinner with a command
spinner_start() {
    local msg=$1
    shift
    
    echo -n "${msg}... "
    
    # Run command in background
    "$@" > /dev/null 2>&1 &
    local pid=$!
    
    # Start spinner
    spinner $pid &
    local spinner_pid=$!
    
    # Wait for command to complete
    wait $pid
    local exit_code=$?
    
    # Stop spinner
    kill $spinner_pid 2>/dev/null
    wait $spinner_pid 2>/dev/null
    
    # Print result
    if [ $exit_code -eq 0 ]; then
        echo -e "${GREEN}✓${NC}"
    else
        echo -e "${RED}✗${NC}"
    fi
    
    return $exit_code
}

# Progress bar function
progress_bar() {
    local duration=$1
    local increment=$((duration / 50))
    
    echo -n "["
    for ((i=0; i<50; i++)); do
        echo -n " "
    done
    echo -n "]"
    
    # Move cursor back
    for ((i=0; i<51; i++)); do
        echo -ne "\b"
    done
    
    for ((i=0; i<50; i++)); do
        echo -ne "${GREEN}█${NC}"
        sleep $increment
    done
    
    echo
}

# Animated dots
dots() {
    local pid=$1
    local msg=$2
    local delay=0.5
    
    echo -n "$msg"
    
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        echo -n "."
        sleep $delay
    done
    
    echo -e " ${GREEN}done${NC}"
}

# Simple spinner with message
simple_spinner() {
    local msg=$1
    local delay=0.1
    local spin=('-' '\\' '|' '/')
    local i=0
    
    echo -n "$msg "
    
    while true; do
        printf "\b${spin[i++ % ${#spin[@]}]}"
        sleep $delay
    done
}

# Usage: with_spinner "message" command args...
with_spinner() {
    local msg=$1
    shift
    
    # Start spinner in background
    simple_spinner "$msg" &
    local spinner_pid=$!
    
    # Run command
    "$@" > /dev/null 2>&1
    local exit_code=$?
    
    # Stop spinner
    kill $spinner_pid 2>/dev/null
    wait $spinner_pid 2>/dev/null
    
    # Clear line and show result
    printf "\r\033[K"  # Clear line
    
    if [ $exit_code -eq 0 ]; then
        echo -e "${GREEN}✓${NC} $msg"
    else
        echo -e "${RED}✗${NC} $msg"
    fi
    
    return $exit_code
}

# Multi-stage progress
multi_stage() {
    local stages=("$@")
    
    for stage in "${stages[@]}"; do
        echo -n "$stage... "
        
        # Simulate work
        sleep 1
        
        echo -e "${GREEN}✓${NC}"
    done
}

# Demo function
demo() {
    echo -e "${BOLD}=== CLI Progress Indicators Demo ===${NC}\n"
    
    echo -e "${CYAN}1. Simple spinner with command:${NC}"
    spinner_start "Downloading file" sleep 2
    
    echo -e "\n${CYAN}2. Progress bar:${NC}"
    progress_bar 5
    
    echo -e "\n${CYAN}3. Animated dots:${NC}"
    sleep 2 &
    dots $! "Processing"
    
    echo -e "\n${CYAN}4. With spinner wrapper:${NC}"
    with_spinner "Calculating results" sleep 2
    with_spinner "Validating data" sleep 1
    with_spinner "Generating report" sleep 3
    
    echo -e "\n${CYAN}5. Multi-stage progress:${NC}"
    multi_stage "Initializing" "Loading modules" "Processing data" "Finalizing"
    
    echo -e "\n${GREEN}✓ All demos complete!${NC}"
}

# If script is run directly, show demo
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    demo
fi

# Example usage in other scripts:
# 
# 1. Import this script:
#    source cli_progress.sh
#
# 2. Use spinner with command:
#    spinner_start "Installing package" apt-get install -y package
#
# 3. Use progress bar:
#    progress_bar 10  # 10 second progress bar
#
# 4. Use with_spinner wrapper:
#    with_spinner "Backing up files" tar -czf backup.tar.gz /path/to/files
#
# 5. Use dots animation:
#    some_long_command &
#    dots $! "Running command"