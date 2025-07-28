@echo off
setlocal enabledelayedexpansion

:: Read JSON input from stdin
set json=
for /f "delims=" %%i in ('more') do set json=!json!%%i

:: Simple check if the JSON contains "error"
echo !json! | findstr /C:"\"error\"" >nul
if !errorlevel! equ 0 (
    echo Skipping commit - tool execution had errors
    exit /b 0
)

:: Get current timestamp
for /f "tokens=2 delims==" %%a in ('wmic OS Get localdatetime /value') do set dt=%%a
set timestamp=%dt:~0,4%-%dt:~4,2%-%dt:~6,2% %dt:~8,2%:%dt:~10,2%

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