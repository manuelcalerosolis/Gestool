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

   ::nFilaInicioImportacion   := 2

   /*
   Columna de campo clave------------------------------------------------------
   */

   ::cColumnaCampoClave       := 'E'

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

   if !empty( ::getExcelString( "B" ) )
      ( D():Clientes( ::nView ) )->Titulo       := ::getExcelString( "B" ) + ::getExcelString( "C" )
   end if 

   if !empty( ::getExcelString( "A" ) )
      ( D():Clientes( ::nView ) )->Nif          := ::getExcelString( "A" )
   end if 

   if !empty( ::getExcelString( "D" ) )
      ( D():Clientes( ::nView ) )->NbrEst       := ::getExcelString( "D" )
   end if

   if !empty( ::getExcelString( "G" ) )
      ( D():Clientes( ::nView ) )->Domicilio    := ::getExcelString( "G" ) + AllTrim( ::getExcelString( "H" ) )
   end if

   if !empty( ::getExcelString( "I" ) )
      ( D():Clientes( ::nView ) )->Poblacion    := ::getExcelString( "I" )
   end if

   if !empty( ::getExcelString( "J" ) )
      ( D():Clientes( ::nView ) )->Provincia    := ::getExcelString( "J" )
   end if

   if !empty( ::getExcelString( "K" ) )
      ( D():Clientes( ::nView ) )->CodPostal    := ::getExcelString( "K" )
   end if

   if !empty( ::getExcelString( "L" ) )
      ( D():Clientes( ::nView ) )->cCodPai      := ::getExcelString( "L" )
   end if

   if !empty( ::getExcelString( "M" ) )
      ( D():Clientes( ::nView ) )->cWebInt      := ::getExcelString( "M" )
   end if

   if !empty( ::getExcelString( "N" ) )
      ( D():Clientes( ::nView ) )->cMeiInt      := ::getExcelString( "N" )
   end if


   if !empty( ::getExcelString( "O" ) )
      ( D():Clientes( ::nView ) )->Telefono     := ::getExcelString( "O" )
   end if

   if !empty( ::getExcelString( "P" ) )
      ( D():Clientes( ::nView ) )->Movil        := ::getExcelString( "P" )
   end if

   if !empty( ::getExcelString( "R" ) )
      ( D():Clientes( ::nView ) )->mComent      := ::getExcelString( "R" )
   end if

   ( D():Clientes( ::nView ) )->CodPago         := "TR"
   ( D():Clientes( ::nView ) )->CodAlm          := "000"

   ( D():Clientes( ::nView ) )->( dbcommit() )

   ( D():Clientes( ::nView ) )->( dbunlock() )

Return nil

//---------------------------------------------------------------------------// 

METHOD filaValida()

Return ( !empty( ::getExcelValue( ::cColumnaCampoClave ) ) )

//---------------------------------------------------------------------------//

#include "ImportarExcel.prg"