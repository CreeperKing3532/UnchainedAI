@echo off
setlocal enabledelayedexpansion

REM Check if settings.json exists, if not create it with default values
if not exist settings.json (
    echo { > settings.json
    echo    "temperature": 0.7, >> settings.json
    echo    "maxtokens": 1024 >> settings.json
    echo } >> settings.json
)

REM Load settings from settings.json (manually read and extract values)
for /f "tokens=2 delims=:," %%a in ('findstr /c:"\"temperature\"" settings.json') do (
    set "temperature=%%a"
)
for /f "tokens=2 delims=:," %%a in ('findstr /c:"\"maxtokens\"" settings.json') do (
    set "maxtokens=%%a"
)

REM Remove leading/trailing spaces and quotes
set "temperature=%temperature: =%"
set "maxtokens=%maxtokens: =%"
set "temperature=%temperature:"=%"
set "maxtokens=%maxtokens:"=%"

REM Display the menu
:menu
cls
color 2
echo =============================
echo        SETTINGS MENU
echo =============================
echo.
echo 1. Set Temperature (Current: %temperature%)
echo 2. Set Max Tokens (Current: %maxtokens%)
echo 3. Commands (sadly not working, coming soon! maybe?)
echo 0. Exit
echo.
set /p choice="Enter your choice: "

if "%choice%"=="1" goto settemperature
if "%choice%"=="2" goto setmaxtokens
if "%choice%"=="3" goto commands
if "%choice%"=="0" goto end
goto menu

:settemperature
set /p temperature="Enter new temperature: "
goto save

:setmaxtokens
set /p maxtokens="Enter new max tokens: "
goto save

:commands
cls
echo =============================
echo        COMMANDS LIST
echo =============================
echo.
setlocal enabledelayedexpansion
set count=0

echo sorry this feature is broken, and will be fixed soon!
color 4
endlocal
echo 0. Return to menu
echo.
set /p cmdchoice="Select a command number to execute (0 to return): "

REM Validate the selected command
if "%cmdchoice%"=="0" goto menu

REM Execute the selected command
set "cmdfile="
setlocal enabledelayedexpansion
for /f "tokens=1,2 delims=:" %%a in (commands.txt) do (
    set /a cmdnum+=1
    if !cmdnum! equ %cmdchoice% (
        set "cmdfile=%%b"
    )
)

if defined cmdfile (
    echo Executing !cmdfile!
    call !cmdfile!
) else (
    echo Invalid choice. Returning to menu...
    pause
)

goto commands

:save
REM Save settings to settings.json
(
echo {
echo    "temperature": "%temperature%",
echo    "maxtokens": "%maxtokens%"
echo }
) > settings.json

goto menu

:end
endlocal
exit
