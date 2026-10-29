@echo off
start "VozLimpia" /min powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0servidor.ps1"
