Function SqlOpen()

   local cStatement     := ""

   if !oUser():lAdministrador()

      cStatement        := "SELECT * FROM " + cPatEmp() + "TikeT WHERE "

      cStatement        += "( cTipTik = '1' AND cSufTik='" + oUser():cDelegacion() + "' AND cNcjTik='" + oUser():cCaja() + "'"

      if oUser():lFiltroVentas()         
         cStatement     += " AND cCcjTik='" + oUser():cCodigo() + "'"
      end if 

      cStatement        += ") "

      cStatement        += " OR ( cTipTik = '6' )"

      cStatement        += " OR ( cTipTik = '8' )"
         
   end if

   if Empty( cStatement )
      cStatement        := "SELECT * FROM " + cPatEmp() + "TikeT"
   end if

   msgalert( cStatement, "cStatement" )

Return ( cStatement )

