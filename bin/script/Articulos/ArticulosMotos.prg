#include "hbclass.ch"

#define CRLF chr( 13 ) + chr( 10 )

//---------------------------------------------------------------------------//

Function Inicio( nView )

   local oImportaArticulos := ImportaArticulos():New( nView )

Return ( nil )

//---------------------------------------------------------------------------//

CLASS ImportaArticulos

   DATA nView
   DATA cFileArticulo
   DATA cFileFamilia
   DATA cFileFabricante
   DATA cFileCliente
   DATA cFileDirecciones
   DATA cFileImagenes
   DATA cFilePropiedades
   DATA cFileLineasPropiedades
   DATA cFilePropiedadesArticulos

   DATA cUrlPsImagen
   DATA cUrlDwImagen

   DATA aDownloadImagenes

   METHOD New()
   METHOD ImpArticulos()
   METHOD ImpFamilias()
   METHOD ImpFabricantes()
   METHOD ImpClientes()
   METHOD ImpDirecciones()
   METHOD ImpImagenes()
   METHOD ImpPropiedades()
   METHOD ImpLineasPropiedades()
   METHOD ImpPropiedadesArticulos()

ENDCLASS

//---------------------------------------------------------------------------//

METHOD New( nView ) CLASS ImportaArticulos

   ::nView                       := nView
   ::cFileArticulo               := "c:\ficheros\product.csv"
   ::cFileFamilia                := "c:\ficheros\category.csv"
   ::cFileFabricante             := "c:\ficheros\manufacturer.csv"
   ::cFileCliente                := "c:\ficheros\customer.csv"
   ::cFileDirecciones            := "c:\ficheros\address.csv"
   ::cFileImagenes               := "c:\ficheros\image.csv"
   ::cFilePropiedades            := "c:\ficheros\propiedades.csv"
   ::cFileLineasPropiedades      := "c:\ficheros\lineaspropiedades.csv"
   ::cFilePropiedadesArticulos   := "c:\ficheros\propiedadesarticulos.csv"

   ::cUrlPsImagen                := "http://motosdasilva.com/t/img/p/"
   ::cUrlDwImagen                := "c:\ficheros\images\"

   ::aDownloadImagenes           := {}

   if msgYesNo( "¿Desea importar productos?" )
      ::ImpArticulos()
   end if

   if msgYesNo( "¿Desea importar familias?" )
      ::ImpFamilias()
   end if

   if msgYesNo( "¿Desea importar fabricantes?" )
      ::ImpFabricantes()
   end if

   if msgYesNo( "¿Desea importar clientes?" )
      ::ImpClientes()
   end if

   if msgYesNo( "¿Desea importar direcciones?" )
      ::ImpDirecciones()
   end if

   if msgYesNo( "¿Desea importar imagenes?" )
      ::ImpImagenes()
   end if

   if msgYesNo( "¿Desea importar propiedades?" )
      ::ImpPropiedades()
   end if

   if msgYesNo( "¿Desea importar lineas propiedades?" )
      ::ImpLineasPropiedades()
   end if

   if msgYesNo( "¿Desea importar lineas propiedades de artículos?" )
      ::ImpPropiedadesArticulos()
   end if

Return ( Self )

//---------------------------------------------------------------------------//

METHOD ImpArticulos() CLASS ImportaArticulos

   local cMemoRead
   local aLineas
   local line
   local aRegistro

   if !File( ::cFileArticulo )
      Return .f.
   end if

   alineas           := hb_aTokens( MemoRead( ::cFileArticulo ), CRLF )

   for each line in alineas

      aRegistro := hb_aTokens( line, "," )

      if len( aRegistro ) != 0

         msgWait( "Añadiendo " + formatText( AllTrim( aRegistro[5] ) ), "Atención", 0.05 )

         ( D():Articulos( ::nView ) )->( dbAppend() )

         ( D():Articulos( ::nView ) )->Codigo     := formatText( AllTrim( aRegistro[1] ) )
         ( D():Articulos( ::nView ) )->Familia    := formatText( AllTrim( aRegistro[2] ) )
         ( D():Articulos( ::nView ) )->cCodFab    := formatText( AllTrim( aRegistro[3] ) )
         ( D():Articulos( ::nView ) )->pVenta1    := formatNumber( AllTrim( aRegistro[4] ) )
         ( D():Articulos( ::nView ) )->Nombre     := formatText( AllTrim( aRegistro[5] ) )

         ( D():Articulos( ::nView ) )->( dbUnlock() )

      end if

   next

Return .t.

//---------------------------------------------------------------------------//

