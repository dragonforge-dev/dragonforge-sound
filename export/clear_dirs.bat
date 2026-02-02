@echo off
setlocal enabledelayedexpansion

echo Clearing directory contents...
echo.

REM Clear windows directory
if exist "windows" (
    echo Clearing windows directory...
    del /q "windows\*" 2>nul
    for /d %%x in ("windows\*") do rd /s /q "%%x" 2>nul
    echo windows directory cleared.
) else (
    echo Warning: windows directory not found.
)

REM Clear web directory
if exist "web" (
    echo Clearing web directory...
    del /q "web\*" 2>nul
    for /d %%x in ("web\*") do rd /s /q "%%x" 2>nul
    echo web directory cleared.
) else (
    echo Warning: web directory not found.
)

REM Clear mac directory
if exist "mac" (
    echo Clearing mac directory...
    del /q "mac\*" 2>nul
    for /d %%x in ("mac\*") do rd /s /q "%%x" 2>nul
    echo mac directory cleared.
) else (
    echo Warning: mac directory not found.
)

REM Clear linux directory
if exist "linux" (
    echo Clearing linux directory...
    del /q "linux\*" 2>nul
    for /d %%x in ("linux\*") do rd /s /q "%%x" 2>nul
    echo linux directory cleared.
) else (
    echo Warning: linux directory not found.
)

echo.
echo Done!
pause
