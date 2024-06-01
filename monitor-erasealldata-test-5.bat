@echo off

:CHECK_USB
timeout /t 1 >nul

rem Check for the presence of the USB drive (typically assigned to D: or E: for simplicity)
for %%a in (F H I J K L M N O P Q R S T U V W X Y Z) do (
    if exist "%%a:\" (
        echo Found USB drive: %%a
        goto RUN_DELETION
    )
)

goto CHECK_USB

:RUN_DELETION
rem Wait for 5 seconds
timeout /t 5 >nul

rem Run the deletion script
powershell.exe -ExecutionPolicy Bypass -File "%~dp0delete.ps1" -delaySeconds 5

goto CHECK_USB
