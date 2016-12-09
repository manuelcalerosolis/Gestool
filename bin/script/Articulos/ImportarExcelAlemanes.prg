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

   DATA idArticulo

   METHOD New()

   METHOD Run()

   METHOD getCampoClave()        INLINE ( alltrim( ::getExcelString( ::cColumnaCampoClave ) ) )

   METHOD procesaFicheroExcel()

   METHOD filaValida()
   
   METHOD siguienteLinea()       INLINE ( ++::nFilaInicioImportacion )

   METHOD existeRegistro()       INLINE ( D():gotoArticulos( ::getCampoClave(), ::nView ) )

   METHOD appendRegistro()       INLINE ( ( D():Articulos( ::nView ) )->( dbappend() ) )

   METHOD desbloqueaRegistro()   INLINE ( ( D():Articulos( ::nView ) )->( dbcommit() ),;
                                          ( D():Articulos( ::nView ) )->( dbunlock() ) )

   METHOD importarCampos()

   METHOD getNombre()
   METHOD getDescripcionlarga()

END CLASS

//----------------------------------------------------------------------------//

METHOD New( nView )

   ::nView                    := nView

   /*
   Cambiar el nombre del fichero-----------------------------------------------
   */

   ::cFicheroExcel            := "C:\ficheros\articulos.xls"

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

      if !::existeRegistro()
      
         ::importarCampos()

      end if 

      ::siguienteLinea()

   end if

   ::closeExcel()

Return nil

//---------------------------------------------------------------------------//

METHOD importarCampos()

   ( D():Articulos( ::nView ) )->( dbappend() )

   ::idArticulo                                 := ::getCampoClave()

   ( D():Articulos( ::nView ) )->Codigo         := ::idArticulo

   if !empty( ::getExcelString( "C" ) )
      ( D():Articulos( ::nView ) )->Nombre      := ::getNombre( ::getExcelString( "C" ) )
      ( D():Articulos( ::nView ) )->Descrip     := ::getDescripcionlarga( ::getExcelString( "C" ) )
   end if 

   if !empty( ::getExcelNumeric( "D" ) )
      ( D():Articulos( ::nView ) )->pVenta1     := ( ::getExcelNumeric( "D" ) / 1.21 )
      ( D():Articulos( ::nView ) )->pVtaIva1    := ::getExcelNumeric( "D" )
   end if 

   ( D():Articulos( ::nView ) )->TipoIva        := "G"
   ( D():Articulos( ::nView ) )->nCtlStock      := 1
   ( D():Articulos( ::nView ) )->nLabel         := 1

   ( D():Articulos( ::nView ) )->( dbcommit() )

   ( D():Articulos( ::nView ) )->( dbunlock() )

Return nil

//---------------------------------------------------------------------------// 

METHOD filaValida()

Return ( !empty( ::getExcelValue( ::cColumnaCampoClave ) ) )

//---------------------------------------------------------------------------//

METHOD getNombre( cGet )

   local cNombre        := ""

   if at( CRLF, cGet ) != 0
      cNombre           := substr( cGet, 1, at( CRLF, cGet ) )
   else
      cNombre           := cGet
   end if

Return ( cNombre )

//---------------------------------------------------------------------------//

METHOD getDescripcionlarga( cGet )

   local cDescripcion   := ""

   if at( CRLF, cGet ) != 0
      cDescripcion      := substr( cGet, at( CRLF, cGet ) + 1 )   
   else
      cDescripcion      := cGet
   end if

Return ( cDescripcion )

//---------------------------------------------------------------------------//

#include "ImportarExcel.prg"