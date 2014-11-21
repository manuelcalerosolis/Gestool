cd \fw195\gestool\

taskkill /F /IM rptapolo.exe

del \fw195\gestool\obj\rptgal.obj

\bcc55\bin\make -S -fLx.mak -D__GST__

cd \fw195\gestool\bin

RptApolo.exe

cd \fw195\gestool\
