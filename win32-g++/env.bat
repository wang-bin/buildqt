@echo wbsecg1@gmail.com 2012-12-18
:: http://stackoverflow.com/questions/3432851/dos-bat-file-equivalent-to-unix-basename-command
@echo off
set this=%~nx0
set compiler=%1
if "%compiler%" == "" (goto help)
if "%compiler%" == "g++" (set QMAKESPEC=win32-g++) else set QMAKESPEC=win32-ms%compiler%
@echo compiler: %compiler%


set GNUWIN32_BIN=G:\GNUWin32\bin
set PERL_BIN=G:\strawberry\perl\bin
set MINGW_BIN=C:\MinGW\bin
set QTSRCDIR=G:\dev\qtbase
set INCLUDE_SSL=G:\software\vs2012-x86\build\include
set LIB_SSL=G:\software\vs2012-x86\build\lib

set QTDIR=

if "%QMAKESPEC%" == "win32-g++" (goto setgcc) else goto setvc

:help
@echo Usage:
@echo call %this% "g++|vc2012|vc2010|..."
@echo You may have to edit some vars in %this%
goto END

:setvc
@echo Requirement: ActivePerl or Strawberry perl, VC
@echo ...
:: may be called from vc prompt, so %PATH% should be kept
:: GNUWin32's link.exe conflicts with vc, we should not add it to PATH
set PATH=%CD%\bin;%PERL_BIN%;%SystemRoot%\system32;%SystemRoot%;%QTSRCDIR%;%PATH%
goto setqt

:setgcc
@echo Requirement: ActivePerl or Strawberry perl, GNUWin32, MinGW gcc
@echo NOTE: ensure no sh.exe in your %%PATH%%
@echo ...
@set MAKE_COMMAND=mingw32-make -j4
set PATH=%CD%\bin;%GNUWIN32_BIN%;%MINGW_BIN%;%PERL_BIN%;%SystemRoot%\system32;%SystemRoot%;%QTSRCDIR%
goto setqt

:setqt
set QT5OPT=-release -opensource -confirm-license -platform %QMAKESPEC%  -developer-build -ltcg -c++11 -no-freetype -opengl desktop -openssl -qt-sql-sqlite -qt-zlib -qt-style-windowsxp -qt-style-windowsvista -nomake tests -nomake demos -nomake examples
set QT5OPT_NOCXX11=-release -opensource -confirm-license -platform %QMAKESPEC% -developer-build -ltcg -no-c++11 -no-freetype -opengl desktop -openssl -qt-sql-sqlite -qt-zlib -qt-style-windowsxp -qt-style-windowsvista -nomake tests -nomake demos -nomake examples
set QT4OPT=-developer-build  -opensource -confirm-license -platform %QMAKESPEC% -ltcg -release -shared -fast -stl -qt-sql-sqlite -no-qt3support -no-xmlpatterns -no-declarative-debug -nomake demos -nomake examples -nomake docs  -nomake tests -qt-libpng -qt-libtiff -qt-libjpeg -qt-libmng -qt-zlib -script -scripttools -no-webkit  -qt-style-windowsxp -qt-style-windowsvista  -opengl desktop -openssl -graphicssystem opengl

set INCLUDE=%INCLUDE%;%INCLUDE_SSL%
set LIB=%LIB%;%LIB_SSL%
@echo PATH=%PATH%
@echo INCLUDE=%INCLUDE%
@echo LIB=%LIB%
@echo =======================configure options========================
@echo QT5OPT=%QT5OPT%
@echo QT4OPT=%QT4OPT%

@echo "build Qt5: configure %%QT5OPT%% or configure %%QT5OPT_NOCXX11%%"
@echo "build Qt4: configure %%QT4OPT%% "
goto END

:END
@echo on
