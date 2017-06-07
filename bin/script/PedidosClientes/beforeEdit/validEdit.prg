#include ".\Include\Factu.ch"

//---------------------------------------------------------------------------//

function InicioHRB( aTmp, nView, dbfTmpLin )

   local aSeries     := {}
   local lReturn     := .t.
   local n           := 0
   local cSerie      := ""

   ( dbfTmpLin )->( dbGoTop() )

   while !( dbfTmpLin )->( eof() )

      cSerie         := AllTrim( getCustomExtraField( "005", "Lineas de propiedades", ( dbfTmpLin )->cCodPr1 + ( dbfTmpLin )->cValPr1 ) )
      if Ascan( aSeries, cSerie ) == 0
         aAdd( aSeries, cSerie )
      end if

      ( dbfTmpLin )->( dbSkip() )

   end while

   ( dbfTmpLin )->( dbGoTop() )

   if len( aSeries ) > 1
      lReturn        := MsgYesNo( "Ha introducido barcos con series distintas", "¿Desea continuar?" )
   end if

return lReturn

//---------------------------------------------------------------------------//