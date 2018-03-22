#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TInfArtPre FROM TInfGen

   DATA  oFamilia    AS OBJECT
   DATA  oIva        AS OBJECT
   DATA  oKit        AS OBJECT
   DATA  oCmbArt     AS OBJECT
   DATA  oAlbPrvT    AS OBJECT
   DATA  oAlbPrvL    AS OBJECT
   DATA  oFacPrvT    AS OBJECT
   DATA  oFacPrvL    AS OBJECT
   DATA  oAlbCliT    AS OBJECT
   DATA  oAlbCliL    AS OBJECT
   DATA  oFacCliT    AS OBJECT
   DATA  oFacCliL    AS OBJECT
   DATA  oFacRecT    AS OBJECT
   DATA  oFacRecL    AS OBJECT
   DATA  oTikCliT    AS OBJECT
   DATA  oTikCliL    AS OBJECT
   DATA  nTotUndCom  INIT 0
   DATA  nTotImpCom  INIT 0
   DATA  nTotUndVta  INIT 0
   DATA  nTotImpVta  INIT 0

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

   METHOD nTotCom( cCodArt )

   METHOD nTotVta( cCodArt )

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField( "cCodArt", "C", 18, 0, {|| "@!" },             "Cod. artículo",  .t., "Código artículo",           14, .f. )
   ::AddField( "cCodBar", "C", 14, 0, {|| "@!" },             "Cod. barra",     .t., "Código barra",              14, .f. )
   ::AddField( "cNomArt", "C",100, 0, {|| "@!" },             "Descripción",    .t., "Descripción",               40, .f. )
   ::AddField( "nIvaArt", "N",  6, 2, {|| "@E 999.99" },      "%" + cImp(),     .t., "%" + cImp(),                 6, .f. )
   ::AddField( "cCodFam", "C", 16, 0, {|| "@!" },             "Familia",        .t., "Familia",                    5, .f. )
   ::AddField( "nCosArt", "N", 16, 6, {|| ::cPicIn },         "Precio de costo",.f., "Costo",                     15, .f. )
   ::AddField( "nBnf1",   "N",  6, 2, {|| "@E 999.99" },      "%Bnf. 1",        .t., "Porcentaje de benefico 1",  12, .f. )
   ::AddField( "nImp1",   "N", 16, 6, {|| ::cPicImp },        "Precio 1",       .t., "Precio 1",                  12, .f. )
   ::AddField( "nIva1",   "N", 16, 6, {|| ::cPicImp },        "Precio 1 " + cImp(),.t., "Precio 1 " + cImp() + " incluido",  15, .f. )
   ::AddField( "nBnf2",   "N",  6, 2, {|| "@E 999.99" },      "%Bnf. 2",        .f., "Porcentaje de benefico 2",  12, .f. )
   ::AddField( "nImp2",   "N", 16, 6, {|| ::cPicImp },        "Precio 2",       .f., "Precio 2",                  12, .f. )
   ::AddField( "nIva2",   "N", 16, 6, {|| ::cPicImp },        "Precio 2 " + cImp(),.f., "Precio 2 " + cImp() + " incluido",  15, .f. )
   ::AddField( "nBnf3",   "N",  6, 2, {|| "@E 999.99" },      "%Bnf. 3",        .f., "Porcentaje de benefico 3",  12, .f. )
   ::AddField( "nImp3",   "N", 16, 6, {|| ::cPicImp },        "Precio 3",       .f., "Precio 3",                  12, .f. )
   ::AddField( "nIva3",   "N", 16, 6, {|| ::cPicImp },        "Precio 3 " + cImp(),.f., "Precio 3 " + cImp() + " incluido",  15, .f. )
   ::AddField( "nBnf4",   "N",  6, 2, {|| "@E 999.99" },      "%Bnf. 4",        .f., "Porcentaje de benefico 4",  12, .f. )
   ::AddField( "nImp4",   "N", 16, 6, {|| ::cPicImp },        "Precio 4",       .f., "Precio 4",                  12, .f. )
   ::AddField( "nIva4",   "N", 16, 6, {|| ::cPicImp },        "Precio 4 " + cImp(),.f., "Precio 4 " + cImp() + " incluido",  15, .f. )
   ::AddField( "nBnf5",   "N",  6, 2, {|| "@E 999.99" },      "%Bnf. 5",        .f., "Porcentaje de benefico 5",  12, .f. )
   ::AddField( "nImp5",   "N", 16, 6, {|| ::cPicImp },        "Precio 5",       .f., "Precio 5",                  12, .f. )
   ::AddField( "nIva5",   "N", 16, 6, {|| ::cPicImp },        "Precio 5 " + cImp(),.f., "Precio 5 " + cImp() + " incluido",  15, .f. )
   ::AddField( "nBnf6",   "N",  6, 2, {|| "@E 999.99" },      "%Bnf. 6",        .f., "Porcentaje de benefico 6",  12, .f. )
   ::AddField( "nImp6",   "N", 16, 6, {|| ::cPicImp },        "Precio 6",       .f., "Precio 6",                  12, .f. )
   ::AddField( "nIva6",   "N", 16, 6, {|| ::cPicImp },        "Precio 6 " + cImp(),.f., "Precio 6 " + cImp() + " incluido",  15, .f. )
   ::AddField( "nUndCom", "N", 16, 6, {|| ::cPicImp },        "Und. com.",      .f., "Total unidades en compras", 12, .f. )
   ::AddField( "nImpCom", "N", 16, 6, {|| ::cPicImp },        "Imp. com.",      .f., "Total importe en compras",  12, .f. )
   ::AddField( "nMedCom", "N", 16, 6, {|| ::cPicImp },        "Med. com.",      .f., "Precio medio de compras",   12, .f. )
   ::AddField( "nUndVta", "N", 16, 6, {|| ::cPicImp },        "Und. vta.",      .f., "Total unidades en ventas",  12, .f. )
   ::AddField( "nImpVta", "N", 16, 6, {|| ::cPicImp },        "Imp. vta.",      .f., "Total importe en ventas",   12, .f. )
   ::AddField( "nMedVta", "N", 16, 6, {|| ::cPicImp },        "Med. vta.",      .f., "Precio medio de ventas",    12, .f. )

   ::AddTmpIndex( "cCodArt", "cCodArt" )
   ::AddTmpIndex( "cNomArt", "cNomArt" )

   ::lDefFecInf   := .f.
   ::lDefSerInf   := .f.

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS TInfArtPre

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   DATABASE NEW ::oFamilia    PATH ( cPatArt() ) FILE "FAMILIAS.DBF" VIA ( cDriver() ) SHARED INDEX "FAMILIAS.CDX"

   DATABASE NEW ::oIva        PATH ( cPatDat() ) FILE "TIVA.DBF"     VIA ( cDriver() ) SHARED INDEX "TIVA.CDX"

   DATABASE NEW ::oKit        PATH ( cPatArt() )   FILE "ARTKIT.DBF"   VIA ( cDriver() ) SHARED INDEX "ARTKIT.CDX"

   DATABASE NEW ::oAlbPrvT    PATH ( cPatEmp() ) FILE "ALBPROVT.DBF" VIA ( cDriver() ) SHARED INDEX "ALBPROVT.CDX"

   DATABASE NEW ::oAlbPrvL    PATH ( cPatEmp() ) FILE "ALBPROVL.DBF" VIA ( cDriver() ) SHARED INDEX "ALBPROVL.CDX"

   DATABASE NEW ::oFacPrvT    PATH ( cPatEmp() ) FILE "FACPRVT.DBF"  VIA ( cDriver() ) SHARED INDEX "FACPRVT.CDX"

   DATABASE NEW ::oFacPrvL    PATH ( cPatEmp() ) FILE "FACPRVL.DBF"  VIA ( cDriver() ) SHARED INDEX "FACPRVL.CDX"

   ::oAlbCliT := TDataCenter():oAlbCliT()

   DATABASE NEW ::oAlbCliL    PATH ( cPatEmp() ) FILE "ALBCLIL.DBF"  VIA ( cDriver() ) SHARED INDEX "ALBCLIL.CDX"

   ::oFacCliT     := TDataCenter():oFacCliT()     

   DATABASE NEW ::oFacCliL    PATH ( cPatEmp() ) FILE "FACCLIL.DBF"  VIA ( cDriver() ) SHARED INDEX "FACCLIL.CDX"

   DATABASE NEW ::oFacRecT    PATH ( cPatEmp() ) FILE "FACRECT.DBF"  VIA ( cDriver() ) SHARED INDEX "FACRECT.CDX"

   DATABASE NEW ::oFacRecL    PATH ( cPatEmp() ) FILE "FACRECL.DBF"  VIA ( cDriver() ) SHARED INDEX "FACRECL.CDX"

   DATABASE NEW ::oTikCliT    PATH ( cPatEmp() ) FILE "TIKET.DBF"    VIA ( cDriver() ) SHARED INDEX "TIKET.CDX"

   DATABASE NEW ::oTikCliL    PATH ( cPatEmp() ) FILE "TIKEL.DBF"    VIA ( cDriver() ) SHARED INDEX "TIKEL.CDX"

   RECOVER

      msgStop( 'Imposible abrir todas las bases de datos' )
      ::CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TInfArtPre

   if !Empty( ::oFamilia ) .and. ::oFamilia:Used()
      ::oFamilia:End()
   end if
   if !Empty( ::oIva ) .and. ::oIva:Used()
      ::oIva:End()
   end if
   if !Empty( ::oKit ) .and. ::oKit:Used()
      ::oKit:End()
   end if

   if !Empty( ::oAlbPrvT ) .and. ::oAlbPrvT:Used()
      ::oAlbPrvT:End()
   end if
   if !Empty( ::oAlbPrvL ) .and. ::oAlbPrvL:Used()
      ::oAlbPrvL:End()
   end if
   if !Empty( ::oFacPrvT ) .and. ::oFacPrvT:Used()
      ::oFacPrvT:End()
   end if
   if !Empty( ::oFacPrvL ) .and. ::oFacPrvL:Used()
      ::oFacPrvL:End()
   end if
   if !Empty( ::oAlbCliT ) .and. ::oAlbCliT:Used()
      ::oAlbCliT:End()
   end if
   if !Empty( ::oAlbCliL ) .and. ::oAlbCliL:Used()
      ::oAlbCliL:End()
   end if
   if !Empty( ::oFacCliT ) .and. ::oFacCliT:Used()
      ::oFacCliT:End()
   end if
   if !Empty( ::oFacCliL ) .and. ::oFacCliL:Used()
      ::oFacCliL:End()
   end if
   if !Empty( ::oFacRecT ) .and. ::oFacRecT:Used()
      ::oFacRecT:End()
   end if
   if !Empty( ::oFacRecL ) .and. ::oFacRecL:Used()
      ::oFacRecL:End()
   end if
   if !Empty( ::oTikCliT ) .and. ::oTikCliT:Used()
      ::oTikCliT:End()
   end if
   if !Empty( ::oTikCliL ) .and. ::oTikCliL:Used()
      ::oTikCliL:End()
   end if

   ::oFamilia := nil
   ::oIva     := nil
   ::oKit     := nil
   ::oAlbPrvT := nil
   ::oAlbPrvL := nil
   ::oFacPrvT := nil
   ::oFacPrvL := nil
   ::oAlbCliT := nil
   ::oAlbCliL := nil
   ::oFacCliT := nil
   ::oFacCliL := nil
   ::oFacRecT := nil
   ::oFacRecL := nil
   ::oTikCliT := nil
   ::oTikCliL := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHod lResource( cFld ) CLASS TInfArtPre

   local cCmbArt := "Código"

   if !::StdResource( "INF_GEN24" )
      return .f.
   end if

   /*
   Monta los articulos de manera automatica
   */

   if !::lDefArtInf( 110, 120, 130, 140, 800 )
      return .f.
   end if

   REDEFINE COMBOBOX ::oCmbArt VAR cCmbArt ;
      ID       100 ;
      ITEMS    { "Código", "Nombre" } ;
      OF       ::oFld:aDialogs[1]

   ::CreateFilter( aItmArt(), ::oDbfArt:cAlias )

   /*
   Damos valor al meter
   */

   ::oMtrInf:SetTotal( ::oDbfArt:Lastrec() )

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate() CLASS TInfArtPre

   local cExpHead := ""

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   ::aHeader   := {  {|| "Fecha    : " + Dtoc( Date() ) },;
                     {|| "Artículo : " + if( ::lAllArt, "Todos", AllTrim( ::cArtOrg ) + " > " + AllTrim( ::cArtDes) ) } }

   ::oDbfArt:OrdSetFocus( "Codigo" )

   if !::lAllArt
      cExpHead       := 'codigo >= "' + Rtrim( ::cArtOrg ) + '" .and. codigo <= "' + Rtrim( ::cArtDes ) + '"'
   else
      cExpHead       := '.t.'
   end if

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oDbfArt:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oDbfArt:cFile ), ::oDbfArt:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oDbfArt:OrdKeyCount() )

   ::oDbfArt:GoTop()

   while !::lBreak .and. !::oDbfArt:Eof()

      ::nTotCom( ::oDbfArt:Codigo )
      ::nTotVta( ::oDbfArt:Codigo )

      ::oDbf:Append()

      ::oDbf:cCodArt := ::oDbfArt:Codigo
      ::oDbf:cCodBar := ::oDbfArt:CodeBar
      ::oDbf:cNomArt := ::oDbfArt:Nombre
      ::oDbf:nIvaArt := nIva( ::oIva:cAlias, ::oDbfArt:TipoIva )
      ::oDbf:cCodFam := ::oDbfArt:Familia
      ::oDbf:nCosArt := nCosto( nil, ::oDbfArt:cAlias, ::oKit:cAlias, .f., ::cDivInf, ::oDbfDiv:cAlias )
      ::oDbf:nBnf1   := ::oDbfArt:Benef1
      ::oDbf:nImp1   := nRetPreArt( 1, ::cDivInf, .f., ::oDbfArt:cAlias, ::oDbfDiv:cAlias, ::oKit:cAlias, ::oIva:cAlias )
      ::oDbf:nIva1   := nRetPreArt( 1, ::cDivInf, .t., ::oDbfArt:cAlias, ::oDbfDiv:cAlias, ::oKit:cAlias, ::oIva:cAlias )
      ::oDbf:nBnf2   := ::oDbfArt:Benef2
      ::oDbf:nImp2   := nRetPreArt( 2, ::cDivInf, .f., ::oDbfArt:cAlias, ::oDbfDiv:cAlias, ::oKit:cAlias, ::oIva:cAlias )
      ::oDbf:nIva2   := nRetPreArt( 2, ::cDivInf, .t., ::oDbfArt:cAlias, ::oDbfDiv:cAlias, ::oKit:cAlias, ::oIva:cAlias )
      ::oDbf:nBnf3   := ::oDbfArt:Benef3
      ::oDbf:nImp3   := nRetPreArt( 3, ::cDivInf, .f., ::oDbfArt:cAlias, ::oDbfDiv:cAlias, ::oKit:cAlias, ::oIva:cAlias )
      ::oDbf:nIva3   := nRetPreArt( 3, ::cDivInf, .t., ::oDbfArt:cAlias, ::oDbfDiv:cAlias, ::oKit:cAlias, ::oIva:cAlias )
      ::oDbf:nBnf4   := ::oDbfArt:Benef4
      ::oDbf:nImp4   := nRetPreArt( 4, ::cDivInf, .f., ::oDbfArt:cAlias, ::oDbfDiv:cAlias, ::oKit:cAlias, ::oIva:cAlias )
      ::oDbf:nIva4   := nRetPreArt( 4, ::cDivInf, .t., ::oDbfArt:cAlias, ::oDbfDiv:cAlias, ::oKit:cAlias, ::oIva:cAlias )
      ::oDbf:nBnf5   := ::oDbfArt:Benef5
      ::oDbf:nImp5   := nRetPreArt( 5, ::cDivInf, .f., ::oDbfArt:cAlias, ::oDbfDiv:cAlias, ::oKit:cAlias, ::oIva:cAlias )
      ::oDbf:nIva5   := nRetPreArt( 5, ::cDivInf, .t., ::oDbfArt:cAlias, ::oDbfDiv:cAlias, ::oKit:cAlias, ::oIva:cAlias )
      ::oDbf:nBnf6   := ::oDbfArt:Benef6
      ::oDbf:nImp6   := nRetPreArt( 6, ::cDivInf, .f., ::oDbfArt:cAlias, ::oDbfDiv:cAlias, ::oKit:cAlias, ::oIva:cAlias )
      ::oDbf:nIva6   := nRetPreArt( 6, ::cDivInf, .t., ::oDbfArt:cAlias, ::oDbfDiv:cAlias, ::oKit:cAlias, ::oIva:cAlias )

      ::oDbf:nUndCom := ::nTotUndCom
      ::oDbf:nImpCom := ::nTotImpCom
      ::oDbf:nMedCom := ::nTotImpCom / ::nTotUndCom

      ::oDbf:nUndVta := ::nTotUndVta
      ::oDbf:nImpVta := ::nTotImpVta
      ::oDbf:nMedVta := ::nTotImpVta / ::nTotUndVta

      ::oDbf:Save()

      ::oMtrInf:AutoInc( ::oDbfArt:OrdKeyNo() )

      ::oDbfArt:Skip()

   end while

   ::oDbfArt:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oDbfArt:cFile ) )

   ::oMtrInf:AutoInc( ::oDbfArt:LastRec() )

   ::oDlg:Enable()

   if ::oDbf:RecCount() > 0
      ::oDbf:OrdSetFocus( ::oCmbArt:nAt )
   end if

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//
//Informa dos variables con los totales comprados

