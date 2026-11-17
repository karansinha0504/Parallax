@echo off
setlocal EnableDelayedExpansion
title Music Library Toolkit - Setup
color 0B

REM ============================================================
REM   MUSIC LIBRARY TOOLKIT - ONE TIME SETUP
REM   Run this once, as Administrator.
REM   Keep all files from this folder together.
REM ============================================================

set "TOOLROOT=C:\MusicTools"
set "SCRIPTDIR=%~dp0"

echo.
echo  ============================================================
echo    MUSIC LIBRARY TOOLKIT - SETUP
echo  ============================================================
echo.

REM ---------- Check admin ----------
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo  [X] NOT RUNNING AS ADMINISTRATOR
    echo.
    echo  Right-click this file and choose "Run as administrator".
    echo.
    pause
    exit /b 1
)
echo  [OK] Running as administrator
echo.

REM ---------- Check winget ----------
where winget >nul 2>&1
if %errorLevel% neq 0 (
    echo  [X] winget not found.
    echo.
    echo  Install "App Installer" from the Microsoft Store, then
    echo  run this script again.
    echo.
    pause
    exit /b 1
)
echo  [OK] winget found
echo.

REM ---------- Create folders ----------
echo  --- Creating folders ---
if not exist "%TOOLROOT%"            mkdir "%TOOLROOT%"
if not exist "%TOOLROOT%\bin"        mkdir "%TOOLROOT%\bin"
if not exist "%TOOLROOT%\scripts"    mkdir "%TOOLROOT%\scripts"
if not exist "%TOOLROOT%\temp"       mkdir "%TOOLROOT%\temp"
if not exist "%TOOLROOT%\reports"    mkdir "%TOOLROOT%\reports"
echo  [OK] %TOOLROOT%
echo.

REM ---------- Install Python ----------
echo  --- Installing Python ---
python --version >nul 2>&1
if %errorLevel% equ 0 (
    for /f "tokens=*" %%v in ('python --version 2^>^&1') do echo  [OK] Already installed: %%v
) else (
    echo  Installing Python 3.12 via winget, please wait...
    winget install --id Python.Python.3.12 -e --silent --accept-package-agreements --accept-source-agreements
    echo  [OK] Python installed
    echo.
    echo  ------------------------------------------------------------
    echo   IMPORTANT: Python was just added to your PATH.
    echo   Close this window and run this setup file AGAIN so the
    echo   new PATH takes effect.
    echo  ------------------------------------------------------------
    echo.
    pause
    exit /b 0
)
echo.

REM ---------- Install ImageMagick and Mp3tag ----------
echo  --- Installing ImageMagick (album art processing) ---
winget install --id ImageMagick.ImageMagick -e --silent --accept-package-agreements --accept-source-agreements >nul 2>&1
echo  [OK] ImageMagick
echo.

echo  --- Installing Mp3tag (manual tag editing) ---
winget install --id Mp3tag.Mp3tag -e --silent --accept-package-agreements --accept-source-agreements >nul 2>&1
echo  [OK] Mp3tag
echo.

REM ---------- Python packages ----------
echo  --- Installing beets and Python libraries ---
echo  This takes a few minutes. Leave it running.
echo.
python -m pip install --upgrade pip --quiet
python -m pip install --upgrade "beets[chroma,fetchart,lyrics,discogs,lastgenre,embedart,web]" mutagen rapidfuzz pyacoustid requests
if %errorLevel% neq 0 (
    echo.
    echo  [X] Python package install failed. Scroll up for the error.
    pause
    exit /b 1
)
echo  [OK] beets and libraries installed
echo.

REM ---------- Download fpcalc (Chromaprint) ----------
echo  --- Downloading fpcalc (audio fingerprinting) ---
if exist "%TOOLROOT%\bin\fpcalc.exe" (
    echo  [OK] Already present
) else (
    set "FPURL=https://github.com/acoustid/chromaprint/releases/download/v1.6.1/chromaprint-fpcalc-1.6.1-windows-x86_64.zip"
    powershell -NoProfile -Command ^
      "$ErrorActionPreference='Stop';" ^
      "try {" ^
      "  Invoke-WebRequest -Uri '!FPURL!' -OutFile '%TOOLROOT%\temp\fpcalc.zip' -UseBasicParsing;" ^
      "  Expand-Archive -Path '%TOOLROOT%\temp\fpcalc.zip' -DestinationPath '%TOOLROOT%\temp\fp' -Force;" ^
      "  $exe = Get-ChildItem -Path '%TOOLROOT%\temp\fp' -Filter 'fpcalc.exe' -Recurse | Select-Object -First 1;" ^
      "  Copy-Item $exe.FullName '%TOOLROOT%\bin\fpcalc.exe' -Force;" ^
      "  Write-Host '  [OK] fpcalc installed'" ^
      "} catch { Write-Host '  [!] fpcalc download failed:' $_.Exception.Message }"
)
echo.

