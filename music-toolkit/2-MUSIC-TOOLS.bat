@echo off
setlocal EnableDelayedExpansion
title Music Library Toolkit
color 0B

set "TOOLROOT=C:\MusicTools"
set "SCRIPTS=%TOOLROOT%\scripts"
set "REPORTS=%TOOLROOT%\reports"
if not exist "%REPORTS%" mkdir "%REPORTS%"

where beet >nul 2>&1
if %errorLevel% neq 0 (
    echo.
    echo  [X] beets not found. Run 1-SETUP-run-as-admin.bat first.
    echo.
    pause
    exit /b 1
)

:MENU
cls
echo.
echo  ============================================================
echo     MUSIC LIBRARY TOOLKIT
echo  ============================================================
echo.
echo   START HERE
echo     1.  Test import on a small folder   (DO THIS FIRST)
echo.
echo   IMPORTING
echo     2.  Import albums        (folders that are real albums)
echo     3.  Import loose singles (individual song files)
echo     4.  Import as-is, no tagging
echo.
echo   ANALYSE  (read-only, safe to run anytime)
echo     5.  Bitrate audit - find your low quality files
echo     6.  Find corrupt / truncated files
echo     7.  Find duplicates (list only, nothing deleted)
echo     8.  Find albums with missing tracks
echo.
echo   CLEAN UP
echo     9.  Move duplicates out  (keeps highest bitrate)
echo    10.  Fetch + embed missing album art
echo    11.  Fetch lyrics
echo    12.  Fetch genres
echo.
echo   PLAYLISTS
echo    13.  Export library list
echo    14.  What am I missing?  (compare a wanted list)
echo.
echo   OTHER
echo    15.  Edit beets config
echo    16.  Open Mp3tag
echo    17.  View import log
echo     0.  Exit
echo.
echo  ============================================================
set "CH="
set /p CH=  Choose: 

if "%CH%"=="1"  goto TESTIMPORT
if "%CH%"=="2"  goto IMPALBUM
if "%CH%"=="3"  goto IMPSINGLE
if "%CH%"=="4"  goto IMPASIS
if "%CH%"=="5"  goto BITRATE
if "%CH%"=="6"  goto BADFILES
if "%CH%"=="7"  goto DUPLIST
if "%CH%"=="8"  goto MISSINGTRK
if "%CH%"=="9"  goto DUPMOVE
if "%CH%"=="10" goto ART
if "%CH%"=="11" goto LYRICS
if "%CH%"=="12" goto GENRE
if "%CH%"=="13" goto EXPORT
if "%CH%"=="14" goto WHATSMISSING
if "%CH%"=="15" goto CONFIG
if "%CH%"=="16" goto MP3TAG
if "%CH%"=="17" goto LOG
if "%CH%"=="0"  exit /b 0
goto MENU

REM ============================================================
:TESTIMPORT
cls
echo.
echo  --- TEST IMPORT ---
echo.
echo  Make a folder with about 20 files first - a few albums and
echo  a few loose singles, including some Indian tracks so you can
echo  see how well matching works on them.
echo.
echo  You will be asked to approve each match:
echo     A = Apply      U = Use as-is      S = Skip
echo     T = Type manually   I = Enter an ID   B = Abort
echo.
echo  Rule of thumb: above 90%% and right track count, press A.
echo  Anything you are unsure about, press S. Skipping is free.
echo.
call :ASKPATH "Path to your TEST folder"
if "!P!"=="" goto MENU
echo.
beet import "!P!"
goto DONE

:IMPALBUM
cls
echo.
echo  --- IMPORT ALBUMS ---
echo.
echo  For folders that are genuine album rips.
echo  This is resumable: Ctrl+C to stop, run again to continue.
echo.
call :ASKPATH "Path to your albums folder"
if "!P!"=="" goto MENU
echo.
beet import "!P!"
goto DONE

:IMPSINGLE
cls
echo.
echo  --- IMPORT LOOSE SINGLES ---
echo.
echo  Use this for individually downloaded songs. It matches each
echo  file on its own instead of trying to find an album.
echo  Most of your Indian tracks belong here.
echo.
call :ASKPATH "Path to your loose songs folder"
if "!P!"=="" goto MENU
echo.
beet import -s "!P!"
goto DONE

:IMPASIS
cls
echo.
echo  --- IMPORT WITHOUT TAGGING ---
echo.
echo  Brings files into the library keeping existing tags exactly
echo  as they are. Use for files you already tagged by hand.
echo.
call :ASKPATH "Path to folder"
if "!P!"=="" goto MENU
echo.
beet import -A "!P!"
goto DONE

REM ============================================================
:BITRATE
cls
echo.
echo  --- BITRATE AUDIT ---
echo.
echo  Read-only. Scans files and reports quality, worst first.
echo  This tells you how many files are actually worth replacing.
echo.
call :ASKPATH "Path to scan"
if "!P!"=="" goto MENU
echo.
python "%SCRIPTS%\bitrate-audit.py" "!P!" "%REPORTS%\bitrate-report.txt"
echo.
echo  Report: %REPORTS%\bitrate-report.txt
set "O="
set /p O=  Open it now? (y/n): 
if /i "!O!"=="y" start "" notepad "%REPORTS%\bitrate-report.txt"
goto DONE

