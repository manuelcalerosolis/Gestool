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

   METHOD cProveedor( cProvee )

   METHOD cFamilia()

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

   ( D():Articulos( ::nView ) )->( dbappend() )

   ::idArticulo                                 := ::getCampoClave()

   ( D():Articulos( ::nView ) )->Codigo         := ::idArticulo

   if !empty( ::getExcelString( "K" ) )
      ( D():Articulos( ::nView ) )->Nombre      := ::getNombre( ::getExcelString( "K" ) )
      ( D():Articulos( ::nView ) )->Descrip     := ::getDescripcionlarga( ::getExcelString( "L" ) )
   end if 

   if !empty( ::getExcelNumeric( "U" ) )
      ( D():Articulos( ::nView ) )->pVenta1     := ::getExcelNumeric( "U" )
      ( D():Articulos( ::nView ) )->pVtaIva1    := ::getExcelNumeric( "U" ) * ( 1 + ::getExcelNumeric( "Z" ) )
      ( D():Articulos( ::nView ) )->pVtaWeb     := ::getExcelNumeric( "U" )
      ( D():Articulos( ::nView ) )->nImpInt1    := ::getExcelNumeric( "U" )
   end if

   if !empty( ::getExcelString( "N" ) )
      ( D():Articulos( ::nView ) )->mDesTec     := ::getExcelString( "N" )
   end if 

   ( D():Articulos( ::nView ) )->TipoIva        := cCodigoIva( D():TiposIva( ::nView ), ( ::getExcelNumeric( "Z" ) * 100 ) )
   
   ( D():Articulos( ::nView ) )->nCtlStock      := 1
   ( D():Articulos( ::nView ) )->nLabel         := 1
   ( D():Articulos( ::nView ) )->nTarWeb        := 1
   ( D():Articulos( ::nView ) )->lPubInt        := .t.
   ( D():Articulos( ::nView ) )->lSbrInt        := .t.

   ::cProveedor( ::getExcelString( "E" ) )

   ::cFamilia()

   /*
   Descripción alemán----------------------------------------------------------
   */

   if !Empty( ::getExcelString( "H" ) )

      ( D():ArticuloLenguaje( ::nView ) )->( dbAppend() )

      ( D():ArticuloLenguaje( ::nView ) )->cCodArt    := ::idArticulo
      ( D():ArticuloLenguaje( ::nView ) )->cCodLen    := "DEU "
      ( D():ArticuloLenguaje( ::nView ) )->cDesTik    := ::getExcelString( "H" )
      ( D():ArticuloLenguaje( ::nView ) )->cDesArt    := ::getExcelString( "I" )

      ( D():ArticuloLenguaje( ::nView ) )->( dbcommit() )

      ( D():ArticuloLenguaje( ::nView ) )->( dbunlock() )   

   end if

   /*
   Descripción español---------------------------------------------------------
   */

   if !Empty( ::getExcelString( "R" ) )

      ( D():ArticuloLenguaje( ::nView ) )->( dbAppend() )

      ( D():ArticuloLenguaje( ::nView ) )->cCodArt    := ::idArticulo
      ( D():ArticuloLenguaje( ::nView ) )->cCodLen    := "ESP "
      ( D():ArticuloLenguaje( ::nView ) )->cDesTik    := ::getExcelString( "R" )
      ( D():ArticuloLenguaje( ::nView ) )->cDesArt    := ::getExcelString( "S" )

      ( D():ArticuloLenguaje( ::nView ) )->( dbcommit() )

      ( D():ArticuloLenguaje( ::nView ) )->( dbunlock() )

   end if

   /*
   Desbloqueamos la tabla de artículos-----------------------------------------
   */

   ( D():Articulos( ::nView ) )->( dbcommit() )

   ( D():Articulos( ::nView ) )->( dbunlock() )

Return nil

//---------------------------------------------------------------------------// 

METHOD filaValida()

Return ( !empty( ::getExcelValue( ::cColumnaCampoClave ) ) )

