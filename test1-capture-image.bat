@echo off

REM Get the current directory of the batch script
set "script_dir=%~dp0"

REM Introduce a delay to allow USB drives to be initialized
timeout /t 5 /nobreak >nul

REM Initialize USB base folder as empty
set "usb_base_folder="

REM Check for USB drives
for /f "skip=1 tokens=1,2 delims=:" %%A in ('wmic logicaldisk where "drivetype=2" get caption^,deviceid') do (
    set "usb_base_folder=%%B"
    goto :next
)

:next

REM Check if USB base folder is set
if not defined usb_base_folder (
    echo No USB drive detected. Exiting...
    pause
    exit /b 1
)

REM Check if Python script exists
if not exist "%script_dir%capt-image.py" (
    echo Python script not found. Exiting...
    pause
    exit /b 1
)

REM Run Python script with dynamically detected USB drive path
pythonw.exe "%script_dir%capt-image.py"

REM Keep terminal open until user input
pause
