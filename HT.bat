cd \fw195\gestblt\

taskkill /F /IM gestblt.exe

\BCC582\BIN\MAKE -S -fHT.MAK -D__GST__ TARGET=gestool

cd \fw195\gestool\bin\

if "%1"=="" goto NOPASSWORD

   gestblt.exe %1
   goto EXIT

:NOPASSWORD
   gestblt.exe /NOPASSWORD

:EXIT
   cd \fw195\gestool\