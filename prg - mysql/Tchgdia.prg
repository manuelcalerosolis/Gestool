#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

function ChgDiario( oWnd )

   local oChgDia

   /*
   Cerramos todas las ventanas
   */

   if oWnd != nil
      SysRefresh(); oWnd:CloseAll(); SysRefresh()
   end if

   oChgDia  := TChgDiario():OpenFiles()
   if oChgDia:lOpenFiles

      oChgDia:lGenerate()
      oChgDia:CloseFiles()

   end if

return ( nil )

//---------------------------------------------------------------------------//

CLASS TChgDiario

   DATA  lOpenFiles  INIT .t.

   DATA  oDiario     AS OBJECT

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lGenerate()

   METHOD IsDescuadrado( nAsiento )

   METHOD AjustaAsiento( nAsiento )

   METHOD IsFactura( nAsiento )

   METHOD CambiaIva( nAsiento, nDiferencia )

END CLASS

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS TChgDiario

   if File( "C:\GrupoSp\DIARIO.DBF" )

      DATABASE NEW ::oDiario PATH ( "C:\GrupoSp" ) FILE "DIARIO.DBF" VIA ( cDriver() ) SHARED INDEX "DIARIO.CDX"
      ::oDiario:OrdSetFocus( "NuAsi" )

   else

      MsgStop( "No existe C:\GrupoSp\DIARIO.DBF" )
      ::lOpenFiles         := .f.

   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TChgDiario

   ::oDiario:End()

RETURN ( Self )

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate() CLASS TChgDiario

   local n  := 1

   while n <= 26647

      Titulo( Str( n ) )

      if ::IsDescuadrado( n ) .and. ::IsFactura( n )
         ::AjustaAsiento( n )
      end if

      n++

   end while

   MsgInfo( "Porceso finalizado con exito." )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD IsDescuadrado( nAsiento ) CLASS TChgDiario

   local nDebe    := 0
   local nHaber   := 0

   if ::oDiario:Seek( nAsiento )
      while nAsiento == ( ::oDiario:cAlias )->Asien

         nDebe    += ( ::oDiario:cAlias )->EuroDebe
         nHaber   += ( ::oDiario:cAlias )->EuroHaber

         ::oDiario:Skip()

      end while
   end if

RETURN ( Round( nDebe, 2 ) != Round( nHaber, 2 ) )

//---------------------------------------------------------------------------//

METHOD IsFactura( nAsiento ) CLASS TChgDiario

   local l430  := .f.
   local l700  := .f.
   local l477  := .f.

   if ::oDiario:Seek( nAsiento )
      while nAsiento == ::oDiario:Asien

         do case
            case SubStr( ::oDiario:SubCta, 1, 3 ) == "430"
               l430  := .t.
            case SubStr( ::oDiario:SubCta, 1, 3 ) == "700"
               l700  := .t.
            case SubStr( ::oDiario:SubCta, 1, 3 ) == "477"
               l477  := .t.
         end case

         ::oDiario:Skip()

      end while
   end if

RETURN ( l430 .or. l700 .or. l477 )

//---------------------------------------------------------------------------//

METHOD AjustaAsiento( nAsiento ) CLASS TChgDiario

   local nCliente := 0
   local nIva     := 0
   local nBase    := 0

   if ::oDiario:Seek( nAsiento )
      while nAsiento == ::oDiario:Asien

         do case
            case SubStr( ::oDiario:SubCta, 1, 3 ) == "430"
               nCliente += ::oDiario:EuroDebe
            case SubStr( ::oDiario:SubCta, 1, 3 ) == "700"
               nIva     += ::oDiario:EuroHaber
            case SubStr( ::oDiario:SubCta, 1, 3 ) == "477"
               nBase    += ::oDiario:EuroHaber
         end case

      ::oDiario:Skip()

      end while
   end if

   ::CambiaIva( nAsiento, nCliente - nBase - nIva )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD CambiaIva( nAsiento, nDiferencia ) CLASS TChgDiario

   ::oDiario:Seek( nAsiento )
   while nAsiento == ::oDiario:Asien

      if SubStr( ::oDiario:SubCta, 1, 3 ) == "700"
         ::oDiario:Load()
         ::oDiario:EuroHaber  += nDiferencia
         ::oDiario:Save()
         exit
      end if

      ::oDiario:Skip()

   end while

   msgWait( "Proceso " + Str( nAsiento ) + " descuadrado " + Str( nDiferencia ), , 0.0001 )

RETURN ( Self )

//---------------------------------------------------------------------------//