//---------------------------------------------------------------------------//

METHOD cProveedor( cProvee, cCodArt )

   local nRec        := ( D():Proveedores( ::nView ) )->( Recno() )
   local nOrdAnt     := ( D():Proveedores( ::nView ) )->( OrdSetFocus( "Titulo" ) )
   local cNewCodigo

   /*
   Creamos el proveedor si no existe-------------------------------------------
   */

   if !( D():Proveedores( ::nView ) )->( dbSeek( AllTrim( upper( cProvee ) ) ) )

      cNewCodigo     := NextKey( dbLast(  D():Proveedores( ::nView ), 1 ), D():Proveedores( ::nView ), "0", RetNumCodPrvEmp() )

      ( D():Proveedores( ::nView ) )->( dbAppend() )

      ( D():Proveedores( ::nView ) )->Cod          := cNewCodigo
      ( D():Proveedores( ::nView ) )->Titulo       := AllTrim( cProvee )

      ( D():Proveedores( ::nView ) )->( dbcommit() )

      ( D():Proveedores( ::nView ) )->( dbunlock() )

   else

      cNewCodigo     := ( D():Proveedores( ::nView ) )->Cod

   end if

   ( D():Proveedores( ::nView ) )->( OrdSetFocus( nOrdAnt ) )
   ( D():Proveedores( ::nView ) )->( dbgoto( nRec ) )

   /*
   Lo metemos en la tabla de artículos-----------------------------------------
   */

   ( D():Articulos( ::nView ) )->cPrvHab           := cNewCodigo

   /*
   Ponemos el proveedor por defecto en el articulo-----------------------------
   */

   ( D():ProveedorArticulo( ::nView ) )->( dbAppend() )

   ( D():ProveedorArticulo( ::nView ) )->cCodArt   := ::idArticulo
   ( D():ProveedorArticulo( ::nView ) )->cCodPrv   := cNewCodigo
   ( D():ProveedorArticulo( ::nView ) )->lDefPrv   := .t.

   ( D():ProveedorArticulo( ::nView ) )->( dbcommit() )

   ( D():ProveedorArticulo( ::nView ) )->( dbunlock() )

Return ( nil )

//---------------------------------------------------------------------------//

METHOD cFamilia()

   local nRec        := ( D():Familias( ::nView ) )->( Recno() )
   local nOrdAnt     := ( D():Familias( ::nView ) )->( OrdSetFocus( "cNomFam" ) )
   local cNewCodigo

   
   if Empty( ::getExcelString( "BB" ) ) .and. !Empty( ::getExcelString( "BA" ) )

      ( D():Articulos( ::nView ) )->Familia        := ::getExcelString( "BA" )

   else

      /*
      Creamos el proveedor si no existe-------------------------------------------
      */

      if !( D():Familias( ::nView ) )->( dbSeek( AllTrim( upper( ::getExcelString( "BB" ) ) ) ) )

         cNewCodigo     := NextKey( dbLast(  D():Familias( ::nView ), 1 ), D():Familias( ::nView ) )

         ( D():Familias( ::nView ) )->( dbAppend() )

         ( D():Familias( ::nView ) )->cCodFam      := cNewCodigo
         ( D():Familias( ::nView ) )->cNomFam      := AllTrim( upper( ::getExcelString( "BB" ) ) )
         ( D():Familias( ::nView ) )->cFamCmb      := ::getExcelString( "BA" )

         ( D():Familias( ::nView ) )->( dbcommit() )
         ( D():Familias( ::nView ) )->( dbunlock() )

      else

         cNewCodigo     := ( D():Familias( ::nView ) )->cCodFam

      end if

      ( D():Familias( ::nView ) )->( OrdSetFocus( nOrdAnt ) )
      ( D():Familias( ::nView ) )->( dbgoto( nRec ) )

      /*
      Lo metemos en la tabla de artículos-----------------------------------------
      */

      ( D():Articulos( ::nView ) )->Familia        := cNewCodigo

   end if

Return ( nil )

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