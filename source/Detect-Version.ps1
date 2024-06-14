
$TargetURI = "<!TARGET!>\version.json"
$Version = (Get-Content -Path $TargetURI -ErrorAction SilentlyContinue) | ConvertFrom-Json | Select-Object -ExpandProperty Version
if($Version -eq "<!VERSION!>") { 
    Write-Host "Detected!"
    return 0
}