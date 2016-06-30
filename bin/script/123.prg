#include "Factu.ch"

static aAtipicas
static dbfCliAtp

//---------------------------------------------------------------------------//

function InicioHRB()

   aAtipicas   := {}

   USE ( cPatCli() + "CliAtp.Dbf" ) NEW VIA ( cDriver() ) EXCLUSIVE ALIAS ( cCheckArea( "CliAtp", @dbfCliAtp ) )
   SET ADSINDEX TO ( cPatCli() + "CliAtp.Cdx" ) ADDITIVE

   Msginfo( "Paso a un array temporal" )
   pasoArray()

   if len( aAtipicas ) != 0

      Msginfo( "Elimino la tabla" )
      eliminoTabla()

      Msginfo( "Paso los registros válidos" )
      pasoDefinitivo()

   end if

   if !Empty( dbfCliAtp ) .and. ( dbfCliAtp )->( Used() )
      ( dbfCliAtp )->( dbCloseArea() )
   end if

   Msginfo( "Proceso realizado con éxito" )

return .t.

//---------------------------------------------------------------------------//

Static Function pasoArray()

   local nScan

   ( dbfCliAtp )->( dbGoTop() )

   while !( dbfCliAtp )->( eof() )

      MsgWait( ( dbfCliAtp )->cCodCli + ( dbfCliAtp )->cCodGrp + ( dbfCliAtp )->cCodArt, "Tit", 0,1 )

      nScan := aScan( aAtipicas, {|a| a[1] + a[2] + a[3] + a[4] + Str( a[5] ) == ( dbfCliAtp )->cCodCli + ( dbfCliAtp )->cCodGrp + ( dbfCliAtp )->cCodArt + ( dbfCliAtp )->cCodFam + Str( ( dbfCliAtp )->nTipAtp ) } )

      if nScan == 0 
         aAdd( aAtipicas, dbScatter( dbfCliAtp ) )
      end if

      ( dbfCliAtp )->( dbSkip() )

   end while

Return .t.

//---------------------------------------------------------------------------//

Static Function eliminoTabla()

   ( dbfCliAtp )->( __dbZap() )

Return .t.

//---------------------------------------------------------------------------//

Static Function pasoDefinitivo()

   local atipica

   for each atipica in aAtipicas
  
      dbGather( atipica, dbfCliAtp, .t. )

   next

Return .t.

//---------------------------------------------------------------------------//