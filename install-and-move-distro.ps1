[CmdletBinding()]
param(
    # Specifies the destination drive where the distribution will be moved (e.g., "T:")
    [Parameter(Mandatory = $true)]
    [string]$DiskUnitSelected,

    # Non-destructive mode: if enabled, unregister/import operations will not be performed
    [Parameter(Mandatory = $false)]
    [switch]$NonDestructive
)

# Check if the script is running with administrator privileges
$principal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Output "Script is not running with administrator privileges. Restarting with elevated privileges..."
    $arguments = "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`" " + $args
    Start-Process PowerShell -Verb RunAs -ArgumentList $arguments
    exit
}

# Display the list of available WSL distributions
Write-Output "Here is the list of available WSL distributions:"
$availableDistros = wsl --list -o | Out-String
Write-Output $availableDistros

# Ask the user to select the desired distribution
$distroName = Read-Host "Select your distribution (e.g., 'Ubuntu-22.04')"

Write-Output "Installing on C: and then moving to $DiskUnitSelected..."

# Check if the distribution is already installed
$installedDistroNames = wsl --list --quiet | Out-String
if ($installedDistroNames -match $distroName) {
    Write-Output "The distribution $distroName is already installed. Proceeding with the move..."
}
else {
    # Loop to attempt installation until it is successful.
    do {
        Write-Output "Installing the distribution $distroName..."
        wsl --install -d $distroName
        
        if ($LASTEXITCODE -eq 0) {
            break
        }
        else {
            Write-Output "Error installing the distribution '$distroName'."
            Write-Output "`nSelect a distribution from the NAME column and not the FRIENDLY NAME column, then try again."
            $distroName = Read-Host "Re-enter your distribution (e.g., 'Ubuntu-22.04')"
        }
    } while ($true)

    Write-Output "Waiting a few minutes to complete the installation..."
    Start-Sleep -Seconds 30
    Write-Output "Installation complete."
}

Write-Output "Moving to drive $DiskUnitSelected..."

# Define the paths for export and for the new destination
$exportDir = "$DiskUnitSelected\wsl-export"
$destDir = "$DiskUnitSelected\wsl"

if ($NonDestructive) {
    Write-Output "Non-destructive mode enabled: unregister and import operations will not be performed."
    $executeFlag = $false
} else {
    $executeFlag = $true
}

# Call the move-distribution.ps1 script, passing the required parameters
.\move-distribution.ps1 -WslSourceName $distroName -ExportDir $exportDir -DestDir $destDir -ExecuteUnregisterImport $executeFlag

Write-Output "Move complete."
