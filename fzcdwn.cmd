@echo off
setlocal enableextensions
if "%1" == "--help" goto mhelp
if "%1" == "-h" goto mhelp
if "%1" == "l" goto lfz else goto fzc
if "%1" == "s" goto sfz else goto fzc
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
     ) do curl.exe -C - -LRZSs --create-dirs --output FileZilla\client\FileZilla_%ver%%%A https://download.filezilla-project.org/client/FileZilla_%ver%%%A
if not "%~1" == "" (curl.exe -C - -LRZSs --create-dirs --output FileZilla\client\FileZilla_%ver%.sha512 https://download.filezilla-project.org/client/FileZilla_%ver%.sha512)
:lfz
if "%2" == "" goto:eof
for %%A in (
      tar.bz2
      sha512
     ) do curl.exe -C - -LRZSs --create-dirs --output FileZilla\libfilezilla\libfilezilla-%2.%%A https://download.filezilla-project.org/libfilezilla/libfilezilla-%2.%%A
if "%3" == "" (goto:eof) else (goto sfz1)
exit
:sfz
if "%2" == "" goto:eof
for %%A in (
      .sha512
      _src.tar.bz2
     ) do curl.exe -C - -LRZSs --create-dirs --output FileZilla\server\FileZilla_Server_%2%%A https://download.filezilla-project.org/server/FileZilla_Server_%2%%A
set vr=%2:~1,1%
if "%vr%" == "0" (
      curl.exe -C - -LRZSs --create-dirs --output FileZilla\server\FileZilla_Server_%2.exe https://download.filezilla-project.org/server/FileZilla_Server_%2.exe
      ) else (
      curl.exe -C - -LRZSs --create-dirs --output FileZilla\server\FileZilla_Server_%2_win64-setup.exe https://download.filezilla-project.org/server/FileZilla_Server_%2_win64-setup.exe
      )
exit
:sfz1
if "%3" == "" goto:eof
for %%A in (
      .sha512
      _src.tar.bz2
     ) do curl.exe -C - -LRZSs --create-dirs --output FileZilla\server\FileZilla_Server_%3%%A https://download.filezilla-project.org/server/FileZilla_Server_%3%%A
set vr=%3:~1,1%
if "%vr%" == "0" (
      curl.exe -C - -LRZSs --create-dirs --output FileZilla\server\FileZilla_Server_%3.exe https://download.filezilla-project.org/server/FileZilla_Server_%3.exe
      ) else (
      curl.exe -C - -LRZSs --create-dirs --output FileZilla\server\FileZilla_Server_%3_win64-setup.exe https://download.filezilla-project.org/server/FileZilla_Server_%3_win64-setup.exe
      )
exit
:mhelp
echo.
echo Synopsis:
echo.
echo       This script is download FileZilla FTP Client and libfilezilla use cURL 7.66.0 or never.
echo.
echo Usage:
echo.
echo       fzcdwn ^<version^> [^<libfilezilla_version^>] [^<server_version^>]
echo       or fzcdwn l ^<libfilezilla_version^> or fzcdwn s ^<server_version^>
echo.
echo Examples:
echo.
echo       fzcdwn 3.43.0 0.30.0 or fzcdwn 3.43.0 or fzcdwn l 0.30.0 or fzcdwn s 1.0.0
echo.
pause
exit /b
