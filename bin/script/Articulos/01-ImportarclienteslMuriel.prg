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

   ::cFicheroExcel            := "C:\ficheros\clientes.xlsx"

   /*
   Cambiar la fila de cominezo de la importacion-------------------------------
   */

   ::nFilaInicioImportacion   := 8

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

   ( D():Clientes( ::nView ) )->Cod             := RJust( ::getCampoClave(), "0", RetNumCodCliEmp() )

   if !empty( ::getExcelString( "C" ) )
      ( D():Clientes( ::nView ) )->Titulo       := ::getExcelString( "C" )
   end if 

   if !empty( ::getExcelString( "B" ) )
      ( D():Clientes( ::nView ) )->Nif          := ::getExcelString( "B" )
   end if 

   if !empty( ::getExcelString( "D" ) )
      ( D():Clientes( ::nView ) )->Domicilio    := ::getExcelString( "D" )
   end if

   if !empty( ::getExcelString( "F" ) )
      ( D():Clientes( ::nView ) )->Poblacion    := ::getExcelString( "F" )
   end if

   if !empty( ::getExcelString( "G" ) )
      ( D():Clientes( ::nView ) )->Provincia    := ::getExcelString( "G" )
   end if

   if !empty( ::getExcelString( "E" ) )
      ( D():Clientes( ::nView ) )->CodPostal    := ::getExcelString( "E" )
   end if

   if !empty( ::getExcelString( "H" ) )
      ( D():Clientes( ::nView ) )->cMeiInt      := ::getExcelString( "H" )
   end if

   if !empty( ::getExcelString( "I" ) )
      ( D():Clientes( ::nView ) )->Telefono     := ::getExcelString( "I" )
   end if

   if !empty( ::getExcelString( "J" ) )
      ( D():Clientes( ::nView ) )->Fax        := ::getExcelString( "J" )
   end if

   ( D():Clientes( ::nView ) )->CodPago         := "00"
   ( D():Clientes( ::nView ) )->cCodAlm         := "000"

   ( D():Clientes( ::nView ) )->( dbcommit() )

   ( D():Clientes( ::nView ) )->( dbunlock() )
Return nil

//---------------------------------------------------------------------------// 

METHOD filaValida()

Return ( !empty( ::getExcelValue( ::cColumnaCampoClave ) ) )

//---------------------------------------------------------------------------//

#include "ImportarExcel.prg"