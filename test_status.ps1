$reportFiles = @(Get-ChildItem -Path "reports\RAM_*.txt" -ErrorAction SilentlyContinue)
Write-Host "Gefundene Reports: $($reportFiles.Count)"

foreach ($file in $reportFiles) {
  $content = Get-Content $file -ErrorAction SilentlyContinue
  Write-Host "Datei: $($file.Name)"
  
  if ($content | Select-String "STATUS:" -Quiet) {
    $line = $content | Select-String "STATUS:" | Select-Object -First 1
    Write-Host "  Zeile: $($line.ToString())"
    $status = $line.ToString() -replace ".*STATUS:\s*", ""
    Write-Host "  Status: '$status'" -ForegroundColor Green
  }
}
