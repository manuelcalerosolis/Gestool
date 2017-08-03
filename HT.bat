cd \fw195\gestool\

taskkill /F /IM gestablet.exe

\BCC582\BIN\MAKE -S -fHT.MAK -D__TABLET__ TARGET=GesTablet OBJDIR=Obj1701Tblt PPODIR=Ppo1701Tblt

cd \fw195\gestool\bin\

if "%1"=="" goto NOPASSWORD

   gestablet.exe %1
   goto EXIT

:NOPASSWORD
   gestablet.exe /NOPASSWORD

:EXIT
   cd \fw195\gestool\