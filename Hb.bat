cd \fw195\gestool\

taskkill /F /IM gestoolHb.exe

\BCC55\BIN\MAKE -S -fHB.MAK -D__GST__

cd \fw195\gestool\bin\

gestoolHb.exe /NOPASSWORD

cd \fw195\gestool\
