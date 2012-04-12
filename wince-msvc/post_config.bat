:: After configure before nmake
@echo off
set INCLUDE=%VC9CE_DIR%\include;%CETOOL_DIR%\Include\Armv4i;%WCE_EXTRAS%\include
set LIB=%VC9CE_DIR%\lib\armv4i;%CETOOL_DIR%\Lib\ARMV4I;%WCE_EXTRAS%\lib
set PATH=%VC9CE_DIR%\bin\x86_arm;%PATH%

setcepaths  wincewm60professional-msvc2008

@echo on