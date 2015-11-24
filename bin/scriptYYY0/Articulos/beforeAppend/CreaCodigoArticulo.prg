function InicioHRB( aGet, aTmp, nView )

   local cCodigo  := ""

   if Empty( aTmp[ ( D():Articulos( nView ) )->( fieldpos( "Familia" ) ) ] )
      MsgInfo( "La especie no puede estar vacía." )
      aGet[ ( D():Articulos( nView ) )->( fieldpos( "Familia" ) ) ]:SetFocus()
      Return .f.
   end if

   if Len( AllTrim( aTmp[ ( D():Articulos( nView ) )->( fieldpos( "Familia" ) ) ] ) ) != 4
      if !MsgYesNo( "La especie seleccionada no tiene el formato requerido", "¿Desea continuar?" )
         aGet[ ( D():Articulos( nView ) )->( fieldpos( "Familia" ) ) ]:SetFocus()
         Return .f.
      end if
   end if

   cCodigo        += AllTrim( RetFld( aTmp[ ( D():Articulos( nView ) )->( fieldpos( "Familia" ) ) ], D():Familias( nView ), "cFamCmb", "cCodFam" ) )
   cCodigo        += AllTrim( aTmp[ ( D():Articulos( nView ) )->( fieldpos( "Familia" ) ) ] )
   cCodigo        += getContador( cCodigo, nView )

   aTmp[ ( D():Articulos( nView ) )->( fieldpos( "Codigo" ) ) ]   := cCodigo

return .t.

//---------------------------------------------------------------------------//

function getContador( cSemilla, nView )

   local nRec                    := ( D():Articulos( nView ) )->( Recno() )
   local nOrdAnt                 := ( D():Articulos( nView ) )->( OrdSetFocus( "Codigo" ) )
   local contadorActual
   local contadorDefinitivo      := 0

   ( D():Articulos( nView ) )->( dbGoTop() )

   if ( D():Articulos( nView ) )->( dbSeek( cSemilla ) )

      while ( SubStr( ( D():Articulos( nView ) )->Codigo, 1, 6 ) == cSemilla ) .and. !( D():Articulos( nView ) )->( Eof() )

         contadorActual          := Val( SubStr( ( D():Articulos( nView ) )->Codigo, 7 ) )

         if contadorActual != 0
            contadorDefinitivo   := contadorActual
         end if

         ( D():Articulos( nView ) )->( dbSkip() )

      end while

   end if

   ( D():Articulos( nView ) )->( OrdSetFocus( nOrdAnt ) )
   ( D():Articulos( nView ) )->( dbGoTo( nRec ) )

Return ( RJust( contadorDefinitivo + 1, "0", 4 ) )

//---------------------------------------------------------------------------//