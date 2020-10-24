@echo off
setlocal enableextensions
if "%1" == "--help" goto mhlp
if "%1" == "-h" goto mhlp
if not exist "%path%\7-zip\7z.exe" (if not exist "%ProgramFiles%\7-Zip\7z.exe" echo Required 7z.exe not found! & pause & exit /b)
if "%1" == "" (set wd="%cd%") else (set wd="%1")
cd /d "%wd%"
if exist "avidemux_*_win32.exe" set nm="avidemux_*_win32.exe" & goto mgcc  > nul
if exist "avidemux_*_win64.exe" set nm="avidemux_*_win64.exe" & goto mgcc   > nul
if exist "avidemux_r*_win64Qt5_*.zip" set nm="avidemux_r*_win64Qt5_*.zip" & goto mgcc  > nul
if exist "Avidemux_*.exe" set nm="Avidemux_*.exe" & goto mvc  > nul
goto mhlp
:mgcc
7z x %nm% -y -oADM -xr!$PLUGINSDIR -x![NSIS].nsi -x!uninstall.exe > nul & goto next
:mvc
7z x %nm% -y -t#:e -oADM -ir!*.7z > nul & 7z x "ADM\*.7z" -y -oADM > nul & del /f/q "ADM\*.7z" > nul
:next
7z x %nm% -y -xr!$PLUGINSDIR -x![NSIS].nsi -x!uninstall.exe -oADM > nul
if exist ADM\avidemux_64 (xcopy /e/q/y ADM\avidemux_64\* ADM > nul && rmdir /s/q ADM\avidemux_64 > nul)
if exist ADM\pluginSettings (rmdir /s/q ADM\pluginSettings > nul)
if not exist ADM\settings (mkdir ADM\settings > nul)
for %%A in (Avidemux_*_settings.zip) do (7z x -y -oADM\settings -x!readme.txt %%A > nul)
if exist ADM\readme.txt (del /f/q ADM\readme.txt > nul )
if not exist avidemuxp.cmd (
echo @echo off > avidemuxp.cmd
echo setlocal enableextensions >> avidemuxp.cmd
echo ^cd /d %%cd%% >> avidemuxp.cmd
echo ^if not exist "ADM\avidemux.exe" ^goto mmsg >> avidemuxp.cmd
echo ^start /dADM ADM\avidemux --portable >> avidemuxp.cmd
echo ^exit >> avidemuxp.cmd
echo ^:mmsg >> avidemuxp.cmd
echo ^echo WARNING! ADM\avidemux.exe not found! >> avidemuxp.cmd
echo ^pause >> avidemuxp.cmd
echo ^exit ^/b >> avidemuxp.cmd
)
call avidemuxp.cmd
exit
:mhlp
echo.
echo SYNOPSIS: this script unpack Avidemux distributive and make portable.
echo Script required 7z.exe in to ^%PATH^% or "^%ProgramFiles^%^\7-Zip" directory.
echo Script find first avidemux_*_win*.exe, avidemux_r*_win64Qt5_*.zip or
echo Avidemux_*64bits*.exe files and unpack it to ^<target_dir^>^\ADM.
echo.
echo Also if found Avidemux_*_settings.zip then unpack and install it in to
echo ^<target_dir^>^\ADM^\settings directory.
echo.
echo USAGE:
echo.
echo admport [target dir] or admport [-h^|--help] for display this help
echo.
echo NOTES:
echo.
echo Messages like
echo,
echo     ERROR: Avidemux_2.7.7 VC++ 64bits 201020.exe
echo     Cannot open the file as archive
echo.
echo is just warning, but all files be unpacked success
echo.
echo HISTORY:
echo.
echo v2.0 , 10.08.2020, First public version.
echo v2.1 , 10.08.2020, Refactoring.
echo v2.2 , 24.10.2020, Refactoring, add support VsWin64 platform (big thanks Pasha_ZZZ by idea!)
pause
exit /b