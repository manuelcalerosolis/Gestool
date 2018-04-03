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
   DATA cCodigoBarras
   DATA aImagenes
   DATA cDirDescarga

   METHOD New()

   METHOD Run()

   METHOD getCampoClave()

   METHOD procesaFicheroExcel()

   METHOD filaValida()
   
   METHOD siguienteLinea()       INLINE ( ++::nFilaInicioImportacion )

   METHOD existeRegistro()       INLINE ( D():gotoArticulos( ::getCampoClave(), ::nView ) )

   METHOD appendRegistro()       INLINE ( ( D():ArticulosCodigosBarras( ::nView ) )->( dbappend() ) )

   METHOD desbloqueaRegistro()   INLINE ( ( D():ArticulosCodigosBarras( ::nView ) )->( dbcommit() ),;
                                          ( D():ArticulosCodigosBarras( ::nView ) )->( dbunlock() ) )

   METHOD importarCampos()

   METHOD getNombre()
   METHOD getDescripcionlarga()

   METHOD cProveedor( cProvee )

   METHOD cFamilia()

   METHOD addImages()

   METHOD descargaImagenes()

   METHOD descargaESP()

END CLASS

//----------------------------------------------------------------------------//

METHOD New( nView )

   ::nView                    := nView

   ::aImagenes                := {}

   /*
   Cambiar el nombre del fichero-----------------------------------------------
   */

   ::cFicheroExcel            := "C:\ficheros\barras.xls"
   ::cDirDescarga             := "C:\ficheros\fotos\"

   /*
   Cambiar la fila de cominezo de la importacion-------------------------------
   */

   ::nFilaInicioImportacion   := 1

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

      ::importarCampos( "B" )
      ::importarCampos( "C" )
      ::importarCampos( "D" )
      ::importarCampos( "E" )
      ::importarCampos( "F" )
      ::importarCampos( "G" )
      ::importarCampos( "H" )
      ::importarCampos( "I" )
      ::importarCampos( "J" )
      ::importarCampos( "K" )

      ::siguienteLinea()

   end if

   ::closeExcel()

Return nil

//---------------------------------------------------------------------------//

METHOD importarCampos( cFieldCodBar )

   local nOrdAnt     :=( D():ArticulosCodigosBarras( ::nView ) )->( OrdSetFocus( "cArtBar" ) )
   
   ::idArticulo      := Padr( ::getCampoClave(), 18 )
   ::cCodigoBarras   := Padr( Str( ::getExcelNumeric( cFieldCodBar ) ), 20 )

   MsgWait( ::idArticulo + " - " + ::cCodigoBarras, "Datos", 0.005 )

   if !( D():ArticulosCodigosBarras( ::nView ) )->( dbSeek( ::idArticulo + " - " + ::cCodigoBarras ) )

      if ::appendRegistro()

         ( D():ArticulosCodigosBarras( ::nView ) )->cCodArt   := ::idArticulo
         ( D():ArticulosCodigosBarras( ::nView ) )->cCodBar   := ::cCodigoBarras

         ::desbloqueaRegistro()

      end if

   end if

Return nil

//---------------------------------------------------------------------------// 

METHOD addImages( cImagen )

   ( D():ArticuloImagenes( ::nView ) )->( dbAppend() )

   ( D():ArticuloImagenes( ::nView ) )->cCodArt    := ::idArticulo
   ( D():ArticuloImagenes( ::nView ) )->cImgArt    := AllTrim( cImagen ) + ".jpg"

   ( D():ArticuloImagenes( ::nView ) )->( dbUnlock() )

   aAdd( ::aImagenes, AllTrim( cImagen ) )