REM ---------- Download mp3val ----------
echo  --- Downloading mp3val (corrupt file detection) ---
if exist "%TOOLROOT%\bin\mp3val.exe" (
    echo  [OK] Already present
) else (
    powershell -NoProfile -Command ^
      "$ErrorActionPreference='Stop';" ^
      "try {" ^
      "  $u='https://downloads.sourceforge.net/project/mp3val/mp3val/0.1.8/mp3val-0.1.8-win32.zip';" ^
      "  Invoke-WebRequest -Uri $u -OutFile '%TOOLROOT%\temp\mp3val.zip' -UseBasicParsing -MaximumRedirection 10;" ^
      "  Expand-Archive -Path '%TOOLROOT%\temp\mp3val.zip' -DestinationPath '%TOOLROOT%\temp\mv' -Force;" ^
      "  $exe = Get-ChildItem -Path '%TOOLROOT%\temp\mv' -Filter 'mp3val.exe' -Recurse | Select-Object -First 1;" ^
      "  Copy-Item $exe.FullName '%TOOLROOT%\bin\mp3val.exe' -Force;" ^
      "  Write-Host '  [OK] mp3val installed'" ^
      "} catch {" ^
      "  Write-Host '  [!] Auto-download failed. Get it manually from:';" ^
      "  Write-Host '      http://mp3val.sourceforge.net/';" ^
      "  Write-Host '      and put mp3val.exe in %TOOLROOT%\bin\' }"
)
echo.

REM ---------- Add bin folder to user PATH ----------
echo  --- Adding %TOOLROOT%\bin to your PATH ---
powershell -NoProfile -Command ^
  "$p=[Environment]::GetEnvironmentVariable('Path','User');" ^
  "if ($p -notlike '*%TOOLROOT%\bin*') {" ^
  "  if ($p -and -not $p.EndsWith(';')) { $p += ';' };" ^
  "  [Environment]::SetEnvironmentVariable('Path', $p + '%TOOLROOT%\bin', 'User');" ^
  "  Write-Host '  [OK] PATH updated'" ^
  "} else { Write-Host '  [OK] Already in PATH' }"
set "PATH=%PATH%;%TOOLROOT%\bin"
echo.

REM ---------- Copy helper scripts ----------
echo  --- Installing helper scripts ---
if exist "%SCRIPTDIR%bitrate-audit.py"  copy /Y "%SCRIPTDIR%bitrate-audit.py"  "%TOOLROOT%\scripts\" >nul
if exist "%SCRIPTDIR%whats-missing.py"  copy /Y "%SCRIPTDIR%whats-missing.py"  "%TOOLROOT%\scripts\" >nul
if exist "%SCRIPTDIR%2-MUSIC-TOOLS.bat" copy /Y "%SCRIPTDIR%2-MUSIC-TOOLS.bat" "%TOOLROOT%\" >nul
echo  [OK] Scripts in %TOOLROOT%\scripts
echo.

REM ---------- Ask where the clean library should live ----------
echo  ============================================================
echo    CONFIGURATION
echo  ============================================================
echo.
echo  beets will COPY cleaned files into a new folder.
echo  Your original messy collection is never moved or deleted.
echo.
set "CLEANDIR="
set /p CLEANDIR=  Where should the clean library go? [D:\Music-Clean]: 
if "!CLEANDIR!"=="" set "CLEANDIR=D:\Music-Clean"
if not exist "!CLEANDIR!" mkdir "!CLEANDIR!"
echo.

echo  A Discogs token greatly improves matching for Indian releases.
echo  Get one free at: https://www.discogs.com/settings/developers
echo  (You can leave this blank now and add it later.)
echo.
set "DISCOGS="
set /p DISCOGS=  Paste your Discogs token (or press Enter to skip): 
if "!DISCOGS!"=="" set "DISCOGS=PASTE_YOUR_DISCOGS_TOKEN_HERE"
echo.

REM ---------- Write beets config ----------
echo  --- Writing beets config ---
if not exist "%APPDATA%\beets" mkdir "%APPDATA%\beets"

if not exist "%SCRIPTDIR%config-template.yaml" (
    echo  [X] config-template.yaml not found next to this script.
    pause
    exit /b 1
)

powershell -NoProfile -Command ^
  "$c = Get-Content -Raw '%SCRIPTDIR%config-template.yaml';" ^
  "$clean = '!CLEANDIR!' -replace '\\','/';" ^
  "$c = $c -replace '__LIBRARY_DIR__', $clean;" ^
  "$c = $c -replace '__DISCOGS_TOKEN__', '!DISCOGS!';" ^
  "Set-Content -Path '%APPDATA%\beets\config.yaml' -Value $c -Encoding UTF8;" ^
  "Write-Host '  [OK] Config written to %APPDATA%\beets\config.yaml'"
echo.

REM ---------- Verify ----------
echo  ============================================================
echo    VERIFICATION
echo  ============================================================
echo.
call :check python  "Python"
call :check beet     "beets"
call :check fpcalc   "fpcalc (fingerprinting)"
call :check mp3val   "mp3val (corrupt detection)"
call :check magick   "ImageMagick"
echo.

REM ---------- Cleanup ----------
if exist "%TOOLROOT%\temp" rd /s /q "%TOOLROOT%\temp" >nul 2>&1

echo  ============================================================
echo    SETUP COMPLETE
echo  ============================================================
echo.
echo   Clean library will be built at: !CLEANDIR!
echo   Tools installed at:             %TOOLROOT%
echo.
echo   NEXT STEP:
echo   Close this window, then run  2-MUSIC-TOOLS.bat
echo   (a fresh window is needed for the PATH change)
echo.
echo   Start with menu option 1 - the small test import.
echo   Do NOT run a full import before testing on ~20 files.
echo.
pause
exit /b 0

REM ============================================================
:check
where %1 >nul 2>&1
if %errorLevel% equ 0 (echo  [OK]  %~2) else (echo  [!!]  %~2 - NOT FOUND)
exit /b 0
