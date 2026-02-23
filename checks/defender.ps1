# Windows Defender / Sicherheits-Check
try {
    $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $winVersion = [System.Environment]::OSVersion.Version
    $buildNumber = $winVersion.Build
    $osName = if ($buildNumber -ge 22000) { "Windows 11" } else { "Windows 10" }
    
    $output = "=== SICHERHEITS-CHECK ===`n"
    $output += "Betriebssystem: $osName (Build $buildNumber)`n"
    
    # Windows Defender Status
    $mp = Get-MpComputerStatus -ErrorAction SilentlyContinue
    
    if ($mp) {
        $output += "`n=== Windows Defender ===`n"
        $output += "Real-Time Protection: $(if ($mp.RealTimeProtectionEnabled) {'Aktiviert'} else {'DEAKTIVIERT'})`n"
        $output += "Tamper Protection: $(if ($mp.IsTamperProtected) {'Aktiviert'} else {'Deaktiviert'})`n"
        
        $status = "OK"
        if (-not $mp.RealTimeProtectionEnabled) {
            $status = "GEFAHR"
        }
        elseif (-not $mp.IsTamperProtected -and $buildNumber -ge 22000) {
            $status = "HINWEIS"
        }
    }
    else {
        $output += "`nWindows Defender: Nicht verfügbar`n"
        $status = "HINWEIS"
    }
    
    $output += "`nSTATUS: $status"
    
    $reportPath = "reports\SECURITY_$status`_$timestamp.txt"
    $output | Out-File -FilePath $reportPath -Encoding UTF8 -Force
}
catch {
    "STATUS: GEFAHR`nFehler bei Sicherheitscheck" | Out-File "reports\SECURITY_GEFAHR_$(Get-Date -Format yyyyMMdd_HHmmss).txt" -Encoding UTF8 -Force
}