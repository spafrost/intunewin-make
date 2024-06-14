#############################################
#
#  S description of this script!
#   
#  v0.1 - DD/MM/YYYY - HH:mm
#
#############################################


## Wallpaper Location 
$Version = "<!VERSION!>"
$TargetURI = "<!TARGET!>"


# Log Function 
function Write-Log($location=$TargetURI, $level="INFO", $message) {
    $date = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $log = "$date > [$level] :: $message"
    Add-Content -Path "$location\Script-Log.log" -Value $log
}
# Announce Script Start 
Write-Log -level "INFO" -message "The script has started!"

# Make somewhere to keep it 
if(Test-Path $TargetURI) { 
    Write-Log -level "INFO" -message "Deleting target location: $TargetURI"
    Remove-Item -Path $TargetURI -Recurse -Force
    Write-Log -level "INFO" -message "Deleting done! ($TargetURI)"
}
Write-Log -level "INFO" -message "Creating target location: $TargetURI"
New-Item -ItemType Directory -Path $TargetURI -Force | Out-Null
Write-Log -level "INFO" -message "Creating done! ($TargetURI)"

# Run LAPS Force Command 
try { 
    # Do something to the device!
} catch { 
    Write-Log -level "ERROR" -message ("Reset LAPS command failed with error - " + $error[0].Exception.Message)
}

# Create Version File 
Write-Log -level "INFO" -message "Creating Version File ($TargetURI)"
@{ 
    Target = $TargetURI
    Version = $Version
} | ConvertTo-Json | Out-File -FilePath ($TargetURI + "\version.json") -Force

#Log 
Write-Log -level "INFO" -message "Script completed"