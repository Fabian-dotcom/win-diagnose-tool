$status = "OK"

$nonMs = Get-Service |
Where {$_.Status -eq "Running"} |
Where {$_.DisplayName -notmatch "Microsoft"}

if ($nonMs.Count -gt 20) {
    $status = "HINWEIS"
}

"STATUS: $status" | Out-File "..\reports\SERVICES.txt" -Encoding UTF8
$nonMs | Select Name,DisplayName |
Out-String |
Out-File "..\reports\SERVICES.txt" -Append