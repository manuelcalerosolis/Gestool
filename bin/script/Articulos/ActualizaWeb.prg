#include "FiveWin.Ch"

#include "Hbxml.ch"
#include "Hbclass.ch"
#include "Fileio.ch"

#include "Factu.ch" 
      
//---------------------------------------------------------------------------//

Function ImportarExcelArguelles( nView )                	 
	      
   local oImportarExcel    := TActualizaWebArguellesExcel():New( nView )

   oImportarExcel:Run()

Return nil

//---------------------------------------------------------------------------//  

CLASS TActualizaWebArguellesExcel FROM TImportarExcel

   DATA nombreWeb

   METHOD New()

   METHOD Run()

   METHOD procesaFicheroExcel()

   METHOD getCampoClave()        INLINE ( alltrim( ::getExcelString( ::cColumnaCampoClave ) ) )

   METHOD filaValida()
   
   METHOD siguienteLinea()       INLINE ( ++::nFilaInicioImportacion )

   METHOD eliminaReferenciaWeb()
   METHOD cambiaReferenciaWeb( id )

END CLASS

//----------------------------------------------------------------------------//

METHOD New( nView ) CLASS TActualizaWebArguellesExcel

   ::nView                    := nView

   /*
   Cambiar el nombre del fichero-----------------------------------------------
   */

   ::cFicheroExcel            := "C:\ads\web-ayives.xlsx"

   /*
   Cambiar el nombre del fichero-----------------------------------------------
   */

   ::nombreWeb                := "Ayives"

   /*
   Cambiar la fila de cominezo de la importacion-------------------------------
   */

   ::nFilaInicioImportacion   := 2

   /*
   Columna de campo clave------------------------------------------------------
   */

   ::cColumnaCampoClave       := 'B'

Return ( Self )

//----------------------------------------------------------------------------//

METHOD Run() CLASS TActualizaWebArguellesExcel

   if !file( ::cFicheroExcel )
      msgStop( "El fichero " + ::cFicheroExcel + " no existe." )
      Return ( .f. )
   end if 

   msgrun( "Eliminando referencias anteriores a la web", "Espere por favor...",  {|| ::eliminaReferenciaWeb() } )

   msgrun( "Procesando fichero " + ::cFicheroExcel, "Espere por favor...",  {|| ::procesaFicheroExcel() } )

   msginfo( "Proceso finalizado" )

Return ( .t. )

//----------------------------------------------------------------------------//

METHOD procesaFicheroExcel() CLASS TActualizaWebArguellesExcel

   ::openExcel()

   while ( ::filaValida() )

      ::cambiaReferenciaWeb( ::getExcelString( "B" ) )

      ::siguienteLinea()

   end while

   ::closeExcel()

Return nil

//---------------------------------------------------------------------------//

METHOD eliminaReferenciaWeb() CLASS TActualizaWebArguellesExcel

   local ordenAnterior        := ( D():Articulos( ::nView ) )->( ordsetfocus( "Codigo" ) )

   ( D():Articulos( ::nView ) )->( dbgotop() )
   while ( D():Articulos( ::nView ) )->( eof() )
      if dbLock( D():Articulos( ::nView ) )
         ( D():Articulos( ::nView ) )->lPubInt     := .f.
         ( D():Articulos( ::nView ) )->cWebShop    := ""
         ( D():Articulos( ::nView ) )->( dbUnLock() )
      end if
   end while

   ( D():Articulos( ::nView ) )->( ordsetfocus( ordenAnterior ) )

Return nil

//---------------------------------------------------------------------------//

METHOD cambiaReferenciaWeb( id ) CLASS TActualizaWebArguellesExcel

   local ordenAnterior        := ( D():Articulos( ::nView ) )->( ordsetfocus( "Codigo" ) )

   if ( D():Articulos( ::nView ) )->( dbseek( id ) )
      if dbLock( D():Articulos( ::nView ) )
         ( D():Articulos( ::nView ) )->lPubInt     := .t.
         ( D():Articulos( ::nView ) )->cWebShop    := ::nombreWeb
         ( D():Articulos( ::nView ) )->( dbUnLock() )
      end if
   end if 

   ( D():Articulos( ::nView ) )->( ordsetfocus( ordenAnterior ) )

Return nil

//---------------------------------------------------------------------------//

METHOD filaValida() CLASS TActualizaWebArguellesExcel

Return ( !empty( ::getExcelValue( ::cColumnaCampoClave ) ) )

//---------------------------------------------------------------------------//

#include "ImportarExcel.prg"