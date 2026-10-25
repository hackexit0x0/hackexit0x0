@echo off
setlocal EnableExtensions
title RDP CredSSP Authentication Fix
color 0A

:: ============================================================
:: RDP CredSSP Authentication Fix
:: ============================================================
:: Purpose:
:: Fix:
:: "An authentication error has occurred.
::  The function requested is not supported.
::  This could be due to CredSSP encryption oracle remediation."
::
:: WARNING:
:: AllowEncryptionOracle=2 enables Vulnerable compatibility mode.
:: Use this as a temporary troubleshooting workaround.
:: ============================================================

echo.
echo ============================================================
echo              RDP CredSSP AUTHENTICATION FIX
echo ============================================================
echo.
echo This script will configure:
echo.
echo AllowEncryptionOracle = 2
echo.
echo WARNING: This temporarily enables Vulnerable CredSSP mode.
echo Use this only on a trusted/internal network.
echo.
pause

:: ============================================================
:: STEP 1 - Check Administrator Privileges
:: ============================================================

echo.
echo [1/5] Checking Administrator privileges...
echo.

net session >nul 2>&1

if %errorlevel% neq 0 (
    echo.
    echo ========================================================
    echo ERROR: Administrator privileges are required.
    echo ========================================================
    echo.
    echo Right-click this file and select:
    echo.
    echo     Run as administrator
    echo.
    pause
    exit /b 1
)

echo SUCCESS: Running as Administrator.

:: ============================================================
:: STEP 2 - Create CredSSP Registry Path
:: ============================================================

echo.
echo [2/5] Creating CredSSP registry path...
echo.

reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\CredSSP\Parameters" /f >nul 2>&1

if %errorlevel% neq 0 (
    echo ERROR: Could not create CredSSP registry path.
    echo.
    pause
    exit /b 1
)

echo SUCCESS: CredSSP registry path created.

:: ============================================================
:: STEP 3 - Set AllowEncryptionOracle = 2
:: ============================================================

echo.
echo [3/5] Setting AllowEncryptionOracle = 2...
echo.

reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\CredSSP\Parameters" /v AllowEncryptionOracle /t REG_DWORD /d 2 /f

if %errorlevel% neq 0 (
    echo.
    echo ERROR: Failed to configure AllowEncryptionOracle.
    echo.
    pause
    exit /b 1
)

echo.
echo SUCCESS: AllowEncryptionOracle has been set to 2.

:: ============================================================
:: STEP 4 - Verify Registry Configuration
:: ============================================================

echo.
echo [4/5] Verifying configuration...
echo.

reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\CredSSP\Parameters" /v AllowEncryptionOracle

if %errorlevel% neq 0 (
    echo.
    echo ERROR: Registry verification failed.
    echo.
    pause
    exit /b 1
)

echo.
echo SUCCESS: Registry configuration verified.

:: ============================================================
:: STEP 5 - Update Group Policy
:: ============================================================

echo.
echo [5/5] Updating Group Policy...
echo.

gpupdate /force

if %errorlevel% neq 0 (
    echo.
    echo WARNING: gpupdate returned an error.
    echo The registry setting may still have been applied.
) else (
    echo.
    echo SUCCESS: Group Policy updated.
)

:: ============================================================
:: COMPLETE
:: ============================================================

echo.
echo ============================================================
echo                  CONFIGURATION COMPLETE
echo ============================================================
echo.
echo CredSSP setting:
echo.
echo AllowEncryptionOracle = 2
echo.
echo Mode:
echo Vulnerable compatibility mode
echo.
echo ============================================================
echo.
echo Next step:
echo Restart Windows and try Remote Desktop again.
echo.
echo RDP command:
echo.
echo     mstsc
echo.
echo ============================================================
echo.

choice /C YN /M "Restart computer now"

if errorlevel 2 goto END

if errorlevel 1 (
    echo.
    echo Restarting computer...
    shutdown /r /t 5
)

:END
echo.
echo Script finished.
echo.
pause

endlocal