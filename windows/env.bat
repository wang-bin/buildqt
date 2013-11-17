@echo wbsecg1@gmail.com 2012-12-18
:: http://stackoverflow.com/questions/3432851/dos-bat-file-equivalent-to-unix-basename-command
@echo off
set THIS=%~nx0
set THIS_DIR=%~dp0
set compiler=%1

if "%compiler%" == "" (goto help)
if "%compiler%" == "g++" set QMAKESPECNAME=win32-g++
if "%compiler%" == "clang" set QMAKESPECNAME=win32-clang
if "%compiler%" == "vc" set QMAKESPECNAME=win32-ms%compiler%%2

@echo compiler: %compiler%

:: TODO: XP compat for vs>2012
set DEPEND_DIR=%THIS_DIR%depends
set GNUWIN32_BIN=G:\GNUWin32\bin
set PERL_BIN=G:\strawberry\perl\bin
set MINGW_BIN=G:\MinGW\MinGW\bin
set QTSRCDIR=G:\dev\qtbase
set OPENSSL_DIR=%DEPEND_DIR%\OpenSSL
:: INCLUDE, LIB, PATH may be auto define if DXSDK_DIR is set
set DXSDK_DIR=%DEPEND_DIR%\DXSDK\
set QTDIR=
set WINSDKDIR=C:\Program Files (x86)\Microsoft SDKs\Windows\v7.1A

set XP_OPTS=
:: for clang
::set CPATH=%THIS_DIR%include\c++\4.8.0;%THIS_DIR%x86_64-w64-mingw32\include;%THIS_DIR%include\c++\4.8.0\x86_64-w64-mingw32
::set LIBRARY_PATH=%THIS_DIR%x86_64-w64-mingw32\lib

if "%QMAKESPECNAME%" == "win32-g++" (
	echo "%QMAKESPECNAME%"
	goto setgcc
) else if "%QMAKESPECNAME%" == "win32-clang" (
	echo "%QMAKESPECNAME%"
	goto setgcc
) else (
	echo "%QMAKESPECNAME%"
	if "%3" == "-xp" (
		set INCLUDE=%VCINSTALLDIR%INCLUDE;"%WINSDKDIR%\Include"
		set LIB=%VCINSTALLDIR%LIB;"%WINSDKDIR%\lib"
		set XP_OPTS=-xp
	)
		
	goto setvc
)

:help
@echo Usage:
@echo call %this% "g++|clang|vc 2012|vc 2010|vc 2012|vc 2013..."
@echo You may have to edit some vars in %this%
goto END

:setvc
@echo Requirement: ActivePerl or Strawberry perl, VC
@echo ...
:: may be called from vc prompt, so %PATH% should be kept
:: GNUWin32's link.exe conflicts with vc, we should not add it to PATH
set PATH=%THIS_DIR%bin;%PERL_BIN%;%SystemRoot%\system32;%SystemRoot%;%QTSRCDIR%;%PATH%
goto setqt

:setgcc
@echo Requirement: ActivePerl or Strawberry perl, GNUWin32, MinGW gcc
@echo NOTE: ensure no sh.exe in your %%PATH%%
@echo ...
@set MAKE_COMMAND=mingw32-make -j4
set PATH=%THIS_DIR%bin;%GNUWIN32_BIN%;%MINGW_BIN%;%PERL_BIN%;%SystemRoot%\system32;%SystemRoot%;%QTSRCDIR%;
goto setqt

:setqt
md qt-%QMAKESPECNAME%
cd qt-%QMAKESPECNAME%
set PATH=%THIS_DIR%qt-%QMAKESPECNAME%\bin;%PATH%

set QT5OPT=-release -opensource -confirm-license -platform %QMAKESPECNAME%  -developer-build -ltcg -c++11 -no-freetype -opengl es2 -angle -openssl -qt-sql-sqlite  -no-iconv -qt-style-windowsvista -nomake tests  -nomake examples  -mp -openssl %XP_OPTS%
set QT5OPT_NOCXX11=-release -opensource -confirm-license -platform %QMAKESPECNAME% -developer-build -ltcg -no-c++11 -no-freetype -opengl es2 -angle -openssl -qt-sql-sqlite  -qt-style-windowsxp -qt-style-windowsvista -nomake tests - -nomake examples %XP_OPTS%
set QT4OPT=-developer-build  -opensource -confirm-license -platform %QMAKESPECNAME% -ltcg -release -shared -fast -stl -qt-sql-sqlite -no-qt3support -no-xmlpatterns -no-declarative-debug -nomake demos -nomake examples -nomake docs  -nomake tests -qt-libpng -qt-libtiff -qt-libjpeg -qt-libmng -script -scripttools -no-webkit  -qt-style-windowsxp -qt-style-windowsvista  -opengl desktop -openssl %XP_OPTS%

:: -graphicssystem opengl

set INCLUDE=%INCLUDE%;%OPENSSL_DIR%\include;%DXSDK_DIR%Include
set LIB=%LIB%;%OPENSSL_DIR%\lib;%DXSDK_DIR%Lib\x86
set PATH=%PATH%;%DXSDK_DIR%Utilities\bin\x86
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
