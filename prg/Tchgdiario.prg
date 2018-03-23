#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

function ChgDiario( oMenuItem, oWnd )

   local oChgDia
   local nLevel

   nLevel   := Auth():Level( oMenuItem )

   if nAnd( nLevel, 1 ) != 0
      msgStop( "Acceso no permitido." )
      return nil
   end if

   /*
   Cerramos todas las ventanas
   */

   if oWnd != nil
      SysRefresh(); oWnd:CloseAll(); SysRefresh()
   end if
   oChgDia  := TChgDiario():OpenFiles()
   oChgDia:lGenerate()
   oChgDia:CloseFiles()

return ( nil )

//---------------------------------------------------------------------------//

CLASS TChgDiario

   DATA  oDiario     AS OBJECT

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD Resource( cFld )

   METHOD lGenerate()

   METHOD AjustaAsiento( nAsiento )

   METHOD CambiaIva( nAsiento, nDiferencia )

END CLASS

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS TChgTarifa

   DATABASE NEW ::oDiario PATH ( cPatDat() ) FILE "DIARIO.DBF" VIA ( cDriver() ) SHARED INDEX "DIARIO.CDX"
   ::oDiario:OrdSetFocus( "NuAsi" )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TChgTarifa

   ::oDiario:End()

RETURN ( Self )

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate() CLASS TChgTarifa

   local n := 1

   while !::oDiario:Eof()

      if ::IsDescuadrado( n )
         ::AjustaAsiento( n )
      end if

   end while

   MsgInfo( "Porceso finalizado con exito." )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD IsDescuadrado( nAsiento ) CLASS TChgTarifa

   local nDebe    := 0
   local nHaber   := 0

   ::oDiario:Seek( nAsiento )
   while nAsiento == ::oDiario:Asien

      nDebe       += ::oDiario:EuroDebe
      nHaber      += ::oDiario:EuroHaber

      ::oDiario:Skip()

   end while

RETURN ( nDebe == nHaber )

//---------------------------------------------------------------------------//

METHOD AjustaAsiento( nAsiento ) CLASS TChgTarifa

   local nCliente := 0
   local nIva     := 0
   local nBase    := 0

   ::oDiario:Seek( nAsiento )
   while nAsiento == ::oDiario:Asien

      do case
         case SubStr( ::oDiario:SubCta, 3 ) == "430"
            nCliente += ::oDiario:EuroDebe
         case SubStr( ::oDiario:SubCta, 3 ) == "700"
            nIva     += ::oDiario:EuroHaber
         case SubStr( ::oDiario:SubCta, 3 ) == "477"
            nBase    += ::oDiario:EuroHaber
      end case

      ::oDiario:Skip()

   end while

   ::CambiaIva( nAsiento, nCliente - nBase - nIva )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD CambiaIva( nAsiento, nDiferencia )

   msginfo( nDiferencia )

   ::oDiario:Seek( nAsiento )
   while nAsiento == ::oDiario:Asien

      if SubStr( ::oDiario:SubCta, 3 ) == "700"
         ::oDiario:Load()
         ::oDiario:EuroHaber  -= nDiferencia
         ::oDiario:Save()
         exit
      end if

      ::oDiario:Skip()

   end while

RETURN ( Self )

//---------------------------------------------------------------------------//