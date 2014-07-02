cd \fw195\gestool\

taskkill /F /IM gestool.exe

\BCC55\BIN\MAKE -S -fHX.MAK -D__GST__

cd \fw195\gestool\bin\

gestool.exe /NOPASSWORD

cd \fw195\gestool\
