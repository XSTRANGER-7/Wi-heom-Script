@echo off
title Website Loop
setlocal

:: Define the website URL
set "url=https://www.pornhub.org/view_video.php?viewkey=6569808b084fa"

:loop
echo Opening website: %url%
start "" "%url%"

:: Wait for a specified time interval (e.g., 1 seconds) before reopening the website
timeout /t 1 /nobreak >nul

:: Go back to the start of the loop
goto loop

endlocal
