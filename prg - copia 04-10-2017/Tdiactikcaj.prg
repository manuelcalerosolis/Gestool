#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"
//---------------------------------------------------------------------------//

CLASS TDiaCTikCaj FROM TInfGen

   DATA  lExcCero    AS LOGIC    INIT .f.
   DATA  oEstado     AS OBJECT
   DATA  oDbfIva     AS OBJECT
   DATA  oTikCliP    AS OBJECT
   DATA  oTikCliT    AS OBJECT
   DATA  oTikCliL    AS OBJECT

   METHOD Create ()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField( "cTipTik", "C", 12, 0, {|| "@!" },        "Tip. doc.",     .t., "Tipo documento",      12, .f. )
   ::AddField( "cCodCaj", "C",  3, 0, {|| "@!" },        "Cod.Caj.",      .f., "Código de la caja",   12, .f. )
   ::AddField( "cNomCaj", "C", 30, 0, {|| "@!" },        "Caja",          .f., "Nombre de la caja",   12, .f. )
   ::FldDiario( .t. )
   ::AddField( "nCobTik", "N", 16, 6, {|| ::cPicOut },   "Cobrado",       .t., "Cobrado tiket",       10, .t. )

   ::AddTmpIndex( "CCODCAJ", "CCODCAJ" )
   ::AddGroup( {|| ::oDbf:cCodCaj }, {|| "Caja  : " + Rtrim( ::oDbf:cCodCaj ) + "-" + Rtrim( ::oDbf:cNomCaj ) } )

   ::dIniInf := GetSysDate()

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   DATABASE NEW ::oTikCliT  PATH ( cPatEmp() ) FILE "TIKET.DBF" VIA ( cDriver() ) SHARED INDEX "TIKET.CDX"

   DATABASE NEW ::oTikCliL  PATH ( cPatEmp() ) FILE "TIKEL.DBF" VIA ( cDriver() ) SHARED INDEX "TIKEL.CDX"

   DATABASE NEW ::oDbfIva   PATH ( cPatDat() ) FILE "TIVA.DBF"  VIA ( cDriver() ) SHARED INDEX "TIVA.CDX"

   DATABASE NEW ::oTikCliP  PATH ( cPatEmp() ) FILE "TIKEP.DBF" VIA ( cDriver() ) SHARED INDEX "TIKEP.CDX"

   RECOVER

      msgStop( 'Imposible abrir todas las bases de datos' )
      ::CloseFiles()
      lOpen       := .f.

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
   if !Empty( ::oTikCliP ) .and. ::oTikCliP:Used()
   ::oTikCliP:End()
   end if
   if !Empty( ::oDbfIva ) .and. ::oDbfIva:Used()
   ::oDbfIva:End()
   end if

   ::oTikCliT := nil
   ::oTikCliL := nil
   ::oTikCliP := nil
   ::oDbfIva  := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld )

   if !::StdResource( "INF_GEN26C" )
      return .f.
   end if

   if !::oDefCajInf( 220, 221, 230, 231, 210 )
      return .f.
   end if

   if !::oDefCliInf( 70, 80, 90, 100, , 600 )
      return .f.
   end if

   /*
   Damos valor al meter
   */

   ::oMtrInf:SetTotal( ::oTikCliT:Lastrec() )

   ::oDefExcInf()

   ::CreateFilter( aItmTik(), ::oTikCliT:cAlias )

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   local aTotTmp  := {}
   local cExpHead := ""

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   ::aHeader      := {  {|| "Fecha   : " + Dtoc( Date() ) },;
                        {|| "Periodo : " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                        {|| "Cajas   : " + if( ::lAllCaj, "Todos", AllTrim ( ::cCajOrg ) + " > " + AllTrim ( ::cCajDes ) ) },;
                        {|| "Cliente : " + if( ::lAllCli, "Todos", AllTrim ( ::cCliOrg ) + " > " + AllTrim ( ::cCliDes ) ) } }

   ::oTikCliT:OrdSetFocus( "dFecTik" )

   cExpHead       := 'dFecTik >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecTik <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
   cExpHead       += ' .and. ( cTipTik == "1" .or. cTipTik == "4" )'

   if !::lAllCaj
      cExpHead    += ' .and. cNcjTik >= "' + Rtrim( ::cCajOrg ) + '" .and. cNcjTik <= "' + Rtrim( ::cCajDes ) + '"'
   end if

   if !::lAllCli
      cExpHead    += ' .and. cCliTik >= "' + Rtrim( ::cCliOrg ) + '" .and. cCliTik <= "' + Rtrim( ::cCliDes ) + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead    += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oTikCliT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oTikCliT:cFile ), ::oTikCliT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oTikCliT:OrdKeyCount() )

   ::oTikCliT:GoTop()

   while !::lBreak .and. !::oTikCliT:Eof()

      if lChkSer( ::oTikCliT:cSerTik, ::aSer )

         /*
         Posicionamos en las lineas de detalle --------------------------------
         */

         aTotTmp        := aTotTik( ::oTikCliT:cSerTik + ::oTikCliT:cNumTik + ::oTikCliT:cSufTik, ::oTikCliT:cAlias, ::oTikCliL:cAlias, ::oDbfDiv:cAlias, nil, ::cDivInf )

         if !( ::lExcCero .AND. aTotTmp[3]== 0 )

            ::oDbf:Append()

            ::oDbf:cCodCli := ::oTikCliT:cCliTik
            ::oDbf:dFecMov := ::oTikCliT:dFecTik

            ::oDbf:nTotNet := if( ::oTikCliT:cTipTik == "4", - aTotTmp[1], aTotTmp[1] )
            ::oDbf:nTotIva := if( ::oTikCliT:cTipTik == "4", - aTotTmp[2], aTotTmp[2] )
            ::oDbf:nTotDoc := if( ::oTikCliT:cTipTik == "4", - aTotTmp[3], aTotTmp[3] )
            ::oDbf:cDocMov := ::oTikCliT:cSerTik + ::oTikCliT:cNumTik + ::oTikCliT:cSufTik
            ::oDbf:nCobTik := nTotCobTik( ::oTikCliT:cSerTik + ::oTikCliT:cNumTik + ::oTikCliT:cSufTik, ::oTikCliP:cAlias, ::oDbfDiv:cAlias )

            ::oDbf:cCodCaj := ::oTikCliT:cNcjTik
            ::oDbf:cNomCaj := oRetFld( ::oTikCliT:cNcjTik, ::oDbfCaj )

            ::AddCliente( ::oTikCliT:cCliTik, ::oTikCLiT, .t. )
            ::oDbf:cTipTik := "Tiket"
            ::oDbf:Save()

         end if

      end if

      ::oMtrInf:AutoInc()

      ::oTikCliT:Skip()

   end while

   ::oTikCliT:IdxDelete( cCurUsr(), GetFileNoExt( ::oTikCliT:cFile ) )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//