@echo off
setlocal EnableExtensions DisableDelayedExpansion
cd /d "%~dp0"
chcp 65001 >nul 2>&1
:: ============================================================
::  LEGIONFORGE 7.3.5.26124 (сборка 2026-10-20) - запуск из
::  папки server. Вызывает play.bat из корня сервера.
:: ============================================================
set "ROOT=%~dp0.."
call "%ROOT%\play.bat"
exit /b %errorlevel%
