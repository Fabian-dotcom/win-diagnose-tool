# CPU-Analyse
try {
    $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    
    $output = "=== CPU-ANALYSE ===`n"
    
    # Top 5 CPU-intensive Prozesse
    $topCPUProc = Get-Process | Where-Object {$_.Name -ne "Idle"} | Sort-Object -Property CPU -Descending | Select-Object -First 5
    
    $output += "`n=== Top 5 CPU-Prozesse ===`n"
    $maxCPU = 0
    foreach ($proc in $topCPUProc) {
        $cpu = [Math]::Round($proc.CPU, 2)
        $output += "$($proc.Name): $cpu Sekunden`n"
        if ($cpu -gt $maxCPU) { $maxCPU = $cpu }
    }
    
    # Status bestimmen
    if ($maxCPU -gt 600) {
        $status = "GEFAHR"
    }
    elseif ($maxCPU -gt 300) {
        $status = "HINWEIS"
    }
    else {
        $status = "OK"
    }
    
    $output += "`nHöchster CPU-Wert: $maxCPU Sekunden"
    $output += "`nSTATUS: $status"
    
    $reportPath = "reports\CPU_$status`_$timestamp.txt"
    $output | Out-File -FilePath $reportPath -Encoding UTF8 -Force
}
catch {
    "STATUS: GEFAHR" | Out-File "reports\CPU_GEFAHR_$(Get-Date -Format yyyyMMdd_HHmmss).txt" -Encoding UTF8 -Force
}