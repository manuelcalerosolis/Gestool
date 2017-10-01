cd \fw195\gestool\

taskkill /F /IM gestool.exe

\BCC582\BIN\MAKE -S -fHB.MAK -D__GST__ TARGET=gestool

cd \fw195\gestool\bin\

if "%1"=="" goto NOPASSWORD

   gestool.exe %1 /TABLET
   goto EXIT

:NOPASSWORD
   gestool.exe /TABLET

:EXIT
   cd \fw195\gestool\