METHOD nTotCom( cCodArt )

   /*Inicializamos las variables*/

   ::nTotUndCom  := 0
   ::nTotImpCom  := 0

   /*Recorremos albarames de compras para sumar los totales*/

   ::oAlbPrvL:OrdSetFocus( "cRef" )
   ::oAlbPrvL:GoTop()
   ::oAlbPrvL:Seek( cCodArt )

   while ::oAlbPrvL:cRef == cCodArt .and. !::oAlbPrvL:Eof()

      ::nTotUndCom  += nTotNAlbPrv( ::oAlbPrvL )
      ::nTotImpCom  += nImpLAlbPrv( ::oAlbPrvT:cAlias, ::oAlbPrvL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )

      ::oAlbPrvL:Skip()

   end while

   /*Recorremos facturas de compras para sumar los totales*/

   ::oFacPrvL:OrdSetFocus( "cRef" )
   ::oFacPrvL:GoTop()
   ::oFacPrvL:Seek( cCodArt )

   while ::oFacPrvL:cRef == cCodArt .and. !::oFacPrvL:Eof()

      ::nTotUndCom  += nTotNFacPrv( ::oFacPrvL )
      ::nTotImpCom  += nImpLFacPrv( ::oFacPrvT:cAlias, ::oFacPrvL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )

      ::oFacPrvL:Skip()

   end while

