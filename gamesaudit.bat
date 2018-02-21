@echo off

REM here you can set where you want your results to end up
SET OUTPUTFOLDER="D:\temp\gamesaudit"

REM there are two dependencies for this script, they are both expected to be in your path
REM the directory calculations are done by du.exe, this is required and nothing good will happen otherwise
REM du.exe can be obtained here: https://docs.microsoft.com/en-us/sysinternals/downloads/du
REM the sorting below requires cmsort.exe being in your path, this is optional but recommended; the results will be unsorted without it
REM cmsort.exe can be obtained here: http://www.chmaas.handshake.de/delphi/freeware/cmsort/cmsort.htm#download

ECHO Auditing your games...

REM !! IMPORTANT !! the first 'du' line in your script must not contain | more +1 | and must use only one > symbol. 
REM ALL following 'du' lines must use two >> symbols and include | more +1 | as per the examples!
REM
REM if all your games are in a few folders, this is easy. everything should be in lowercase unless noted otherwise!
REM three examples below
REM games folder which only contains named games as subfolders; put path inbetween quotes "" ; path uses \\ between each folder in the findstr bit
REM du -l 1 -c "c:\games" | more +1 | findstr /v \"c:\\games\\\" >> %OUTPUTFOLDER%\games_usage.csv
REM games folder which contains another games folder (D:\Games1\Games2\) inside it; findstr bit must include second folder, this folder's name is CASE SENSITIVE; you will need to specify second folder in another 'du' line as a game folder itself
REM du -l 1 -c "d:\games1" | more +1 | findstr /v \"d:\\games1\\\" | findstr /v \"d:\games1\Games2\\\" >> %OUTPUTFOLDER%\games_usage.csv
REM single game folder; doesn't need any findstr part
REM du -l 0 -c "c:\program files (x86)\overwatch" >> %OUTPUTFOLDER%\games_usage.csv

ECHO.

ECHO Calculating C:\ usage...
ECHO c:\program files (x86)\overwatch
du -l 0 -c "c:\program files (x86)\overwatch" > %OUTPUTFOLDER%\games_usage.csv

ECHO Calculating D:\ usage...
ECHO d:\games
du -l 1 -c "d:\games" | more +1 | findstr /v \"d:\\games\\\" | findstr /v \"d:\games\Origin\\\" >> %OUTPUTFOLDER%\games_usage.csv
ECHO d:\games\origin
du -l 1 -c "d:\games\origin" | more +1 | findstr /v \"d:\games\origin\\\" >> %OUTPUTFOLDER%\games_usage.csv
ECHO d:\illusion
du -l 0 -c "d:\illusion" | more +1 | findstr /v \"d:\illusion\\\" >> %OUTPUTFOLDER%\games_usage.csv
ECHO d:\steamlibrary\steamapps\common
du -l 1 -c "d:\steamlibrary\steamapps\common" | more +1 | findstr /v \"d:\steamlibrary\steamapps\common\\\" >> %OUTPUTFOLDER%\games_usage.csv

ECHO Calculating G:\ usage...
ECHO g:\games
du -l 1 -c "G:\games" | more +1 | findstr /v \"g:\games\\\" >> %OUTPUTFOLDER%\games_usage.csv
ECHO g:\steamlibrary\steamapps\common
du -l 1 -c "G:\steamlibrary\steamapps\common" | more +1 | findstr /v \"g:\steamlibrary\steamapps\common\\\" >> %OUTPUTFOLDER%\games_usage.csv

ECHO.
ECHO Cleaning up and sorting...
findstr . %OUTPUTFOLDER%\games_usage.csv > %OUTPUTFOLDER%\games_usage_temp.csv
cmsort /Q /NV=6,1,0- /V=$2C,$22 /H=1 %OUTPUTFOLDER%\games_usage_temp.csv %OUTPUTFOLDER%\games_usage.csv
del %OUTPUTFOLDER%\games_usage_temp.csv

ECHO.
for /f %%C in ('Find /V /C "" ^< %OUTPUTFOLDER%\games_usage.csv') do set Count=%%C
set /a Count-=1
echo %Count% games tallied, sorted audit file is:
dir/b/o %OUTPUTFOLDER%\games_usage*.csv
