function InicioHRB( aGet, aTmp, nView )

   local cCodigo  := ""

   if Empty( aTmp[ ( D():Articulos( nView ) )->( fieldpos( "Familia" ) ) ] )
      MsgInfo( "La especie no puede estar vacía." )
      aGet[ ( D():Articulos( nView ) )->( fieldpos( "Familia" ) ) ]:SetFocus()
      Return .f.
   end if

   if Empty( aTmp[ ( D():Articulos( nView ) )->( fieldpos( "cCodCate" ) ) ] )
      MsgInfo( "La categoría no puede estar vacía." )
      aGet[ ( D():Articulos( nView ) )->( fieldpos( "cCodCate" ) ) ]:SetFocus()
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
   cCodigo        += AllTrim( aTmp[ ( D():Articulos( nView ) )->( fieldpos( "cCodCate" ) ) ] )

   aTmp[ ( D():Articulos( nView ) )->( fieldpos( "Codigo" ) ) ]   := cCodigo

return .t.

//---------------------------------------------------------------------------//