#include "FiveWin.Ch"

#include "Hbxml.ch"
#include "Hbclass.ch"
#include "Fileio.ch"

#include "Factu.ch" 
      
//---------------------------------------------------------------------------//

Function ImportarExcelArguelles( nView )                	 
	      
   local oImportarExcel    := TImportarExcelArguelles():New( nView )

   oImportarExcel:Run()

Return nil

//---------------------------------------------------------------------------//  

CLASS TImportarExcelArguelles FROM TImportarExcel

   METHOD New()

   METHOD Run()

   METHOD procesaFicheroExcel()

   METHOD getCampoClave()        INLINE ( alltrim( ::getExcelString( ::cColumnaCampoClave ) ) )

   METHOD filaValida()
   
   METHOD siguienteLinea()       INLINE ( ++::nFilaInicioImportacion )

   METHOD eliminaReferenciaProveedor()

END CLASS

//----------------------------------------------------------------------------//

METHOD New( nView )

   ::nView                    := nView

   /*
   Cambiar el nombre del fichero-----------------------------------------------
   */

   ::cFicheroExcel            := "C:\importar\baja.xlsx"

   /*
   Cambiar la fila de cominezo de la importacion-------------------------------
   */

   ::nFilaInicioImportacion   := 2

   /*
   Columna de campo clave------------------------------------------------------
   */

   ::cColumnaCampoClave       := 'A'

Return ( Self )

//----------------------------------------------------------------------------//

METHOD Run()

   if !file( ::cFicheroExcel )
      msgStop( "El fichero " + ::cFicheroExcel + " no existe." )
      Return ( .f. )
   end if 

   msgrun( "Procesando fichero " + ::cFicheroExcel, "Espere por favor...",  {|| ::procesaFicheroExcel() } )

   msginfo( "Proceso finalizado" )

Return ( .t. )

//----------------------------------------------------------------------------//

METHOD procesaFicheroExcel()

   ::openExcel()

   while ( ::filaValida() )

      ::eliminaReferenciaProveedor()

      ::siguienteLinea()

   end while

   ::closeExcel()

Return nil

//---------------------------------------------------------------------------//

METHOD eliminaReferenciaProveedor()

   local ordenAnterior        := ( D():ProveedorArticulo( ::nView ) )->( ordsetfocus( "cCodArt" ) )

   MsgWait( ::getCampoClave(), "Eliminando artículo", 0.05 )

   while ( D():ProveedorArticulo( ::nView ) )->( dbSeek( padr( ::getCampoClave(), 18 ) ) ) .and. !( D():ProveedorArticulo( ::nView ) )->( eof() )
      if dbLock( D():ProveedorArticulo( ::nView ) )
         ( D():ProveedorArticulo( ::nView ) )->( dbDelete() )
         ( D():ProveedorArticulo( ::nView ) )->( dbUnLock() )
      end if
   end while

   ( D():ProveedorArticulo( ::nView ) )->( ordsetfocus( ordenAnterior ) )

Return nil

//---------------------------------------------------------------------------//

METHOD filaValida()

Return ( !empty( ::getExcelValue( ::cColumnaCampoClave ) ) )

//---------------------------------------------------------------------------//

#include "ImportarExcel.prg"