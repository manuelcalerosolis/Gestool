cd \fw195\gestool\

taskkill /F /IM gestool.exe

\BCC582\BIN\MAKE -S -fHB.MAK -D__GST__ TARGET=gestool

cd \fw195\gestool\bin\

if "%1"=="" goto NOPASSWORD

   gestool.exe %1
   goto EXIT

:NOPASSWORD
   gestool.exe 000 2015 Articulos

:EXIT
   cd \fw195\gestool\