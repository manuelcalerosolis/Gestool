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
   
   DATA idFamilia

   METHOD New()

   METHOD Run()

   METHOD getCampoClave()        INLINE ( alltrim( ::getExcelString( ::cColumnaCampoClave ) ) )

   METHOD procesaFicheroExcel()

   METHOD filaValida()
   
   METHOD siguienteLinea()       INLINE ( ++::nFilaInicioImportacion )

   METHOD existeRegistro()       INLINE ( D():gotoFamilias( ::getCampoClave(), ::nView ) )

   METHOD appendRegistro()       INLINE ( ( D():Familias( ::nView ) )->( dbappend() ) )

   METHOD desbloqueaRegistro()   INLINE ( ( D():Familias( ::nView ) )->( dbcommit() ),;
                                          ( D():Familias( ::nView ) )->( dbunlock() ) )

   METHOD importarCampos()

   METHOD getNombre()

END CLASS

//----------------------------------------------------------------------------//

METHOD New( nView )

   ::nView                    := nView

   /*
   Cambiar el nombre del fichero-----------------------------------------------
   */

   ::cFicheroExcel            := "C:\ficheros\falfam.xls"

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

      if !::existeRegistro()
      
         ::importarCampos()

      end if 

      ::siguienteLinea()

   end if

   ::closeExcel()

Return nil

//---------------------------------------------------------------------------//

METHOD importarCampos()

   ( D():Familias( ::nView ) )->( dbappend() )

   ::idFamilia                                  := ::getCampoClave()

   ( D():Familias( ::nView ) )->cCodFam         := ::idFamilia

   if !empty( ::getExcelString( "B" ) )
      ( D():Familias( ::nView ) )->cNomFam      := ::getNombre( ::getExcelString( "B" ) )
   end if 

   /*
   Desbloqueamos la tabla de artículos-----------------------------------------
   */

   ( D():Familias( ::nView ) )->( dbcommit() )

   ( D():Familias( ::nView ) )->( dbunlock() )

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

#include "ImportarExcel.prg"