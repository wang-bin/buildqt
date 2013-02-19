@echo wbsecg1@gmail.com 2012-12-18
@echo Requirement: ActivePerl or Strawberry perl, GNUWin32, MinGW gcc
@echo NOTE: ensure no sh.exe in your %%PATH%%
@echo ...
@echo off
set GNUWIN32_BIN=G:\GNUWin32\bin
set PERL_BIN=G:\strawberry\perl\bin
set MINGW_BIN=C:\MinGW\bin
set QTSRCDIR=G:\dev\qtbase
set INCLUDE_SSL=g:\build\openssl\include
set LIB_SSL=g:\build\openssl\lib

set QMAKESPEC=
set QTDIR=
set MAKE_COMMAND=mingw32-make -j4

set PATH=%CD%\bin;%GNUWIN32_BIN%;%MINGW_BIN%;%PERL_BIN%;%SystemRoot%\system32;%SystemRoot%;%QTSRCDIR%

set QT5OPT=-release -opensource -confirm-license -platform win32-g++ -developer-build -ltcg -c++11 -no-freetype -opengl desktop -openssl -qt-sql-sqlite -qt-zlib -qt-style-windowsxp -qt-style-windowsvista -nomake tests -nomake demos -nomake examples
set QT5OPT_NOCXX11=-release -opensource -confirm-license -platform win32-g++ -developer-build -ltcg -no-c++11 -no-freetype -opengl desktop -openssl -qt-sql-sqlite -qt-zlib -qt-style-windowsxp -qt-style-windowsvista -nomake tests -nomake demos -nomake examples
set QT4OPT=-developer-build  -opensource -confirm-license -platform win32-g++ -ltcg -release -shared -fast -stl -qt-sql-sqlite -no-qt3support -no-xmlpatterns -no-declarative-debug -nomake demos -nomake examples -nomake docs  -nomake tests -qt-libpng -qt-libtiff -qt-libjpeg -qt-libmng -qt-zlib -script -scripttools -no-webkit  -qt-style-windowsxp -qt-style-windowsvista  -opengl desktop -openssl -graphicssystem opengl
@echo on

@echo INCLUDE=%INCLUDE_SSL%
@echo LIB=%LIB_SSL%
@echo PATH=%PATH%
@echo =======================configure options========================
@echo QT5OPT=%QT5OPT%
@echo QT4OPT=%QT4OPT%

@echo "build Qt5: configure %%QT5OPT%% or configure %%QT5OPT_NOCXX11%%"
@echo "build Qt4: configure %%QT4OPT%% "