METHOD ImpFamilias() CLASS ImportaArticulos

   local cMemoRead
   local aLineas
   local line
   local aRegistro

   if !File( ::cFileFamilia )
      Return .f.
   end if

   alineas           := hb_aTokens( MemoRead( ::cFileFamilia ), CRLF )

   for each line in alineas

      aRegistro := hb_aTokens( line, "," )

      if len( aRegistro ) != 0

         msgWait( "Añadiendo " + formatText( AllTrim( aRegistro[3] ) ), "Atención", 0.05 )

         ( D():Familias( ::nView ) )->( dbAppend() )

         ( D():Familias( ::nView ) )->cCodFam    := formatText( AllTrim( aRegistro[1] ) )
         ( D():Familias( ::nView ) )->cFamCmb    := formatText( AllTrim( aRegistro[2] ) )
         ( D():Familias( ::nView ) )->cNomFam    := formatText( AllTrim( aRegistro[3] ) )

         ( D():Familias( ::nView ) )->( dbUnlock() )

      end if

   next

Return .t.

//---------------------------------------------------------------------------//

METHOD ImpFabricantes() CLASS ImportaArticulos

   local cMemoRead
   local aLineas
   local line
   local aRegistro

   if !File( ::cFileFabricante )
      Return .f.
   end if

   alineas           := hb_aTokens( MemoRead( ::cFileFabricante ), CRLF )

   for each line in alineas

      aRegistro := hb_aTokens( line, "," )

      if len( aRegistro ) != 0

         msgWait( "Añadiendo " + formatText( AllTrim( aRegistro[2] ) ), "Atención", 0.05 )

         ( D():Fabricantes( ::nView ) )->( dbAppend() )

         ( D():Fabricantes( ::nView ) )->cCodFab    := formatText( AllTrim( aRegistro[1] ) )
         ( D():Fabricantes( ::nView ) )->cNomFab    := formatText( AllTrim( aRegistro[2] ) )

         ( D():Fabricantes( ::nView ) )->( dbUnlock() )

      end if

   next

Return .t.

//---------------------------------------------------------------------------//

METHOD ImpClientes() CLASS ImportaArticulos

   local cMemoRead
   local aLineas
   local line
   local aRegistro

   if !File( ::cFileCliente )
      Return .f.
   end if

   alineas           := hb_aTokens( MemoRead( ::cFileCliente ), CRLF )

   for each line in alineas

      aRegistro := hb_aTokens( line, "," )

      if len( aRegistro ) != 0

         msgWait( "Añadiendo " + formatText( AllTrim( aRegistro[3] ) ), "Atención", 0.05 )

         ( D():Clientes( ::nView ) )->( dbAppend() )

         ( D():Clientes( ::nView ) )->Cod       := Rjust( formatText( AllTrim( aRegistro[1] ) ), "0", RetNumCodCliEmp() )
         ( D():Clientes( ::nView ) )->Titulo    := formatText( AllTrim( aRegistro[5] ) ) + Space( 1 ) + formatText( AllTrim( aRegistro[4] ) )
         ( D():Clientes( ::nView ) )->cMeiInt   := formatText( AllTrim( aRegistro[6] ) )

         ( D():Clientes( ::nView ) )->( dbUnlock() )

      end if

   next

Return .t.

//---------------------------------------------------------------------------//

