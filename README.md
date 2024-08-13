# iOS Bypass and MDM Check Script

This repository provides a script to check whether an iOS device is MDM (Mobile Device Management) controlled, iCloud locked, or bypassed. The script helps determine:

1. **MDM Bypass Status**: Whether the device has an MDM profile installed or if it has been bypassed.
2. **iCloud Lock Status**: Whether the device is iCloud locked and if it has been bypassed.

## Table of Contents

- [Requirements](#requirements)
- [Usage](#usage)
  - [Check MDM Bypass Status](#1-check-mdm-bypass-status)
  - [Check iCloud Lock Status](#2-check-icloud-lock-status)
  - [Detecting High-Quality Bypass](#3-detecting-high-quality-bypass)
- [Conclusion](#conclusion)
- [Disclaimer](#disclaimer)

## Requirements

Before running the script, ensure you have the following:

- **Jailbroken iOS Device**: Some checks require a jailbroken environment.
- **Libimobiledevice Tools**: Install tools like `ideviceinfo`, `ideviceprovision`, `cfgutil`, or `idevicediagnostics`.
- **Terminal/Command Line Access**: Necessary to run the commands provided.

## Usage

### 1. Check MDM Bypass Status

This section checks if the device is under MDM control or if it has been bypassed.

```bash
# Check for MDM Profile
ideviceinfo -k ConfigurationProfiles

# Another method to check for MDM
ideviceprovision -l | grep -i "Profile" 

# Check for MDM-related restrictions
ideviceinfo -k Restrictions | grep -i "mdm"

# Check MDM Profile presence in system files (Jailbreak required)
ls /var/mobile/Library/ConfigurationProfiles/
```
### 2. Check Icloud Lock Status

```bash
# Check Activation Lock Status
ideviceinfo -k ActivationState

# Check iCloud Account Status
ideviceinfo -k AppleAccountInfo

# Verify iCloud Bypass (Jailbreak required)
cat /var/root/Library/Lockdown/activation_records.plist | grep -i "bypass"
```

### 3. Detecting High Quality Bypass

```bash
# Check Activation Lock Status
ideviceinfo -k ActivationState

# Check iCloud Account Status
ideviceinfo -k AppleAccountInfo

# Verify iCloud Bypass (Jailbreak required)
cat /var/root/Library/Lockdown/activation_records.plist | grep -i "bypass"

```

### 4. Conclusion 

```bash
This script provides a basic method to detect if an iOS device is under MDM control or iCloud locked and whether it has been bypassed. For more in-depth analysis, additional tools or methods might be required, especially when dealing with high-quality bypasses.
```

### 5. Disclaimer


