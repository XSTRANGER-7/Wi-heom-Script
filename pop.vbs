' Set your USB drive's volume label here
Const USB_Drive_Label = "YOUR_USB_LABEL"

' Function to get the drive letter of the specified USB drive
Function GetDriveLetterByLabel(driveLabel)
    Dim fso, drive
    Set fso = CreateObject("Scripting.FileSystemObject")
    
    ' Iterate through all drives
    For Each drive In fso.Drives
        ' Check if the drive is removable and matches the specified label
        If drive.DriveType = 1 And drive.VolumeName = driveLabel Then
            GetDriveLetterByLabel = drive.DriveLetter & ":\"
            Exit Function
        End If
    Next
    
    ' If the drive is not found
    GetDriveLetterByLabel = ""
End Function

' Infinite loop to continuously check if the USB drive is connected
Do
    ' Get the drive letter of the USB drive
    usbDriveLetter = GetDriveLetterByLabel(USB_Drive_Label)
    
    ' Check if the USB drive is connected
    If usbDriveLetter = "" Then
        ' Display a message box indicating the USB drive is removed
        MsgBox "USB drive has been removed. Full screen mode activated.", 4096, "Alert"
        
        ' Call AutoHotkey script to handle full screen and key disabling
        Dim objShell
        Set objShell = CreateObject("WScript.Shell")
        objShell.Run "disable_keys.ahk", 0, False
    End If
    
    ' Wait for a shorter period before checking again
    WScript.Sleep 500 ' Sleep for 0.5 seconds (500 milliseconds)
Loop
