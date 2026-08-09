# Windows Scripts

A collection of Windows batch, CMD and AutoIt utilities written for desk-side IT
work: setting static IPs, renaming machines, mapping admin shares, verifying file
hashes, and automating repetitive GUI entry.

Anything network- or site-specific is a placeholder. **Wherever you see
`PRIMARY_DNS_IP`, `GATEWAY_IP`, `DNS_IP`, `HOSTNAME_PREFIX` or `YOUR_DOMAIN`,
fill in your own value first — the scripts do nothing useful until you do.**

> These scripts change IP configuration, rename computers, mount administrative
> shares and edit the registry. Read one before you run it. Several require an
> elevated prompt, and two delete themselves when they finish.

---

## Windows Modifications

### `IPv4Changer.bat`
Menu-driven adapter configuration. Set a static IP on Ethernet or Wi-Fi, view
adapter details, dump the full IP configuration, or switch an adapter back to
DHCP.

### `IT Tools.cmd`
The larger version of the above, with the extras a technician wants on a bench
machine: hostname display and rename, a three-step software installer, a hosts
file editor that opens Notepad and Explorer side by side, self-elevation via
VBScript, a shell, and domain settings. Writes a log to `%COMPUTERNAME%.txt` with
the hostname, IP configuration and installed product versions.

The installer step expects these three files next to the script:

1. `1-CWControlClientInstaller.msi`
2. `2-Agent_Install(wizard).MSI`
3. `3-Agent_Install(backend).exe`

### `StaticIPv4.cmd`
Prompts for IP, subnet and gateway, applies them to the `Ethernet` adapter, then
sets two DNS servers and opens Network Connections.

**Fill in first:** `PRIMARY_DNS_IP` and `SECONDARY_DNS_IP`.
**Note:** ends with `del %0` — the script deletes itself after running.

### `Micros Set.cmd`
Same idea, aimed at POS terminals: takes the last octet of the address, applies
a fixed subnet and gateway, sets DNS, then renames the machine via WMIC.

**Fill in first:** the IP prefix on the `set /P a=` line, `GATEWAY_IP` and
`DNS_IP`.
**Note:** also ends with `del %0`.

### `OpenClient.cmd`
Maps the `C$` administrative share of a remote machine by hostname or IP, so you
can browse its drive from Explorer. Also clears all mapped drives.

**Fill in first:** `%a%` and `%b%` at the top are the username and password used
for `net use`. Set them at runtime instead of saving credentials in the file, and
edit `HOSTNAME_PREFIX` and the IP prefix to match your network.

### `EVR.bat`
Environment Variable Rescue. Backs up a named environment variable from both the
system and user registry hives to a timestamped text file, then lets you edit or
restore it. Self-elevates through PowerShell. Change `TARGET_VAR` at the top —
it ships set to `testX`.

### `Values.reg`
Enables Windows automatic logon by writing `AutoAdminLogon` under `Winlogon`.

> **This weakens the machine.** It stores a logon password in the registry in
> plain text and lets anyone with physical access boot straight to a desktop.
> `DefaultPassword` and `DefaultDomainName` ship as placeholders — filling them
> in is what makes the risk real. Don't use this on anything portable.

---

## File Integrity

Two scripts that work on a `MyFiles\` folder placed beside them.

### `Hash Gen.bat`
Walks every file in `MyFiles\` and writes name, size, line count, character count
and MD5 hash to `Hashes\md5_hashes.txt`.

### `Hash Read.bat`
Walks the same folder, prints the same details, and prompts you for the expected
hash of each file. Reports a match/mismatch tally at the end.

Uses `certutil` for MD5 and PowerShell for the character count — both ship with
Windows.

> MD5 detects accidental corruption. It does **not** detect deliberate
> tampering: MD5 collisions are cheap to produce. Use it to catch a bad copy, not
> to prove a file is authentic.

`MyFiles\` and `Hashes\` are included with sample content so you can see the
output format.

---

## Tools

Small AutoIt utilities. Source is the `.au3`; the `.exe` beside it is the
compiled build.

### `N.C.R.J/NCR.au3`
Nine text fields bound to `Ctrl+1` … `Ctrl+9`. Press a hotkey and the contents of
that field are typed into whatever window has focus. `Shift+Alt+T` exits. Built
for filling the same values into a form over and over.

### `N.C.R.J/SPC.au3`
A variant of the same idea with its own field set.

### `Auto Sign.exe`, `N.C.RTool.exe`, `N.C.R.T.exe`
Compiled builds whose AutoIt source is not in this repository.

---

## Automation

`Automation/CSM(1)` holds per-OS versions of a GUI automation routine — Windows
2000, XP, Vista and 7 each get their own script, because the dialogs they drive
differ between versions. `Tools.au3` is a launcher for common Windows control
panels. `Automation/OLD` is earlier drafts, kept for reference.

These target long-unsupported versions of Windows and are published as a record
of the work rather than as something to deploy.

---

## Running these

- **Windows only.** Nothing here runs on macOS or Linux.
- **AutoIt** is needed to run or recompile the `.au3` files:
  <https://www.autoitscript.com/site/autoit/downloads/>
- **Administrator rights** are required for IP changes, renames, registry edits,
  admin-share mapping and software installs. Some scripts self-elevate; others
  simply fail without explaining why.

## A note on the bundled `.exe` files

This repository ships AutoIt installers (`1. autoit-v3-setup.exe`,
`2. autoit-v3.3.6.1-setup.exe`) and compiled builds of the scripts. The
installers are redistributed third-party software and account for most of the
repository size — prefer the official download linked above. The compiled
builds can't be verified against their source by anyone cloning this, and
AutoIt-compiled executables are frequently flagged by antivirus. Run the `.au3`
source instead where you have a choice.
