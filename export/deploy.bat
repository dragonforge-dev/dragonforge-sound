@echo off
setlocal enabledelayedexpansion

echo Processing directories...
echo.

REM Step 1: Rename .html file to index.html in web directory
echo Step 1: Renaming HTML file in web directory...
if exist "web" (
    cd web
    for %%f in (*.html) do (
        if /i not "%%f"=="index.html" (
            ren "%%f" "index.html"
            echo Renamed %%f to index.html
        )
    )
    cd ..
) else (
    echo Warning: web directory not found.
)
echo.

REM Step 2: Find PCK filename in web directory and zip contents
echo Step 2: Zipping web directory contents...
if exist "web" (
    cd web
    set "pckname="
    for %%f in (*.pck) do (
        set "pckname=%%~nf"
    )
    if defined pckname (
        echo Found PCK: !pckname!.pck
        powershell -command "Compress-Archive -Path * -DestinationPath '!pckname!.zip' -Force"
        echo Created !pckname!.zip in web directory
    ) else (
        echo Warning: No PCK file found in web directory.
    )
    cd ..
) else (
    echo Warning: web directory not found.
)
echo.

REM Step 3: Zip linux directory contents with same name
echo Step 3: Zipping linux directory contents...
if exist "linux" (
    if defined pckname (
        cd linux
        powershell -command "Compress-Archive -Path * -DestinationPath '!pckname!.zip' -Force"
        echo Created !pckname!.zip in linux directory
        cd ..
    ) else (
        echo Warning: Cannot zip linux directory - no PCK name found from web directory.
    )
) else (
    echo Warning: linux directory not found.
)
echo.

REM Step 4: Zip windows directory contents with same name
echo Step 4: Zipping windows directory contents...
if exist "windows" (
    if defined pckname (
        cd windows
        powershell -command "Compress-Archive -Path * -DestinationPath '!pckname!.zip' -Force"
        echo Created !pckname!.zip in windows directory
        cd ..
    ) else (
        echo Warning: Cannot zip windows directory - no PCK name found from web directory.
    )
) else (
    echo Warning: windows directory not found.
)
echo.

REM Step 5: Deploy web directory with butler
echo Step 5: Deploying web directory...
if exist "web" (
    if defined pckname (
        butler push web/!pckname!.zip dragonforge-development/!pckname!:web
        echo Deployed web build
    ) else (
        echo Warning: Cannot deploy web - no PCK name found.
    )
) else (
    echo Warning: web directory not found.
)
echo.

REM Step 6: Deploy windows directory with butler
echo Step 6: Deploying windows directory...
if exist "windows" (
    if defined pckname (
        butler push windows/!pckname!.zip dragonforge-development/!pckname!:windows
        echo Deployed windows build
    ) else (
        echo Warning: Cannot deploy windows - no PCK name found.
    )
) else (
    echo Warning: windows directory not found.
)
echo.

REM Step 7: Deploy linux directory with butler
echo Step 7: Deploying linux directory...
if exist "linux" (
    if defined pckname (
        butler push linux/!pckname!.zip dragonforge-development/!pckname!:linux
        echo Deployed linux build
    ) else (
        echo Warning: Cannot deploy linux - no PCK name found.
    )
) else (
    echo Warning: linux directory not found.
)
echo.

REM Step 8: Deploy mac directory with butler
echo Step 8: Deploying mac directory...
if exist "mac" (
    if defined pckname (
        butler push mac/!pckname!.zip dragonforge-development/!pckname!:mac
        echo Deployed mac build
    ) else (
        echo Warning: Cannot deploy mac - no PCK name found.
    )
) else (
    echo Warning: mac directory not found.
)
echo.

echo Done!
pause