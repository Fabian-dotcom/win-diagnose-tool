# Autostart-Überprüfung
try {
    $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    
    $output = "=== AUTOSTART-CHECK ===`n`n"
    
    # Registry Autostart
    $runKeys = @(
        "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run",
        "HKCU:\Software\Microsoft\Windows\CurrentVersion\RunOnce",
        "HKLM:\Software\Microsoft\Windows\CurrentVersion\Run",
        "HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce"
    )
    
    $count = 0
    foreach ($key in $runKeys) {
        $items = Get-ItemProperty -Path $key -ErrorAction SilentlyContinue
        if ($items) {
            $members = $items | Get-Member -MemberType NoteProperty | Where-Object {$_.Name -notmatch "^PS"}
            $count += $members.Count
        }
    }
    
    $output += "Autostart-Einträge in Registry: $count`n"
    
    # Startup Folder
    $startupFolder = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup"
    $startupItems = @(Get-ChildItem -Path $startupFolder -ErrorAction SilentlyContinue)
    $output += "Startup-Ordner Einträge: $($startupItems.Count)`n"
    
    # Status bestimmen
    $totalAutostart = $count + $startupItems.Count
    if ($totalAutostart -gt 20) {
        $status = "GEFAHR"
    }
    elseif ($totalAutostart -gt 10) {
        $status = "HINWEIS"
    }
    else {
        $status = "OK"
    }
    
    $output += "`nSTATUS: $status"
    
    $reportPath = "reports\AUTOSTART_$status`_$timestamp.txt"
    $output | Out-File -FilePath $reportPath -Encoding UTF8 -Force
}
catch {
    "STATUS: HINWEIS`nFehler bei Autostart-Check" | Out-File "reports\AUTOSTART_HINWEIS_$(Get-Date -Format yyyyMMdd_HHmmss).txt" -Encoding UTF8 -Force
}