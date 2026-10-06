@echo off

:: ============================================
::  游戏上号提醒 - 卸载定时任务脚本
:: ============================================

title Game Reminder - Uninstall

echo.
echo ============================================
echo   Game Reminder - Remove Scheduled Task
echo ============================================
echo.

:: 任务名（必须与安装脚本里的一致）
set TASK_NAME=GameReminder

:: 先查任务是否存在
schtasks /query /tn "%TASK_NAME%" >nul 2>&1
if errorlevel 1 (
    echo Task "%TASK_NAME%" not found. Nothing to remove.
    echo.
    pause
    exit /b 0
)

:: 删除任务
schtasks /delete /tn "%TASK_NAME%" /f

if errorlevel 1 (
    echo.
    echo [ERROR] Failed to delete. Try running as Administrator.
    echo.
    pause
    exit /b 1
)

echo.
echo [SUCCESS] Scheduled task removed.
echo.
pause