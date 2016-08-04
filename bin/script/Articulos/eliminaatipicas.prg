#include "Factu.ch"

static nView
static dbfTmpAtp

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

   local cTmpAtp           := cGetNewFileName( "c:\ficheros\TmpAtp" )

   if file( cTmpAtp + ".dbf" ) .or. file( cTmpAtp + ".cdx" )
      dbfErase( cTmpAtp )
   end if

   dbCreate( cTmpAtp, aSqlStruct( aItmAtp() ), cLocalDriver() )
   dbUseArea( .t., cLocalDriver(), cTmpAtp, cCheckArea( "TmpAtp", @dbfTmpAtp ), .f. )

   ( dbfTmpAtp )->( ordCondSet( "!Deleted()", {||!Deleted()}  ) )
   ( dbfTmpAtp )->( OrdCreate( cTmpAtp, "cCliArt", "CCODCLI + CCODGRP + CCODART + CCODFAM + Str( NTIPATP ) + CCODPR1 + CCODPR2 + CVALPR1 + CVALPR2", {|| Field->CCODCLI + Field->CCODGRP + Field->CCODART + Field->CCODFAM + Str( Field->NTIPATP ) + Field->CCODPR1 + Field->CCODPR2 + Field->CVALPR1 + Field->CVALPR2 } ) )

   ( dbfTmpAtp )->( OrdSetFocus( "cCliArt" ) )

Return .t.

//---------------------------------------------------------------------------//

Static Function CierroTemporal()

   if !Empty( dbfTmpAtp ) .and. ( dbfTmpAtp )->( Used() )
      ( dbfTmpAtp )->( dbCloseArea() )
   end if

Return .t.

//---------------------------------------------------------------------------//

Static Function pasoRegistros()

   local nScan

   ( D():Atipicas( nView ) )->( dbGoTop() )

   while !( D():Atipicas( nView ) )->( eof() )

      MsgWait( ( D():Atipicas( nView ) )->cCodCli + ( D():Atipicas( nView ) )->cCodGrp + ( D():Atipicas( nView ) )->cCodArt, "Tit", 0,1 )

      if !( dbfTmpAtp )->( dbSeek( ( D():Atipicas( nView ) )->CCODCLI + ( D():Atipicas( nView ) )->CCODGRP + ( D():Atipicas( nView ) )->CCODART + ( D():Atipicas( nView ) )->CCODFAM + Str( ( D():Atipicas( nView ) )->NTIPATP ) + ( D():Atipicas( nView ) )->CCODPR1 + ( D():Atipicas( nView ) )->CCODPR2 + ( D():Atipicas( nView ) )->CVALPR1 + ( D():Atipicas( nView ) )->CVALPR2 ) )
          dbPass( D():Atipicas( nView ), dbfTmpAtp, .t. )  
      end if

      ( D():Atipicas( nView ) )->( dbSkip() )

   end while

Return .t.

//---------------------------------------------------------------------------//