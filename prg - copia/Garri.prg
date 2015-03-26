#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 

FUNCTION Traspaso ()

local dbfOrigen, dbfComparar, dbfFinal
local nCod

// Abrimos los ficheros


USE ( "c:\garri\CLIENT.dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "CLIENT", @dbfOrigen ) )
      SET ADSINDEX TO ( "c:\garri\CLIENT.CDX" ) ADDITIVE

USE ( "c:\garri\TB_CLI1.dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "TBCLI", @dbfComparar ) )
      SET ADSINDEX TO ( "c:\garri\tb_cli1.CDX" ) ADDITIVE

USE ( "c:\garri\GACLIENTE.dbf" ) NEW VIA ( cDriver() ) SHARED ALIAS ( cCheckArea( "GACLIENTE", @dbfFinal ) )
      SET ADSINDEX TO ( "c:\garri\GACLIENTE.CDX" ) ADDITIVE


// Buscamos los duplicados


while ( dbfComparar )->( !eof() )

   ( dbfOrigen )-> ( dbGotop () )

   while ( dbfOrigen ) -> ( !eof ())

      nCod := Val ( ( dbfOrigen ) -> COD )

      if nCod != ( dbfComparar ) -> CODIGO

         ( dbfOrigen )->( DbSkip() )

      end if

   end while

   // Añadimos el registro

   ( dbfGarri )->( dbAppend ())

   ( dbfComparar )->( DbSkip() )

end while