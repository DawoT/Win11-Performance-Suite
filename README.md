# Win11 Performance Suite

![License](https://img.shields.io/github/license/DawoT/Win11-Performance-Suite)
![Platform](https://img.shields.io/badge/platform-Windows%2011-blue)
![PowerShell](https://img.shields.io/badge/PowerShell-5.1%20%7C%207-blue)

**Enterprise-grade optimization suite for Windows 11 high-performance environments.**

Originally designed to neutralize memory leaks in heavy development tools (like Language Servers), this suite has evolved into a complete system optimization toolkit. It unlocks hardware acceleration, optimizes network stacks for low latency, and relentlessly manages system resources using intelligent adaptive logic.

## 🚀 Key Features

### 🧠 Smart Adaptive Memory Guard
Replaces traditional "dumb" memory cleaners with an intelligent sentinel (`MemoryGuard/Purge-Smart.ps1`).
- **Adaptive Architecture**: Monitors Global RAM pressure every 2 seconds.
    - 🟢 **Green Zone (>4GB Free)**: Relaxed monitoring. Only purges critical leaks (e.g. broken Language Servers).
    - 🟡 **Yellow Zone (<4GB Free)**: Aggressive background trim for Browsers (Chrome/Edge) and Electron Apps (Code, Discord). **Protects your active window** to prevent stutter.
    - 🔴 **Red Zone (<2GB Free)**: Emergency purge of all eligible processes to prevent system hangs.
- **Targets**: `node`, `bun`, `deno`, `chrome`, `msedge`, `code`, `java`, `python`, `discord`, `slack`.
- **Resilience**: Immune to crashes. If the guard falls, the "Immortal Watchdog" (`.bat` loop) revives it instantly.
- **Stealth**: Runs invisibly via VBScript service.

### ⚡ System Unlocked
Located in `System/`.
- **Bloatware Killer**: Removes background services for Xbox, Phone Link, Retail Demo, and Maps.
- **Network**: TCP Autotuning 'Normal', CTCP Congestion Provider, Optimized DNS.
- **I/O**: Forced SSD TRIM, Disabled Legacy NTFS overhead (8.3/LastAccess).
- **defender Minimizer**: Soft-kills Windows Defender satellite services to reduce CPU usage without disabling core protection.

### 🎮 Hardware Acceleration
Located in `Utils/`.
- **GPU**: Enforces "Hardware Accelerated GPU Scheduling" (HAGS).
- **CPU**: Disables Core Parking for consistent priority handling.
- **MSI Mode**: Enables Message Signaled Interrupts for NVIDIA GPUs (Low Latency).

## 📦 Installation

### Option 1: Full Optimization (One-Click)
Run `Apply-System-Optimizations.bat` as Administrator.
> Applies all optimizations found in the `System/` folder (Network, Disk, UI, Bloatware).

### Option 2: Install Memory Guard
Run `MemoryGuard/Install-Immortal.ps1` with PowerShell (Admin).
> Installs the boot-time watchdog service. This is "Install & Forget".

## 🛠️ Usage

- **Check System Health**: Run `Utils/Verify-PostBoot.ps1` to see a dashboard of your RAM, Services, and Network status.
- **Manual Global Purge**: Run `MemoryGuard/Invoke-Global-Purge.ps1` to instantly free GBs of RAM (Wise Optimizer style).

## 🤝 Contributing

Contributions are welcome! Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct.

## 📝 License

This project is licensed under the MIT License.

---
*Maintained by [DawoT](https://github.com/DawoT)*
