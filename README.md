# ⚙️ Install

[![Platform](https://img.shields.io/badge/platform-Windows-blue.svg)](https://github.com/YourUsername/Install)
[![Shell](https://img.shields.io/badge/shell-PowerShell-5391FE.svg)](https://learn.microsoft.com/en-us/powershell/)
[![License: MIT](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)

A streamlined, logged, and user-friendly post-install script for Windows using PowerShell and `winget`.

---

## 📦 What It Does

- Installs essential software for productivity, development, gaming, and daily use  
- Uses `winget` to silently install multiple packages  
- Logs all steps and results to your Desktop (`InstallLog.txt`)  
- Checks for admin privileges and winget availability  
- Optionally reboots system with user cancel option  

---

## 🧰 Features

✅ Installs:
- Browsers, editors, and archive tools (Firefox, VSCode, WinRAR, 7-Zip)  
- Chat & music (Discord, Spotify)  
- Game launchers (Steam, Riot, Ubisoft, Battle.net)  
- Proton tools (VPN, Mail, Drive, Pass, Calendar)  
- Java Runtime and .NET runtimes (8, 9, Framework 4.8)

✅ Logs:
- All actions timestamped  
- Appends to `InstallLog.txt` on user's Desktop  

✅ Reboot Prompt:
- Waits 60 seconds  
- ESC cancels shutdown  

---

## ⚙️ Usage

> 💡 Run in an elevated PowerShell session (right-click → “Run as Administrator”).

### 📂 Option 1: Clone and run
```powershell
git clone https://github.com/YourUsername/Install
cd Install
.\windows-install.ps1
