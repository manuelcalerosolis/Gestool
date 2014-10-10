cd \fw195\gestool\

taskkill /F /IM gestoolhb.exe

\BCC55\BIN\MAKE -S -fHB.MAK -D__GST__

cd \fw195\gestool\bin\

gestoolhb.exe /TABLET

cd \fw195\gestool\
