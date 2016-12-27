 #include "FiveWin.Ch"

#include "Hbxml.ch"
#include "Hbclass.ch"
#include "Fileio.ch"
#include "Factu.ch" 
      
//---------------------------------------------------------------------------//

Function ImportarExcelVillaverde( nView )                	 
	      
   local oImportarExcel    := TImportarExcelClientes():New( nView ) 

   oImportarExcel:Run()

Return nil

//---------------------------------------------------------------------------//  

CLASS TImportarExcelClientes FROM TImportarExcel
 
   METHOD New()

   METHOD Run()

   METHOD getCampoClave()        INLINE ( rjust( ::getExcelNumeric( ::cColumnaCampoClave ), "0", 8 ) )

   METHOD procesaFicheroExcel()

   METHOD filaValida()
   
   METHOD siguienteLinea()       INLINE ( ++::nFilaInicioImportacion, msgwait( str( ::nFilaInicioImportacion ), "fila", .1 ) )

   METHOD existeRegistro()       INLINE ( if ( D():gotoCliente( ::getCampoClave(), ::nView ),;
                                             ( msgalert( ::getCampoClave(), "existeRegistro" ), .t. ),;
                                             ( msgwait( ::getCampoClave(), "no existeRegistro", .1 ), .f. ) ) )

   METHOD importarCampos()

END CLASS

//----------------------------------------------------------------------------//

METHOD New( nView )

   ::nView                    := nView

   /*
   Cambiar el nombre del fichero-----------------------------------------------
   */

   ::cFicheroExcel            := "C:\Users\Manuel\Desktop\Clientes.xlsx" 

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

   ( D():Clientes( ::nView ) )->( dbappend() )

   ( D():Clientes( ::nView ) )->Cod             := ::getCampoClave()

   logwrite( ::getExcelString( "B" ), "nombre cliente" )

   if !empty( ::getExcelString( "B" ) )
      ( D():Clientes( ::nView ) )->Titulo       := ::getExcelString( "B" )
   end if 

   if !empty( ::getExcelString( "C" ) )
      ( D():Clientes( ::nView ) )->NbrEst       := ::getExcelString( "C" )
   end if

   if !empty( ::getExcelString( "D" ) )
      ( D():Clientes( ::nView ) )->Nif          := ::getExcelString( "D" )
   end if 

   if !empty( ::getExcelString( "E" ) )
      ( D():Clientes( ::nView ) )->Domicilio    := ::getExcelString( "E" )
   end if

   if !empty( ::getExcelString( "G" ) )
      ( D():Clientes( ::nView ) )->Poblacion    := ::getExcelString( "G" )
   end if

   if !empty( ::getExcelString( "H" ) )
      ( D():Clientes( ::nView ) )->Provincia    := ::getExcelString( "H" )
   end if

   if !empty( ::getExcelString( "F" ) )
      ( D():Clientes( ::nView ) )->CodPostal    := ::getExcelString( "F" )
   end if

   if !empty( ::getExcelString( "I" ) )
      ( D():Clientes( ::nView ) )->cMeiInt      := ::getExcelString( "I" )
   end if

   ( D():Clientes( ::nView ) )->cCodAlm         := "000"

   ( D():Clientes( ::nView ) )->( dbcommit() )
   ( D():Clientes( ::nView ) )->( dbunlock() )

Return nil

//---------------------------------------------------------------------------// 

METHOD filaValida()

Return ( !empty( ::getExcelValue( ::cColumnaCampoClave ) ) )

//---------------------------------------------------------------------------//

#include "ImportarExcel.prg"