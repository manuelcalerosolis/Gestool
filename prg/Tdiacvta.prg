#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TDiaCVta FROM TInfGen

   DATA  lExcMov     AS LOGIC    INIT .f.
   DATA  lResumen    AS LOGIC    INIT .f.
   DATA  lExcCero    AS LOGIC    INIT .f.
   DATA  oTikCliT    AS OBJECT
   DATA  oTikCliL    AS OBJECT
   DATA  oAlbCliT    AS OBJECT
   DATA  oAlbCliL    AS OBJECT
   DATA  oFacCliT    AS OBJECT
   DATA  oFacCliL    AS OBJECT
   DATA  oFacCliP    AS OBJECT
   DATA  oAntCliT    AS OBJECT
   DATA  oFacRecT    AS OBJECT
   DATA  oFacRecL    AS OBJECT
   DATA  oDbfIva     AS OBJECT
   DATA  oDbfPgo     AS OBJECT

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::FldDiario( .t. )
   ::AddField( "cTipDoc",     "C",  14, 0, {|| "@!" },         "Tipo documento",    .t., "Tipo documento",                 14 )
   ::AddField( "cEstado",     "C",  20, 0, {|| "@!" },         "Estado",            .f., "Estado documento",               20 )
   ::AddField( "cFpago",      "C",   2, 0, {|| "@!" },         "Código pago",       .f., "Código de pago",                 10 )
   ::AddField( "cDesFPago",   "C", 150, 0, {|| "@!" },         "Forma pago",        .f., "Forma de pago",                  20 )
   ::AddField( "cCodCaj",     "C",   3, 0, {|| "@!" },         "Código caja",       .f., "Código de caja",                 10 )

   if ::xOthers
   ::AddTmpIndex( "CCODCLI", "CCODCLI" )
   ::AddGroup( {|| ::oDbf:cCodCli }, {|| "Cliente  : " + Rtrim( ::oDbf:cCodCli ) + "-" + oRetFld( ::oDbf:cCodCli, ::oDbfCli ) } )
   else
   ::AddTmpIndex( "dFecMov", "Dtos( dFecMov ) + cDocMov" )
   end if

   ::dIniInf := GetSysDate()

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   DATABASE NEW ::oDbfIva  PATH ( cPatDat() )   FILE "TIVA.DBF"      VIA ( cDriver() ) SHARED INDEX "TIVA.CDX"

   DATABASE NEW ::oTikCliT PATH ( cPatEmp() )   FILE "TIKET.DBF"     VIA ( cDriver() ) SHARED INDEX "TIKET.CDX"

   DATABASE NEW ::oTikCliL PATH ( cPatEmp() )   FILE "TIKEL.DBF"     VIA ( cDriver() ) SHARED INDEX "TIKEL.CDX"

   ::oAlbCliT := TDataCenter():oAlbCliT()

   DATABASE NEW ::oAlbCliL PATH ( cPatEmp() )   FILE "ALBCLIL.DBF"   VIA ( cDriver() ) SHARED INDEX "ALBCLIL.CDX"

   ::oFacCliT := TDataCenter():oFacCliT()

   DATABASE NEW ::oFacCliL PATH ( cPatEmp() )   FILE "FACCLIL.DBF"   VIA ( cDriver() ) SHARED INDEX "FACCLIL.CDX"

   ::oFacCliP := TDataCenter():oFacCliP()

   DATABASE NEW ::oAntCliT PATH ( cPatEmp() )   FILE "ANTCLIT.DBF"   VIA ( cDriver() ) SHARED INDEX "ANTCLIT.CDX"

   DATABASE NEW ::oFacRecT PATH ( cPatEmp() )   FILE "FACRECT.DBF"   VIA ( cDriver() ) SHARED INDEX "FACRECT.CDX"

   DATABASE NEW ::oFacRecL PATH ( cPatEmp() )   FILE "FACRECL.DBF"   VIA ( cDriver() ) SHARED INDEX "FACRECL.CDX"

   DATABASE NEW ::oDbfPgo  PATH ( cPatEmp() )   FILE "FPAGO.DBF"     VIA ( cDriver() ) SHARED INDEX "FPAGO.CDX"

   RECOVER

      msgStop( 'Imposible abrir todas las bases de datos' )
      ::CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles()

   if !Empty( ::oTikCliT ) .and. ::oTikCliT:Used()
      ::oTikCliT:End()
   end if
   if !Empty( ::oTikCliL ) .and. ::oTikCliL:Used()
      ::oTikCliL:End()
   end if
   if !Empty( ::oFacCliT ) .and. ::oFacCliT:Used()
      ::oFacCliT:End()
   end if
   if !Empty( ::oFacCliL ) .and. ::oFacCliL:Used()
      ::oFacCliL:End()
   end if
   if !Empty( ::oFacCliP ) .and. ::oFacCliP:Used()
      ::oFacCliP:End()
   end if
   if !Empty( ::oAlbCliT ) .and. ::oAlbCliT:Used()
      ::oAlbCliT:End()
   end if
   if !Empty( ::oAlbCliL ) .and. ::oAlbCliL:Used()
      ::oAlbCliL:End()
   end if
   if !Empty( ::oDbfIva ) .and. ::oDbfIva:Used()
      ::oDbfIva:End()
   end if
   if !Empty( ::oAntCliT ) .and. ::oAntCliT:Used()
      ::oAntCliT:End()
   end if
   if !Empty( ::oFacRecT ) .and. ::oFacRecT:Used()
      ::oFacRecT:End()
   end if
   if !Empty( ::oFacRecL ) .and. ::oFacRecL:Used()
      ::oFacRecL:End()
   end if
   if !Empty( ::oDbfPgo )  .and. ::oDbfPgo:Used()
      ::oDbfPgo:End()
   end if

   ::oTikCliT := nil
   ::oTikCliL := nil
   ::oFacCliT := nil
   ::oFacCliL := nil
   ::oFacCliP := nil
   ::oAlbCliT := nil
   ::oAlbCliL := nil
   ::oDbfIva  := nil
   ::oAntCliT := nil
   ::oFacRecT := nil
   ::oFacRecL := nil
   ::oDbfPgo  := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld )

   if !::StdResource( "INFGEN26" )
      return .f.
   end if

   ::CreateFilter( , ::oDbf, .t. )

   /*
   Monta los clientes de manera automatica
   */

   if !::oDefCliInf( 70, 80, 90, 100, , 600 )
      return .f.
   end if

   /*
   Damos valor al meter
   */

   ::oDefExcInf()

   ::oDefResInf()

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   local Seconds  := Seconds()
   local nLasTik  := ::oTikCliT:Lastrec()
   local nLasAlb  := ::oAlbCliT:Lastrec()
   local nLasFac  := ::oFacCliT:Lastrec()
   local nLasRec  := ::oFacRecT:Lastrec()
   local cExpHead := ""
   local aTotTmp

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   ::oMtrInf:SetTotal( nLasTik )
   ::oMtrInf:cText   := "Procesando tikets"

   ::aHeader         := {  {|| "Fecha   : " + Dtoc( Date() ) },;
                           {|| "Periodo : " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                           {|| "Cliente : " + AllTrim ( ::cCliOrg )+ " > " + AllTrim ( ::cCliDes ) } }

   ::oTikCliT:OrdSetFocus( "dFecTik" )

   cExpHead          := 'dFecTik >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecTik <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
   cExpHead          += ' .and. ( cTipTik == "1" .or. cTipTik == "4" )'

   if !::lAllCli
      cExpHead       += ' .and. cCliTik >= "' + Rtrim( ::cCliOrg ) + '" .and. cCliTik <= "' + Rtrim( ::cCliDes ) + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter 
   end if

   ::oTikCliT:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oTikCliT:cFile ), ::oTikCliT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oTikCliT:OrdKeyCount() )

   /*
    Recorremos tikets
   */

  ::oTikCliT:GoTop()

   WHILE !::lBreak .and. !::oTikCliT:Eof()

      IF lChkSer( ::oTikCliT:cSerTik, ::aSer )

         /*
         Posicionamos en las lineas de detalle --------------------------------
         */

         aTotTmp              := aTotTik( ::oTikCliT:cSerTik + ::oTikCliT:cNumTik + ::oTikCliT:cSufTik, ::oTikCliT:cAlias, ::oTikCliL:cAlias, ::oDbfDiv:cAlias, nil, ::cDivInf )

         if !( ::lExcCero .AND. aTotTmp[3] == 0 )

            ::oDbf:Append()

            ::oDbf:cCodCli    := ::oTikCliT:cCliTik
            ::oDbf:dFecMov    := ::oTikCliT:dFecTik
            ::oDbf:cCodCaj    := ::oTikCliT:cNcjTik

            ::oDbf:nTotNet    := if( ::oTikCliT:cTipTik == "4", - aTotTmp[1], aTotTmp[1] )
            ::oDbf:nTotIva    := if( ::oTikCliT:cTipTik == "4", - aTotTmp[2], aTotTmp[2] )
            ::oDbf:nTotDoc    := if( ::oTikCliT:cTipTik == "4", - aTotTmp[3], aTotTmp[3] )
            ::oDbf:cDocMov    := ::oTikCliT:cSerTik + ::oTikCliT:cNumTik + ::oTikCliT:cSufTik
            ::oDbf:cTipDoc    := "Tiket"
            ::oDbf:cFPago     := ::oTikCliT:cFpgTik
            ::oDbf:cDesFPago  := oRetFld( ::oTikCliT:cFpgTik, ::oDbfPgo )
            ::oDbf:cEstado    := if( ::oTikCliT:lPgdTik, "Liquidado", "Pendiente" )

            ::AddCliente( ::oTikCliT:cCliTik, ::oTikCliT, .t. )

            ::oDbf:Save()

         end if

      end if

      ::oTikCliT:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oTikCliT:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oTikCliT:cFile ) )

   ::oAlbCliT:OrdSetFocus( "dFecAlb" )

   cExpHead       := 'nFacturado < 3 .and. dFecAlb >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecAlb <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   if !::lAllCli
      cExpHead    += ' .and. cCodCli >= "' + Rtrim( ::cCliOrg ) + '" .and. cCodCli <= "' + Rtrim( ::cCliDes ) + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter ) 
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oAlbCliT:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oAlbCliT:cFile ), ::oAlbCliT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oAlbCliT:OrdKeyCount() )

   /*
   Recorremos albaranes
   */

   ::oAlbCliT:GoTop()
   ::oMtrInf:cText := "Procesando albaranes"

   WHILE !::lBreak .and. !::oAlbCliT:Eof()

      if lChkSer( ::oAlbCliT:cSerAlb, ::aSer )

         /*
         Posicionamos en las lineas de detalle --------------------------------
         */

         aTotTmp              := aTotAlbCli( ::oAlbCliT:CSERALB + Str( ::oAlbCliT:NNUMALB ) + ::oAlbCliT:CSUFALB, ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias, ::cDivInf  )

         if !( ::lExcCero .AND. aTotTmp[4] == 0 )

            ::oDbf:Append()

            ::oDbf:cCodCli    := ::oAlbCliT:cCodCli
            ::oDbf:cNomCli    := ::oAlbCliT:cNomCli
            ::oDbf:dFecMov    := ::oAlbCliT:dFecAlb
            ::oDbf:cCodCaj    := ::oAlbCliT:cCodCaj

            ::oDbf:nTotNet    := aTotTmp[1] - aTotTmp[5] - aTotTmp[6]
            ::oDbf:nTotIva    := aTotTmp[2]
            ::oDbf:nTotReq    := aTotTmp[3]
            ::oDbf:nTotDoc    := aTotTmp[4]
            ::oDbf:nTotPnt    := aTotTmp[5]
            ::oDbf:nTotTrn    := aTotTmp[6]
            ::oDbf:cDocMov    := ::oAlbCliT:cSerAlb + Str( ::oAlbCliT:nNumAlb ) + ::oAlbCliT:cSufAlb
            ::oDbf:cTipDoc    := "Albarán"
            ::oDbf:cFPago     := ::oAlbCliT:cCodPago
            ::oDbf:cDesFPago  := oRetFld( ::oAlbCliT:cCodPago, ::oDbfPgo )
            ::oDbf:cEstado    := "No facturado"

            ::AddCliente( ::oAlbCliT:cCodCli, ::oAlbCliT, .f. )

            ::oDbf:Save()

         end if

      end if

      ::oMtrInf:AutoInc()

      ::oAlbCliT:Skip()

   end while

   ::oAlbCliT:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oAlbCliT:cFile ) )

   ::oFacCliT:OrdSetFocus( "dFecFac" )

   cExpHead       := 'dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   if !::lAllCli
      cExpHead    += ' .and. cCodCli >= "' + Rtrim( ::cCliOrg ) + '" .and. cCodCli <= "' + Rtrim( ::cCliDes ) + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oFacCliT:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oFacCliT:cFile ), ::oFacCliT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oFacCliT:OrdKeyCount() )

   ::oFacCliT:GoTop()
   ::oMtrInf:cText := "Procesando factura"

   WHILE !::lBreak .and. !::oFacCliT:Eof()

      if lChkSer( ::oFacCliT:CSERIE, ::aSer )

         aTotTmp              := aTotFacCli (::oFacCliT:cSerie + str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac, ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias, ::oFacCliP:cAlias, ::oAntCliT:cAlias, ::cDivInf )

         if !( ::lExcCero .AND. aTotTmp[4]== 0 )

            ::oDbf:Append()

            ::oDbf:cCodCli    := ::oFacCliT:cCodCli
            ::oDbf:cNomCli    := ::oFacCliT:cNomCli
            ::oDbf:dFecMov    := ::oFacCliT:dFecFac
            ::oDbf:cCodCaj    := ::oFacCliT:cCodCaj

            ::oDbf:nTotNet    := aTotTmp[1] - aTotTmp[5] - aTotTmp[6]
            ::oDbf:nTotIva    := aTotTmp[2]
            ::oDbf:nTotReq    := aTotTmp[3]
            ::oDbf:nTotDoc    := aTotTmp[4]
            ::oDbf:nTotPnt    := aTotTmp[5]
            ::oDbf:nTotTrn    := aTotTmp[6]
            ::oDbf:cDocMov    := ::oFacCliT:CSERIE + Str( ::oFacCliT:NNUMFAC ) + ::oFacCliT:CSUFFAC
            ::oDbf:cTipDoc    := "Factura"
            ::oDbf:cFPago     := ::oFacCliT:cCodPago
            ::oDbf:cDesFPago  := oRetFld( ::oFacCliT:cCodPago, ::oDbfPgo )
            ::oDbf:cEstado    := if( ::oFacCliT:lLiquidada, "Liquidada", "Pendiente" )

            ::AddCliente( ::oFacCliT:cCodCli, ::oFacClit, .f. )

            ::oDbf:Save()

         end if

      end if

      ::oMtrInf:AutoInc()

      ::oFacCliT:Skip()

   end while

   ::oFacCliT:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oFacCliT:cFile ) )

   ::oFacRecT:OrdSetFocus( "dFecFac" )

   cExpHead       := 'dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   if !::lAllCli
      cExpHead    += ' .and. cCodCli >= "' + Rtrim( ::cCliOrg ) + '" .and. cCodCli <= "' + Rtrim( ::cCliDes ) + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter 
   end if

   ::oFacRecT:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oFacRecT:cFile ), ::oFacRecT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oFacRecT:OrdKeyCount() )

   ::oFacRecT:GoTop()

   while !::lBreak .and.!::oFacRecT:Eof()

      if lChkSer( ::oFacRecT:cSerie, ::aSer )

         ::oDbf:Append()

         ::oDbf:cCodCli    := ::oFacRecT:cCodCli
         ::oDbf:cNomCli    := ::oFacRecT:cNomCli
         ::oDbf:cCodCaj    := ::oFacRecT:cCodCaj

         ::AddCliente( ::oFacRecT:cCodCli, ::oFacRecT, .f. )
         ::oDbf:dFecMov    := ::oFacRecT:dFecFac

         aTotTmp           := aTotFacRec (::oFacRecT:cSerie + Str( ::oFacRecT:nNumFac ) + ::oFacRecT:cSufFac, ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias, ::cDivInf )

         ::oDbf:nTotNet    := aTotTmp[1] - aTotTmp[5] - aTotTmp[6]
         ::oDbf:nTotIva    := aTotTmp[2]
         ::oDbf:nTotReq    := aTotTmp[3]
         ::oDbf:nTotDoc    := aTotTmp[4]
         ::oDbf:nTotPnt    := aTotTmp[5]
         ::oDbf:nTotTrn    := aTotTmp[6]
         ::oDbf:cDocMov    := ::oFacRecT:cSerie + Str( ::oFacRecT:nNumFac ) + ::oFacRecT:cSufFac
         ::oDbf:cTipDoc    := "Fac. rec."
         ::oDbf:cFPago     := ::oFacRecT:cCodPago
         ::oDbf:cDesFPago  := oRetFld( ::oFacRecT:cCodPago, ::oDbfPgo )
         ::oDbf:cEstado    := if( ::oFacRecT:lLiquidada, "Liquidada", "Pendiente" )

         ::oDbf:Save()

      end if

      ::oMtrInf:AutoInc()

      ::oFacRecT:Skip()

   end while

   ::oFacRecT:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oFacRecT:cFile ) )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//