METHOD ImpDirecciones() CLASS ImportaArticulos

   local cMemoRead
   local aLineas
   local line
   local aRegistro
   local cCliente    := ""

   if !File( ::cFileDirecciones )
      Return .f.
   end if

   alineas           := hb_aTokens( MemoRead( ::cFileDirecciones ), CRLF )

   for each line in alineas

      aRegistro := hb_aTokens( line, "," )

      if len( aRegistro ) != 0 .and. len( aRegistro ) == 23

         msgWait( "Añadiendo " + formatText( AllTrim( aRegistro[11] ) ), "Atención", 0.05 )

         cCliente    := Rjust( formatText( AllTrim( aRegistro[4] ) ), "0", RetNumCodCliEmp() )

         if ( D():Clientes( ::nView ) )->( dbSeek( cCliente ) )

            if Empty( ( D():Clientes( ::nView ) )->Domicilio )

               if dbLock( ( D():Clientes( ::nView ) ) )

                  ( D():Clientes( ::nView ) )->Domicilio   := formatText( AllTrim( aRegistro[11] ) ) + Space( 1 ) + formatText( AllTrim( aRegistro[12] ) )
                  ( D():Clientes( ::nView ) )->CodPostal   := formatText( AllTrim( aRegistro[13] ) )
                  ( D():Clientes( ::nView ) )->Poblacion   := formatText( AllTrim( aRegistro[14] ) )
                  ( D():Clientes( ::nView ) )->Telefono    := formatText( AllTrim( aRegistro[16] ) )
                  ( D():Clientes( ::nView ) )->Movil       := formatText( AllTrim( aRegistro[17] ) )
                  ( D():Clientes( ::nView ) )->Nif         := formatText( AllTrim( aRegistro[19] ) )

                  ( D():Clientes( ::nView ) )->( dbUnlock() )

               end if

            else
               
               ( D():ClientesDirecciones( ::nView ) )->( dbAppend() )

                  ( D():ClientesDirecciones( ::nView ) )->cCodCli   := cCliente
                  ( D():ClientesDirecciones( ::nView ) )->cCodObr   := formatText( AllTrim( aRegistro[1] ) )
                  ( D():ClientesDirecciones( ::nView ) )->cNomObr   := formatText( AllTrim( aRegistro[8] ) )
                  ( D():ClientesDirecciones( ::nView ) )->cDirObr   := formatText( AllTrim( aRegistro[11] ) ) + Space( 1 ) + formatText( AllTrim( aRegistro[12] ) )
                  ( D():ClientesDirecciones( ::nView ) )->cPosObr   := formatText( AllTrim( aRegistro[13] ) )
                  ( D():ClientesDirecciones( ::nView ) )->cPobObr   := formatText( AllTrim( aRegistro[14] ) )
                  ( D():ClientesDirecciones( ::nView ) )->cTelObr   := formatText( AllTrim( aRegistro[16] ) )
                  ( D():ClientesDirecciones( ::nView ) )->cMovObr   := formatText( AllTrim( aRegistro[17] ) )
                  ( D():ClientesDirecciones( ::nView ) )->Nif       := formatText( AllTrim( aRegistro[19] ) )

               ( D():ClientesDirecciones( ::nView ) )->( dbUnlock() )

            end if

         end if

      end if

   next

Return .t.

//---------------------------------------------------------------------------//

METHOD ImpImagenes() CLASS ImportaArticulos

   local cMemoRead
   local aLineas
   local line
   local aRegistro
   local cImagen  := ""

   /*if !File( ::cFileImagenes )
      Return .f.
   end if

   alineas           := hb_aTokens( MemoRead( ::cFileImagenes ), CRLF )

   for each line in alineas

      aRegistro := hb_aTokens( line, "," )

      if len( aRegistro ) != 0

         msgWait( "Añadiendo " + formatText( AllTrim( aRegistro[1] ) ), "Atención", 0.05 )

         ( D():ArticuloImagenes( ::nView ) )->( dbAppend() )

         ( D():ArticuloImagenes( ::nView ) )->cCodArt    := formatText( AllTrim( aRegistro[2] ) )
         ( D():ArticuloImagenes( ::nView ) )->cImgArt    := formatText( AllTrim( aRegistro[2] ) ) + "-" + formatText( AllTrim( aRegistro[1] ) ) + ".jpg"

         ( D():ArticuloImagenes( ::nView ) )->( dbUnlock() )

         aAdd( ::aDownloadImagenes, formatText( AllTrim( aRegistro[2] ) ) + "-" + formatText( AllTrim( aRegistro[1] ) ) + ".jpg" )

      end if

   next*/

   ( D():ArticuloImagenes( ::nView ) )->( dbGoTop() )

   while !( D():ArticuloImagenes( ::nView ) )->( eof() )

      msgWait( "Descargando " + AllTrim( ( D():ArticuloImagenes( ::nView ) )->cImgArt ), "Atención", 0.05 )

      DownLoadFileToUrl( ::cUrlPsImagen + AllTrim( ( D():ArticuloImagenes( ::nView ) )->cImgArt ), ::cUrlDwImagen + AllTrim( ( D():ArticuloImagenes( ::nView ) )->cImgArt ) )

      ( D():ArticuloImagenes( ::nView ) )->( dbSkip() )

   end while

   /*if len( ::aDownloadImagenes ) != 0

      for each cImagen in ::aDownloadImagenes
         
         msgWait( "Descargando " + cImagen, "Atención", 0.05 )

         DownLoadFileToUrl( ::cUrlPsImagen + cImagen, ::cUrlDwImagen + cImagen )

      next

   end if*/

Return .t.

//---------------------------------------------------------------------------//

