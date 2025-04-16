[CmdletBinding()]
param(
    # Specifica l'unità di destinazione su cui spostare la distribuzione (es. "T:")
    [Parameter(Mandatory = $true)]
    [string]$DiskUnitSelected,

    # Modalità non distruttiva: se attivo, le operazioni di unregister/import non verranno eseguite
    [Parameter(Mandatory = $false)]
    [switch]$NonDestructive
)

# Controlla se lo script è eseguito con privilegi di amministratore
$principal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Output "Script non eseguito con privilegi di amministratore. Riavvio in modalità elevata..."
    $arguments = "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`" " + $args
    Start-Process PowerShell -Verb RunAs -ArgumentList $arguments
    exit
}

# Mostra la lista delle distribuzioni disponibili
Write-Output "Ecco la lista delle distribuzioni WSL disponibili:"
$availableDistros = wsl --list -o | Out-String
Write-Output $availableDistros

# Chiede all'utente di selezionare la distribuzione desiderata
$distroName = Read-Host "Seleziona la tua distribuzione (es. 'Ubuntu-22.04')"

Write-Output "Installazione su C: e poi spostamento su $DiskUnitSelected in corso..."

# Verifica se la distribuzione è già installata
$installedDistroNames = wsl --list --quiet | Out-String
if ($installedDistroNames -match $distroName) {
    Write-Output "La distribuzione $distroName è già installata. Procedo con lo spostamento..."
}
else {
    # Ciclo per tentare l'installazione finché non va a buon fine.
    do {
        Write-Output "Installazione della distribuzione $distroName in corso..."
        wsl --install -d $distroName
        
        if ($LASTEXITCODE -eq 0) {
            break
        }
        else {
            Write-Output "Errore durante l'installazione della distribuzione '$distroName'."
            Write-Output "`nSelezionare una distribuzione dalla colonna NAME e non dalla colonna FRIENDLY NAME e riprovare."

            $distroName = Read-Host "Reinserisci la tua distribuzione (es. 'Ubuntu-22.04')"
        }
    } while ($true)

    Write-Output "Attendere qualche minuto per completare l'installazione..."
    Start-Sleep -Seconds 30
    Write-Output "Installazione completata."
}

Write-Output "Spostamento nel disco $DiskUnitSelected in corso..."

# Definisce i percorsi per l'export e per la nuova destinazione
$exportDir = "$DiskUnitSelected\wsl-export"
$destDir = "$DiskUnitSelected\wsl"

if ($NonDestructive) {
    Write-Output "Modalità non distruttiva abilitata: le operazioni di unregister e import non verranno eseguite."
    $executeFlag = $false
} else {
    $executeFlag = $true
}

# Richiama lo script move-distribution.ps1 passando i parametri necessari
.\move-distribution.ps1 -WslSourceName $distroName -ExportDir $exportDir -DestDir $destDir -ExecuteUnregisterImport $executeFlag

Write-Output "Spostamento completato."
