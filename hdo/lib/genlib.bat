REM Cliente/Servidor
IMPDEF libmysql.def libmysql.dll
implib libmysql.lib libmysql.dll
REM Embebida
IMPDEF libmysqld.def libmysqld.dll
implib libmysqld.lib libmysqld.dll