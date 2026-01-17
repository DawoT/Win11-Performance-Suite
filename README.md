# Win11 Performance Suite

![License](https://img.shields.io/github/license/DawoT/Win11-Performance-Suite)
![Platform](https://img.shields.io/badge/platform-Windows%2011-blue)
![PowerShell](https://img.shields.io/badge/PowerShell-5.1%20%7C%207-blue)

**Enterprise-grade optimization suite for Windows 11 high-performance environments.**

Originally designed to neutralize memory leaks in heavy development tools (like Language Servers), this suite has evolved into a complete system optimization toolkit. It unlocks hardware acceleration, optimizes network stacks for low latency, and relentlessly manages system resources.

## 🚀 Key Features

### 🛡️ Antigravity Memory Guard (Immortal Watchdog)
Eliminates memory leaks in long-running processes.
- **Architecture**: Stateless Watchdog (`.bat` loop) + Surgical Purge (`.ps1`).
- **Resilience**: Immune to crashes, shutdowns, or "optimizer" conflicts.
- **Performance**: Keeps leaky processes (e.g., node, rust binaries) under **200MB**.
- **Stealth**: Runs invisibly via VBScript.

### ⚡ System Unlocked
- **Network**: TCP Autotuning 'Normal', CTCP Congestion Provider, Optimized DNS.
- **I/O**: Forced SSD TRIM, Disabled Legacy NTFS overhead (8.3/LastAccess).
- **Startup**: Neutralizes hidden background updaters (Edge, MiniTool, etc.).

### 🎮 Hardware Acceleration
- **GPU**: Enforces "Hardware Accelerated GPU Scheduling" (HAGS).
- **CPU**: Disables Core Parking for consistent priority handling.
- **MSI Mode**: Enables Message Signaled Interrupts for NVIDIA GPUs (Low Latency).

## 📦 Installation

### Option 1: Full Optimization (One-Click)
Run `Apply-System-Optimizations.bat` as Administrator.
> Applies Network, Disk, UI, and Startup optimizations.

### Option 2: Install Memory Guard
Run `Install-Immortal.ps1` with PowerShell (Admin).
> Installs the boot-time watchdog service to prevent memory leaks permanently.

## 🛠️ Configuration

You can customize the memory thresholds in `System-Memory-Manager.ps1`:

```powershell
$MaxRAMPercent = 85       # Emergency cleanup threshold
$MinFreeMB = 2048         # Minimum free RAM to maintain
$ProtectedProcesses = @("Antigravity", "Code", "devenv") # Apps to protect from background trimming
```

## 🤝 Contributing

Contributions are welcome! Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct, and the process for submitting pull requests.

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---
*Maintained by [DawoT](https://github.com/DawoT)*
