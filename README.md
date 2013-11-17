# Scripts to Build Qt4 and Qt5

## Windows

#### MinGW

1. edit these vars in buildqt/win32-g++/env.bat AND save

set GNUWin32, Perl, MinGW, OpenSSL(optional) dir


    set DEPEND_DIR=%THIS_DIR%depends
    set GNUWIN32_BIN=G:\GNUWin32\bin
    set PERL_BIN=G:\strawberry\perl\bin
    set MINGW_BIN=G:\MinGW\MinGW\bin
    set QTSRCDIR=G:\dev\qtbase
    set OPENSSL_DIR=%DEPEND_DIR%\OpenSSL
    set DXSDK_DIR=%DEPEND_DIR%\DXSDK\


2. double click buildqt/win32-g++/buildqt_mingw, a cmd dialog will popup. It will tell you how to build.  

To build Qt4(only latest release tested), type

	configure %QT4OPT%

To build Qt5

	configure %QT5OPT%


#### MSVC

Almost the same.

Open vs prompt window, go to buildqt dir. run

    call env.bat vc 2013

Then 

	configure %QT5OPT%


#### Windows CE

WARNING: The script is out of date, only tested for Qt4.7.x and Qt4.8.0


#### How To Get Headers and Private Headers?

Bash scripts are available. Both Qt4 and Qt5 supported. MSYS and 7zip is required. Make sure 7z.exe is in $PATH.  

	cp buildqt/*.sh Qt_build_dir/include
	cd Qt_build_dir/include
	./get_h.sh
	./get_private.sh
	cp *.sh *.7z target_dir
	cd target_dir
	./put_h.sh
	./put_private.sh


## Unix

WARNING: the script is out of date, only Qt4.8.3 and older are tested.

script is buildqt/unix/qbuild.sh

	. qbuild.sh
	setqt configure path_of_configure
	#setqt host linux-clang
	#setqt xplatform ios-linux-clang #not officially support now, just my test
	#setqt other "other options from configure --help"
	setqt
	buildqt
	installqt

If you are building the code from git, and want to build new code with the old configuration, just

	. qbuild.sh
	setqt
	buildqt



