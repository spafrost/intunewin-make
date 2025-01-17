Write-Host "IntuneWinAppUtil Build Script"


Write-Host "Reading settings file @ .\packageConfig.json"
try { 
    $jsonSettings = Get-Content -Path ".\packageConfig.json" | ConvertFrom-Json
} catch { 
    Write-Host "Failed to read .\packageConfig.json, exiting"
    exit
}

Write-Host "Version is $($jsonSettings.PackageVersion)"
Write-Host "WorkingDirectory is $($jsonSettings.WorkingDirectory)"

# Delete old build folders
Get-ChildItem -Path "..\build" -Directory  | Where-Object { $_.Name -match "\d{4}-\d{2}-\d{2}-\d{4}" } | ForEach-Object { 
   Remove-Item -Path $_.FullName -Recurse -Force
}

# Make somewhere to keep it
New-Item -ItemType Directory -Name $($jsonSettings.PackageVersion) -Path ".\"

# Copy Files Here 
Copy-Item -Path "..\source\*" -Destination ".\$($jsonSettings.PackageVersion)" -Recurse -Force 
$BuildFolder = (Get-Item -Path ".\$($jsonSettings.PackageVersion)").FullName

Get-ChildItem $BuildFolder | Where-Object { $_.Name -like "*.ps1" } | ForEach-Object { 
    $File = $_.FullName
    $FileContent = Get-Content -Path $File

    ##### Per Variable Replacement #####
    $FileContent = $FileContent -replace "<!VERSION!>", $($jsonSettings.PackageVersion)
    $FileContent = $FileContent -replace "<!WORKING-DIR!>", $($jsonSettings.WorkingDirectory)
    $FileContent = $FileContent -replace "<!PKG-TITLE!>", $($jsonSettings.PackageTitle)
    $FileContent = $FileContent -replace "<!PKG-DESC!>", $($jsonSettings.PackageDescription)
    ##### End Per Variable Replacement #####

    Set-Content -Path $File -Value $FileContent
}

..\Win32-Content-Prep-Tool\IntuneWinAppUtil.exe -c $BuildFolder -s $($jsonSettings.ExecuteScript) -o "..\bin\$($jsonSettings.PackageVersion)" -q

Compress-Archive -Path $BuildFolder -DestinationPath "..\art\$($jsonSettings.PackageVersion).zip" 
Compress-Archive -Update -DestinationPath "..\art\$($jsonSettings.PackageVersion).zip" -Path "..\bin\$($jsonSettings.PackageVersion)"

Write-Host "Use the following outputs when configuring the App in Intune GUI:" -ForegroundColor Yellow
Write-Host "$($jsonSettings.PackageTitle) ($($jsonSettings.PackageVersion))" -ForegroundColor Green 
Write-Host $($jsonSettings.PackageDescription) -ForegroundColor Green 
Write-Host "--------------------------------------------------" -ForegroundColor Yellow 
Write-Host "powershell.exe -ExecutionPolicy Bypass -File $($jsonSettings.ExecuteScript)" -ForegroundColor Blue 