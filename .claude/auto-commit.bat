@echo off
setlocal enabledelayedexpansion

:: Debug: Log that hook was triggered
echo Hook triggered at %date% %time% >> .claude\hook-debug.log

:: Read JSON input from stdin
set json=
for /f "delims=" %%i in ('more') do set json=!json!%%i

:: Debug: Log the JSON input
echo JSON input: !json! >> .claude\hook-debug.log

:: Simple check if the JSON contains "error"
echo !json! | findstr /C:"\"error\"" >nul
if !errorlevel! equ 0 (
    echo Skipping commit - tool execution had errors >> .claude\hook-debug.log
    exit /b 0
)

:: Get current timestamp
for /f "tokens=2 delims==" %%a in ('wmic OS Get localdatetime /value') do set dt=%%a
set timestamp=%dt:~0,4%-%dt:~4,2%-%dt:~6,2% %dt:~8,2%:%dt:~10,2%

:: No longer need to sync files - single index.html file now
echo Using single index.html file - no sync needed >> .claude\hook-debug.log

:: Stage all changes
git add -A

:: Commit with descriptive message
git commit -m "Auto-commit: Code changes via Claude Code - %timestamp%"

:: Push to GitHub
git push origin main

if !errorlevel! equ 0 (
    echo Changes successfully pushed to GitHub!
) else (
    echo Push failed - changes committed locally
)