:BADFILES
cls
echo.
echo  --- CORRUPT FILE CHECK ---
echo.
echo  Read-only. Finds truncated and broken files.
echo.
echo   1. Check files already in the beets library
echo   2. Check a folder directly (before importing)
set "M="
set /p M=  Choose: 
if "!M!"=="1" (
    beet badfiles > "%REPORTS%\badfiles.txt" 2>&1
) else (
    call :ASKPATH "Path to scan"
    if "!P!"=="" goto MENU
    mp3val -nb "!P!\*.mp3" > "%REPORTS%\badfiles.txt" 2>&1
)
echo.
echo  Report: %REPORTS%\badfiles.txt
start "" notepad "%REPORTS%\badfiles.txt"
goto DONE

:DUPLIST
cls
echo.
echo  --- FIND DUPLICATES (list only) ---
echo.
echo  Nothing is moved or deleted. Just shows what it found.
echo.
beet duplicates -f "$path  [$bitrate  $format]" > "%REPORTS%\duplicates.txt" 2>&1
echo  Report: %REPORTS%\duplicates.txt
start "" notepad "%REPORTS%\duplicates.txt"
goto DONE

:MISSINGTRK
cls
echo.
echo  --- ALBUMS WITH MISSING TRACKS ---
echo.
beet missing > "%REPORTS%\missing-tracks.txt" 2>&1
echo  Report: %REPORTS%\missing-tracks.txt
start "" notepad "%REPORTS%\missing-tracks.txt"
goto DONE

REM ============================================================
:DUPMOVE
cls
echo.
echo  ************************************************************
echo   THIS ONE MOVES FILES. Read before continuing.
echo  ************************************************************
echo.
echo  Duplicates are moved to a holding folder, keeping the
echo  highest bitrate copy in your library. NOTHING IS DELETED -
echo  you review the holding folder yourself afterwards.
echo.
echo  Be aware: fingerprint matching sometimes flags legitimate
echo  alternate versions (unplugged, film vs album cut) as dupes.
echo  Always review before deleting anything.
echo.
echo  Run option 7 first if you have not looked at the list.
echo.
set "C="
set /p C=  Type YES to continue: 
if /i not "!C!"=="YES" goto MENU
set "HOLD=%TOOLROOT%\duplicates-holding"
if not exist "!HOLD!" mkdir "!HOLD!"
echo.
beet duplicates --tiebreak "items: [bitrate]" --move "!HOLD!"
echo.
echo  Moved to: !HOLD!
echo  Review that folder before deleting anything.
goto DONE

:ART
cls
echo.
echo  --- ALBUM ART ---
echo.
echo  Downloading missing art...
beet fetchart
echo.
echo  Embedding art into tags...
beet embedart
goto DONE

:LYRICS
cls
echo.
echo  --- LYRICS ---
echo.
beet lyrics
goto DONE

:GENRE
cls
echo.
echo  --- GENRES ---
echo.
beet lastgenre
goto DONE

REM ============================================================
:EXPORT
cls
echo.
echo  --- EXPORT LIBRARY LIST ---
echo.
beet ls -f "$artist - $title" > "%REPORTS%\library.txt" 2>&1
for /f %%c in ('type "%REPORTS%\library.txt" ^| find /c /v ""') do set CNT=%%c
echo  Exported !CNT! tracks to:
echo  %REPORTS%\library.txt
goto DONE

:WHATSMISSING
cls
echo.
echo  --- WHAT AM I MISSING? ---
echo.
echo  Give it a list of songs you want, one per line, in any
echo  format. It tells you which ones you do not already have.
echo.
echo  Refreshing library list first...
beet ls -f "$artist - $title" > "%REPORTS%\library.txt" 2>&1
echo.
set "W="
set /p W=  Path to your wanted list (.txt): 
set "W=!W:"=!"
if not exist "!W!" (
    echo.
    echo  [X] File not found.
    goto DONE
)
echo.
python "%SCRIPTS%\whats-missing.py" "!W!" "%REPORTS%\library.txt" "%REPORTS%"
echo.
echo  missing.txt   - not in your library
echo  uncertain.txt - close calls, CHECK THESE BY HAND
echo.
set "O="
set /p O=  Open missing.txt? (y/n): 
if /i "!O!"=="y" start "" notepad "%REPORTS%\missing.txt"
goto DONE

REM ============================================================
:CONFIG
start "" notepad "%APPDATA%\beets\config.yaml"
goto MENU

:MP3TAG
start "" "Mp3tag"
if %errorLevel% neq 0 start "" "%ProgramFiles%\Mp3tag\Mp3tag.exe"
goto MENU

:LOG
for /f "tokens=2 delims=:" %%a in ('findstr /i "log:" "%APPDATA%\beets\config.yaml"') do set "LOGP=%%a"
start "" notepad "%APPDATA%\beets\config.yaml"
goto MENU

REM ============================================================
:ASKPATH
set "P="
echo  %~1
echo  (drag the folder into this window, or type the path)
set /p P=  ^> 
set "P=!P:"=!"
if "!P!"=="" exit /b 0
if not exist "!P!" (
    echo.
    echo  [X] That path does not exist.
    set "P="
    timeout /t 2 >nul
)
exit /b 0

:DONE
echo.
echo  ------------------------------------------------------------
pause
goto MENU
