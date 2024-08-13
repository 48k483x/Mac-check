#!/bin/bash

echo "MacBook Air M2 Verification Script"
echo "=================================="

# Function to print section headers
print_header() {
    echo -e "\n--- $1 ---"
}

# Check macOS version
print_header "macOS Version"
sw_vers

# Verify M2 chip
print_header "Processor Information"
processor=$(sysctl -n machdep.cpu.brand_string)
echo "Processor: $processor"
if [[ $processor == *"Apple M2"* ]]; then
    echo "✅ Apple M2 chip confirmed"
else
    echo "❌ Warning: This doesn't appear to be an M2 chip"
fi

# Check activation status
print_header "Activation Status"
computer_name=$(/usr/sbin/systemsetup -getcomputername 2>&1)
if [[ $computer_name == *"Computer Name:"* ]]; then
    echo "✅ Device appears to be activated"
else
    echo "❌ Warning: Device might not be activated"
fi

# Check for MDM enrollment
print_header "MDM Enrollment Check"
mdm_status=$(sudo profiles show -type enrollment 2>&1)
if [[ $mdm_status == *"There are no enrollment profiles."* ]]; then
    echo "✅ No MDM enrollment detected"
else
    echo "❌ Warning: MDM enrollment detected or unable to check"
fi

# Check battery cycle count
print_header "Battery Information"
system_profiler SPPowerDataType | grep -E "Cycle Count|Condition"

# Check Secure Boot status
print_header "Secure Boot Status"
csrutil status

# Check for suspicious launch agents or daemons
print_header "Launch Agents and Daemons"
echo "Launch Agents:"
ls -la /Library/LaunchAgents
echo -e "\nLaunch Daemons:"
ls -la /Library/LaunchDaemons

# Check disk encryption status
print_header "Disk Encryption Status"
fdesetup status

# Check system integrity
print_header "System Integrity"
spctl --status

echo -e "\nScript completed. Please review the output above for any warnings or unexpected results."
