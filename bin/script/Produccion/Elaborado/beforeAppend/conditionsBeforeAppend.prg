function InicioHRB( oElaborado )
   
   if Empty( oElaborado:oDbfVir:cCodCat )
      setAlertTextDialog( "C�digo de categor�a es obligatorio", oElaborado:oDlg )
      oElaborado:oFld:SetOption( 2 )
      oElaborado:oGetCatalogo:SetFocus()
      Return .f.
   else 
      endAutoTextDialog()
   end if

   if Empty( oElaborado:oDbfVir:cCodTmp )
      setAlertTextDialog( "C�digo de temporada es obligatorio", oElaborado:oDlg )
      oElaborado:oFld:SetOption( 2 )
      oElaborado:oGetTemporada:SetFocus()
      Return .f.
   else 
      endAutoTextDialog()
   end if

return .t.

//---------------------------------------------------------------------------//