@echo off
setlocal enabledelayedexpansion

:: Function to check if jq is installed
echo Checking if jq is installed...
jq --version >nul 2>&1
if %errorlevel%==0 (
    echo jq is already installed.
    pause
    exit /b
)

:: Check if winget is installed
where winget >nul 2>&1
if %errorlevel%==0 (
    echo winget found. Installing jq using winget...
    winget install jqlang.jq
    goto :check_installation
)

:: Check if scoop is installed
where scoop >nul 2>&1
if %errorlevel%==0 (
    echo scoop found. Installing jq using scoop...
    scoop install jq
    goto :check_installation
)

:: Check if choco is installed
where choco >nul 2>&1
if %errorlevel%==0 (
    echo choco found. Installing jq using choco...
    choco install jq
    goto :check_installation
)

:: If none of the package managers are found, suggest installing one
echo No package manager found (winget, scoop, or choco). Please install one of these first.
pause
exit /b

:check_installation
:: Verify jq installation
echo Verifying jq installation...
jq --version >nul 2>&1
if %errorlevel%==0 (
    echo jq has been successfully installed!
) else (
    echo jq installation failed.
)

pause
exit /b