Return .t.

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
   
   if Empty( ::getExcelString( "AV" ) ) .and. !Empty( ::getExcelString( "AU" ) )

      /*
      Creamos el proveedor si no existe-------------------------------------------
      */

      if !( D():Familias( ::nView ) )->( dbSeek( AllTrim( upper( ::getExcelString( "AU" ) ) ) ) )

         cNewCodigo     := NextKey( dbLast(  D():Familias( ::nView ), 1 ), D():Familias( ::nView ) )

         ( D():Familias( ::nView ) )->( dbAppend() )

         ( D():Familias( ::nView ) )->cCodFam      := cNewCodigo
         ( D():Familias( ::nView ) )->cNomFam      := AllTrim( upper( ::getExcelString( "AU" ) ) )
         ( D():Familias( ::nView ) )->lPubInt      := .t.

         ( D():Familias( ::nView ) )->( dbcommit() )
         ( D():Familias( ::nView ) )->( dbunlock() )

      else

         cNewCodigo     := ( D():Familias( ::nView ) )->cCodFam

      end if

      ( D():Articulos( ::nView ) )->Familia        := cNewCodigo

   else

      /*
      Creamos el proveedor si no existe-------------------------------------------
      */

      if !( D():Familias( ::nView ) )->( dbSeek( AllTrim( upper( ::getExcelString( "AV" ) ) ) ) )

         cNewCodigo     := NextKey( dbLast(  D():Familias( ::nView ), 1 ), D():Familias( ::nView ) )

         ( D():Familias( ::nView ) )->( dbAppend() )

         ( D():Familias( ::nView ) )->cCodFam      := cNewCodigo
         ( D():Familias( ::nView ) )->cNomFam      := AllTrim( upper( ::getExcelString( "AV" ) ) )
         ( D():Familias( ::nView ) )->cFamCmb      := RetFld( AllTrim( upper( ::getExcelString( "AU" ) ) ), D():Familias( ::nView ), "cCodFam", "cNomFam" )
         ( D():Familias( ::nView ) )->lPubInt      := .t.

         ( D():Familias( ::nView ) )->( dbcommit() )
         ( D():Familias( ::nView ) )->( dbunlock() )

      else

         cNewCodigo     := ( D():Familias( ::nView ) )->cCodFam

      end if

      /*
      Lo metemos en la tabla de artículos-----------------------------------------
      */

      ( D():Articulos( ::nView ) )->Familia        := cNewCodigo

   end if

   ( D():Familias( ::nView ) )->( OrdSetFocus( nOrdAnt ) )
   ( D():Familias( ::nView ) )->( dbgoto( nRec ) )

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

METHOD descargaImagenes()

   local cImagen

   if !MsgYesNo( "Desea descargar las imágenes" )
      Return .t.
   end if

   for each cImagen in ::aImagenes
      MsgWait( "http://static.webshopapp.com/shops/111832/files/" + cImagen + "/image.jpg", "Descargando", 0.01 )
      DownLoadFileToUrl( "http://static.webshopapp.com/shops/111832/files/" + cImagen + "/image.jpg", ::cDirDescarga + cImagen + ".jpg" )
   next

Return .t.

//---------------------------------------------------------------------------//

METHOD getCampoClave()

   local cCampoClave    := alltrim( ::getExcelString( ::cColumnaCampoClave ) )

   if Val( cCampoClave ) < 100
      cCampoClave       := Rjust( cCampoClave, "0", 3 )
   end if

Return cCampoClave

//---------------------------------------------------------------------------//

METHOD descargaESP()

   MsgWait( "Pasamos a descargar las descripciones en español", "", 0.1 )

   ::cFicheroExcel            := "C:\ficheros\articulosesp.xls"
   ::nFilaInicioImportacion   := 2
   ::cColumnaCampoClave       := 'B'   

   ::openExcel()

   while ( ::filaValida() )

      if ::existeRegistro()
         
         if !Empty( ::getExcelString( "C" ) )

            ( D():ArticuloLenguaje( ::nView ) )->( dbAppend() )

            ( D():ArticuloLenguaje( ::nView ) )->cCodArt    := ::getExcelString( "B" )
            ( D():ArticuloLenguaje( ::nView ) )->cCodLen    := "ESP "
            ( D():ArticuloLenguaje( ::nView ) )->cDesTik    := ::getExcelString( "C" )
            ( D():ArticuloLenguaje( ::nView ) )->cDesArt    := ::getExcelString( "C" )

            ( D():ArticuloLenguaje( ::nView ) )->( dbcommit() )

            ( D():ArticuloLenguaje( ::nView ) )->( dbunlock() )   

         end if

      end if 

      ::siguienteLinea()

   end if

   ::closeExcel()

Return ( .t. )

//---------------------------------------------------------------------------//

#include "ImportarExcel.prg"
