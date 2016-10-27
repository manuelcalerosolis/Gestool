function InicioHRB( aGet, aTmp, nView )

   local cCodigo  := ""
   local cFamilia := ""

   if !( "." $ aTmp[ ( D():Articulos( nView ) )->( fieldpos( "Codigo" ) ) ] )
      Return .t.
   end if 

   if Empty( aTmp[ ( D():Articulos( nView ) )->( fieldpos( "Familia" ) ) ] )
      MsgInfo( "La familia no puede estar vacía." )
      aGet[ ( D():Articulos( nView ) )->( fieldpos( "Familia" ) ) ]:SetFocus()
      Return .f.
   end if

   cFamilia       := alltrim( aTmp[ ( D():Articulos( nView ) )->( fieldpos( "Familia" ) ) ] )
   cCodigo        := getContador( cFamilia, nView )

   aTmp[ ( D():Articulos( nView ) )->( fieldpos( "Codigo" ) ) ]   := cFamilia + cCodigo

return .t.

//---------------------------------------------------------------------------//

function getContador( cSemilla, nView )

   local nRec                    := ( D():Articulos( nView ) )->( Recno() )
   local nOrdAnt                 := ( D():Articulos( nView ) )->( OrdSetFocus( "Codigo" ) )
   local contadorActual
   local contadorDefinitivo      := 0

   ( D():Articulos( nView ) )->( dbGoTop() )

   if ( D():Articulos( nView ) )->( dbSeek( cSemilla ) )

      while ( substr( ( D():Articulos( nView ) )->Codigo, 1, 2 ) == cSemilla ) .and. !( D():Articulos( nView ) )->( eof() )

         contadorActual          := val( substr( ( D():Articulos( nView ) )->Codigo, 3, 4 ) ) + 1

         if contadorActual != 0 .and. contadorActual > contadorDefinitivo
            contadorDefinitivo   := contadorActual
         end if

         ( D():Articulos( nView ) )->( dbSkip() )

      end while

   end if

   ( D():Articulos( nView ) )->( OrdSetFocus( nOrdAnt ) )
   ( D():Articulos( nView ) )->( dbGoTo( nRec ) )

Return ( rjust( contadorDefinitivo, "0", 4 ) )

//---------------------------------------------------------------------------//