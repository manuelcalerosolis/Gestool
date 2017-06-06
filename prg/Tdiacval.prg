#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"
//---------------------------------------------------------------------------//

CLASS TDiaCVal FROM TInfGen

   DATA  lExcCero    AS LOGIC    INIT .f.
   DATA  oEstado     AS OBJECT
   DATA  oDbfIva     AS OBJECT
   DATA  oTikCliP    AS OBJECT
   DATA  oTikCliT    AS OBJECT
   DATA  oTikCliL    AS OBJECT
   DATA  aEstado     AS ARRAY    INIT  { "Liquidados", "Pendientes", "Todos" }

   METHOD Create ()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField( "cTipTik", "C", 12, 0, {|| "@!" },        "Tip. doc.",     .t., "Tipo documento",      12, .f. )
   ::FldDiario( .t. )
   ::AddField( "nCobTik", "N", 16, 6, {|| ::cPicOut },   "Cobrado",       .t., "Cobrado Vale",        10, .t. )

   if ::xOthers
   ::AddTmpIndex( "CCODCLI", "CCODCLI" )
   ::AddGroup( {|| ::oDbf:cCodCli }, {|| "Cliente  : " + Rtrim( ::oDbf:cCodCli ) + "-" + oRetFld( ::oDbf:cCodCli, ::oDbfCli ) } )
   else
   ::AddTmpIndex( "DFECMOV", "Dtos( DFECMOV ) + CDOCMOV" )
   end if

   ::dIniInf := GetSysDate()

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS TDiaCVal

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

METHOD CloseFiles() CLASS TDiaCVal

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

   ::oTikCliT     := nil
   ::oTikCliL     := nil
   ::oTikCliP     := nil
   ::oDbfIva      := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld ) CLASS TDiaCVal

   local cEstado := "Todos"

   if !::StdResource( "INF_GEN26B" )
      return .f.
   end if

   /*
   Monta los clientes de manera automatica
   */

   if !::oDefCliInf( 70, 80, 90, 100, , 600 )
      return .f.
   end if

   /*
   Damos valor al meter
   */

   ::oMtrInf:SetTotal( ::oTikCliT:Lastrec() )

   REDEFINE COMBOBOX ::oEstado ;
      VAR      cEstado ;
      ID       400 ;
      ITEMS    ::aEstado ;
      OF       ::oFld:aDialogs[1]

   ::oDefExcInf()

   ::CreateFilter( aItmTik(), ::oTikCliT:cAlias )

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate() CLASS TDiaCVal

   local lExcCero := .f.
   local aTotTmp  := {}
   local cExpHead := ""

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   ::oTikCliT:GoTop()

   ::aHeader      := {  {|| "Fecha   : " + Dtoc( Date() ) },;
                        {|| "Periodo : " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                        {|| "Cliente : " + AllTrim ( ::cCliOrg ) + " > " + AllTrim ( ::cCliDes ) },;
                        {|| "Estado  : " + ::aEstado[ ::oEstado:nAt ] } }

   ::oTikCliT:OrdSetFocus( "dFecTik" )

   cExpHead       := 'cTipTik == "6" .and. dFecTik >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecTik <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   if !::lAllCli
      cExpHead    += ' .and. cCliTik >= "' + Rtrim( ::cCliOrg ) + '" .and. cCliTik <= "' + Rtrim( ::cCliDes ) + '"'
   end if

   do case
   case ::oEstado:nAt == 1
      cExpHead    += ' .and. lLiqTik'
   case ::oEstado:nAt == 2
      cExpHead    += ' .and. !lLiqTik'
   end case

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oTikCliT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oTikCliT:cFile ), ::oTikCliT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oTikCliT:OrdKeyCount() )

   ::oTikCliT:GoTop()
   while !::lBreak .and. !::oTikCliT:Eof()

      if lChkSer( ::oTikCliT:cSerTik, ::aSer )

         /*
         Posicionamos en las lineas de detalle --------------------------------
         */

         aTotTmp  := aTotTik( ::oTikCliT:cSerTik + ::oTikCliT:cNumTik + ::oTikCliT:cSufTik, ::oTikCliT:cAlias, ::oTikCliL:cAlias, ::oDbfDiv:cAlias, nil, ::cDivInf )

         if !( ::lExcCero .AND. aTotTmp[ 3 ]== 0 )

            ::oDbf:Append()

            ::oDbf:cCodCli := ::oTikCliT:cCliTik
            ::oDbf:dFecMov := ::oTikCliT:dFecTik

            ::oDbf:nTotNet := aTotTmp[1]
            ::oDbf:nTotIva := aTotTmp[2]
            ::oDbf:nTotDoc := aTotTmp[3]
            ::oDbf:cDocMov := ::oTikCliT:cSerTik + ::oTikCliT:cNumTik + ::oTikCliT:cSufTik
            ::oDbf:nCobTik := nTotCobTik( ::oTikCliT:cSerTik + ::oTikCliT:cNumTik + ::oTikCliT:cSufTik, ::oTikCliP:cAlias, ::oDbfDiv:cAlias )

            ::AddCliente( ::oTikCliT:cCliTik, ::oTikCLiT, .t. )
            ::oDbf:cTipTik := "Vale"
            ::oDbf:Save()

         end if

      end if

      ::oMtrInf:AutoInc()

      ::oTikCliT:Skip()

   end while

   ::oTikCliT:IdxDelete( cCurUsr(), GetFileNoExt( ::oTikCliT:cFile ) )

   ::oMtrInf:SetTotal( ::oTikCliT:Lastrec() )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//