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

   ::cFicheroExcel            := "C:\ficheros\proveedores.xls"

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

   ( D():Proveedores( ::nView ) )->( dbappend() )

   ( D():Proveedores( ::nView ) )->Cod             := RJust( ::getCampoClave(), "0", RetNumCodPrvEmp() )

   if !empty( ::getExcelString( "B" ) )
      ( D():Proveedores( ::nView ) )->Titulo       := ::getExcelString( "B" )
   end if 

   if !empty( ::getExcelString( "C" ) )
      ( D():Proveedores( ::nView ) )->Nif          := ::getExcelString( "C" )
   end if 

   if !empty( ::getExcelString( "H" ) )
      ( D():Proveedores( ::nView ) )->cNbrEst      := ::getExcelString( "H" )
   end if

   if !empty( ::getExcelString( "D" ) )
      ( D():Proveedores( ::nView ) )->Domicilio    := ::getExcelString( "D" )
   end if

   if !empty( ::getExcelString( "F" ) )
      ( D():Proveedores( ::nView ) )->Poblacion    := ::getExcelString( "F" )
   end if

   if !empty( ::getExcelString( "E" ) )
      ( D():Proveedores( ::nView ) )->CodPostal    := RJust( ::getExcelString( "E" ), "0", 5 )
   end if

   if !empty( ::getExcelString( "I" ) )
      ( D():Proveedores( ::nView ) )->Telefono     := ::getExcelString( "I" )
   end if

   if !empty( ::getExcelString( "J" ) )
      ( D():Proveedores( ::nView ) )->Fax          := ::getExcelString( "J" )
   end if

   if !empty( ::getExcelString( "K" ) )
      ( D():Proveedores( ::nView ) )->SubCta       := ::getExcelString( "K" )
   end if

   ( D():Proveedores( ::nView ) )->FPAGO           := "00"

   ( D():Proveedores( ::nView ) )->( dbcommit() )

   ( D():Proveedores( ::nView ) )->( dbunlock() )

Return nil

//---------------------------------------------------------------------------// 

METHOD filaValida()

Return ( !empty( ::getExcelValue( ::cColumnaCampoClave ) ) )

//---------------------------------------------------------------------------//

#include "ImportarExcel.prg"