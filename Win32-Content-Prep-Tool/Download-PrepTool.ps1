# Download the most recent master publish from git 
Write-Host "Downloading the Prep-Tool ZIP..."
Invoke-WebRequest -Uri "https://github.com/microsoft/Microsoft-Win32-Content-Prep-Tool/archive/refs/heads/master.zip" -OutFile "master.zip"

Write-Host "Extract downloaded zip..."
Expand-Archive -Path ".\master.zip" -DestinationPath ".\"

Write-Host "Move EXE from downloaded extract..."
Get-ChildItem -Path ".\" -Recurse -Include "*.exe" | Select-Object -First 1 | Move-Item -Destination ".\" -Force

Write-Host "Remove sub-directories..."
Get-ChildItem -Path ".\" -Directory | Remove-Item -Recurse 

Write-Host "Remove ZIPs"
Get-ChildItem -Path ".\" -Recurse -Include "*.zip" | Remove-Item