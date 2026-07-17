# RDR2 on CrossOver (Apple Silicon) — Unofficial Guide

Running Red Dead Redemption 2 (cracked/SteamRIP) on macOS via CrossOver 26.1, Apple M1 Max.

## Setup

### Bottle Config
- **CrossOver:** 26.1.0
- **Bottle:** Windows 10 64-bit (`WineArch=win64`, `Template=win10_64`)
- **Graphics:** D3DMetal (not DXVK)
- **Sync:** ESync (not MSync)
- **Game API in system.xml:** Vulkan (D3D12 also tested, both crash the same way)

### Game Files
- SteamRIP release with 1911 crack (`1911.dll`, `Launcher.exe`)
- Removed 12on7 `d3d12.dll` — CrossOver's native D3DMetal handles D3D12 better
- Symlink inside bottle: `drive_c/RDR2 -> /Users/.../RDR2/Red Dead Redemption 2`

### system.xml
Located at `~/Documents/Rockstar Games/Red Dead Redemption 2/Settings/system.xml`:
- `<API>kSettingAPI_Vulkan</API>` (or `kSettingAPI_D3D12`)
- `<windowed value="1" />`
- All graphics set to Low/Medium

## What Works / What Doesn't

### The Game Launches (partially)
The 1911 crack's `Launcher.exe` spawns `RDR2.exe` at ~100% CPU for 30s, then crashes with:
```
Unhandled exception 0x80000003 (INT 3 / breakpoint) at 00000001425B520C
```
This is the 1911 crack writing `0xCC` at runtime into `RDR2.exe`'s code section as an anti-debug measure. On Windows, the crack's VEH catches it. On Wine/CrossOver, the debugger catches it first and the process dies.

### What Was Tried
| Attempt | Result |
|---------|--------|
| Remove 12on7 d3d12.dll | Ran for 3+ min (process hung), window appeared but black |
| Switch system.xml to D3D12 | Same INT 3 crash |
| `WINEDLLOVERRIDES="winedbg="` | No change |
| Windows 7 registry mode | Same crash |
| Run RDR2.exe directly (no 1911) | Dies immediately, no crack |
| Run Launcher_with_cracktro.exe | Different crash (page fault) |
| Copy files into bottle (no symlink) | Same crash |
| SIGSTOP/SIGCONT trick | No effect on Crash Override (macOS) |
| Crash dialog suppression (`ShowCrashDialog=0`) | Still crashes, just no popup |
| ChilledEther/mac-crossover-fixes crash patch | Same INT 3 crash |

### Root Cause
The 1911 crack uses runtime code patching (writes INT 3 at specific addresses in RDR2.exe) as an anti-debug mechanism. Wine/CrossOver dispatches the resulting exception to the debugger instead of the crack's VEH handler.

## Recommended Approach

### Option A: EMPRESS Crack (build 1436.28)
The EMPRESS crack modifies the EXE on disk rather than patching at runtime. Known to work better on Wine. Full replacement:
1. Remove `1911.dll` and `Launcher.exe`
2. Apply EMPRESS crack files to game directory
3. Run `RDR2.exe` directly (no Launcher needed)

### Option B: Legitimate Steam Copy
Follow [matthiasSchedel/rdr2-crossover-apple-silicon](https://github.com/matthiasSchedel/rdr2-crossover-apple-silicon):
- Install Steam in CrossOver bottle
- Install RDR2 via Steam
- Apply `SocialClubHelper.exe` shim for blank sign-in fix
- Runs at 58-67 FPS on M1 Max at 1440p with FSR 2 Quality

### Option C: Cloud Gaming
Boosteroid streams RDR2 at 1080p/60fps on any Mac.

## Why Not Goldberg?
RDR2.exe imports `socialclub.dll` (Rockstar Social Club) — not `steam_api64.dll`. Goldberg only emulates Steam API. Without a stub for Social Club, it won't help alone.

## Files
- `scripts/launch.sh` — Launch wrapper for CrossOver
- `configs/system.xml` — Recommended graphics settings
- `configs/cxbottle.conf` — Bottle environment config
