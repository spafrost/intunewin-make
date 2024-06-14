Write-Host "IntuneWinAppUtil Build Script"


Write-Host "Setting Values"
############################################################################################################
$PackageTitle = "Descriptive Package Title"
$PackageDesc = "Something for users to read!"
$Version = Get-Date -Format "yyyy-MM-dd-HHmm" 
$TargetURI = "C:\Users\Public\Documents\My-Script"
$ExecuteScript = "Do-Action.ps1"
############################################################################################################


Write-Host "Version is $Version"
Write-Host "TargetURI is $TargetURI"

# Delete old build folders
Get-ChildItem -Path "..\build" -Directory  | Where-Object { $_.Name -match "\d{4}-\d{2}-\d{2}-\d{4}" } | ForEach-Object { 
   Remove-Item -Path $_.FullName -Recurse -Force
}

# Make somewhere to keep it
New-Item -ItemType Directory -Name $Version -Path ".\"

# Copy Files Here 
Copy-Item -Path "..\source\*" -Destination ".\$Version" -Recurse -Force 
$BuildFolder = (Get-Item -Path ".\$Version").FullName

Get-ChildItem $BuildFolder | Where-Object { $_.Name -like "*.ps1" } | ForEach-Object { 
    $File = $_.FullName
    $FileContent = Get-Content -Path $File

    ##### Per Variable Replacement #####
    $FileContent = $FileContent -replace "<!VERSION!>", $Version
    $FileContent = $FileContent -replace "<!TARGET!>", $TargetURI
    ##### End Per Variable Replacement #####

    Set-Content -Path $File -Value $FileContent
}

..\Win32-Content-Prep-Tool\IntuneWinAppUtil.exe -c $BuildFolder -s $ExecuteScript -o "..\bin\$Version" -q

Compress-Archive -Path $BuildFolder -DestinationPath "..\art\$Version.zip" 
Compress-Archive -Update -DestinationPath "..\art\$Version.zip" -Path "..\bin\$Version"

Write-Host "Use the following outputs when configuring the App in Intune GUI:" -ForegroundColor Yellow
Write-Host "$PackageTitle ($Version)" -ForegroundColor Green 
Write-Host $PackageDesc -ForegroundColor Green 
Write-Host "--------------------------------------------------" -ForegroundColor Yellow 
Write-Host "powershell.exe -ExecutionPolicy Bypass -File $ExecuteScript" -ForegroundColor Blue 