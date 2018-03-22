#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TInfNCliVta FROM TInfGen

   DATA  oAlbCliT    AS OBJECT
   DATA  oAlbCliL    AS OBJECT
   DATA  oFacCliT    AS OBJECT
   DATA  oFacCliL    AS OBJECT
   DATA  oFacRecT    AS OBJECT
   DATA  oFacRecL    AS OBJECT
   DATA  lAllCP      AS LOGIC          INIT .t.
   DATA  cCPOrg      AS CHARACTER      INIT "00000"
   DATA  cCPDes      AS CHARACTER      INIT "99999"

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField( "cCodAge", "C",  3, 0, {|| "@!" },          "Cod. Age. ",           .f., "Código agente"             ,  3, .f. )
   ::AddField( "cNomAge", "C", 50, 0, {|| "@!" },          "Agente",               .f., "Nombre agente"             , 28, .f. )
   ::AddField( "cTipDoc", "C", 20, 0, {|| "@!" },          "Tipo",                 .f., "Tipo de documento"         , 10, .f. )
   ::AddField( "cDocMov", "C", 14, 0, {|| "@!" },          "Doc.",                 .t., "Documento"                 , 12, .f. )
   ::AddField( "dFecMov", "D",  8, 0, {|| "@!" },          "Fecha",                .t., "Fecha"                     , 10, .f. )
   ::AddField( "cCodArt", "C", 18, 0, {|| "@!" },          "Art.",                 .f., "Código artículo"           , 14, .f. )
   ::AddField( "cNomArt", "C",100, 0, {|| "@!" },          "Descripción",          .f., "Descripción"               , 35, .f. )
   ::FldPropiedades()
   ::AddField( "cCodCli", "C", 12, 0, {|| "@!" },          "Cód. cli.",            .f., "Cod. Cliente"              ,  8, .f. )
   ::AddField( "cNomCli", "C", 50, 0, {|| "@!" },          "Cliente",              .f., "Nom. Cliente"              , 30, .f. )
   ::AddField( "cNifCli", "C", 15, 0, {|| "@!" },          "Nif",                  .f., "Nif"                       , 12, .f. )
   ::AddField( "cDomCli", "C", 35, 0, {|| "@!" },          "Domicilio",            .f., "Domicilio"                 , 20, .f. )
   ::AddField( "cPobCli", "C", 25, 0, {|| "@!" },          "Población",            .f., "Población"                 , 25, .f. )
   ::AddField( "cProCli", "C", 20, 0, {|| "@!" },          "Provincia",            .f., "Provincia"                 , 20, .f. )
   ::AddField( "cCdpCli", "C",  7, 0, {|| "@!" },          "Cod. Postal",          .t., "Cod. Postal"               , 12, .f. )
   ::AddField( "cTlfCli", "C", 12, 0, {|| "@!" },          "Teléfono",             .f., "Teléfono"                  , 12, .f. )
   ::AddField( "nNumCaj", "N", 16, 6, {|| MasUnd() },      cNombreCajas(),         .f., cNombreCajas()              , 12, .t. )
   ::AddField( "nUniDad", "N", 16, 6, {|| MasUnd() },      cNombreUnidades(),      .f., cNombreUnidades()           , 12, .t. )
   ::AddField( "nNumUni", "N", 16, 6, {|| MasUnd() },      "Tot. " + cNombreUnidades(),.t., "Total " + cNombreUnidades() , 25, .t. )
   ::AddField( "nImpArt", "N", 16, 6, {|| ::cPicImp },     "Precio",               .t., "Precio"                    , 12, .f. )
   ::AddField( "nPntVer", "N", 16, 6, {|| ::cPicImp },     "Pnt. ver.",            .f., "Punto verde"               , 10, .f. )
   ::AddField( "nImpTrn", "N", 16, 6, {|| ::cPicImp },     "Portes",               .f., "Portes"                    , 10, .f. )
   ::AddField( "nImpTot", "N", 16, 6, {|| ::cPicOut },     "Base",                 .t., "Base"                      , 15, .t. )
   ::AddField( "nIvaTot", "N", 16, 6, {|| ::cPicOut },     cImp(),               .t., cImp()                    , 12, .t. )
   ::AddField( "nTotFin", "N", 16, 6, {|| ::cPicOut },     "Total",                .t., "Total"                     , 12, .t. )

   ::AddTmpIndex( "cCodAge", "cCodAge + cCodCli + cCodArt" )
   ::AddGroup( {|| ::oDbf:cCodAge }, {|| "Agente  : " + Rtrim( ::oDbf:cCodAge ) + "-" + Rtrim( ::oDbf:cNomAge ) }, {||"Total agente..."} )
   ::AddGroup( {|| ::oDbf:cCodAge + ::oDbf:cCodCli }, {|| "Cliente  : " + Rtrim( ::oDbf:cCodCli ) + "-" + oRetFld( ::oDbf:cCodCli, ::oDbfCli ) }, {||"Total cliente..."} )
   ::AddGroup( {|| ::oDbf:cCodAge + ::oDbf:cCodCli + ::oDbf:cCodArt },    {|| "Artículo : " + Rtrim( ::oDbf:cCodArt ) + "-" + Rtrim( oRetFld( ::oDbf:cCodArt, ::oDbfArt ) ) }, {|| Space(1) } )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   ::oAlbCliT := TDataCenter():oAlbCliT()

   DATABASE NEW ::oAlbCliL PATH ( cPatEmp() )  FILE "ALBCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "ALBCLIL.CDX"

   ::oFacCliT := TDataCenter():oFacCliT()  

   DATABASE NEW ::oFacCliL PATH ( cPatEmp() )  FILE "FACCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "FACCLIL.CDX"

   DATABASE NEW ::oFacRecT PATH ( cPatEmp() )  FILE "FACRECT.DBF" VIA ( cDriver() ) SHARED INDEX "FACRECT.CDX"

   DATABASE NEW ::oFacRecL PATH ( cPatEmp() )  FILE "FACRECL.DBF" VIA ( cDriver() ) SHARED INDEX "FACRECL.CDX"

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos" )
      ::CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles()

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
   if !Empty( ::oAlbCliT ) .and. ::oAlbCliT:Used()
      ::oAlbCliT:End()
   end if
   if !Empty( ::oAlbCliL ) .and. ::oAlbCliL:Used()
      ::oAlbCliL:End()
   end if

   ::oFacCliT := nil
   ::oFacCliL := nil
   ::oFacRecT := nil
   ::oFacRecL := nil
   ::oAlbCliT := nil
   ::oAlbCliL := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld )

   local oCPOrg
   local oCPDes

   if !::StdResource( "DETAGECLIART" )
      return .f.
   end if

   ::CreateFilter( , ::oDbf, .t. )

   /* Monta Agentes  */

   if !::oDefAgeInf( 150, 151, 160, 161, 170 )
      return .f.
   end if

   /* Monta clientes  */

   if !::oDefCliInf( 110, 120, 130, 140, , 600 )
      return .f.
   end if

   /*
   Monta los articulos de manera automatica
   */

   if !::lDefArtInf( 70, 80, 90, 100, 800 )
      return .f.
   end if

   REDEFINE CHECKBOX ::lAllCP ;
      ID       300 ;
      OF       ::oFld:aDialogs[1]

   REDEFINE GET oCPOrg VAR ::cCPOrg;
      ID       310 ;
      WHEN     ( !::lAllCP );
      PICTURE  "99999" ;
      OF       ::oFld:aDialogs[1]

   REDEFINE GET oCPDes VAR ::cCPDes;
      ID       320 ;
      WHEN     ( !::lAllCP );
      PICTURE  "99999" ;
      OF       ::oFld:aDialogs[1]

   ::oDefExcInf( 210 )
   ::oDefExcImp( 211 )

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   local cExpHead := ""
   local cExpLine := ""

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   ::aHeader   := {  {|| "Fecha     : " + Dtoc( Date() ) },;
                     {|| "Periodo   : " + Dtoc( ::dIniInf )   + " > " + Dtoc( ::dFinInf ) },;
                     {|| "Agentes   : " + if( ::lAgeAll, "Todos", AllTrim( ::cAgeOrg ) + " > " + AllTrim( ::cAgeDes ) ) },;
                     {|| "Clientes  : " + if( ::lAllCli, "Todos", AllTrim( ::cCliOrg ) + " > " + AllTrim( ::cCliDes ) ) },;
                     {|| "Artículos : " + if( ::lAllArt, "Todos", AllTrim( ::cArtOrg ) + " > " + AllTrim (::cArtDes ) ) } }

   /*
   Recorremos albaranes
   */

   ::oAlbCliT:OrdSetFocus( "dFecAlb" )
   ::oAlbCliL:OrdSetFocus( "nNumAlb" )

   cExpHead          := 'nFacturado < 3 .and. dFecAlb >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecAlb <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   if !::lAgeAll
      cExpHead       += ' .and. cCodAge >= "' + Rtrim( ::cAgeOrg ) + '" .and. cCodAge <= "' + Rtrim( ::cAgeDes ) + '"'
   end if

   if !::lAllCli
      cExpHead       += ' .and. cCodCli >= "' + Rtrim( ::cCliOrg ) + '" .and. cCodCli <= "' + Rtrim( ::cCliDes ) + '"'
   end if

   if !::lAllCp
      cExpHead       += ' .and. cPosCli >= "' + Rtrim( ::cCpOrg ) + '" .and. cPosCli <= "' + Rtrim( ::cCpDes ) + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter ) 
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oAlbCliT:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oAlbCliT:cFile ), ::oAlbCliT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:cText := "Procesando albaranes"
   ::oMtrInf:SetTotal( ::oAlbCliT:OrdKeyCount() )

   /*
   Lineas de albaranes
   */

   cExpLine          := '!lControl .and. !lTotLin'

   if !::lAllArt
      cExpLine       += ' .and. cRef >= "' + ::cArtOrg + '" .and. cRef <= "' + ::cArtDes + '"'
   end if

   ::oAlbCliL:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oAlbCliL:cFile ), ::oAlbCliL:OrdKey(), cAllTrimer( cExpLine ), , , , , , , , .t. )

   ::oAlbCliT:GoTop()
   ::oAlbCliL:GoTop()

   while !::lBreak .and. !::oAlbCliT:Eof()

      if lChkSer( ::oAlbCliT:cSerAlb, ::aSer )

         if ::oAlbCliL:Seek( ::oAlbCliT:cSerAlb + Str( ::oAlbCliT:nNumAlb ) + ::oAlbCliT:cSufAlb )

            while ::oAlbCliT:cSerAlb + Str( ::oAlbCliT:nNumAlb ) + ::oAlbCliT:cSufAlb == ::oAlbCliL:cSerAlb + Str( ::oAlbCliL:nNumAlb ) + ::oAlbCliL:cSufAlb .and. !::oAlbCliL:Eof()

               if !( ::lExcCero .AND. nTotNAlbCli( ::oAlbCliL:cAlias ) == 0 )                             .AND.;
                  !( ::lExcImp .AND. nImpLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) == 0 )

                  ::oDbf:Append()

                  ::oDbf:cCodAge    := ::oAlbCliT:cCodAge
                  if ( ::oDbfAge:Seek (::oAlbCliT:cCodAge) )
                     ::oDbf:cNomAge := AllTrim ( ::oDbfAge:cApeAge ) + ", " + AllTrim ( ::oDbfAge:cNbrAge )
                  end if

                  ::AddCliente( ::oAlbCliT:cCodCli, ::oAlbCliT, .f. )
                  ::oDbf:cTipDoc    := "Albarán"
                  ::oDbf:cDocMov    := ::oAlbCliL:cSerAlb + "/" + lTrim ( Str( ::oAlbCliL:nNumAlb ) ) + "/" + lTrim ( ::oAlbCliL:cSufAlb )
                  ::oDbf:dFecMov    := ::oAlbCliT:dFecAlb
                  ::oDbf:cCodArt    := ::oAlbCliL:cRef
                  ::oDbf:cNomArt    := ::oAlbCliL:cDetalle
                  ::oDbf:cCodPr1    := ::oAlbCliL:cCodPr1
                  ::oDbf:cNomPr1    := retProp( ::oAlbCliL:cCodPr1 )
                  ::oDbf:cCodPr2    := ::oAlbCliL:cCodPr2
                  ::oDbf:cNomPr2    := retProp( ::oAlbCliL:cCodPr2 )
                  ::oDbf:cValPr1    := ::oAlbCliL:cValPr1
                  ::oDbf:cNomVl1    := retValProp( ::oAlbCliL:cCodPr1 + ::oAlbCliL:cValPr1 )
                  ::oDbf:cValPr2    := ::oAlbCliL:cValPr2
                  ::oDbf:cNomVl2    := retValProp( ::oAlbCliL:cCodPr2 + ::oAlbCliL:cValPr2 )
                  ::oDbf:nNumCaj    := ::oAlbCliL:nCanEnt
                  ::oDbf:nUniDad    := ::oAlbCliL:nUniCaja
                  ::oDbf:nNumUni    := nTotNAlbCli( ::oAlbCliL )
                  ::oDbf:nImpArt    := nTotUAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nValDiv )
                  ::oDbf:nPntVer    := nPntUAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nValDiv )
                  ::oDbf:nImpTrn    := nTrnUAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nValDiv )
                  ::oDbf:nImpTot    := nImpLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                  ::oDbf:nIvaTot    := nIvaLAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                  ::oDbf:nTotFin    := ::oDbf:nImpTot + ::oDbf:nIvaTot

                  ::oDbf:Save()

               end if

               ::oAlbCliL:Skip()

            end while

         end if

      end if

      ::oAlbCliT:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oAlbCliT:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oAlbCliT:cFile ) )
   ::oAlbCliL:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oAlbCliL:cFile ) )

   ::oFacCliT:OrdSetFocus( "dFecFac" )
   ::oFacCliL:OrdSetFocus( "nNumFac" )

   cExpHead          := 'dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   if !::lAgeAll
      cExpHead       += ' .and. cCodAge >= "' + Rtrim( ::cAgeOrg ) + '" .and. cCodAge <= "' + Rtrim( ::cAgeDes ) + '"'
   end if

   if !::lAllCli
      cExpHead       += ' .and. cCodCli >= "' + Rtrim( ::cCliOrg ) + '" .and. cCodCli <= "' + Rtrim( ::cCliDes ) + '"'
   end if

   if !::lAllCp
      cExpHead       += ' .and. cPosCli >= "' + Rtrim( ::cCpOrg ) + '" .and. cPosCli <= "' + Rtrim( ::cCpDes ) + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oFacCliT:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oFacCliT:cFile ), ::oFacCliT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:cText   := "Procesando facturas"
   ::oMtrInf:SetTotal( ::oFacCliT:OrdKeyCount() )

   /*
   Lineas de albaranes
   */

   cExpLine          := '!( lControl .or. lTotLin )'

   if !::lAllArt
      cExpLine       += ' .and. cRef >= "' + ::cArtOrg + '" .and. cRef <= "' + ::cArtDes + '"'
   end if

   ::oFacCliL:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oFacCliL:cFile ), ::oFacCliL:OrdKey(), cAllTrimer( cExpLine ), , , , , , , , .t. )

   /*
    Recorremos facturas
   */

   ::oFacCliT:GoTop()
   ::oFacCliL:GoTop()

   while !::lBreak .and. !::oFacCliT:Eof()

      if lChkSer( ::oFacCliT:cSerie, ::aSer )

         if ::oFacCliL:Seek( ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac )

            while ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac == ::oFacCliL:cSerie + Str( ::oFacCliL:nNumFac ) + ::oFacCliL:cSufFac .and. !::oFacCliL:Eof()

               if !( ::lExcCero .AND. nTotNFacCli( ::oFacCliL:cAlias ) == 0 )                             .AND.;
                  !( ::lExcImp .AND. nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) == 0 )

                  ::oDbf:Append()

                  ::oDbf:cCodAge    := ::oFacCliT:cCodAge
                  if ( ::oDbfAge:Seek (::oFacCliT:cCodAge) )
                     ::oDbf:cNomAge := AllTrim ( ::oDbfAge:cApeAge ) + ", " + AllTrim ( ::oDbfAge:cNbrAge )
                  end if

                  ::AddCliente( ::oFacCliT:cCodCli, ::oFacCliT, .f. )
                  ::oDbf:cTipDoc    := "Factura"
                  ::oDbf:cDocMov    := ::oFacCliL:cSerie + "/" + lTrim ( Str( ::oFacCliL:nNumFac ) ) + "/" + lTrim ( ::oFacCliL:cSufFac )
                  ::oDbf:dFecMov    := ::oFacCliT:dFecFac
                  ::oDbf:cCodArt    := ::oFacCliL:cRef
                  ::oDbf:cNomArt    := ::oFacCliL:cDetalle
                  ::oDbf:cCodPr1    := ::oFacCliL:cCodPr1
                  ::oDbf:cNomPr1    := retProp( ::oFacCliL:cCodPr1 )
                  ::oDbf:cCodPr2    := ::oFacCliL:cCodPr2
                  ::oDbf:cNomPr2    := retProp( ::oFacCliL:cCodPr2 )
                  ::oDbf:cValPr1    := ::oFacCliL:cValPr1
                  ::oDbf:cNomVl1    := retValProp( ::oFacCliL:cCodPr1 + ::oFacCliL:cValPr1 )
                  ::oDbf:cValPr2    := ::oFacCliL:cValPr2
                  ::oDbf:cNomVl2    := retValProp( ::oFacCliL:cCodPr2 + ::oFacCliL:cValPr2 )
                  ::oDbf:nNumCaj    := ::oFacCliL:nCanEnt
                  ::oDbf:nUniDad    := ::oFacCliL:nUniCaja
                  ::oDbf:nNumUni    := nTotNFacCli( ::oFacCliL )
                  ::oDbf:nImpArt    := nTotUFacCli( ::oFacCliL:cAlias, ::nDecOut, ::nValDiv )
                  ::oDbf:nPntVer    := nPntUFacCli( ::oFacCliL:cAlias, ::nDecOut, ::nValDiv )
                  ::oDbf:nImpTrn    := nTrnUFacCli( ::oFacCliL:cAlias, ::nDecOut, ::nValDiv )
                  ::oDbf:nImpTot    := nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                  ::oDbf:nIvaTot    := nIvaLFacCli( ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                  ::oDbf:nTotFin    := ::oDbf:nImpTot + ::oDbf:nIvaTot

                  ::oDbf:Save()

               end if

               ::oFacCliL:Skip()

            end while

         end if

      end if

      ::oFacCliT:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oFacCliT:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oFacCliT:cFile ) )

   ::oFacCliL:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oFacCliL:cFile ) )

   ::oFacRecT:OrdSetFocus( "dFecFac" )
   ::oFacRecL:OrdSetFocus( "nNumFac" )

   cExpHead          := 'dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   if !::lAgeAll
      cExpHead       += ' .and. cCodAge >= "' + Rtrim( ::cAgeOrg ) + '" .and. cCodAge <= "' + Rtrim( ::cAgeDes ) + '"'
   end if

   if !::lAllCli
      cExpHead       += ' .and. cCodCli >= "' + Rtrim( ::cCliOrg ) + '" .and. cCodCli <= "' + Rtrim( ::cCliDes ) + '"'
   end if

   if !::lAllCp
      cExpHead       += ' .and. cPosCli >= "' + Rtrim( ::cCpOrg ) + '" .and. cPosCli <= "' + Rtrim( ::cCpDes ) + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter 
   end if

   ::oFacRecT:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oFacRecT:cFile ), ::oFacRecT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:cText   := "Procesando fac. rec."
   ::oMtrInf:SetTotal( ::oFacRecT:OrdKeyCount() )

   /*
   Lineas de albaranes
   */

   cExpLine          := '!lControl .and. !lTotLin'

   if !::lAllArt
      cExpLine       += ' .and. cRef >= "' + ::cArtOrg + '" .and. cRef <= "' + ::cArtDes + '"'
   end if

   ::oFacRecL:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oFacRecL:cFile ), ::oFacRecL:OrdKey(), cAllTrimer( cExpLine ), , , , , , , , .t. )

   /*
    Recorremos facturas
   */

   ::oFacRecT:GoTop()
   ::oFacRecL:GoTop()

   while !::lBreak .and. !::oFacRecT:Eof()

      if lChkSer( ::oFacRecT:cSerie, ::aSer )

         if ::oFacRecL:Seek( ::oFacRecT:cSerie + Str( ::oFacRecT:nNumFac ) + ::oFacRecT:cSufFac )

            while ::oFacRecT:cSerie + Str( ::oFacRecT:nNumFac ) + ::oFacRecT:cSufFac == ::oFacRecL:cSerie + Str( ::oFacRecL:nNumFac ) + ::oFacRecL:cSufFac .and. !::oFacRecL:Eof()

               if !( ::lExcCero .AND. nTotNFacRec( ::oFacRecL:cAlias ) == 0 )                             .AND.;
                  !( ::lExcImp .AND. nImpLFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) == 0 )

                  ::oDbf:Append()

                  ::oDbf:cCodAge    := ::oFacRecT:cCodAge
                  if ( ::oDbfAge:Seek (::oFacRecT:cCodAge) )
                     ::oDbf:cNomAge := AllTrim ( ::oDbfAge:cApeAge ) + ", " + AllTrim ( ::oDbfAge:cNbrAge )
                  end if

                  ::AddCliente( ::oFacRecT:cCodCli, ::oFacRecT, .f. )
                  ::oDbf:cTipDoc    := "Fac. rec."
                  ::oDbf:cDocMov    := ::oFacRecL:cSerie + "/" + lTrim ( Str( ::oFacRecL:nNumFac ) ) + "/" + lTrim ( ::oFacRecL:cSufFac )
                  ::oDbf:dFecMov    := ::oFacRecT:dFecFac
                  ::oDbf:cCodArt    := ::oFacRecL:cRef
                  ::oDbf:cNomArt    := ::oFacRecL:cDetalle
                  ::oDbf:cCodPr1    := ::oFacRecL:cCodPr1
                  ::oDbf:cNomPr1    := retProp( ::oFacRecL:cCodPr1 )
                  ::oDbf:cCodPr2    := ::oFacRecL:cCodPr2
                  ::oDbf:cNomPr2    := retProp( ::oFacRecL:cCodPr2 )
                  ::oDbf:cValPr1    := ::oFacRecL:cValPr1
                  ::oDbf:cNomVl1    := retValProp( ::oFacRecL:cCodPr1 + ::oFacRecL:cValPr1 )
                  ::oDbf:cValPr2    := ::oFacRecL:cValPr2
                  ::oDbf:cNomVl2    := retValProp( ::oFacRecL:cCodPr2 + ::oFacRecL:cValPr2 )
                  ::oDbf:nNumCaj    := ( ::oFacRecL:nCanEnt )
                  ::oDbf:nUniDad    := ( ::oFacRecL:nUniCaja )
                  ::oDbf:nNumUni    := ( nTotNFacRec( ::oFacRecL ) )
                  ::oDbf:nImpArt    := nTotUFacRec( ::oFacRecL:cAlias, ::nDecOut, ::nValDiv )
                  ::oDbf:nPntVer    := nPntUFacRec( ::oFacRecL:cAlias, ::nDecOut, ::nValDiv )
                  ::oDbf:nImpTrn    := nTrnUFacRec( ::oFacRecL:cAlias, ::nDecOut, ::nValDiv )
                  ::oDbf:nImpTot    := ( nImpLFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) )
                  ::oDbf:nIvaTot    := ( nIvaLFacRec( ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) )
                  ::oDbf:nTotFin    := ::oDbf:nImpTot + ::oDbf:nIvaTot

                  ::oDbf:Save()

               end if

               ::oFacRecL:Skip()

            end while

         end if

      end if

      ::oFacRecT:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oFacRecT:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oFacRecT:cFile ) )

   ::oFacRecL:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oFacRecL:cFile ) )

   ::oMtrInf:AutoInc( ::oFacRecT:Lastrec() )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//