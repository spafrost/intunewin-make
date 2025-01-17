#############################################
#
#  INTUNEWIN-MAKE - 17/01/2025 10:38
#     This script is part of IntuneWin-Make, a small wrapper tool used to wrap any script 
#     or executable in a .intunewin file and provide basic logging and detection features.
#
#  This script was used to install: 
#  <!PKG-TITLE!> <!VERSION!>
#  <!PKG-DESC!> 
#
#############################################

# These will be replaced by the Make script tokenisation, don't edit
$Version = "<!VERSION!>"
$WorkingDir = "<!WORKING-DIR!>"


# Log Function 
function Write-Log($location=$WorkingDir, $level="INFO", $message) {
    $date = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $log = "$date > [$level] :: $message"
    Add-Content -Path "$location\Script-Log.log" -Value $log
}

# Announce Script Start 
Write-Log -level "INFO" -message "The script has started!"

# Delete working directory if exists
if(Test-Path $WorkingDir) { 
    Write-Log -level "INFO" -message "Deleting existing working directory: $WorkingDir"
    Remove-Item -Path $WorkingDir -Recurse -Force
    Write-Log -level "INFO" -message "Deleting done! ($WorkingDir)"
}

# Create new working directory
Write-Log -level "INFO" -message "Creating working directory: $WorkingDir"
New-Item -ItemType Directory -Path $WorkingDir -Force | Out-Null
Write-Log -level "INFO" -message "Creating done! ($WorkingDir)"

# Run your desired commands in the try section
try { 
    # Do something to the device!
} catch { 
    Write-Log -level "ERROR" -message ("Reset LAPS command failed with error - " + $error[0].Exception.Message)
}

# Create Version File 
Write-Log -level "INFO" -message "Creating Version File ($WorkingDir)"
@{ 
    Target = $WorkingDir
    Version = $Version
} | ConvertTo-Json | Out-File -FilePath ($WorkingDir + "\version.json") -Force

#Log 
Write-Log -level "INFO" -message "Script completed"