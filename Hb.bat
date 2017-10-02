cd \fw195\gestool\

taskkill /F /IM gestool.exe

\BCC582\BIN\MAKE -S -fHB.MAK -D__GST__ TARGET=gestool

cd \fw195\gestool\bin\

if "%1"=="" goto NOPASSWORD

<<<<<<< HEAD
   gestool.exe %1 /NOPASSWORD
=======
   gestool.exe %1
>>>>>>> 58cf7e4b4f22f3cfd4f88a53d3fdf6d7ca6af92f
   goto EXIT

:NOPASSWORD
   gestool.exe /NOPASSWORD

:EXIT
   cd \fw195\gestool\