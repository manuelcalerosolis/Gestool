cd \fw195\gestool\

taskkill /F /IM rpttool.exe

\BCC582\BIN\MAKE -S -fRB.MAK -D__GST__

cd \fw195\gestool\bin\

if "%1"=="" goto NOPASSWORD

   rpttool.exe %1
   goto EXIT

:NOPASSWORD
   rpttool.exe /NOPASSWORD

:EXIT
   cd \fw195\gestool\