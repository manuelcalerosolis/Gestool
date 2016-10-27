#include "FiveWin.Ch"

#include "Hbxml.ch"
#include "Hbclass.ch"
#include "Fileio.ch"

#include "Factu.ch" 
      
//---------------------------------------------------------------------------//

Function ImportarExcelPreciosMarpicon( nView )                	 
	      
   local oImportarExcel    := TImportarExcelPreciosMarpicon():New( nView )

   oImportarExcel:Run()

Return nil

//---------------------------------------------------------------------------//

CLASS TImportarExcelPreciosMarpicon FROM TImportarExcel

   METHOD New()

   METHOD procesaFicheroExcel()

   METHOD importarCampos()   

END CLASS

//----------------------------------------------------------------------------//

METHOD New( nView )

   ::Super:New( nView )

   /*
   Cambiar el nombre del fichero
   */

   ::cFicheroExcel            := "C:\Users\calero\Desktop\productos_precios_marpicon.csv"

Return ( Self )

//----------------------------------------------------------------------------//

METHOD procesaFicheroExcel()

   ::openExcel()

   while ( ::filaValida() )

      if ::existeRegistro()

         ::bloqueaRegistro()

         if !( neterr() )      

            ::importarCampos()

            ::desbloqueaRegistro()

         endif

      end if 

      ::siguienteLinea()

   end if

   ::closeExcel()

Return nil

//---------------------------------------------------------------------------//

METHOD importarCampos()

   local nIva           := nIva( dbfIva, ( D():Articulos( nView ) )->TipoIva ) / 100
   local nPrecioVenta   := ::getExcelValue( "F" )

   if isnum(nPrecioVenta)
      ( D():Articulos( ::nView ) )->pVenta1  := nPrecioVenta
      ( D():Articulos( ::nView ) )->pVtaIva1 := ( D():Articulos( nView ) )->pVenta1 + ( ( D():Articulos( nView ) )->pVenta1 * nIva )      
   end if 

Return nil

//---------------------------------------------------------------------------//

#include "ImportarExcelMarpicon.prg"
