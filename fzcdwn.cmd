@echo off
setlocal enableextensions
if "%1" == "--help" goto mhelp
if "%1" == "-h" goto mhelp
if "%1" == "l" goto lfz else goto fzc
:fzc
if not "%1" == "" (
set ver=%1
  ) else (
echo.
echo Required parameter is missing. Download is cancel.
echo.
goto mhelp
)
for %%A in (
     _i686-linux-gnu.tar.bz2
     _macosx-x86.app.tar.bz2
     _src.tar.bz2
     _win32.zip
     _win32-setup.exe
     _win64.zip
     _win64-setup.exe
     _x86_64-linux-gnu.tar.bz2
     ) do curl.exe -C - -LRZSs --create-dirs --output FileZilla\Client\FileZilla_%ver%%%A https://download.filezilla-project.org/client/FileZilla_%ver%%%A
if not "%~1" == "" (curl.exe -C - -LRZSs --create-dirs --output FileZilla\Client\FileZilla_%ver%.sha512 https://download.filezilla-project.org/client/FileZilla_%ver%.sha512)
:lfz
if "%2" == "" goto:eof
for %%A in (
      tar.bz2
      sha512
     ) do curl.exe -C - -LRZSs --create-dirs --output FileZilla\libfilezilla\libfilezilla-%2.%%A https://download.filezilla-project.org/libfilezilla/libfilezilla-%2.%%A
exit
:mhelp
echo.
echo Synopsis:
echo.
echo       This script is download FileZilla FTP Client and libfilezilla use cURL 7.66.0 or never.
echo.
echo Usage:
echo.
echo       fzcdwn ^<version^> [^<libfilezilla_version^>] or fzcdwn l ^<libfilezilla_version^>
echo.
echo Examples:
echo.
echo       fzcdwn 3.43.0 0.30.0 or fzcdwn 3.43.0 or fzcdwn l 0.30.0
echo.
pause
exit /b
