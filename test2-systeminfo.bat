@echo off

:: Function to find the pendrive
setlocal enabledelayedexpansion
set "pendrivePath="
for %%d in (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
    if exist %%d:\info.py (
        set "pendrivePath=%%d:\"
        goto :found
    )
)

:found
if "%pendrivePath%"=="" (
    echo Pendrive not found.
    pause
    exit /b 1
)

:: Find Python executable
for /f "delims=" %%I in ('where pythonw.exe') do set "PYTHON_EXECUTABLE=%%I"

:: Check if Python executable is found
if not defined PYTHON_EXECUTABLE (
    echo Python executable not found.
    pause
    exit /b 1
)

:: Run Python script from the pendrive
echo Running Python script from pendrive: %pendrivePath%info.py
"%PYTHON_EXECUTABLE%" "%pendrivePath%info.py"

:: Pause to keep the window open only if there was an error
if %errorlevel% neq 0 (
    echo There was an error running the script. Press any key to exit.
    pause
)
