#include "Factu.ch"

static nView
static dbfTmpArt

//---------------------------------------------------------------------------//

function InicioHRB( nVista )

   nView       := nVista

   Creotemporal()

   Msginfo( "Paso los registros válidos" )
   pasoRegistros()

   CierroTemporal()

   Msginfo( "Proceso realizado con éxito" )

return .t.

//---------------------------------------------------------------------------//

Static Function CreoTemporal()

   local cTmpArt           := cGetNewFileName( "c:\ficheros\TmpArt" )

   if file( cTmpArt + ".dbf" ) .or. file( cTmpArt + ".cdx" )
      dbfErase( cTmpArt )
   end if

   dbCreate( cTmpArt, aSqlStruct( aItmArt() ), cLocalDriver() )
   dbUseArea( .t., cLocalDriver(), cTmpArt, cCheckArea( "TmpArt", @dbfTmpArt ), .f. )

   ( dbfTmpArt )->( ordCondSet( "!Deleted()", {||!Deleted()}  ) )
   ( dbfTmpArt )->( OrdCreate( cTmpArt, "Codigo", "Codigo", {|| Field->Codigo } ) )

   ( dbfTmpArt )->( OrdSetFocus( "Codigo" ) )

Return .t.

//---------------------------------------------------------------------------//

Static Function CierroTemporal()

   if !Empty( dbfTmpArt ) .and. ( dbfTmpArt )->( Used() )
      ( dbfTmpArt )->( dbCloseArea() )
   end if

Return .t.

//---------------------------------------------------------------------------//

Static Function pasoRegistros()

   local nScan

   ( D():Articulos( nView ) )->( dbGoTop() )

   while !( D():Articulos( nView ) )->( eof() )

      MsgWait( ( D():Articulos( nView ) )->Codigo + "-" + ( D():Articulos( nView ) )->Nombre, "Tit", 0.001 )

      if !( dbfTmpArt )->( dbSeek( ( D():Articulos( nView ) )->Codigo ) )
         MsgWait( "Paso", "Tit", 0.001 )
         dbPass( D():Articulos( nView ), dbfTmpArt, .t. )  
      end if

      ( D():Articulos( nView ) )->( dbSkip() )

   end while

Return .t.

//---------------------------------------------------------------------------//