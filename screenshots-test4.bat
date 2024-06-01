@echo off
setlocal enabledelayedexpansion

REM Determine the current username from the full user path
for /f "tokens=*" %%u in ('whoami') do (
    for /f "tokens=2 delims=\" %%i in ("%%u") do set "username=%%i"
)

REM Define the source folder where the screenshots are saved
set "source_folder=C:\Users\!username!\OneDrive\Pictures\Screenshots"

REM Check if the source folder exists
if not exist "!source_folder!\" (
    echo Source folder not found or inaccessible: !source_folder!
    echo Please ensure the folder path is correct and try again.
    pause
    exit /b 1
)

REM Check if the source folder is empty
set "has_files="
for %%F in ("!source_folder!\*.*") do (
    set "has_files=true"
    goto :have_files
)
:have_files

if not defined has_files (
    echo No screenshots found in the source folder: !source_folder!
    pause
    exit /b 1
)

REM Infinite loop to keep the script running
:loop
REM Variable to hold the detected pendrive path
set "pendrivePath="

REM Check for all possible drive letters to find the pendrive
for %%d in (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
    if exist %%d:\ (
        REM Check if drive type is removable
        for /f "tokens=*" %%i in ('wmic logicaldisk where "DeviceID='%%d:'" get DriveType /value ^| findstr "DriveType=2"') do (
            set "pendrivePath=%%d:\"
            goto :found
        )
    )
)

:found
if "%pendrivePath%"=="" (
    echo Pendrive not detected. Please insert pendrive.
    pause
) else (
    REM Define the base destination folder on the pendrive
    set "base_destination_folder=%pendrivePath%screenshots"

    REM Generate a unique folder name based on the current date and time
    for /f "tokens=1-5 delims=/: " %%d in ("%date% %time%") do (
        set "folder_name=%%d-%%e-%%f_%%g-%%h"
    )

    REM Ensure the folder name is unique by appending a counter if necessary
    set "destination_folder=%base_destination_folder%\%folder_name%"
    set counter=1
    :check_folder
    if exist "%destination_folder%" (
        set /a counter+=1
        set "destination_folder=%base_destination_folder%\%folder_name%_!counter!"
        goto check_folder
    )

    REM Create the new destination folder
    mkdir "%destination_folder%"

    REM Copy all screenshots from source folder to destination folder
    for %%F in ("!source_folder!\*.*") do (
        copy "%%F" "%destination_folder%"
    )
    echo All screenshots copied to %destination_folder%.
)

REM Wait for 5 seconds before checking again
timeout /t 5 /nobreak >nul
goto loop

pause
