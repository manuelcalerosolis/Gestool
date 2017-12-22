 #include "FiveWin.Ch"

#include "Hbxml.ch"
#include "Hbclass.ch"
#include "Fileio.ch"
#include "Factu.ch" 
      
//---------------------------------------------------------------------------//

Function ImportarExcelArguelles( nView )                	 
	      
   local oImportarExcel    := TImportarExcelClientes():New( nView )

   oImportarExcel:Run()

Return nil

//---------------------------------------------------------------------------//  

CLASS TImportarExcelClientes FROM TImportarExcel

   METHOD New()

   METHOD Run()

   METHOD getCampoClave()        INLINE ( ::getExcelNumeric( ::cColumnaCampoClave ) )

   METHOD procesaFicheroExcel()

   METHOD filaValida()
   
   METHOD siguienteLinea()       INLINE ( ++::nFilaInicioImportacion )

   METHOD existeRegistro()       INLINE ( D():gotoCliente( ::getCampoClave(), ::nView ) )

   METHOD importarCampos()

END CLASS

//----------------------------------------------------------------------------//

METHOD New( nView )

   ::nView                    := nView

   /*
   Cambiar el nombre del fichero-----------------------------------------------
   */

   ::cFicheroExcel            := "C:\ficheros\clientes.xls"

   /*
   Cambiar la fila de cominezo de la importacion-------------------------------
   */

   ::nFilaInicioImportacion   := 1240

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

   logWrite( RJust( ::getCampoClave(), "0", RetNumCodCliEmp() ) )

   MsgWait( RJust( ::getCampoClave(), "0", RetNumCodCliEmp() ) + ::getExcelString( "B" ), "aaa", 0.01 )

   ( D():Clientes( ::nView ) )->( dbappend() )

   ( D():Clientes( ::nView ) )->Cod             := RJust( ::getCampoClave(), "0", RetNumCodCliEmp() )

   if !empty( ::getExcelString( "B" ) )
      ( D():Clientes( ::nView ) )->Titulo       := ::getExcelString( "B" )
   end if 

   if !empty( ::getExcelString( "C" ) )
      ( D():Clientes( ::nView ) )->Nif          := ::getExcelString( "C" )
   end if 

   if !empty( ::getExcelString( "G" ) )
      ( D():Clientes( ::nView ) )->NbrEst       := ::getExcelString( "G" )
   end if

   if !empty( ::getExcelString( "D" ) )
      ( D():Clientes( ::nView ) )->Domicilio    := ::getExcelString( "D" )
   end if

   if !empty( ::getExcelString( "F" ) )
      ( D():Clientes( ::nView ) )->Poblacion    := ::getExcelString( "F" )
   end if

   if !empty( ::getExcelString( "E" ) )
      ( D():Clientes( ::nView ) )->CodPostal    := RJust( ::getExcelString( "E" ), "0", 5 )
   end if

   if !empty( ::getExcelString( "H" ) )
      ( D():Clientes( ::nView ) )->Telefono     := ::getExcelString( "H" )
   end if

   //( D():Clientes( ::nView ) )->nDtoEsp         := ::getExcelNumeric( "N" )

   if !empty( ::getExcelString( "K" ) )
      ( D():Clientes( ::nView ) )->lReq         := if( ::getExcelString( "K" ) == "S", .t., .f. )
   end if

   if !empty( ::getExcelString( "I" ) )
      ( D():Clientes( ::nView ) )->cCodRut      := ::getExcelString( "I" )
   end if

   if !empty( ::getExcelString( "L" ) )
      ( D():Clientes( ::nView ) )->cAgente      := ::getExcelString( "L" )
   end if

   if !empty( ::getExcelString( "P" ) )
      ( D():Clientes( ::nView ) )->cCodGrp      := ::getExcelString( "P" )
   end if

   ( D():Clientes( ::nView ) )->CodPago         := "00"

   ( D():Clientes( ::nView ) )->( dbcommit() )

   ( D():Clientes( ::nView ) )->( dbunlock() )

Return nil

//---------------------------------------------------------------------------// 

METHOD filaValida()

Return ( !empty( ::getExcelValue( ::cColumnaCampoClave ) ) )

//---------------------------------------------------------------------------//

#include "ImportarExcel.prg"