@echo off

rem ===================== Use Microsoft Visual Studio ==========================

 call "%VS100COMNTOOLS%..\..\VC\vcvarsall.bat" amd64

rem  ======================== Set name and version ... =========================

set PlugName=AdvCmpEx
set fileversion=3,0,2927,37
set fileversion_str=3.0 build 37 x64
set MyDir=%CD%
set companyname=Eugene Roshal ^& FAR Group
set filedescription=Advanced compare files for Far Manager x64
set legalcopyright=Copyright c 2006 Alexey Samlyukov

rem  ==================== Make %PlugName%.def file... ==========================

if not exist %PlugName%.def (
echo Make %PlugName%.def file...

echo LIBRARY           %PlugName%                         > %PlugName%.def
echo EXPORTS                                              >> %PlugName%.def
echo   SetStartupInfoW                                    >> %PlugName%.def
echo   GetPluginInfoW                                     >> %PlugName%.def
echo   OpenW                                              >> %PlugName%.def
echo   GetGlobalInfoW                                     >> %PlugName%.def
echo   ExitFARW                                           >> %PlugName%.def

if exist %PlugName%.def echo ... succesfully
)

rem  ================== Make %PlugName%.rc file... =============================

if not exist %PlugName%.rc (
echo Make %PlugName%.rc file...

echo #define VERSIONINFO_1   1                                 > %PlugName%.rc
echo.                                                          >> %PlugName%.rc
echo VERSIONINFO_1  VERSIONINFO                                >> %PlugName%.rc
echo FILEVERSION    %fileversion%                              >> %PlugName%.rc
echo PRODUCTVERSION 3,0,0,0                                    >> %PlugName%.rc
echo FILEFLAGSMASK  0x0                                        >> %PlugName%.rc
echo FILEFLAGS      0x0                                        >> %PlugName%.rc
echo FILEOS         0x4                                        >> %PlugName%.rc
echo FILETYPE       0x2                                        >> %PlugName%.rc
echo FILESUBTYPE    0x0                                        >> %PlugName%.rc
echo {                                                         >> %PlugName%.rc
echo   BLOCK "StringFileInfo"                                  >> %PlugName%.rc
echo   {                                                       >> %PlugName%.rc
echo     BLOCK "000004E4"                                      >> %PlugName%.rc
echo     {                                                     >> %PlugName%.rc
echo       VALUE "CompanyName",      "%companyname%\0"         >> %PlugName%.rc
echo       VALUE "FileDescription",  "%filedescription%\0"     >> %PlugName%.rc
echo       VALUE "FileVersion",      "%fileversion_str%\0"     >> %PlugName%.rc
echo       VALUE "InternalName",     "%PlugName%\0"            >> %PlugName%.rc
echo       VALUE "LegalCopyright",   "%legalcopyright%\0"      >> %PlugName%.rc
echo       VALUE "OriginalFilename", "%PlugName%.dll\0"        >> %PlugName%.rc
echo       VALUE "ProductName",      "Far Manager\0"           >> %PlugName%.rc
echo       VALUE "ProductVersion",   "3.0\0"                   >> %PlugName%.rc
echo       VALUE "Comments",         "%comments%\0"            >> %PlugName%.rc
echo     }                                                     >> %PlugName%.rc
echo   }                                                       >> %PlugName%.rc
echo   BLOCK "VarFileInfo"                                     >> %PlugName%.rc
echo   {                                                       >> %PlugName%.rc
echo     VALUE "Translation", 0, 0x4e4                         >> %PlugName%.rc
echo   }                                                       >> %PlugName%.rc
echo }                                                         >> %PlugName%.rc

if exist %PlugName%.rc echo ... succesfully
)

rem  ==================== Compile %PlugName%.dll file...========================

cd ".."
if exist %PlugName%.dll del %PlugName%.dll>nul

cd %MyDir%
rc /l 0x4E4 %PlugName%.rc
cl /Zp8 /O2 /W2 /Gy /GF /J /GS- /Gr /GR- /EHs-c- /LD AdvCmp.cpp string.cpp AdvCmpDlgOpt.cpp AdvCmpProc.cpp /D_CRT_SECURE_NO_WARNINGS /D_CRT_NONSTDC_NO_WARNINGS /D_CRT_NON_CONFORMING_SWPRINTFS /DUNICODE /D_UNICODE /link /subsystem:console /machine:AMD64 /nodefaultlib /def:%PlugName%.def kernel32.lib advapi32.lib user32.lib shell32.lib gdi32.lib MSVCRT.LIB %PlugName%.res /map:"..\%PlugName%.map" /out:"..\%PlugName%.dll" /merge:.rdata=.text

if exist *.exp del *.exp>nul
if exist *.obj del *.obj>nul
if exist *.lib del *.lib>nul
if exist *.res del *.res>nul
if exist *.def del *.def>nul
if exist *.rc  del *.rc>nul
cd ".."
if not exist x64 md x64>nul
copy /y /b AdvCmpEx*.* .\x64>nul
copy /y /b *.txt .\x64>nul
copy /y /b README.md .\x64>nul
if exist %PlugName%.dll del %PlugName%.dll>nul
if exist %PlugName%.map del %PlugName%.map>nul

echo ***************
