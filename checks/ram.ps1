# RAM-Analyse
try {
    $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $totalRAM = [Math]::Round((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1GB, 2)
    $freeRAM = [Math]::Round((Get-CimInstance Win32_OperatingSystem).FreePhysicalMemory / 1MB, 2)
    $usedRAM = $totalRAM - ($freeRAM / 1024)
    $usagePercent = [Math]::Round(($usedRAM / $totalRAM) * 100, 2)

    $output = @"
=== RAM-ANALYSE ===
Gesamter RAM: $totalRAM GB
Genutzter RAM: $usedRAM GB
Freier RAM: $freeRAM MB
Auslastung: $usagePercent %

"@

    # Top 5 RAM-intensive Prozesse
    $topProcesses = Get-Process | Sort-Object -Property WorkingSet64 -Descending | Select-Object -First 5
    $output += "`n=== Top 5 RAM-Prozesse ===`n"
    foreach ($proc in $topProcesses) {
        $ramMB = [Math]::Round($proc.WorkingSet64 / 1MB, 2)
        $output += "$($proc.Name): $ramMB MB`n"
    }

    # Status bestimmen
    if ($usagePercent -gt 90) {
        $status = "GEFAHR"
    }
    elseif ($usagePercent -gt 75) {
        $status = "HINWEIS"
    }
    else {
        $status = "OK"
    }

    $output += "`nSTATUS: $status"

    # Report schreiben
    $reportPath = "reports\RAM_$status`_$timestamp.txt"
    $output | Out-File -FilePath $reportPath -Encoding UTF8 -Force
}
catch {
    "STATUS: GEFAHR" | Out-File "reports\RAM_GEFAHR_$(Get-Date -Format yyyyMMdd_HHmmss).txt" -Encoding UTF8 -Force
}