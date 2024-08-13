#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print section headers
print_header() {
    echo -e "\n${BLUE}=== $1 ===${NC}"
}

# Function to print pass/fail messages
print_result() {
    if [ $1 -eq 0 ]; then
        echo -e "${GREEN}✅ $2${NC}"
    else
        echo -e "${RED}❌ $3${NC}"
    fi
}

echo -e "${YELLOW}MacBook Air M2 Comprehensive Verification Script${NC}"
echo -e "${YELLOW}================================================${NC}"

# Check macOS version
print_header "macOS Version"
sw_vers
os_version=$(sw_vers -productVersion)
if [[ $os_version =~ ^11|^12|^13|^14 ]]; then
    print_result 0 "macOS version $os_version is compatible with M2 Macs"
else
    print_result 1 "macOS version $os_version might not be compatible with M2 Macs"
fi

# Verify M2 chip
print_header "Processor Information"
processor=$(sysctl -n machdep.cpu.brand_string)
echo "Processor: $processor"
if [[ $processor == *"Apple M2"* ]]; then
    print_result 0 "Apple M2 chip confirmed"
else
    print_result 1 "This doesn't appear to be an M2 chip" "Expected Apple M2, found $processor"
fi

# Check activation status
print_header "Activation Status"
computer_name=$(/usr/sbin/systemsetup -getcomputername 2>&1)
if [[ $computer_name == *"Computer Name:"* ]]; then
    print_result 0 "Device appears to be activated" "Computer Name: ${computer_name#*: }"
else
    print_result 1 "Device might not be activated" "Unable to retrieve computer name"
fi

# Check for MDM enrollment
print_header "MDM Enrollment Check"
mdm_status=$(sudo profiles show -type enrollment 2>&1)
if [[ $mdm_status == *"There are no enrollment profiles."* ]]; then
    print_result 0 "No MDM enrollment detected"
else
    print_result 1 "MDM enrollment detected or unable to check" "$mdm_status"
fi

# Check battery cycle count and condition
print_header "Battery Information"
battery_info=$(system_profiler SPPowerDataType)
cycle_count=$(echo "$battery_info" | grep "Cycle Count" | awk '{print $3}')
condition=$(echo "$battery_info" | grep "Condition" | awk '{print $2}')
echo "Cycle Count: $cycle_count"
echo "Condition: $condition"
if [[ $cycle_count -lt 10 && $condition == "Normal" ]]; then
    print_result 0 "Battery appears to be new and in good condition"
else
    print_result 1 "Battery might not be new or in optimal condition" "Cycle Count: $cycle_count, Condition: $condition"
fi

# Check Secure Boot status
print_header "Secure Boot Status"
secure_boot=$(csrutil status)
echo "$secure_boot"
if [[ $secure_boot == *"enabled"* ]]; then
    print_result 0 "Secure Boot is enabled"
else
    print_result 1 "Secure Boot is not enabled" "$secure_boot"
fi

# Check for suspicious launch agents or daemons
print_header "Launch Agents and Daemons"
echo "Launch Agents:"
la_count=$(ls -la /Library/LaunchAgents | wc -l)
echo "Number of Launch Agents: $((la_count-3))"
ls -la /Library/LaunchAgents
echo -e "\nLaunch Daemons:"
ld_count=$(ls -la /Library/LaunchDaemons | wc -l)
echo "Number of Launch Daemons: $((ld_count-3))"
ls -la /Library/LaunchDaemons
if [[ $((la_count-3)) -gt 10 || $((ld_count-3)) -gt 20 ]]; then
    print_result 1 "Unusually high number of launch agents or daemons detected" "Launch Agents: $((la_count-3)), Launch Daemons: $((ld_count-3))"
else
    print_result 0 "Number of launch agents and daemons appears normal"
fi

# Check disk encryption status
print_header "Disk Encryption Status"
fdesetup_status=$(fdesetup status)
echo "$fdesetup_status"
if [[ $fdesetup_status == *"FileVault is On."* ]]; then
    print_result 0 "FileVault disk encryption is enabled"
else
    print_result 1 "FileVault disk encryption is not enabled" "$fdesetup_status"
fi

# Check system integrity
print_header "System Integrity"
spctl_status=$(spctl --status)
echo "$spctl_status"
if [[ $spctl_status == *"assessments enabled"* ]]; then
    print_result 0 "System Integrity Protection is enabled"
else
    print_result 1 "System Integrity Protection is not enabled" "$spctl_status"
fi

# Check for software updates
print_header "Software Update Status"
sw_update=$(softwareupdate -l)
if [[ $sw_update == *"No new software available."* ]]; then
    print_result 0 "System is up to date"
else
    print_result 1 "Software updates are available" "$sw_update"
fi

# Check if Recovery OS is available
print_header "Recovery OS Check"
if [ -d "/System/Volumes/Recovery" ]; then
    print_result 0 "Recovery OS is available"
else
    print_result 1 "Recovery OS not found" "Unable to locate /System/Volumes/Recovery"
fi

# Check for any third-party kernel extensions
print_header "Third-Party Kernel Extensions"
kexts=$(kextstat | grep -v com.apple)
if [ -z "$kexts" ]; then
    print_result 0 "No third-party kernel extensions detected"
else
    print_result 1 "Third-party kernel extensions found" "$kexts"
fi

echo -e "\n${YELLOW}Script completed. Please review the output above for any warnings or unexpected results.${NC}"
echo -e "${YELLOW}If you see any red warnings, consider investigating further or contacting Apple Support.${NC}"