RETURN ( Self )

//---------------------------------------------------------------------------//
//Informa dos variables con los totales vendidos

METHOD nTotVta( cCodArt )

   /*Inicializamos las variables*/

   ::nTotUndVta  := 0
   ::nTotImpVta  := 0

   /*Recorremos albarames de clientes para sumar los totales*/

   ::oAlbCliL:OrdSetFocus( "cRef" )
   ::oAlbCliL:GoTop()
   ::oAlbCliL:Seek( cCodArt )

   while ::oAlbCliL:cRef == cCodArt .and. !::oAlbCliL:Eof()

      ::nTotUndVta  += nTotNAlbCli( ::oAlbCliL )
      ::nTotImpVta  += nImpLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )

      ::oAlbCliL:Skip()

   end while

   /*Recorremos facturas de clientes para sumar los totales*/

   ::oFacCliL:OrdSetFocus( "cRef" )
   ::oFacCliL:GoTop()
   ::oFacCliL:Seek( cCodArt )

   while ::oFacCliL:cRef == cCodArt .and. !::oFacCliL:Eof()

      ::nTotUndVta  += nTotNFacCli( ::oFacCliL )
      ::nTotImpVta  += nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )

      ::oFacCliL:Skip()

   end while

   /*Recorremos facturas rectificativas de clientes para sumar los totales*/

   ::oFacRecL:OrdSetFocus( "cRef" )
   ::oFacRecL:GoTop()
   ::oFacRecL:Seek( cCodArt )

   while ::oFacRecL:cRef == cCodArt .and. !::oFacRecL:Eof()

      ::nTotUndVta  -= nTotNFacRec( ::oFacRecL )
      ::nTotImpVta  -= nImpLFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )

      ::oFacRecL:Skip()

   end while

   /*Recorremos tikets de clientes para sumar los totales*/

   ::oTikCliL:OrdSetFocus( "cCbaTil" )
   ::oTikCliL:GoTop()
   ::oTikCliL:Seek( cCodArt )

   while ::oTikCliL:cCbaTil == cCodArt .and. !::oTikCliL:Eof()

      ::nTotUndVta  += ::oTikCliL:nUntTil
      ::nTotImpVta  += nImpLTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nDerOut, ::nValDiv, nil, 1 )

      ::oTikCliL:Skip()

   end while

   ::oTikCliL:OrdSetFocus( "cComTil" )
   ::oTikCliL:GoTop()
   ::oTikCliL:Seek( cCodArt )

   while ::oTikCliL:cComTil == cCodArt .and. !::oTikCliL:Eof()

      ::nTotUndVta  += ::oTikCliL:nUntTil
      ::nTotImpVta  += nImpLTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nDerOut, ::nValDiv, nil, 2 )

      ::oTikCliL:Skip()

   end while

RETURN ( Self )

//---------------------------------------------------------------------------//