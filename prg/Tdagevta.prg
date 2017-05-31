#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TdAgeVta FROM TInfPAge

   DATA  oTikCliT    AS OBJECT
   DATA  oTikCliL    AS OBJECT
   DATA  oAlbCliT    AS OBJECT
   DATA  oAlbCliL    AS OBJECT
   DATA  oFacCliT    AS OBJECT
   DATA  oFacCliL    AS OBJECT
   DATA  oFacCliP    AS OBJECT
   DATA  oFacRecT    AS OBJECT
   DATA  oFacRecL    AS OBJECT
   DATA  oAntCliT    AS OBJECT
   DATA  oDbfIva     AS OBJECT
   DATA  oOrdenado   AS OBJECT
   DATA  cOrdenado   AS CHARACTER     INIT  "Fechas"
   DATA  aOrdenado   AS ARRAY    INIT  { "Clientes", "Fechas", "Documento" }

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField( "cCodAge", "C",  3, 0, {|| "@!" },        "Cód. age.",        .f., "Cod. agente",         3 )
   ::AddField( "cNomAge", "C", 50, 0, {|| "@!" },        "Agente",           .f., "Nom. agente",        25 )
   ::FldCliente()
   ::AddField( "cNumDoc", "C", 20, 0, {|| "" },          "Doc.",             .t., "Documento",          20 )
   ::AddField( "dFecDoc", "D",  8, 0, {|| "" },          "Fecha",            .t., "Fecha",              12 )
   ::AddField( "nTotNet", "N", 16, 6, {|| ::cPicOut },   "Neto",             .t., "Neto",               12 )
   ::AddField( "nTotIva", "N", 16, 6, {|| ::cPicOut },   cImp(),              .t., cImp(),                12 )
   ::AddField( "nTotReq", "N", 16, 3, {|| ::cPicOut },   "Rec",              .t., "Rec",                12 )
   ::AddField( "nTotPnt", "N", 16, 6, {|| ::cPicPnt },   "Pnt.Ver.",         .f., "Punto verde",        12 )
   ::AddField( "nTotTrn", "N", 16, 6, {|| ::cPicOut },   "Transp.",          .f., "Transporte",         12 )
   ::AddField( "nTotDoc", "N", 16, 6, {|| ::cPicOut },   "Total",            .t., "Total",              12 )
   ::AddField( "nTotCos", "N", 16, 6, {|| ::cPicOut },   "Costo",            .t., "Costo",              12 )
   ::AddField( "nMarGen", "N", 16, 6, {|| ::cPicOut },   "Margen",           .t., "Margen",             12 )
   ::AddField( "nRenTab", "N", 16, 6, {|| ::cPicOut },   "% Ren.",           .t., "% rentabilidad",     12 )
   ::AddField( "nTotPgd", "N", 16, 6, {|| ::cPicOut },   "Pagado",           .t., "Pagado",             12 )
   ::AddField( "nComAge", "N", 13, 6, {|| ::cPicOut },   "Com.Age.",         .t., "Comisión agente",    12 )

   ::AddTmpIndex( "cCodCli", "cCodAge + cCodCli" )
   ::AddTmpIndex( "cCodFec", "cCodAge + DtoS( dFecDoc )" )
   ::AddTmpIndex( "cCodNum", "cCodAge + cNumDoc" )

   ::AddGroup( {|| ::oDbf:cNomAge }, {|| "Agente  : " + Rtrim( ::oDbf:cNomAge ) + "-" + oRetFld( ::oDbf:cNomAge, ::oDbfAge ) }, {||"Total agente..."} )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   DATABASE NEW ::oTikCliT PATH ( cPatEmp() ) CLASS "TIKETT" FILE "TIKET.DBF" VIA ( cDriver() ) SHARED INDEX "TIKET.CDX"

   DATABASE NEW ::oTikCliL PATH ( cPatEmp() ) CLASS "TIKETL" FILE "TIKEL.DBF" VIA ( cDriver() ) SHARED INDEX "TIKEL.CDX"

   ::oAlbCliT := TDataCenter():oAlbCliT()

   DATABASE NEW ::oAlbCliL PATH ( cPatEmp() ) CLASS "ALBCLIL" FILE "ALBCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "ALBCLIL.CDX"

   ::oFacCliT := TDataCenter():oFacCliT()

   DATABASE NEW ::oFacCliL PATH ( cPatEmp() ) CLASS "FACCLIL" FILE "FACCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "FACCLIL.CDX"

   ::oFacCliP := TDataCenter():oFacCliP()

   DATABASE NEW ::oFacRecT PATH ( cPatEmp() ) CLASS "FACRECT" FILE "FACRECT" VIA ( cDriver() ) SHARED INDEX "FACRECT.CDX"

   DATABASE NEW ::oFacRecL PATH ( cPatEmp() ) CLASS "FACRECL" FILE "FACRECL.DBF" VIA ( cDriver() ) SHARED INDEX "FACRECL.CDX"

   DATABASE NEW ::oAntCliT  PATH ( cPatEmp() ) FILE "ANTCLIT.DBF" VIA ( cDriver() ) SHARED INDEX "ANTCLIT.CDX"

   DATABASE NEW ::oDbfIva PATH ( cPatDat () ) FILE "TIVA.DBF" VIA ( cDriver() ) SHARED INDEX "TIVA.CDX"

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos" )
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

   if !Empty( ::oFacRecT ) .and. ::oFacRecT:Used()
      ::oFacRecT:End()
   end if
   if !Empty( ::oFacRecL ) .and. ::oFacRecL:Used()
      ::oFacRecL:End()
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
   if !Empty ( ::oAntCliT ) .and. ::oAntCliT:Used()
      ::oAntCliT:End()
   end if

   ::oTikCliT := nil
   ::oTikCliL := nil
   ::oFacCliT := nil
   ::oFacCliL := nil
   ::oFacCliP := nil
   ::oAntCliT := nil
   ::oAlbCliT := nil
   ::oAlbCliL := nil
   ::oDbfIva  := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld )

   if !::StdResource( "INF_GEN25G" )
      return .f.
   end if

   ::CreateFilter( , ::oDbf, .t. )

   /*
   Monta los agentes de manera automatica
   */

   if !::oDefAgeInf( 70, 80, 90, 100, 930 )
      return .f.
   end if

   /*
   Damos valor al meter
   */

   ::oMtrInf:SetTotal( ::oTikCliT:Lastrec() )

   REDEFINE COMBOBOX ::oOrdenado ;
      VAR      ::cOrdenado ;
      ID       219 ;
      ITEMS    ::aOrdenado ;
      OF       ::oFld:aDialogs[1]

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   local lExcCero := .f.
   local nLasTik  := ::oTikCliT:Lastrec()
   local nLasAlb  := ::oAlbCliT:Lastrec()
   local nLasFac  := ::oFacRecT:Lastrec()
   local aTotal
   local nTotPag
   local cExpHead := ""

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   ::aHeader      := {{|| "Fecha    : "   + Dtoc( Date() ) },;
                      {|| "Periodo  : "   + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                      {|| "Agentes  : "   + ::cAgeOrg         + " > " + ::cAgeDes },;
                      {|| "Ordenado : "   + ::cOrdenado } }

   ::oTikCliT:OrdSetFocus( "dFecTik" )

   /*
   Cabeceras de tikets creamos el indice sobre la cabecera
   */

   cExpHead          := 'dFecTik >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecTik <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   cExpHead          += ' .and. ( cTipTik == "1" .or. cTipTik == "4" )'

   if !::lAgeAll
      cExpHead       += ' .and. cCodAge >= "' + Rtrim( ::cAgeOrg ) + '" .and. cCodAge <= "' + Rtrim( ::cAgeDes ) + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter 
   end if

   ::oTikCliT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oTikCliT:cFile ), ::oTikCliT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:cText   := "Tickets"
   ::oMtrInf:SetTotal( ::oTikCliT:OrdKeyCount() )

   ::oTikCliT:GoTop()

   while !::lBreak .and. !::oTikCliT:Eof()

      if lChkSer( ::oTikCliT:cSerTik, ::aSer )

         ::oDbf:Append()

         ::oDbf:cCodAge    := ::oTikCliT:cCodAge

         if ::oDbfAge:Seek( ::oTikCliT:cCodAge )
            ::oDbf:cNomAge := Rtrim( ::oDbfAge:cApeAge ) + ", " + ::oDbfAge:cNbrAge
         end if

         ::oDbf:cNomAge    := ::oTikCliT:cCodAge

         ::AddCliente( ::oTikCliT:cCliTik, ::oTikCliT, .t. )

         aTotal        := aTotTik( ::oTikCliT:cSerTik + ::oTikCliT:cNumTik + ::oTikCliT:cSufTik, ::oTikCliT:cAlias, ::oTikCliL:cAlias, ::oDbfDiv:cAlias, nil, ::cDivInf )

         ::oDbf:dFecDoc    := ::oTikCliT:dFecTik
         ::oDbf:cNumDoc    := "Tiket:" + lTrim ( ::oTikCliT:cSerTik ) + "/" + lTrim ( ::oTikCliT:cNumTik ) + "/" + lTrim ( ::oTikCliT:cSufTik )
         ::oDbf:nTotNet    := if( ::oTikCliT:cTipTik == "4", - aTotal[1], aTotal[1] )
         ::oDbf:nTotIva    := if( ::oTikCliT:cTipTik == "4", - aTotal[2], aTotal[2] )
         ::oDbf:nTotDoc    := if( ::oTikCliT:cTipTik == "4", - aTotal[3], aTotal[3] )
         ::oDbf:nComAge    := ::oDbf:nTotNet * ::oTikCliT:nComAge / 100

         ::oDbf:nTotCos    := 0
         ::oDbf:nMarGen    := 0
         ::oDbf:nRenTab    := 0

         ::oDbf:Save()

      end if

      ::oTikCliT:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oTikCliT:IdxDelete( cCurUsr(), GetFileNoExt( ::oTikCliT:cFile ) )

   ::oAlbCliT:OrdSetFocus( "dFecAlb" )

   cExpHead          := 'nFacturado < 3 .and. dFecAlb >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecAlb <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   if !::lAgeAll
      cExpHead       += ' .and. cCodAge >= "' + Rtrim( ::cAgeOrg ) + '" .and. cCodAge <= "' + Rtrim( ::cAgeDes ) + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter ) 
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oAlbCliT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oAlbCliT:cFile ), ::oAlbCliT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:cText   := "Albaranes"
   ::oMtrInf:SetTotal( ::oAlbCliT:OrdKeyCount() )

   ::oAlbCliT:GoTop()

   while !::lBreak .and. !::oAlbCliT:Eof()

      if lChkSer( ::oAlbCliT:cSerAlb, ::aSer )

         ::oDbf:Append()

         ::oDbf:cCodAge    := ::oAlbCliT:cCodAge

         if ::oDbfAge:Seek( ::oAlbCliT:cCodAge )
            ::oDbf:cNomAge := Rtrim( ::oDbfAge:cApeAge ) + ", " + ::oDbfAge:cNbrAge
         end if

         ::oDbf:cNomAge    := ::oAlbCliT:cCodAge
         ::oDbf:cCodCli    := ::oAlbCliT:cCodCli
         ::oDbf:cNomCli    := ::oAlbCliT:cNomCli

         ::AddCliente( ::oAlbCliT:cCodCli, ::oAlbCliT, .f. )

         aTotal            := aTotAlbCli( ::oAlbCliT:cSerAlb + Str( ::oAlbCliT:nNumAlb ) + ::oAlbCliT:cSufAlb, ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias )

         ::oDbf:dFecDoc    := ::oAlbCliT:dFecAlb
         ::oDbf:cNumDoc    := "Albarán:" + ::oAlbCliT:cSerAlb + "/" + AllTrim( Str( ::oAlbCliT:nNumAlb ) ) + "/" + ::oAlbCliT:cSufAlb
         ::oDbf:nTotNet    := aTotal[ 1 ] - aTotal[ 5 ] - aTotal[ 6 ]
         ::oDbf:nTotIva    := aTotal[ 2 ]
         ::oDbf:nTotReq    := aTotal[ 3 ]
         ::oDbf:nTotDoc    := aTotal[ 4 ]
         ::oDbf:nTotPnt    := aTotal[ 5 ]
         ::oDbf:nTotTrn    := aTotal[ 6 ]
         //::oDbf:nComAge    := ::oDbf:nTotNet * ::oAlbCliT:nPctComAge / 100
         ::oDbf:nComAge    := aTotal[ 7 ]

         ::oDbf:nTotCos    := aTotal[ 9 ]
         ::oDbf:nMarGen    := ::oDbf:nTotNet - ::oDbf:nTotCos - ::oDbf:nComAge //aTotal[ 4 ] - aTotal[ 9 ]
         ::oDbf:nRenTab    := ( ( ( aTotal[ 1 ] - aTotal[ 7 ] ) / aTotal[ 9 ] ) - 1 ) * 100

         ::oDbf:Save()

      end if

      ::oAlbCliT:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oAlbCliT:IdxDelete( cCurUsr(), GetFileNoExt( ::oAlbCliT:cFile ) )

   ::oFacCliT:OrdSetFocus( "dFecFac" )

   cExpHead          := 'dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   if !::lAgeAll
      cExpHead       += ' .and. cCodAge >= "' + Rtrim( ::cAgeOrg ) + '" .and. cCodAge <= "' + Rtrim( ::cAgeDes ) + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oFacCliT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oFacCliT:cFile ), ::oFacCliT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:cText   := "Facturas"
   ::oMtrInf:SetTotal( ::oFacCliT:OrdKeyCount() )

   ::oFacCliT:GoTop()

   while !::lBreak .and. !::oFacCliT:Eof()

      if lChkSer( ::oFacCliT:cSerie, ::aSer )

         ::oDbf:Append()

         ::oDbf:cCodAge    := ::oFacCliT:cCodAge

         if ::oDbfAge:Seek( ::oFacCliT:cCodAge )
            ::oDbf:cNomAge := Rtrim( ::oDbfAge:cApeAge ) + ", " + ::oDbfAge:cNbrAge
         end if

         ::oDbf:cNomAge    := ::oFacCliT:cCodAge
         ::oDbf:cCodCli    := ::oFacCliT:cCodCli
         ::oDbf:cNomCli    := ::oFacCliT:cNomCli

         ::AddCliente( ::oFacCliT:cCodCli, ::oFacCliT, .f. )

         nTotPag           := nPagFacCli( ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac, ::oFacCliT:cAlias, ::oFacCliP:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias )
         aTotal            := aTotFacCli( ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac, ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias, ::oFacCliP:cAlias, ::oAntCliT:cAlias )

         ::oDbf:dFecDoc    := ::oFacCliT:dFecFac
         ::oDbf:cNumDoc    := "Factura:" + ::oFacCliT:cSerie + "/" + AllTrim( Str( ::oFacCliT:nNumFac ) ) + "/" + ::oFacCliT:cSufFac
         ::oDbf:nTotNet    := aTotal[ 1 ] - aTotal[ 5 ] - aTotal[ 6 ]
         ::oDbf:nTotIva    := aTotal[ 2 ]
         ::oDbf:nTotReq    := aTotal[ 3 ]
         ::oDbf:nTotDoc    := aTotal[ 4 ]
         ::oDbf:nTotPnt    := aTotal[ 5 ]
         ::oDbf:nTotTrn    := aTotal[ 6 ]
         //::oDbf:nComAge    := ::oDbf:nTotNet * ::oFacCliT:nPctComAge / 100
         ::oDbf:nComAge    := aTotal[ 7 ]
         ::oDbf:nTotPgd    := nTotPag

         ::oDbf:nTotCos    := aTotal[ 9 ]
         ::oDbf:nMarGen    := ::oDbf:nTotNet - ::oDbf:nTotCos - ::oDbf:nComAge //aTotal[ 4 ] - aTotal[ 9 ]
         ::oDbf:nRenTab    := ( ( ( aTotal[ 1 ] - aTotal[ 7 ] ) / aTotal[ 9 ] ) - 1 ) * 100

         ::oDbf:Save()

      end if

      ::oFacCliT:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oMtrInf:AutoInc( nLasFac )

   ::oFacCliT:IdxDelete( cCurUsr(), GetFileNoExt( ::oFacCliT:cFile ) )

   //facturas rectificativas

   ::oFacRecT:OrdSetFocus( "dFecFac" )

   cExpHead          := 'dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   if !::lAgeAll
      cExpHead       += ' .and. cCodAge >= "' + Rtrim( ::cAgeOrg ) + '" .and. cCodAge <= "' + Rtrim( ::cAgeDes ) + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oFacRecT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oFacRecT:cFile ), ::oFacRecT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:cText   := "Facturas Rectificativas"
   ::oMtrInf:SetTotal( ::oFacRecT:OrdKeyCount() )

   ::oFacRecT:GoTop()

   while !::lBreak .and. !::oFacRecT:Eof()

      if lChkSer( ::oFacRecT:cSerie, ::aSer )

         ::oDbf:Append()

         ::oDbf:cCodAge    := ::oFacRecT:cCodAge

         if ::oDbfAge:Seek( ::oFacRecT:cCodAge )
            ::oDbf:cNomAge := Rtrim( ::oDbfAge:cApeAge ) + ", " + ::oDbfAge:cNbrAge
         end if

         ::oDbf:cNomAge    := ::oFacRecT:cCodAge
         ::oDbf:cCodCli    := ::oFacRecT:cCodCli
         ::oDbf:cNomCli    := ::oFacRecT:cNomCli

         ::AddCliente( ::oFacRecT:cCodCli, ::oFacRecT, .f. )

         nTotPag           := nPagFacRec( ::oFacRecT:cSerie + Str( ::oFacRecT:nNumFac ) + ::oFacRecT:cSufFac, ::oFacRecT:cAlias, ::oFacCliP:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias )

         aTotal            := aTotFacRec( ::oFacRecT:cSerie + Str( ::oFacRecT:nNumFac ) + ::oFacRecT:cSufFac, ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias )

         ::oDbf:dFecDoc    := ::oFacRecT:dFecFac
         ::oDbf:cNumDoc    := "Factura rectificativa:" + ::oFacRecT:cSerie + "/" + AllTrim( Str( ::oFacRecT:nNumFac ) ) + "/" + ::oFacRecT:cSufFac
         ::oDbf:nTotNet    := aTotal[ 1 ] - aTotal[ 5 ] - aTotal[ 6 ]
         ::oDbf:nTotIva    := aTotal[ 2 ]
         ::oDbf:nTotReq    := aTotal[ 3 ]
         ::oDbf:nTotDoc    := aTotal[ 4 ]
         ::oDbf:nTotPnt    := aTotal[ 5 ]
         ::oDbf:nTotTrn    := aTotal[ 6 ]
         //::oDbf:nComAge    := ::oDbf:nTotNet * ::oFacRecT:nPctComAge / 100
         ::oDbf:nComAge    := aTotal[ 7 ]
         ::oDbf:nTotPgd    := nTotPag

         ::oDbf:nTotCos    := aTotal[ 9 ]
         ::oDbf:nMarGen    := ::oDbf:nTotNet - ::oDbf:nTotCos - ::oDbf:nComAge //aTotal[ 4 ] - aTotal[ 9 ]
         ::oDbf:nRenTab    := ( ( ( aTotal[ 1 ] - aTotal[ 7 ] ) / aTotal[ 9 ] ) - 1 ) * 100

         ::oDbf:Save()

      end if

      ::oFacRecT:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oMtrInf:Set( nLasFac )

   ::oFacRecT:IdxDelete( cCurUsr(), GetFileNoExt( ::oFacRecT:cFile ) )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//