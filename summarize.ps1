# Zusammenfassung aller Reports
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$danger = @(Get-ChildItem "reports\*_GEFAHR*.txt" -ErrorAction SilentlyContinue)
$warn   = @(Get-ChildItem "reports\*_HINWEIS*.txt" -ErrorAction SilentlyContinue)

$suffix = "_OK"
$color = "Green"

if ($danger.Count -gt 0) {
    $suffix = "_GEFAHR"
    $color = "Red"
}
elseif ($warn.Count -gt 0) {
    $suffix = "_HINWEIS"
    $color = "Yellow"
}

$summary = "reports\SUMMARY$suffix`_$timestamp.txt"

$summaryContent = @"
=====================================
SYSTEMDIAGNOSE ZUSAMMENFASSUNG
=====================================
Erstellt: $(Get-Date)
Status: $suffix

"@

# Alle Reports hinzufügen
$summaryContent += "`n=== DETAILLIERTE BERICHTE ===`n`n"
Get-ChildItem "reports\*.txt" -ErrorAction SilentlyContinue | 
    Where-Object { $_.Name -notlike "SUMMARY*" } | 
    ForEach-Object {
        $summaryContent += "--- $(​$_.Name) ---`n"
        $summaryContent += (Get-Content $_.FullName | Out-String)
        $summaryContent += "`n`n"
    }

$summaryContent | Out-File $summary -Encoding UTF8 -Force

Write-Host "SUMMARY erstellt: $summary" -ForegroundColor $color