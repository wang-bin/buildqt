@echo wbsecg1@gmail.com 2012-12-18
:: http://stackoverflow.com/questions/3432851/dos-bat-file-equivalent-to-unix-basename-command
@echo off
set THIS=%~nx0
set THIS_DIR=%~dp0
set compiler=%1
set ARCH=

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
:: WINSDK_DIR can not contain '(' and ')'. e.g. C:\Program Files (x86)\Microsoft SDKs\Windows\v7.1A is wrong. you may move it to another place
:: TODO: why? happens if %WINSDK_DIR%\Include. But if "%WINSDK_DIR%\Include" winver.h may can't be found.
set WINSDK_DIR=C:\dev\v7.1A


set XP_OPTS=
set SSL_OPTS=-openssl
set GL_OPTS=-opengl es2 -angle
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
		set INCLUDE=%VCINSTALLDIR%INCLUDE;%WINSDK_DIR%\Include
		set LIB=%VCINSTALLDIR%LIB;%WINSDK_DIR%\lib
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

cl 2>%TEMP%\testarch.txt
findstr /i x64 %TEMP%\testarch.txt  1>nul && set ARCH=x64
findstr /i x86_64 %TEMP%\testarch.txt  1>nul   && set ARCH=x86_64
findstr /i x86 %TEMP%\testarch.txt  1>nul  && set ARCH=x86
findstr /i ARM %TEMP%\testarch.txt  1>nul  && set ARCH=arm && set GL_OPTS= && set SSL_OPTS=
goto setqt

:setgcc
@echo Requirement: ActivePerl or Strawberry perl, GNUWin32, MinGW gcc
@echo NOTE: ensure no sh.exe in your %%PATH%%
@echo ...
@set MAKE_COMMAND=mingw32-make -j4
set PATH=%THIS_DIR%bin;%GNUWIN32_BIN%;%MINGW_BIN%;%PERL_BIN%;%SystemRoot%\system32;%SystemRoot%;%QTSRCDIR%;
for /f "delims=" %%t in ('gcc -dumpmachine') do set ARCH=%%t
goto setqt

:setqt
set BUILDQT_OUT=qt-%QMAKESPECNAME%-%ARCH%%XP_OPTS%
md %BUILDQT_OUT%
cd %BUILDQT_OUT%
set PATH=%THIS_DIR%%BUILDQT_OUT%\bin;%PATH%

set QT5OPT=-release -opensource -confirm-license -platform %QMAKESPECNAME%  -developer-build -ltcg -c++11 -no-freetype  -qt-sql-sqlite  -no-iconv -qt-style-windowsvista -nomake tests  -nomake examples  -mp  %XP_OPTS% %GL_OPTS% %SSL_OPTS%
set QT5OPT_NOCXX11=-release -opensource -confirm-license -platform %QMAKESPECNAME% -developer-build -ltcg -no-c++11 -no-freetype -qt-sql-sqlite  -qt-style-windowsxp -qt-style-windowsvista -nomake tests - -nomake examples %XP_OPTS%  %GL_OPTS% %SSL_OPTS%
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
