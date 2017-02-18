cd \fw195\gestool\

taskkill /F /IM rpttool.exe

\BCC582\BIN\MAKE -S -fHB.MAK -D__GST__ TARGET=rpttool

cd \fw195\gestool\bin\

if "%1"=="" goto NOPASSWORD

   rpttool.exe %1
   goto EXIT

:NOPASSWORD
   rpttool.exe 2015 000 Articulos

:EXIT
   cd \fw195\gestool\