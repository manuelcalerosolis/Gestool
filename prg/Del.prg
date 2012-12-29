function cCurUsr( cUsr )

   if cUsr != nil
      cCurUsr  := cUsr
   end if

return cCurUsr

//---------------------------------------------------------------------------//

function lUsrMaster()

return ( cCurUsr == "000" )

//---------------------------------------------------------------------------//

function lUsrAdministrador( lUsrAdministrador )

   if lUsrAdministrador != nil
      lAdmUsr  := lUsrAdministrador
   end if

return lAdmUsr

//---------------------------------------------------------------------------//

Function cNbrUsr( cNbr )

   if cNbr != nil
      cNbrUsr  := cNbr
      if oMsgUser != nil
         oMsgUser:SetText( "Usuario : " + RTrim( cNbr ) )
      end if
   end if

Return cNbrUsr

//---------------------------------------------------------------------------//

Function cCajUsr( cCaj )

   if cCaj != nil
      cCajUsr  := cCaj
      if oMsgCaja != nil
         oMsgCaja:SetText( "Caja : " + RTrim( cCaj ) )
      end if
   end if

Return cCajUsr

//---------------------------------------------------------------------------//

Function nHndUsr( nHnd )

   if nHnd != nil
      nHndUsr  := nHnd
   end if

Return nHndUsr

//---------------------------------------------------------------------------//

Function nHndCaj( nHnd )

   if nHnd != nil
      nHndCaj  := nHnd
   end if

Return nHndCaj

//---------------------------------------------------------------------------//

Function cNbrCaj( cNbr )

   if cNbr != nil
      cNbrCaj  := cNbr
      oMsgUser:SetText( "Caja : " + RTrim( cNbr ) )
   end if

Return cNbrCaj

//---------------------------------------------------------------------------//

Function cEmpUsr( cEmp )

   if cEmp != nil
      cEmpUsr  := cEmp
   end if

Return cEmpUsr

//---------------------------------------------------------------------------//

Function cPcnUsr()

Return cPcnUsr

//---------------------------------------------------------------------------//

Function cBmpUsr( cBmpUsr )

   if cBmpUsr != nil
      cBmpUsr  := cBmpUsr
   end if

Return cBmpUsr

//---------------------------------------------------------------------------//
