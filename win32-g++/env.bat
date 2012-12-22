@echo wbsecg1@gmail.com 2012-12-18
@echo Requirement: ActivePerl or Strawberry perl, GNUWin32, MinGW gcc
@echo NOTE: ensure no sh.exe in your %%PATH%%
@echo ...
@echo off
set MINGWPATH=G:\MinGW\bin
set QTSRCDIR=G:\dev\qtbase
set INCLUDE=g:\build\openssl\include
set LIB=g:\build\openssl\lib
set QMAKESPEC=
set QTDIR=
set MAKE_COMMAND=

set PATH=%CD%\bin;G:\GNUWin32\bin;%MINGWPATH%;G:\strawberry\perl\bin;C:\Python27;C:\Program Files (x86)\Git\cmd;%SystemRoot%\system32;%SystemRoot%;%QTSRCDIR%

set QT5OPT=-release -opensource -confirm-license -platform win32-g++ -developer-build -ltcg -c++11 -no-freetype -opengl desktop -openssl -qt-sql-sqlite -qt-zlib -qt-style-windowsxp -qt-style-windowsvista -nomake tests -nomake demos -nomake examples
set QT5OPT_NOCXX11=-release -opensource -confirm-license -platform win32-g++ -developer-build -ltcg -no-c++11 -no-freetype -opengl desktop -openssl -qt-sql-sqlite -qt-zlib -qt-style-windowsxp -qt-style-windowsvista -nomake tests -nomake demos -nomake examples
set QT4OPT=-developer-build  -opensource -confirm-license -platform win32-g++ -ltcg -release -shared -fast -stl -qt-sql-sqlite -no-qt3support -no-xmlpatterns -no-declarative-debug -nomake demos -nomake examples -nomake docs  -nomake tests -qt-libpng -qt-libtiff -qt-libjpeg -qt-libmng -qt-zlib -script -scripttools -no-webkit -largefile  -qt-style-windowsxp -qt-style-windowsvista  -opengl desktop -openssl -graphicssystem opengl
@echo on

@echo INCLUDE=g:\build\openssl\include
@echo LIB=g:\build\openssl\lib
@echo PATH=%CD%\bin;G:\GNUWin32\bin;G:\MinGW\bin;G:\strawberry\perl\bin;C:\Python27;C:\Program Files (x86)\Git\cmd;%SystemRoot%\system32;%SystemRoot%;G:\dev\qtbase
@echo =======================configure options========================
@echo QT5OPT=-release -opensource -confirm-license -platform win32-g++ -developer-build -ltcg -c++11 -opengl desktop -openssl -qt-sql-sqlite -qt-zlib -qt-style-windowsxp -qt-style-windowsvista -nomake tests -nomake demos -nomake examples
@echo QT4OPT=-developer-build  -opensource -confirm-license -platform win32-g++ -ltcg -release -shared -fast -stl -qt-sql-sqlite -no-qt3support -no-xmlpatterns -no-declarative-debug -nomake demos -nomake examples -nomake docs  -nomake tests -qt-libpng -qt-libtiff -qt-libjpeg -qt-libmng -qt-zlib -script -scripttools -no-webkit -largefile  -qt-style-windowsxp -qt-style-windowsvista  -opengl desktop -openssl -graphicssystem opengl

@echo "configure %%QT5OPT%% or configure %%QT4OPT%% "
