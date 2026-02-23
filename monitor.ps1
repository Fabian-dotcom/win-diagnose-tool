Clear-Host
$Host.UI.RawUI.WindowTitle = "DIAGNOSE - MONITOR"

# Arbeitsverzeichnis sicherstellen
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
if ([string]::IsNullOrEmpty($scriptDir)) { $scriptDir = Get-Location }
Set-Location $scriptDir

$winVersion = [System.Environment]::OSVersion.Version
$buildNumber = $winVersion.Build
$osName = if ($buildNumber -ge 22000) { "Windows 11" } else { "Windows 10" }

Write-Host "======================================" -ForegroundColor Cyan
Write-Host "DIAGNOSE MONITOR" -ForegroundColor Cyan
Write-Host "Betriebssystem: $osName (Build $buildNumber)" -ForegroundColor Cyan
Write-Host "Verzeichnis: $(Get-Location)" -ForegroundColor Cyan
Write-Host "Bereit fuer Befehle..." -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan

function Run-Check {
    param (
        [string]$CheckScript,
        [string]$DisplayName
    )

    Write-Host ""
    Write-Host "[*] Fuehre aus: $DisplayName" -ForegroundColor Yellow
    
    $startTime = Get-Date
    
    try {
        & ".\checks\$CheckScript" 2>&1 | Out-Null
        $elapsed = (Get-Date) - $startTime
        Write-Host "[+] $DisplayName abgeschlossen (${elapsed.TotalSeconds:F1}s)" -ForegroundColor Green
        return $true
    }
    catch {
        Write-Host "[X] $DisplayName FEHLER: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
}

function Show-Status {
    param (
        [string]$Name,
        [string]$Pattern
    )

    $file = Get-ChildItem -Path "reports\$Pattern" -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending | Select-Object -First 1
    
    if ($file) {
        $content = Get-Content $file.FullName -ErrorAction SilentlyContinue
        $statusLine = $content | Select-String "STATUS:" | Select-Object -First 1
        
        if ($statusLine) {
            $status = $statusLine.ToString() -replace ".*STATUS:\s*", ""
            $status = $status.Trim()
            
            $color = switch ($status) {
                "OK" { "Green" }
                "GEFAHR" { "Red" }
                "HINWEIS" { "Yellow" }
                default { "Gray" }
            }
            
            Write-Host "    [$status]" -ForegroundColor $color
            return
        }
    }
    
    Write-Host "    [UNKNOWN]" -ForegroundColor Gray
}

# Hauptschleife
while ($true) {

    if (Test-Path "status\command.txt") {

        $cmd = Get-Content "status\command.txt" -ErrorAction SilentlyContinue
        Remove-Item "status\command.txt" -ErrorAction SilentlyContinue

        $cmd = $cmd.Trim()
        Write-Host "`n>>> Befehl empfangen: $cmd" -ForegroundColor Magenta

        if ($cmd -eq "START FULL") {
            Write-Host "`nSTARTE KOMPLETTDIAGNOSE..." -ForegroundColor Cyan
            
            Run-Check "ram.ps1" "RAM-Analyse"
            Show-Status "RAM" "RAM_*.txt"
            
            Run-Check "defender.ps1" "Sicherheitscheck"
            Show-Status "SECURITY" "SECURITY_*.txt"
            
            Run-Check "autostart.ps1" "Autostart-Check"
            Show-Status "AUTOSTART" "AUTOSTART_*.txt"
            
            Run-Check "cpu.ps1" "CPU-Analyse"
            Show-Status "CPU" "CPU_*.txt"
            
            Write-Host ""
            Write-Host "Erstelle Zusammenfassung..." -ForegroundColor Yellow
            & .\summarize.ps1 2>&1 | Out-Null
            
            Write-Host ""
            Write-Host "DIAGNOSE ABGESCHLOSSEN!" -ForegroundColor Green
            Write-Host "Ergebnisse in: reports\" -ForegroundColor Gray
            Write-Host "======================================" -ForegroundColor Cyan
        }
        elseif ($cmd -eq "START RAM") {
            Write-Host "`nSTARTE RAM-CHECK..." -ForegroundColor Cyan
            Run-Check "ram.ps1" "RAM-Analyse"
            Show-Status "RAM" "RAM_*.txt"
            Write-Host ""
        }
        elseif ($cmd -eq "START SECURITY") {
            Write-Host "`nSTARTE SECURITY-CHECK..." -ForegroundColor Cyan
            Run-Check "defender.ps1" "Sicherheitscheck"
            Show-Status "SECURITY" "SECURITY_*.txt"
            Write-Host ""
        }
        else {
            Write-Host "Unbekannter Befehl: $cmd" -ForegroundColor Red
        }
        
        Write-Host "Bereit fuer naechsten Befehl..." -ForegroundColor Cyan
    }

    Start-Sleep -Milliseconds 500
}
