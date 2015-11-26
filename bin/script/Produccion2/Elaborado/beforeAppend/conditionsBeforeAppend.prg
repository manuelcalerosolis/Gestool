function InicioHRB( oElaborado )
   
   if Empty( oElaborado:oDbfVir:cCodCat )
      setAlertTextDialog( "Código de " + lower( getTraslation( "Categoría" ) ) + " es obligatorio", oElaborado:oDlg )
      oElaborado:oFld:SetOption( 2 )
      oElaborado:oGetCatalogo:SetFocus()
      Return .f.
   else 
      endAutoTextDialog()
   end if

   if Empty( oElaborado:oDbfVir:cCodTmp )
      setAlertTextDialog( "Código de " + lower( getTraslation( "Temporada" ) ) + " es obligatorio", oElaborado:oDlg )
      oElaborado:oFld:SetOption( 2 )
      oElaborado:oGetTemporada:SetFocus()
      Return .f.
   else 
      endAutoTextDialog()
   end if

return .t.

//---------------------------------------------------------------------------//