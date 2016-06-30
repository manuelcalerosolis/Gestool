#include "Factu.ch"

static nView
static aAtipicas

//---------------------------------------------------------------------------//

function InicioHRB( nVista )

   nView       := nVista
   aAtipicas   := {}

   Msginfo( "Paso a un array temporal" )
   pasoArray()

   Msginfo( "Elimino la tabla" )
   eliminoTabla()

   Msginfo( "Paso los registros válidos" )
   //pasoDefinitivo()

   Msginfo( "Proceso realizado con éxito" )

return .t.

//---------------------------------------------------------------------------//

Static Function pasoArray()

   local nScan

   ( D():Atipicas( nView ) )->( dbGoTop() )

   while !( D():Atipicas( nView ) )->( eof() )

      MsgWait( ( D():Atipicas( nView ) )->cCodCli + ( D():Atipicas( nView ) )->cCodGrp + ( D():Atipicas( nView ) )->cCodArt, "Tit", 0,1 )

      nScan := aScan( aAtipicas, {|a| a[1] + a[2] + a[3] + a[4] + Str( a[5] ) == ( D():Atipicas( nView ) )->cCodCli + ( D():Atipicas( nView ) )->cCodGrp + ( D():Atipicas( nView ) )->cCodArt + ( D():Atipicas( nView ) )->cCodFam + Str( ( D():Atipicas( nView ) )->nTipAtp ) } )

      if nScan == 0 
         aAdd( aAtipicas, dbScatter( D():Atipicas( nView ) ) )
      end if

      ( D():Atipicas( nView ) )->( dbSkip() )

   end while

   MsgInfo( hb_valtoexp( aAtipicas ), "Array" )

Return .t.

//---------------------------------------------------------------------------//

Static Function eliminoTabla()

   ( D():Atipicas( nView ) )->( dbGoTop() )

   while !( D():Atipicas( nView ) )->( Eof() )
      if dbLock( D():Atipicas( nView ) )
         ( D():Atipicas( nView ) )->( dbDelete() )
         ( D():Atipicas( nView ) )->( dbUnLock() )
      end if
   end while

Return .t.

//---------------------------------------------------------------------------//

Static Function pasoDefinitivo()

   local atipica

   MsgInfo( hb_valtoexp( aAtipicas ), "Array" )

   for each atipica in aAtipicas
  
      dbGather( atipica, D():Atipicas( nView ) )

   next

Return .t.

//---------------------------------------------------------------------------//