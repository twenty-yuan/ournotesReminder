@echo off
setlocal enabledelayedexpansion

:: ============================================
::  游戏上号提醒 - 定时任务安装脚本
:: ============================================

title Game Reminder - Install

echo.
echo ============================================
echo   Game Reminder - Scheduled Task Installer
echo ============================================
echo.

:: 检查 exe 是否在同一目录
if not exist "%~dp0reminder.exe" (
    echo [ERROR] reminder.exe not found.
    echo Please make sure this .bat and reminder.exe are in the same folder.
    echo.
    pause
    exit /b 1
)

:: 让用户输入提醒时间
echo Enter the daily reminder time in 24-hour format (HH:MM, e.g. 23:00)
echo Press Enter to use the default: 23:00
set /p USER_TIME=Time:

if "!USER_TIME!"=="" set USER_TIME=23:00

:: 校验时间格式（两位数字:两位数字）
echo(!USER_TIME!| findstr /r "^[0-2][0-9]:[0-5][0-9]$" >nul
if errorlevel 1 (
    echo.
    echo [ERROR] Invalid time format. Please run again and use HH:MM like 23:00.
    echo.
    pause
    exit /b 1
)

:: 任务名和程序路径
set TASK_NAME=GameReminder
set EXE_PATH=%~dp0reminder.exe

echo.
echo --------------------------------------------
echo About to create scheduled task:
echo   Task name: %TASK_NAME%
echo   Time     : Daily at %USER_TIME%
echo   Program  : %EXE_PATH%
echo --------------------------------------------
echo.

:: 先删除同名旧任务（如果存在），避免冲突
schtasks /query /tn "%TASK_NAME%" >nul 2>&1
if not errorlevel 1 (
    echo Existing task found. Deleting old task...
    schtasks /delete /tn "%TASK_NAME%" /f >nul
)

:: 创建新任务
schtasks /create /tn "%TASK_NAME%" /tr "\"%EXE_PATH%\"" /sc DAILY /st %USER_TIME% /f

if errorlevel 1 (
    echo.
    echo [ERROR] Failed to create the scheduled task.
    echo Try running this script as Administrator.
    echo.
    pause
    exit /b 1
)

echo.
echo ============================================
echo   [SUCCESS] Scheduled task created!
echo   You will be reminded every day at %USER_TIME%.
echo ============================================
echo.

pause
endlocal