@echo off

powershell -NonInteractive -NoProfile -ExecutionPolicy Unrestricted -Command "& { .\RunTests.ps1 %* }"