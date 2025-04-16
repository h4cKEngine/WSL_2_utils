# WSL 2.0 Utility
This repo is based on the move-distribution.ps1 script made by freemansoft.

Check it for more useful info about WSL 2: https://github.com/freemansoft/wsl2-utils or directly in the wsl2-utils-main.zip

Make sure to get enoght space both in C: and in D: drives.
Every command below requires, obviusly, to be executed a admin shell console open in the same folder of the scripts.
If you want you can try it without it but it is not sure it works correctly.

## To download, install, and move a new distro:
Run the script by setting D: as the destination drive (could be whatever letter or disk, with enought space):
```powershell
PowerShell -NoProfile -ExecutionPolicy Bypass -File .\install-and-move-distro.ps1 -DiskUnitSelected "D:"
```

## To move an existing distro:
```powershell
PowerShell -NoProfile -ExecutionPolicy Bypass -File .\move-distribution.ps1 -WslSourceName "NameDistroHere" -DiskUnitSelected "D:"
```

Both scripts set the downloaded distro as default wsl distribution (done in move-distribution.ps1).

### To check available online distros:
```powershell
wsl --list --online
```

### To check installed distros:
```powershell
wsl --list
```

### If necessary, unblock the downloaded files:
```powershell
Unblock-File -Path ".\install-and-move-distro.ps1"
Unblock-File -Path ".\move-distribution.ps1"
```

## Options
The most important options are:
```
-WslSourceName "NameDistroHere"
```
To set the distro name choosen

```
-DiskUnitSelected "D:"
```
To set the unit letter of the disk choosen (or whather disk letter it is)

#### Non Destructive options
With Non-destructive mode enabled unregister and move operations will not be performed.
for example. 
```powershell
PowerShell -NoProfile -ExecutionPolicy Bypass -File ./move-distribution.ps1 -WslSourceName "NameDistroHere" -DiskUnitSelected "D:" -NonDestructive
```

## --- In case of default logging in only as root ---
Edit and save the file:
```bash
nano /etc/wsl.conf
```

```ini
[user]
default=usernamehere
```

Terminate and restart WSL:
To terminate all distros:
```powershell
wsl --shutdown
```
Or just one:
```powershell
wsl --terminate NameDistroHere
```
And finally launch:
```powershell
wsl
```