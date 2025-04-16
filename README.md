# WSL 2.0 Utility

## To download, install, and move a new distro:
Run the script by setting D: as the destination drive:  
```powershell
PowerShell -NoProfile -ExecutionPolicy Bypass -File .\install-and-move-distro.ps1 -DiskUnitSelected "D:"
```

## To move an existing distro:
```powershell
PowerShell -NoProfile -ExecutionPolicy Bypass -File ./move-distribution.ps1 -WslSourceName "NomeDistroQui" -DiskUnitSelected "D:"
```

### To view available distros:
```powershell
wsl --list -o
```

### To view installed distros:
```powershell
wsl --list
```

### If necessary, unblock the downloaded file:
```powershell
Unblock-File -Path "./move-distribution.ps1"
Unblock-File -Path "./install-and-move-distro.ps1"
```

## --- In case of logging in as root ---
Edit and save the file:
```bash
nano /etc/wsl.conf
```

```ini
[user]
default=nomeutentequi
```

Terminate and restart WSL:
```powershell
wsl --shutdown
```
 or
```powershell
wsl --terminate NomeDistroQui
```

```powershell
wsl
```