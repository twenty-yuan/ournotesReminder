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
:INPUT_TIME
set "USER_TIME="
set /p "USER_TIME=Time: "

if "!USER_TIME!"=="" set USER_TIME=23:00

:: ---------------------------------------------------
:: 使用纯批处理替换中文冒号并校验时间
:: ---------------------------------------------------

:: 1. 将中文全角冒号“：”替换为英文半角冒号“:”
set "USER_TIME=!USER_TIME:：=:!"

:: 2. 初步校验：必须是“两位数:两位数”的格式
echo !USER_TIME! | findstr /r "^[0-9][0-9]:[0-9][0-9]$" >nul
if errorlevel 1 (
    echo.
    echo [ERROR] Invalid time format. Please enter HH:MM like 23:00.
    echo.
    goto INPUT_TIME
)

:: 3. 进一步校验：提取小时和分钟，去除前导0，并检查范围
set "HH=!USER_TIME:~0,2!"
set "MM=!USER_TIME:~3,2!"

:: 去掉前导 0（防止批处理将 08 当成八进制报错）
if "!HH:~0,1!"=="0" set "HH=!HH:~1,1!"
if "!MM:~0,1!"=="0" set "MM=!MM:~1,1!"

:: 检查小时是否大于 23，分钟是否大于 59
if !HH! gtr 23 (
    echo.
    echo [ERROR] Invalid hour. Must be 00-23.
    echo.
    goto INPUT_TIME
)
if !MM! gtr 59 (
    echo.
    echo [ERROR] Invalid minute. Must be 00-59.
    echo.
    goto INPUT_TIME
)
:: ---------------------------------------------------

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