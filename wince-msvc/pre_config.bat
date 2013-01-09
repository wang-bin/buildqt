rem wbsecg1@gmail.com 2012-12-18
rem Require ActivePerl
:: Make sure the enviroment variables for your compiler are set. Visual Studio includes vcvars32.bat for that purpose - or simply use the "Visual Studio Command Prompt" from the Start menu
:: install to QTSDK_DIR

@echo off
set QTSDK_DIR=E:\QtSDK
:: use perl to get version from qglobal.h
set QTCE_VERSION=4.8.1
set BUILD_DIR=%~dp0
set CETOOL_DIR=D:\Windows Mobile 6 SDK\PocketPC
:: C:\Program Files\Windows Mobile 6 SDK\PocketPC
:: WCE_EXTRAS is optional
set WCE_EXTRAS=C:\Program Files\Windows CE Tools\Extras
:: set WCECOMPAT=E:\Windows.CE.Tools\valerino-wcecompat-17e9e12
:: openssl opengl etc.

set VSInstallDir=%VS90COMNTOOLS%\..\..
set VCInstallDir=%VSInstallDir%\VC
set VC9CE_DIR=%VCInstallDir%\ce
set QTCE_DIR=%QTSDK_DIR%\Embedded\%QTCE_VERSION%\wincewm60pro-armv4i-vc9

call "%VCInstallDir%\vcvarsall.bat" x86
set PATH=%PATH%;%BUILD_DIR%\bin
set INCLUDE=%INCLUDE%;%WCE_EXTRAS%\include
cd /d %BUILD_DIR%


set QT_CONF_OPTS=-developer-build  -opensource -prefix %QTCE_DIR%  -examplesdir %QTSDK_DIR%\Examples\4.8 -demosdir %QTSDK_DIR%\Demos\4.8 -platform win32-msvc2008 -xplatform wincewm60professional-msvc2008 -release -shared -fast -stl -qt-sql-sqlite -no-qt3support -no-declarative-debug -nomake demos -nomake examples -nomake docs  -qt-libpng -qt-libtiff -qt-libjpeg -qt-libmng -qt-zlib -script -scripttools -no-webkit -largefile
::  -prefix-install. -prefix doesn't work
:: -bindir -libdir  -docdir -headerdir -plugindir -translationdir 
::  -declarative  -opengl es2 -openvg -openssl -audio-backend  -iwmmxt
::  -phonon default enabled for wince
:: freetype default is disabled. -qt-freetype cause compile error "unistd.h"
@echo "QT will be installed to %QTCE_DIR%"
@echo on
:: nmake confclean

@echo.
@echo Configure example:
@echo "configure %QT_CONF_OPTS%"
@echo your may just type:
@echo path_of_configure  %%QT_CONF_OPTS%%     to use the configuration above
@echo.
@echo After configure and before nmake, use the command: "call post_config.bat"


:: Functions

