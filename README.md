# Utility Toolkit

This repository contains a set of custom Windows utilities for network configuration, file integrity verification, and autofill automation. These scripts are designed to assist technicians, IT administrators, and power users.

---

## 1. MD5 Hash Verifier + File Info (`md5_verifier.bat`)

### Features:
- Checks for the existence of a `MyFiles\` directory.
- For each file:
  - Displays file name, size, line count, character count.
  - Calculates MD5 hash.
  - Compares it to a user-supplied hash.
- Displays summary of matched and mismatched hashes.

### Usage:
1. Place files to be verified in a folder called `MyFiles` in the same directory as the script.
2. Run the batch script.
3. Manually enter the expected hash when prompted.

---

## 2. Auto-Fill GUI Tool (AutoIt: `auto_fill_tool.au3`)

### Features:
- GUI with 9 input fields for custom text.
- Binds hotkeys `Ctrl + 1` through `Ctrl + 9` to each field.
- Sends the content of the corresponding field to the active window when a hotkey is pressed.
- `Shift + Alt + T` terminates the script.
- Auto-detects Paint version for compatibility with older OS versions.

### Hotkeys:
| Hotkey    | Sends Text From |
|-----------|------------------|
| Ctrl + 1  | Input Field 1    |
| Ctrl + 2  | Input Field 2    |
| Ctrl + 3  | Input Field 3    |
| ...       | ...              |
| Ctrl + 9  | Input Field 9    |
| Shift+Alt+T | Exit Script   |

### Requirements:
- AutoIt installed: https://www.autoitscript.com/site/autoit/downloads/

---

## 3. IPv4 Changer Utility (`ipv4_changer.bat`)

### Features:
A command-line menu utility to manage network settings.

#### Main Menu Options:
1. Edit Ethernet IP (static).
2. View Ethernet Info.
3. Edit Wi-Fi IP (static).
4. View Wi-Fi Info.
5. Show all IP configurations.
6. Enable DHCP for selected adapter.
7. Show hostname.
8. Change hostname.
9. Multi-software installer (three MSI/EXE files).
10. Edit hosts file in Notepad.
11. Relaunch script as admin if needed.
12. Open CMD shell.
13. Open domain settings.

#### Special Utilities:
- Creates a log file (`%COMPUTERNAME%.txt`) with hostname, IP config, and installed product versions.
- Hosts file editor opens Notepad and File Explorer side by side.
- Admin privilege escalation handled via VBScript if needed.
- Supports adapter selection before editing IP or enabling DHCP.

### File Installer:
Installs the following in order:
1. `1-CWControlClientInstaller.msi`
2. `2-Agent_Install(wizard).MSI`
3. `3-Agent_Install(backend).exe`

Ensure these files are present in the script directory.

---

## Requirements

- Windows OS
- Administrator privileges (for hostname changes, IP edits, and software installs)
- `certutil` (included with Windows) for MD5 hashing
- PowerShell for character count in the MD5 script
- AutoIt for the GUI autofill tool

---