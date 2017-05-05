@ECHO OFF
CLS
ECHO ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
ECHO ³ FiveWin for Harbour 17.02 - Feb.  2017          Harbour development power  ³Ü
ECHO ³ (c) FiveTech 1993-2017 for Microsoft Windows 9X/NT/200X/ME/XP/Vista/7/8/10 ³Û
ECHO ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙÛ
ECHO ÿ ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

if A%1 == A GOTO :SINTAX
if NOT EXIST %1.prg GOTO :NOEXIST

set FWDIR=.\..
set HBDIR=.\..\..\CX\Hb

set GT=gtgui

ECHO Compiling...

set hdir=%HBDIR%
set hdirl=%hdir%\lib
set bcdir=e:\XBASE\FWH\CC\bcc7
set hdodir=.\..\..\HDO
set fwh=%FWDIR%

%hdir%\bin\harbour %1 /n /i%hdodir%\include;%fwh%\include;%hdir%\include /w /p %2 %3 > comp.log 2> warnings.log
if errorlevel 1 goto COMPILEERRORS
@type comp.log
@type warnings.log

echo -O2 -e%1.exe -I%hdir%\include -I%bcdir%\include %1.c > b32.bc
%bcdir%\bin\bcc32 -M -c @b32.bc
:ENDCOMPILE

IF EXIST %1.rc %bcdir%\bin\brc32.exe -r -I%bcdir%\include -I%bcdir%\include\windows\sdk %1
rem IF EXIST %1.rc %bcdir%\bin\cgrc.exe -r -m -I%bcdir%\include -I%bcdir%\include\windows\sdk %1
rem IF EXIST %1.rc %vcdir%\bin\rc -r -d__FLAT__ %1

echo %bcdir%\lib\c0w32.obj + > b32.bc
echo %1.obj, + >> b32.bc
echo %1.exe, + >> b32.bc
echo %1.map, + >> b32.bc
echo %hdodir%\lib\hdo %hdodir%\lib\rdlsqlite %hdodir%\lib\sqlite %fwh%\lib\FiveH.lib %fwh%\lib\FiveHC.lib + >> b32.bc
echo %hdirl%\hbwin.lib + >> b32.bc
echo %hdirl%\gtgui.lib + >> b32.bc
echo %hdirl%\hbrtl.lib + >> b32.bc
echo %hdirl%\hbvm.lib + >> b32.bc
echo %hdirl%\hblang.lib + >> b32.bc
echo %hdirl%\hbmacro.lib + >> b32.bc
echo %hdirl%\hbrdd.lib + >> b32.bc
echo %hdirl%\rddntx.lib + >> b32.bc
echo %hdirl%\rddcdx.lib + >> b32.bc
echo %hdirl%\rddfpt.lib + >> b32.bc
echo %hdirl%\hbsix.lib + >> b32.bc
echo %hdirl%\hbdebug.lib + >> b32.bc
echo %hdirl%\hbcommon.lib + >> b32.bc
echo %hdirl%\hbpp.lib + >> b32.bc
echo %hdirl%\hbcpage.lib + >> b32.bc
echo %hdirl%\hbcplr.lib + >> b32.bc
echo %hdirl%\hbct.lib + >> b32.bc
echo %hdirl%\hbpcre.lib + >> b32.bc
echo %hdirl%\xhb.lib + >> b32.bc
echo %hdirl%\hbziparc.lib + >> b32.bc
echo %hdirl%\hbmzip.lib + >> b32.bc
echo %hdirl%\hbzlib.lib + >> b32.bc
echo %hdirl%\minizip.lib + >> b32.bc
rem echo %hdirl%\png.lib + >> b32.bc
echo %hdirl%\hbusrrdd.lib + >> b32.bc
echo %hdirl%\hbtip.lib + >> b32.bc

rem Uncomment these two lines to use Advantage RDD
rem echo %hdirl%\rddads.lib + >> b32.bc
rem echo %hdirl%\Ace32.lib + >> b32.bc

rem echo %fwh%\lib\dolphin.lib + >> b32.bc
echo %fwh%\lib\libmysql.lib + >> b32.bc

echo %bcdir%\lib\cw32mt.lib + >> b32.bc
echo %bcdir%\lib\uuid.lib + >> b32.bc
echo %bcdir%\lib\import32.lib + >> b32.bc
echo %bcdir%\lib\ws2_32.lib + >> b32.bc
echo %bcdir%\lib\psdk\odbc32.lib + >> b32.bc
echo %bcdir%\lib\psdk\nddeapi.lib + >> b32.bc
echo %bcdir%\lib\psdk\iphlpapi.lib + >> b32.bc
echo %bcdir%\lib\psdk\msimg32.lib + >> b32.bc
echo %bcdir%\lib\psdk\psapi.lib + >> b32.bc
echo %bcdir%\lib\psdk\rasapi32.lib + >> b32.bc
echo %bcdir%\lib\psdk\gdiplus.lib + >> b32.bc
echo %bcdir%\lib\psdk\shell32.lib, >> b32.bc

IF EXIST %1.res echo %1.res >> b32.bc
if %GT% == gtwin %bcdir%\bin\ilink32 -Gn -Tpe -s @b32.bc
IF ERRORLEVEL 1 GOTO LINKERROR
if %GT% == gtgui %bcdir%\bin\ilink32 -Gn -aa -Tpe -s @b32.bc
IF ERRORLEVEL 1 GOTO LINKERROR
ECHO * Application successfully built *
rem signtool.exe sign /fd sha256 %1.exe
%1
GOTO EXIT
ECHO

rem delete temporary files
@del %1.c

:COMPILEERRORS
@type comp.log
@type warnings.log
ECHO * Compile errors *
GOTO EXIT

:LINKERROR
ECHO * Linking errors *
GOTO EXIT

:SINTAX
ECHO    SYNTAX: Build [Program]     {-- No especifiques la extensi¢n PRG
ECHO                                {-- Don't specify .PRG extension
GOTO EXIT

:NOEXIST
ECHO The specified PRG %1 does not exist

:EXIT
@pause