@echo off
rem
rem FarColorer v1.3.x build toolkit v1.4.1
rem
rem Required:
rem
rem  cURL 7.66.0 or higher;
rem  Java Development Kit 8 (JDK) or higher;
rem  UNIX utilities cp, mv, rm, tar, xz;
rem  CMake 3.20 or higher;
rem  Git 2.30 or higher;
rem  Visual Studio 2017 or higher;
rem  Set environment variables %VS150COMNTOOLS% or/and %VS160COMNTOOLS%
rem   (like %VS100COMNTOOLS% for MSVS 2010)
rem  Perl 5.28 or higher.
rem
setlocal enableextensions
set wkd=%~dps0
rem
rem Settings variables. Please, customize it by current development environment.
rem
rem Set MSVC version. Default 2017
if "%1" == "" (set vsv=2017) else (set vsv=%1)
rem Set JDK version
set jdkv=16.0.1
rem Apache Ant version
set antv=1.10.10
rem Used Visual Studio edition name
set vsnm=Enterprise
rem
rem End settings
rem
cd /d %~dps0
if not exist Colorer-schemes (git clone https://github.com/colorer/Colorer-schemes.git Colorer-schemes)
cd /d %wkd%\Colorer-schemes
echo @echo off> bld.cmd
echo setlocal enableextensions>> bld.cmd
echo if not exist apache-ant-%%antv%% (curl -C - -LRZO https://downloads.apache.org/ant/binaries/apache-ant-%%antv%%-bin.tar.xz ^& tar -xf apache-ant-%%antv%%-bin.tar.xz ^& rm -f apache-ant-%%antv%%-bin.tar.xz ^> nul)>> bld.cmd
echo git pull origin HEAD -f ^& git pull origin HEAD -f --tag>> bld.cmd
echo if exist .\build\* (del /f /q /s .\build\*) ^> nul>> bld.cmd
echo if not exist build md build>> bld.cmd
echo for /f %%%%A in ('git rev-list -n1 --abbrev-commit master') do ( echo Shemes Git %%%%A ^> version )>> bld.cmd
echo set "path=C:\Program Files\Java\jdk-%%jdkv%%\bin;%%~dps0\apache-ant-%%antv%%\bin;%%path%%">> bld.cmd
echo set "JAVA_HOME=C:\Program Files\Java\jdk-%%jdkv%%">> bld.cmd
echo rem path to java libs>> bld.cmd
echo set CLR_JL=javalib>> bld.cmd
echo set CLASSPATH=%%CLR_JL%%\commons-net-ftp-2.0.jar;%%CLR_JL%%\commons-net-2.0.jar;%%CLR_JL%%\resolver.jar;%%CLR_JL%%\saxon9.jar;%%CLASSPATH%%>> bld.cmd
echo ant %%*>> bld.cmd
echo goto:eof>> bld.cmd
cd /d %wkd%
if not exist FarColorer (git clone https://github.com/colorer/FarColorer.git --recursive --recurse-submodules -b build-from-far FarColorer)
echo @echo off> %wkd%\FarColorer\fcbld.cmd
echo setlocal enableextensions>> %wkd%\FarColorer\fcbld.cmd
echo if exist build (rm -fr build ^> nul)>> %wkd%\FarColorer\fcbld.cmd
echo if exist shemes (rm -fr shemes\* ^> nul ) else (md shemes)>> %wkd%\FarColorer\fcbld.cmd
echo if exist ..\Colorer-schemes\build\base (cp -fr -t shemes ../Colorer-schemes/build/*)>> %wkd%\FarColorer\fcbld.cmd
echo git pull -f ^& git submodule update --recursive -f>> %wkd%\FarColorer\fcbld.cmd
echo call scripts\mkbld.cmd %%1>> %wkd%\FarColorer\fcbld.cmd
echo md build\x64\Far\Plugins\farcolorer build\x86\Far\Plugins\farcolorer build\Far3\x64\Far\plugins\editor\colorer build\Far3\x86\Far\plugins\editor\colorer build\Add-ons\plugins\bin\3.0.5788\FarColorer build\Add-ons\plugins\x64\plugins\editor\colorer ^> nul>> %wkd%\FarColorer\fcbld.cmd
echo rm -fr build/Release>> %wkd%\FarColorer\fcbld.cmd
echo cp -fr shemes/* build/FarColorer/x64/ ^> nul>> %wkd%\FarColorer\fcbld.cmd
echo cp -fr build/FarColorer/x64/* build/Add-ons/plugins/x64/plugins/editor/colorer/ ^> nul>> %wkd%\FarColorer\fcbld.cmd
echo cp -fr build/FarColorer/x64/* build/x64/Far/Plugins/farcolorer/ ^> nul>> %wkd%\FarColorer\fcbld.cmd
echo cp -fr build/FarColorer/x64/* build/Far3/x64/Far/plugins/editor/colorer/ ^> nul>> %wkd%\FarColorer\fcbld.cmd
echo cp -fr shemes/* build/FarColorer/x86/ ^> nul>> %wkd%\FarColorer\fcbld.cmd
echo cp -fr build/FarColorer/x86/* build/Add-ons/plugins/bin/3.0.5788/FarColorer/ ^> nul>> %wkd%\FarColorer\fcbld.cmd
echo cp -fr build/FarColorer/x86/* build/x86/Far/Plugins/farcolorer/ ^> nul>> %wkd%\FarColorer\fcbld.cmd
echo cp -fr build/FarColorer/x86/* build/Far3/x86/Far/plugins/editor/colorer/ ^> nul>> %wkd%\FarColorer\fcbld.cmd
echo rm -fr build/FarColorer/x64/* build/Add-ons/plugins/x64/plugins/editor/colorer/bin/*.map ^> nul>> %wkd%\FarColorer\fcbld.cmd
echo rm -fr build/FarColorer/x64/* build/Far3/x64/Far/plugins/editor/colorer/bin/*.map ^> nul>> %wkd%\FarColorer\fcbld.cmd
echo rm -fr build/FarColorer/x86/* build/Far3/x86/Far/plugins/editor/colorer/bin/*.map ^> nul>> %wkd%\FarColorer\fcbld.cmd
echo rm -fr build/FarColorer ^> nul>> %wkd%\FarColorer\fcbld.cmd
echo for /f %%%%A in ('git rev-list -n1 --abbrev-commit HEAD') do ( cp -f ../Colorer-schemes/version build\version^> nul ^& echo Colorer Git %%%%A ^>^> build\version )>> %wkd%\FarColorer\fcbld.cmd
echo exit>> %wkd%\FarColorer\fcbld.cmd
echo @echo off> %wkd%\FarColorer\scripts\mkbld.cmd
echo setlocal>> %wkd%\FarColorer\scripts\mkbld.cmd
echo if "%%1" == "2017" (>> %wkd%\FarColorer\scripts\mkbld.cmd
echo goto def>> %wkd%\FarColorer\scripts\mkbld.cmd
echo      ) else (>> %wkd%\FarColorer\scripts\mkbld.cmd
echo   if "%%1" == "2019" (goto vc16)>> %wkd%\FarColorer\scripts\mkbld.cmd
echo   )>> %wkd%\FarColorer\scripts\mkbld.cmd
echo :def>> %wkd%\FarColorer\scripts\mkbld.cmd
echo if not "%%VS150COMNTOOLS%%" == "" set vspth=%%VS150COMNTOOLS%%\..\..\>> %wkd%\FarColorer\scripts\mkbld.cmd
echo goto next>> %wkd%\FarColorer\scripts\mkbld.cmd
echo :vc16>> %wkd%\FarColorer\scripts\mkbld.cmd
echo if not "%%VS160COMNTOOLS%%" == "" set vspth=%%VS160COMNTOOLS%%\..\..\>> %wkd%\FarColorer\scripts\mkbld.cmd
echo goto next>> %wkd%\FarColorer\scripts\mkbld.cmd
echo set vspth = "C:\Program Files (x86)\Microsoft Visual Studio\2019\%%vsnm%%">> %wkd%\FarColorer\scripts\mkbld.cmd
echo :next>> %wkd%\FarColorer\scripts\mkbld.cmd
echo set PROJECT_ROOT=%%~dp0..>> %wkd%\FarColorer\scripts\mkbld.cmd
echo set PROJECT_CONFIG=Release>> %wkd%\FarColorer\scripts\mkbld.cmd
echo set PROJECT_CONF=x86>> %wkd%\FarColorer\scripts\mkbld.cmd
echo :build>> %wkd%\FarColorer\scripts\mkbld.cmd
echo set PROJECT_BUIILDDIR=%%PROJECT_ROOT%%\build\%%PROJECT_CONFIG%%\%%PROJECT_CONF%%>> %wkd%\FarColorer\scripts\mkbld.cmd
echo if not exist %%PROJECT_BUIILDDIR%% ( mkdir %%PROJECT_BUIILDDIR%% ^> nul )>> %wkd%\FarColorer\scripts\mkbld.cmd
echo pushd %%PROJECT_BUIILDDIR%%>> %wkd%\FarColorer\scripts\mkbld.cmd
echo @call "%%vspth%%\VC\Auxiliary\Build\vcvarsall.bat" %%PROJECT_CONF%%>> %wkd%\FarColorer\scripts\mkbld.cmd
echo cmake.exe -G "NMake Makefiles" -D CMAKE_BUILD_TYPE=%%PROJECT_CONFIG%% %%PROJECT_ROOT%%>> %wkd%\FarColorer\scripts\mkbld.cmd
echo nmake>> %wkd%\FarColorer\scripts\mkbld.cmd
echo :: Create temp directory>> %wkd%\FarColorer\scripts\mkbld.cmd
echo set PKGDIR=%%PROJECT_ROOT%%\build\FarColorer>> %wkd%\FarColorer\scripts\mkbld.cmd
echo set PKGDIRARCH=%%PKGDIR%%\%%PROJECT_CONF%%>> %wkd%\FarColorer\scripts\mkbld.cmd
echo set PKGDIRBIN=%%PKGDIRARCH%%\bin>> %wkd%\FarColorer\scripts\mkbld.cmd
echo set SDIR=%%PROJECT_ROOT%%\build\%%PROJECT_CONFIG%%\%%PROJECT_CONF%%\src>> %wkd%\FarColorer\scripts\mkbld.cmd
echo if exist %%PKGDIRARCH%% rmdir /s /q %%PKGDIRARCH%%>> %wkd%\FarColorer\scripts\mkbld.cmd
echo :: Copy files>> %wkd%\FarColorer\scripts\mkbld.cmd
echo if not exist %%PKGDIR%% ( mkdir %%PKGDIR%% ^> nul )>> %wkd%\FarColorer\scripts\mkbld.cmd
echo mkdir %%PKGDIRARCH%% ^> nul>> %wkd%\FarColorer\scripts\mkbld.cmd
echo mkdir %%PKGDIRBIN%% ^> nul>> %wkd%\FarColorer\scripts\mkbld.cmd
echo copy %%PROJECT_ROOT%%\misc\*.* %%PKGDIRBIN%% ^> nul>> %wkd%\FarColorer\scripts\mkbld.cmd
echo copy %%PROJECT_ROOT%%\LICENSE %%PKGDIRARCH%% ^> nul>> %wkd%\FarColorer\scripts\mkbld.cmd
echo copy %%PROJECT_ROOT%%\README.MD %%PKGDIRARCH%% ^> nul>> %wkd%\FarColorer\scripts\mkbld.cmd
echo copy %%PROJECT_ROOT%%\docs\history.ru.txt %%PKGDIRARCH%% ^> nul>> %wkd%\FarColorer\scripts\mkbld.cmd
echo copy %%SDIR%%\*.dll %%PKGDIRBIN%% ^> nul>> %wkd%\FarColorer\scripts\mkbld.cmd
echo copy %%SDIR%%\*.map %%PKGDIRBIN%% ^> nul>> %wkd%\FarColorer\scripts\mkbld.cmd
echo popd>> %wkd%\FarColorer\scripts\mkbld.cmd
echo if "%%PROJECT_CONF%%" == "x86" goto x64>> %wkd%\FarColorer\scripts\mkbld.cmd
echo goto exit>> %wkd%\FarColorer\scripts\mkbld.cmd
echo :x64>> %wkd%\FarColorer\scripts\mkbld.cmd
echo set PROJECT_CONF=x64>> %wkd%\FarColorer\scripts\mkbld.cmd
echo goto build>> %wkd%\FarColorer\scripts\mkbld.cmd
echo :exit>> %wkd%\FarColorer\scripts\mkbld.cmd
echo goto:eof>> %wkd%\FarColorer\scripts\mkbld.cmd
cd /d %wkd%\Colorer-schemes
call bld.cmd base.far
if exist build\base rd /s/q build\base > nul
if exist build\basefar move /y build\basefar build\base > nul
cd /d %wkd%\FarColorer
start /i fcbld.cmd %vsv%
cd /d %wkd%
exit