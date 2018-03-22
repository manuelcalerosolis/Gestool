#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"
//---------------------------------------------------------------------------//

CLASS TDiaCAnt FROM TInfGen

   DATA  lExcCero    AS LOGIC    INIT .f.
   DATA  lExcCredito AS LOGIC    INIT .f.
   DATA  oEstado     AS OBJECT
   DATA  oDbfIva     AS OBJECT
   DATA  oAntCliT    AS OBJECT
   DATA  aEstado     AS ARRAY    INIT  { "Pendientes", "Liquidados", "Todos" }

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::FldDiario( .f. )
   ::AddField( "dFecLiq", "D", 8, 0, {|| "@!" }, "Fec.Liq.", .t., "Fecha liquidación", 10 )

   if ::xOthers
   ::AddTmpIndex( "CCODCLI", "CCODCLI" )
   ::AddGroup( {|| ::oDbf:cCodCli }, {|| "Cliente  : " + Rtrim( ::oDbf:cCodCli ) + "-" + oRetFld( ::oDbf:cCodCli, ::oDbfCli ) } )
   else
   ::AddTmpIndex( "DFECMOV", "DFECMOV" )
   end if

   ::dIniInf := GetSysDate()

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS TDiaCAnt

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   DATABASE NEW ::oAntCliT  PATH ( cPatEmp() ) FILE "ANTCLIT.DBF" VIA ( cDriver() ) SHARED INDEX "ANTCLIT.CDX"

   DATABASE NEW ::oDbfIva   PATH ( cPatDat() ) FILE "TIVA.DBF"    VIA ( cDriver() ) SHARED INDEX "TIVA.CDX"

   RECOVER

      msgStop( 'Imposible abrir todas las bases de datos' )
      ::CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TDiaCAnt

   if !Empty( ::oAntCliT ) .and. ::oAntCliT:Used()
      ::oAntCliT:End()
   end if

   if !Empty( ::oDbfIva ) .and. ::oDbfIva:Used()
      ::oDbfIva:End()
   end if

   ::oAntCliT := nil
   ::oDbfIva  := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld ) CLASS TDiaCAnt

   local cEstado := "Todos"

   if !::StdResource( "INF_GEN05" )
      return .f.
   end if

   /*
   Monta los obras de manera automatica
   */

   if !::oDefCliInf( 70, 80, 90, 100, , 600 )
      return .f.
   end if

   /*
   Damos valor al meter
   */

   ::oMtrInf:SetTotal( ::oAntCliT:Lastrec() )

   ::oDefExcInf()

   REDEFINE CHECKBOX ::lExcCredito ;
      ID       191;
      OF       ::oFld:aDialogs[1]

   REDEFINE COMBOBOX ::oEstado ;
      VAR      cEstado ;
      ID       218 ;
      ITEMS    ::aEstado ;
      OF       ::oFld:aDialogs[1]

   ::CreateFilter( aItmAntCli(), ::oAntCliT:cAlias )

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate() CLASS TDiaCAnt

   local bValid
   local aTotTmp
   local lExcCero := .f.
   local cExpHead := ""

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   ::aHeader         := {  {|| "Fecha   : " + Dtoc( Date() ) },;
                           {|| "Periodo : " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                           {|| "Cliente : " + if( ::lAllCli, "Todos", AllTrim( ::cCliOrg )+ " > " + AllTrim( ::cCliDes ) ) },;
                           {|| "Estado  : " + ::aEstado[ ::oEstado:nAt ] } }

   cExpHead          := 'dFecAnt >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecAnt <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   do case
      case ::oEstado:nAt == 1
         cExpHead    += ' .and. !lLiquidada'
      case ::oEstado:nAt == 2
         cExpHead    += ' .and. lLiquidada'
   end case

   if !::lAllCli
      cExpHead       += ' .and. cCodCli >= "' + Rtrim( ::cCliOrg ) + '" .and. cCodCli <= "' + Rtrim( ::cCliDes ) + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oAntCliT:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oAntCliT:cFile ), ( ::oAntCliT:OrdKey() ), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oAntCliT:OrdKeyCount() )

   /*
   Nos movemos por las cabeceras de los albaranes a clientes-------------------
	*/

   ::oAntCliT:GoTop()

   while !::lBreak .and. !::oAntCliT:Eof()

      if lChkSer( ::oAntCliT:cSerAnt, ::aSer )                  .and.;
         if( ::lExcCredito, lClienteBloquearRiesgo( ::oAntCliT:cCodCli, ::oDbfCli:cAlias ), .t. )

         /*
         Posicionamos en las lineas de detalle --------------------------------
         */

         ::oDbf:Append()

         ::oDbf:cCodCli := ::oAntCliT:cCodCli
         ::oDbf:cNomCli := ::oAntCliT:cNomCli
         ::oDbf:dFecMov := ::oAntCliT:dFecAnt
         ::oDbf:dFecLiq := ::oAntCliT:dLiquidada

         aTotTmp        := aTotAntCli( ::oAntCliT:cAlias,  ::oDbfIva:cAlias, ::oDbfDiv:cAlias )

         ::oDbf:nTotNet := aTotTmp[1]
         ::oDbf:nTotIva := aTotTmp[2]
         ::oDbf:nTotReq := aTotTmp[3]
         ::oDbf:nTotDoc := aTotTmp[5]

         ::oDbf:cDocMov := ::oAntCliT:cSerAnt + "/" + Alltrim( Str( ::oAntCliT:nNumAnt ) ) + "/" + ::oAntCliT:cSufAnt

         ::AddCliente( ::oAntCliT:cCodCli, ::oAntCliT, .f. )

         ::oDbf:Save()

      end if

      ::oMtrInf:AutoInc( ::oAntCliT:OrdKeyNo() )

      ::oAntCliT:Skip()

   end while

   ::oAntCliT:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oAntCliT:cFile ) )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//