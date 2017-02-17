cd \fw195\gestool\

taskkill /F /IM rptapolo.exe

del \fw195\gestool\obj\rptgal.obj

\BCC582\BIN\MAKE -S -fLX.MAK -D__GST__

cd \fw195\gestool\bin

RptApolo.exe 2015 000 

cd \fw195\gestool\
