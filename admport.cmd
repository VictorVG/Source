@echo off
setlocal enableextensions
rem %1 is installer file name
rem %2 is target dir
if "%2" == "" (set wd=%~dps0) else (set wd=%2)
cd /d %wd%
if "%1" == "" (if exist avidemux_*.* (set nm=avidemux_*.*) else (set nm=%1))
if exist  %nm% (7z x %nm% -y -xr!$PLUGINSDIR -x![NSIS].nsi -x!uninstall.exe -o%wd%\ADM > nul)
if exist %wd%\ADM\avidemux_64 (xcopy /e/q/y ADM\avidemux_64\* ADM > nul && rmdir /s/q ADM\avidemux_64 > nul)
if exist Avidemux_*_settings.zip (
if not exist ADM\settings (mkdir ADM\settings > nul)
for %%A in (Avidemux_*_settings.zip) do (7z x -y %%A -oADM\settings -x!readme.txt > nul)
if exist ADM\pluginSettings (rmdir /s/q ADM\pluginSettings > nul)
)
if exist ADM\readme.txt (del /f/q ADM\readme.txt > nul)
start /dADM ADM\avidemux.exe --portable
exit