METHOD ImpPropiedades() CLASS ImportaArticulos

   local cMemoRead
   local aLineas
   local line
   local aRegistro

   if !File( ::cFilePropiedades )
      Return .f.
   end if

   alineas           := hb_aTokens( MemoRead( ::cFilePropiedades ), CRLF )

   for each line in alineas

      aRegistro := hb_aTokens( line, "," )

      if len( aRegistro ) != 0

         msgWait( "Añadiendo " + formatText( AllTrim( aRegistro[3] ) ), "Atención", 0.05 )

         ( D():Propiedades( ::nView ) )->( dbAppend() )

         ( D():Propiedades( ::nView ) )->cCodPro    := formatText( AllTrim( aRegistro[1] ) )
         ( D():Propiedades( ::nView ) )->cDesPro    := formatText( AllTrim( aRegistro[3] ) )

         ( D():Propiedades( ::nView ) )->( dbUnlock() )

      end if

   next


Return .t.

//---------------------------------------------------------------------------//

METHOD ImpLineasPropiedades() CLASS ImportaArticulos

   local cMemoRead
   local aLineas
   local line
   local aRegistro

   if !File( ::cFileLineasPropiedades )
      Return .f.
   end if

   alineas           := hb_aTokens( MemoRead( ::cFileLineasPropiedades ), CRLF )

   for each line in alineas

      aRegistro := hb_aTokens( line, "," )

      if len( aRegistro ) != 0

         msgWait( "Añadiendo " + formatText( AllTrim( aRegistro[4] ) ), "Atención", 0.05 )

         ( D():PropiedadesLineas( ::nView ) )->( dbAppend() )

         ( D():PropiedadesLineas( ::nView ) )->cCodPro    := formatText( AllTrim( aRegistro[2] ) )
         ( D():PropiedadesLineas( ::nView ) )->cCodTbl    := formatText( AllTrim( aRegistro[1] ) )
         ( D():PropiedadesLineas( ::nView ) )->cDesTbl    := formatText( AllTrim( aRegistro[4] ) )

         ( D():PropiedadesLineas( ::nView ) )->( dbUnlock() )

      end if

   next

Return .t.

//---------------------------------------------------------------------------//

METHOD ImpPropiedadesArticulos() CLASS ImportaArticulos

   local cMemoRead
   local aLineas
   local line
   local aRegistro
   local nOrdAnt     := ( D():PropiedadesLineas( ::nView ) )->( OrdSetFocus( "CCODTBL" ) )

   if !File( ::cFilePropiedadesArticulos )
      Return .f.
   end if

   alineas           := hb_aTokens( MemoRead( ::cFilePropiedadesArticulos ), CRLF )

   for each line in alineas

      aRegistro := hb_aTokens( line, "," )

      if len( aRegistro ) != 0

         msgWait( "Añadiendo " + formatText( AllTrim( aRegistro[1] ) ), "Atención", 0.05 )

         if ( D():PropiedadesLineas( ::nView ) )->( dbSeek( formatText( AllTrim( aRegistro[2] ) ) ) )

            ( D():ArticuloPrecioPropiedades( ::nView ) )->( dbAppend() )

            ( D():ArticuloPrecioPropiedades( ::nView ) )->cCodArt    := formatText( AllTrim( aRegistro[1] ) )
            ( D():ArticuloPrecioPropiedades( ::nView ) )->cCodDiv    := "EUR"
            ( D():ArticuloPrecioPropiedades( ::nView ) )->cCodPr1    := ( D():PropiedadesLineas( ::nView ) )->cCodPro
            ( D():ArticuloPrecioPropiedades( ::nView ) )->cValPr1    := formatText( AllTrim( aRegistro[2] ) )

            ( D():ArticuloPrecioPropiedades( ::nView ) )->( dbUnlock() )

            if ( D():Articulos( ::nView ) )->( dbSeek( formatText( AllTrim( aRegistro[1] ) ) ) )

               if dbLock( D():Articulos( ::nView ) )

                  ( D():Articulos( ::nView ) )->cCodPrp1             := ( D():PropiedadesLineas( ::nView ) )->cCodPro

                  ( D():Articulos( ::nView ) )->( dbUnlock() )

               end if

            end if

         end if

      end if

   next

   ( D():PropiedadesLineas( ::nView ) )->( OrdSetFocus( nOrdAnt ) )

Return .t.


//---------------------------------------------------------------------------//

static Function formatText( cText )

   local cResult  := ""

   if !Empty( cText )
      cResult     := SubStr( cText, 2, Len( cText ) - 2 )
   end if

Return cResult

//---------------------------------------------------------------------------//

static Function formatNumber( cText )

   local nResult  := 0

   if !Empty( cText )
      nResult     := Val( SubStr( cText, 2, Len( cText ) - 2 ) )
   end if

Return nResult

//---------------------------------------------------------------------------//