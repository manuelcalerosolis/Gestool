#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"
//---------------------------------------------------------------------------//

CLASS TDiaXAlb FROM TInfGen

   DATA  lExcCero    AS LOGIC    INIT .f.
   DATA  oEstado     AS OBJECT
   DATA  oDbfIva     AS OBJECT
   DATA  oAlbCliT    AS OBJECT
   DATA  oAlbCliL    AS OBJECT
   DATA  oDbfCli     AS OBJECT
   DATA  aEstado     AS ARRAY    INIT  { "No facturado", "Facturado", "Todos" }
   DATA  lExcCredito AS LOGIC    INIT .f.
   DATA  aEntregado  AS ARRAY    INIT  { "No entregados", "Entregados", "Todos"}
   DATA  oEntregado  AS OBJECT

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD create()

   ::AddField( "cDocMov", "C", 14, 0, {|| "@!" },         "Doc.",           .t., "Documento",                 14 )
   ::AddField( "dFecMov", "D",  8, 0, {|| "@!" },         "Fecha",          .t., "Fecha",                     14 )
   ::AddField( "cCodGrC", "C", 12, 0, {|| "@!" },         "Grp. Cli.",      .f., "Grupo cliente",              8 )
   ::AddField( "cNomGrC", "C", 50, 0, {|| "@!" },         "Nombre",         .f., "Nombre grupo cliente",      25 )
   ::FldCliente()
   ::AddField( "nTotNet", "N", 16, 6, {|| ::cPicOut },    "Neto",           .t., "Neto",                      10 )
   ::AddField( "nTotPnt", "N", 16, 6, {|| ::cPicPnt },    "P.V.",           .f., "Punto Verde",               10 )
   ::AddField( "nTotTrn", "N", 16, 6, {|| ::cPicOut },    "Transp.",        .f., "Transporte",                10 )
   ::AddField( "nTotIva", "N", 16, 6, {|| ::cPicOut },    cImp(),            .t., cImp(),                       10 )
   ::AddField( "nTotReq", "N", 16, 3, {|| ::cPicOut },    "Rec",            .t., "Rec",                       10 )
   ::AddField( "nTotDoc", "N", 16, 6, {|| ::cPicOut },    "Total",          .t., "Total",                     10 )
   ::AddField( "cTipVen", "C", 20, 0, {|| "@!" },         "Venta",          .f., "Tipo de venta",             20 )
   ::AddField( "dFecEnt", "D",  8, 0, {|| "@!" },         "Fec. entrega",   .t., "Fecha de entrega",          10 )

   ::AddTmpIndex( "cCodGrC", "cCodGrC + cDocMov" )

   ::AddGroup( {|| ::oDbf:cCodGrC }, {|| "Grupo clientes  : " + Rtrim( ::oDbf:cCodGrC ) + "-" + Rtrim( ::oDbf:cNomGrC ) }, {||"Total grupo clientes..."} )

   ::dIniInf := GetSysDate()

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS TDiaXAlb

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   ::oAlbCliT := TDataCenter():oAlbCliT()

   DATABASE NEW ::oAlbCliL  PATH ( cPatEmp() ) FILE "ALBCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "ALBCLIL.CDX"

   DATABASE NEW ::oDbfIva   PATH ( cPatDat() ) FILE "TIVA.DBF"  VIA ( cDriver() ) SHARED INDEX "TIVA.CDX"

   DATABASE NEW ::oDbfCli PATH ( cPatEmp() ) FILE "CLIENT.DBF" VIA ( cDriver() ) SHARED INDEX "CLIENT.CDX"

   RECOVER

      msgStop( 'Imposible abrir todas las bases de datos' )
      ::CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TDiaXAlb

   if !Empty( ::oAlbCliT ) .and. ::oAlbCliT:Used()
      ::oAlbCliT:End()
   end if
   if !Empty( ::oAlbCliL ) .and. ::oAlbCliL:Used()
      ::oAlbCliL:End()
   end if
   if !Empty( ::oDbfIva ) .and. ::oDbfIva:Used()
      ::oDbfIva:End()
   end if
   if !Empty( ::oDbfCli ) .and. ::oDbfCli:Used()
      ::oDbfCli:End()
   end if

   ::oAlbCliT := nil
   ::oAlbCliL := nil
   ::oDbfIva  := nil
   ::oDbfCli  := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld ) CLASS TDiaXAlb

   local cEstado    := "Todos"
   local cEntregado := "Todos"

   if !::StdResource( "INFDIAGRP" )
      return .f.
   end if

   /*
   Monta los grupos de clientes de manera automatica
   */

   if !::oDefGrpCli( 70, 80, 90, 100, 160 )
      return .f.
   end if

   /*
   Damos valor al meter
   */

   ::oMtrInf:SetTotal( ::oAlbCliT:Lastrec() )

   ::oDefExcInf()

   REDEFINE CHECKBOX ::lExcCredito ;
      ID       191;
      OF       ::oFld:aDialogs[1]

   REDEFINE COMBOBOX ::oEstado ;
      VAR      cEstado ;
      ID       218 ;
      ITEMS    ::aEstado ;
      OF       ::oFld:aDialogs[1]

   REDEFINE COMBOBOX ::oEntregado ;
      VAR      cEntregado ;
      ID       219 ;
      ITEMS    ::aEntregado ;
      OF       ::oFld:aDialogs[1]

   ::CreateFilter( aItmAlbCli(), ::oAlbCliT:cAlias )

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate() CLASS TDiaXAlb

   local bValid       := {|| .t. }
   local bVEntregado  := {|| .t. }
   local lExcCero     := .f.
   local aTotTmp      := {}
   local cGrpCli
   local cExpHead     := ""

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   ::aHeader   := {  {|| "Fecha     : " + Dtoc( Date() ) },;
                     {|| "Periodo   : " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                     {|| "Grp. Cli. : " + if( ::lGrpAll, "Todos", Alltrim( ::cGrpOrg ) + " > " + Alltrim( ::cGrpDes ) ) },;
                     {|| "Estado    : " + ::aEstado[ ::oEstado:nAt ] },;
                     {|| "Entregado : " + ::aEntregado[ ::oEntregado:nAt ] } }

   ::oAlbCliT:OrdSetFocus( "dFecAlb" )

   do case
      case ::oEstado:nAt == 1
         cExpHead    += 'nFacturado < 3'
      case ::oEstado:nAt == 2
         cExpHead    += 'nFacturado == 3'
      case ::oEstado:nAt == 3
         cExpHead    += '.t.'
   end case

   do case
      case ::oEntregado:nAt == 1
         cExpHead    += ' .and. !lEntregado'
      case ::oEntregado:nAt == 2
         cExpHead    += ' .and. lEntregado'
      case ::oEntregado:nAt == 3
         cExpHead    += ' .and. .t.'
   end case

   if ::oEntregado:nAt != 2
      cExpHead       += ' .and. dFecAlb >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecAlb <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
   else
      cExpHead       += ' .and. dFecEnv >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecEnv <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
   end if

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oAlbCliT:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oAlbCliT:cFile ), ::oAlbCliT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oAlbCliT:OrdKeyCount() )

   /*
   Nos movemos por las cabeceras de los albaranes
	*/

   ::oAlbCliT:GoTop()

   WHILE !::lBreak .and. !::oAlbCliT:Eof()

      cGrpCli := cGruCli( ::oAlbCliT:cCodCli, ::oDbfCli )

      if ( ::lGrpAll .or. ( cGrpCli >= ::cGrpOrg .AND. cGrpCli <= ::cGrpDes ) )    .AND.;
         if( ::lExcCredito, lCliChg( cGrpCli, ::oGrpCli:oDbf ), .t. )              .AND.;
         lChkSer( ::oAlbCliT:cSerAlb, ::aSer )

         /*
         Posicionamos en las lineas de detalle --------------------------------
         */

         ::oDbf:Append()

         ::oDbf:cCodGrC := cGrpCli
         ::oDbf:cNomGrC := oRetFld( cGrpCli, ::oGrpCli:oDbf)
         ::oDbf:dFecMov := ::oAlbCliT:dFecAlb
         ::oDbf:dFecEnt := ::oAlbCliT:dFecEnt
         ::AddCliente( ::oAlbCliT:cCodCli, ::oAlbCliT, .f. )

         aTotTmp        := aTotAlbCli( ::oAlbCliT:cSerAlb + Str( ::oAlbCliT:nNumAlb ) + ::oAlbCliT:cSufAlb, ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias, ::cDivInf  )

         ::oDbf:nTotNet := aTotTmp[1] - aTotTmp[5] - aTotTmp[6]
         ::oDbf:nTotIva := aTotTmp[2]
         ::oDbf:nTotReq := aTotTmp[3]
         ::oDbf:nTotDoc := aTotTmp[4]
         ::oDbf:nTotPnt := aTotTmp[5]
         ::oDbf:nTotTrn := aTotTmp[6]
         ::oDbf:cDocMov := lTrim ( ::oAlbCliT:cSerAlb ) + "/" + lTrim ( Str( ::oAlbCliT:nNumAlb ) ) + "/" + lTrim ( ::oAlbCliT:cSufAlb )

         ::oDbf:Save()

      end if

      ::oMtrInf:AutoInc()

      ::oAlbCliT:Skip()

   end while

   ::oMtrInf:SetTotal( ::oAlbCliT:Lastrec() )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//