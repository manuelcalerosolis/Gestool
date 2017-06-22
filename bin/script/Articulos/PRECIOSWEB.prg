//---------------------------------------------------------------------------//

Function CambiaPreciosWeb()

   local cStatement     := ""
   local cSql           := "articulos"
   local cTienda        := ""

   MsgCombo( "Seleccione", "Tiendas", { "", "OutLet", "Temporada" }, @cTienda )

   if !Empty( cTienda )
   
      cStatement           := "UPDATE " + cPatEmp() + "ARTICULO SET "

      cStatement           += "pVenta4=nImpInt1, pVtaIva4=nImpIva1 "

      cStatement           += "WHERE UPPER( cWebShop ) LIKE '%" + AllTrim( Upper( cTienda ) ) + "'"

      TDataCenter():ExecuteSqlStatement( cStatement, @cSql )

   end if

Return ( nil )

//---------------------------------------------------------------------------//