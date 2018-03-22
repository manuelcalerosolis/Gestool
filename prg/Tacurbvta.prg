#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TAcuRBVta FROM TInfGen

   DATA  lExcMov     AS LOGIC    INIT .f.
   DATA  oTikCliT    AS OBJECT
   DATA  oTikCliL    AS OBJECT
   DATA  oAlbCliT    AS OBJECT
   DATA  oAlbCliL    AS OBJECT
   DATA  oFacCliT    AS OBJECT
   DATA  oFacCliL    AS OBJECT
   DATA  oFacRecT    AS OBJECT
   DATA  oFacRecL    AS OBJECT
   DATA  oCmbPrv     AS OBJECT
   DATA  oCmbArt     AS OBJECT

   METHOD Create ()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

   METHOD IncluyeCero()

   METHOD PosGenerate()

   METHOD nTotPrv( cCodPrv )

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField( "cCodPrv", "C", 12, 0, {|| "@!" },      "Cod. Prv.",     .f., "Cod. Proveedor"               ,  9, .f. )
   ::AddField( "cNomPrv", "C", 50, 0, {|| "@!" },      "Proveedor",     .f., "Nombre Proveedor"             , 35, .f. )
   ::AddField( "cCodArt", "C", 18, 0, {|| "@!" },      "Cod. Art",      .t., "C�digo art�culo"                    , 14, .f. )
   ::AddField( "cNomArt", "C",100, 0, {|| "@!" },      "Art�culo",      .t., "Art�culo"                     , 35, .f. )
   ::FldPropiedades()
   ::AddField( "nNumUni", "N", 16, 6, {|| MasUnd() },  cNombreUnidades(),.t., cNombreUnidades()             , 12, .t. )
   ::AddField( "nImpArt", "N", 16, 6, {|| ::cPicImp }, "Precio",        .f., "Precio"                       , 12, .f. )
   ::AddField( "nPntVer", "N", 16, 6, {|| ::cPicImp }, "Pnt. ver.",     .f., "Punto verde"                  , 10, .f. )
   ::AddField( "nImpTrn", "N", 16, 6, {|| ::cPicImp }, "Portes",        .f., "Portes"                       , 10, .f. )
   ::AddField( "nImpTot", "N", 16, 6, {|| ::cPicOut }, "Base",          .t., "Base"                         , 18, .t. )
   ::AddField( "nTotPes", "N", 16, 6, {|| MasUnd() },  "Tot. peso",     .f., "Total peso"                   , 12, .t. )
   ::AddField( "nPreKgr", "N", 16, 6, {|| ::cPicImp }, "Pre. kg.",      .f., "Precio kilo"                  , 12, .f. )
   ::AddField( "nTotVol", "N", 16, 6, {|| MasUnd() },  "Tot. volumen",  .f., "Total volumen"                , 12, .t. )
   ::AddField( "nPreVol", "N", 16, 6, {|| ::cPicImp }, "Pre. vol.",     .f., "Precio volumen"               , 12, .f. )
   ::AddField( "nPreMed", "N", 16, 6, {|| ::cPicImp }, "Pre. med.",     .t., "Precio medio"                 , 15, .f. )
   ::AddField( "nIvaTot", "N", 16, 6, {|| ::cPicOut }, "Tot. " + cImp(),.t., "Total " + cImp()                 , 12, .t. )
   ::AddField( "nTotFin", "N", 16, 6, {|| ::cPicOut }, "Total",         .t., "Total"                        , 18, .t. )
   ::AddField( "nPorPrv", "N",  6, 2, {|| "999.99"},   "% Vta. prv.",   .t., "% Del art�culo por proveedor" , 12, .f. )

   ::AddTmpIndex( "CCODPRV1", "CCODPRV + CCODART" )
   ::AddTmpIndex( "CCODPRV2", "CCODPRV + CNOMART" )
   ::AddTmpIndex( "CNOMPRV1", "CNOMPRV + CCODART" )
   ::AddTmpIndex( "CNOMPRV2", "CNOMPRV + CNOMART" )
   ::AddTmpIndex( "CCODPRV", "CCODPRV" )

   ::AddGroup( {|| ::oDbf:cCodPrv }, {|| "Proveedor : " + Rtrim( ::oDbf:cCodPrv ) + "-" + Rtrim( ::oDbf:cNomPrv ) }, {||"Total proveedor..."} )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   DATABASE NEW ::oTikCliT PATH ( cPatEmp() ) FILE "TIKET.DBF"    VIA ( cDriver() ) SHARED INDEX "TIKET.CDX"

   DATABASE NEW ::oTikCliL PATH ( cPatEmp() ) FILE "TIKEL.DBF"    VIA ( cDriver() ) SHARED INDEX "TIKEL.CDX"

   ::oAlbCliT := TDataCenter():oAlbCliT()

   DATABASE NEW ::oAlbCliL PATH ( cPatEmp() ) FILE "ALBCLIL.DBF"  VIA ( cDriver() ) SHARED INDEX "ALBCLIL.CDX"

   ::oFacCliT := TDataCenter():oFacCliT()

   DATABASE NEW ::oFacCliL PATH ( cPatEmp() ) FILE "FACCLIL.DBF"  VIA ( cDriver() ) SHARED INDEX "FACCLIL.CDX"

   DATABASE NEW ::oFacRecT PATH ( cPatEmp() ) FILE "FACRECT.DBF"  VIA ( cDriver() ) SHARED INDEX "FACRECT.CDX"

   DATABASE NEW ::oFacRecL PATH ( cPatEmp() ) FILE "FACRECL.DBF"  VIA ( cDriver() ) SHARED INDEX "FACRECL.CDX"

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

   ::oTikCliT := nil
   ::oTikCliL := nil
   ::oFacCliT := nil
   ::oFacCliL := nil
   ::oFacRecT := nil
   ::oFacRecL := nil
   ::oAlbCliT := nil
   ::oAlbCliL := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld )

   local cCmbPrv  := "C�digo"
   local cCmbArt  := "C�digo"

   if !::StdResource( "INFACUARTPRV" )
      return .f.
   end if

   ::CreateFilter( , ::oDbf, .t. )

   if !::oDefPrvInf( 310, 311, 320, 321, 300 )
      return .f.
   end if

   if !::lDefArtInf( 70, 80, 90, 100, 800 )
      return .f.
   end if

   if !::oDefCliInf( 410, 411, 420, 421, , 400 )
      return .f.
   end if

   ::oDefExcInf( 210 )
   ::oDefExcImp( 211 )

   REDEFINE COMBOBOX ::oCmbPrv VAR cCmbPrv ;
      ID       330 ;
      ITEMS    { "C�digo", "Nombre" } ;
      OF       ::oFld:aDialogs[1]

   REDEFINE COMBOBOX ::oCmbArt VAR cCmbArt ;
      ID       110 ;
      ITEMS    { "C�digo", "Nombre" } ;
      OF       ::oFld:aDialogs[1]

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   local cExpHead := ""
   local cExpLine := ""
   local cPrvHab

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   ::oDbf:OrdSetFocus( "CCODPRV1" )

   ::aHeader      := {  {|| "Fecha     : " + Dtoc( Date() ) },;
                        {|| "Periodo   : " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                        {|| "Proveedor : " + if( ::lAllPrv, "Todos", AllTrim( ::cPrvOrg ) + " > " + AllTrim (::cPrvDes ) ) },;
                        {|| "Art�culos : " + if( ::lAllArt, "Todos", AllTrim( ::cArtOrg ) + " > " + AllTrim (::cArtDes ) ) },;
                        {|| "Clientes  : " + if( ::lAllCli, "Todos", AllTrim( ::cCliOrg ) + " > " + AllTrim (::cCliDes ) ) } }

   /*
   Albaranes-------------------------------------------------------------------
   */

   ::oAlbCliT:OrdSetFocus( "dFecAlb" )
   ::oAlbCliL:OrdSetFocus( "nNumAlb" )

   ::oMtrInf:cText   := "Filtrando cabeceras de albaranes..."

   cExpHead          := 'nFacturado < 3 .and. dFecAlb >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecAlb <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   if !::lAllCli
      cExpHead       += ' .and. cCodCli >= "' + ::cCliOrg + '" .and. cCodCli <= "' + ::cCliDes + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter ) 
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oAlbCliT:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oAlbCliT:cFile ), ::oAlbCliT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:cText   := "Filtrando l�neas de albaranes..."
   ::oMtrInf:SetTotal( ::oAlbCliT:OrdKeyCount() )

   /*
   Lineas de albaranes
   */

   cExpLine          := '!lControl .and. !lTotLin'

   if !::lAllArt
      cExpLine       += ' .and. cRef >= "' + ::cArtOrg + '" .and. cRef <= "' + ::cArtDes + '"'
   end if

   ::oAlbCliL:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oAlbCliL:cFile ), ::oAlbCliL:OrdKey(), cAllTrimer( cExpLine ), , , , , , , , .t. )

   ::oMtrInf:cText   := "Procesando albaranes"

   ::oAlbCliT:GoTop()
   while !::lBreak .and. !::oAlbCliT:Eof()

     if lChkSer( ::oAlbCliT:cSerAlb, ::aSer )                                            .AND.;
        ::oAlbCliL:Seek( ::oAlbCliT:cSerAlb + Str( ::oAlbCliT:nNumAlb ) + ::oAlbCliT:cSufAlb )

        while ::oAlbCliT:cSerAlb + Str( ::oAlbCliT:nNumAlb ) + ::oAlbCliT:cSufAlb == ::oAlbCliL:cSerAlb + Str( ::oAlbCliL:nNumAlb ) + ::oAlbCliL:cSufAlb .AND. ! ::oAlbCliL:eof()

            cPrvHab  := oRetFld( ::oAlbCliL:cRef, ::oDbfArt , "cPrvHab")

            if ( ::lAllPrv .or. ( cPrvHab >= ::cPrvOrg .AND. cPrvHab <= ::cPrvDes ) )    .AND.;
               !( ::lExcCero .and. nTotNAlbCli( ::oAlbCliL ) == 0 )                      .AND.;
               !( ::lExcImp .and. nImpLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) == 0 )

               if ::oDbf:Seek( cPrvHab + ::oAlbCliL:cRef )

                  ::oDbf:Load()

                  ::oDbf:nNumUni    += nTotNAlbCli( ::oAlbCliL )
                  ::oDbf:nImpArt    += nTotUAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nValDiv )
                  ::oDbf:nImpTrn    += nTrnUAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nValDiv )
                  ::oDbf:nPntVer    += nPntUAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nValDiv )
                  ::oDbf:nImpTot    += nImpLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                  ::oDbf:nPreMed    := ::oDbf:nImpTot / ::oDbf:nNumUni
                  ::oDbf:nIvaTot    += nIvaLAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                  ::oDbf:nTotFin    += nImpLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                  ::oDbf:nTotFin    += nIvaLAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )

                  ::AcuPesVol( ::oAlbCliL:cRef, nTotNAlbCli( ::oAlbCliL ), ::oDbf:nImpTot, .t. )

                  ::oDbf:Save()

               else

                  ::oDbf:Append()

                  ::oDbf:cCodPrv    := cPrvHab
                  ::oDbf:cNomPrv    := oRetFld( cPrvHab, ::oDbfPrv )
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
                  ::oDbf:nNumUni    := nTotNAlbCli( ::oAlbCliL )
                  ::oDbf:nImpArt    := nTotUAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nValDiv )
                  ::oDbf:nImpTrn    := nTrnUAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nValDiv )
                  ::oDbf:nPntVer    := nPntUAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nValDiv )
                  ::oDbf:nImpTot    := nImpLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                  ::oDbf:nIvaTot    := nIvaLAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                  ::oDbf:nTotFin    := ::oDbf:nImpTot + ::oDbf:nIvaTot
                  ::oDbf:nPreMed    := ::oDbf:nImpTot / ::oDbf:nNumUni

                  ::AcuPesVol( ::oAlbCliL:cRef, nTotNAlbCli( ::oAlbCliL ), ::oDbf:nImpTot, .f. )

                  ::oDbf:Save()

               end if

            end if

            ::oAlbCliL:Skip()

        end while

     end if

     ::oAlbCliT:Skip()

     ::oMtrInf:AutoInc()

   end while

   ::oMtrInf:AutoInc( ::oAlbCliT:Lastrec() )

   ::oAlbCliT:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oAlbCliT:cFile ) )

   ::oAlbCliL:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oAlbCliL:cFile ) )

   /*
   Facturas--------------------------------------------------------------------
   */

   ::oFacCliT:OrdSetFocus( "dFecFac" )
   ::oFacCliL:OrdSetFocus( "nNumFac" )

   ::oMtrInf:cText   := "Filtrando facturas..."
   cExpHead          := 'dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   if !::lAllCli
      cExpHead       += ' .and. cCodCli >= "' + ::cCliOrg + '" .and. cCodCli <= "' + ::cCliDes + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oFacCliT:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oFacCliT:cFile ), ::oFacCliT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:cText   := "Filtrando lineas de facturas..."
   ::oMtrInf:SetTotal( ::oFacCliT:OrdKeyCount() )

   cExpLine          := '!lControl .and. !lTotLin'

   if !::lAllArt
      cExpLine       += ' .and. cRef >= "' + ::cArtOrg + '" .and. cRef <= "' + ::cArtDes + '"'
   end if

   ::oFacCliL:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oFacCliL:cFile ), ::oFacCliL:OrdKey(), cAllTrimer( cExpLine ), , , , , , , , .t. )

   ::oMtrInf:cText   := "Procesando facturas"

   ::oFacCliT:GoTop()
   while !::lBreak .and. !::oFacCliT:Eof()

     if lChkSer( ::oFacCliT:cSerie, ::aSer )                                            .AND.;
        ::oFacCliL:Seek( ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac )

        while ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac == ::oFacCliL:cSerie + Str( ::oFacCliL:nNumFac ) + ::oFacCliL:cSufFac .AND. ! ::oFacCliL:eof()

           cPrvHab  := oRetFld( ::oFacCliL:cRef, ::oDbfArt , "cPrvHab")

            if ( ::lAllPrv .or. ( cPrvHab >= ::cPrvOrg .AND. cPrvHab <= ::cPrvDes ) )    .AND.;
               !( ::lExcCero .and. nTotNFacCli( ::oFacCliL ) == 0 )                      .AND.;
               !( ::lExcImp .and. nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) == 0 )

            if ::oDbf:Seek( cPrvHab + ::oFacCliL:cRef )

               ::oDbf:Load()

               ::oDbf:nNumUni    += nTotNFacCli( ::oFacCliL )
               ::oDbf:nImpArt    += nTotUFacCli( ::oFacCliL:cAlias, ::nDecOut, ::nValDiv )
               ::oDbf:nImpTrn    += nTrnUFacCli( ::oFacCliL:cAlias, ::nDecOut, ::nValDiv )
               ::oDbf:nPntVer    += nPntUFacCli( ::oFacCliL:cAlias, ::nDecOut, ::nValDiv )
               ::oDbf:nImpTot    += nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
               ::oDbf:nPreMed    := ::oDbf:nImpTot / ::oDbf:nNumUni
               ::oDbf:nIvaTot    += nIvaLFacCli( ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
               ::oDbf:nTotFin    += nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
               ::oDbf:nTotFin    += nIvaLFacCli( ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )

               ::AcuPesVol( ::oFacCliL:cRef, nTotNFacCli( ::oFacCliL ), ::oDbf:nImpTot, .t. )

               ::oDbf:Save()

            else

               ::oDbf:Append()

               ::oDbf:cCodPrv    := cPrvHab
               ::oDbf:cNomPrv    := oRetFld( cPrvHab, ::oDbfPrv )
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
               ::oDbf:nNumUni    := nTotNFacCli( ::oFacCliL )
               ::oDbf:nImpArt    := nTotUFacCli( ::oFacCliL:cAlias, ::nDecOut, ::nValDiv )
               ::oDbf:nImpTrn    := nTrnUFacCli( ::oFacCliL:cAlias, ::nDecOut, ::nValDiv )
               ::oDbf:nPntVer    := nPntUFacCli( ::oFacCliL:cAlias, ::nDecOut, ::nValDiv )
               ::oDbf:nImpTot    := nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
               ::oDbf:nIvaTot    := nIvaLFacCli( ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
               ::oDbf:nTotFin    := ::oDbf:nImpTot + ::oDbf:nIvaTot
               ::oDbf:nPreMed    := ::oDbf:nImpTot / ::oDbf:nNumUni

               ::AcuPesVol( ::oFacCliL:cRef, nTotNFacCli( ::oFacCliL ), ::oDbf:nImpTot, .f. )

               ::oDbf:Save()

            end if

           end if

           ::oFacCliL:Skip()

        end while

     end if

     ::oFacCliT:Skip()

     ::oMtrInf:AutoInc()

   end while

   ::oMtrInf:AutoInc( ::oFacCliT:Lastrec() )

   ::oFacCliT:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oFacCliT:cFile ) )

   ::oFacCliL:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oFacCliL:cFile ) )

   /*
   Facturas rectificativas-----------------------------------------------------
   */

   ::oFacRecT:OrdSetFocus( "dFecFac" )
   ::oFacRecL:OrdSetFocus( "nNumFac" )

   ::oMtrInf:cText   := "Filtrando fac. rec."
   cExpHead          := 'dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   if !::lAllCli
      cExpHead       += ' .and. cCodCli >= "' + ::cCliOrg + '" .and. cCodCli <= "' + ::cCliDes + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter 
   end if

   ::oFacRecT:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oFacRecT:cFile ), ::oFacRecT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:cText   := "Filtrando l�neas de fac. rec."
   ::oMtrInf:SetTotal( ::oFacRecT:OrdKeyCount() )

   cExpLine          := '!lControl .and. !lTotLin'

   if !::lAllArt
      cExpLine       += ' .and. cRef >= "' + ::cArtOrg + '" .and. cRef <= "' + ::cArtDes + '"'
   end if

   ::oFacRecL:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oFacRecL:cFile ), ::oFacRecL:OrdKey(), cAllTrimer( cExpLine ), , , , , , , , .t. )

   ::oMtrInf:cText   := "Procesando fac. rec."

   ::oFacRecT:GoTop()
   while !::lBreak .and. !::oFacRecT:Eof()

     if lChkSer( ::oFacRecT:cSerie, ::aSer )                                            .AND.;
        ::oFacRecL:Seek( ::oFacRecT:cSerie + Str( ::oFacRecT:nNumFac ) + ::oFacRecT:cSufFac )

        while ::oFacRecT:cSerie + Str( ::oFacRecT:nNumFac ) + ::oFacRecT:cSufFac == ::oFacRecL:cSerie + Str( ::oFacRecL:nNumFac ) + ::oFacRecL:cSufFac .AND. ! ::oFacRecL:eof()

           cPrvHab  := oRetFld( ::oFacRecL:cRef, ::oDbfArt , "cPrvHab")

           if ( ::lAllPrv .or. ( cPrvHab >= ::cPrvOrg .AND. cPrvHab <= ::cPrvDes ) )    .AND.;
              !( ::lExcCero .and. nTotNFacRec( ::oFacRecL ) == 0 )                      .AND.;
              !( ::lExcImp .and. nImpLFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) == 0 )

              if ::oDbf:Seek( cPrvHab + ::oFacRecL:cRef )

               ::oDbf:Load()

               ::oDbf:nNumUni    += nTotNFacRec( ::oFacRecL )
               ::oDbf:nImpArt    += nTotUFacRec( ::oFacRecL:cAlias, ::nDecOut, ::nValDiv )
               ::oDbf:nImpTrn    += nTrnUFacRec( ::oFacRecL:cAlias, ::nDecOut, ::nValDiv )
               ::oDbf:nPntVer    += nPntUFacRec( ::oFacRecL:cAlias, ::nDecOut, ::nValDiv )
               ::oDbf:nImpTot    += nImpLFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
               ::oDbf:nPreMed    := ::oDbf:nImpTot / ::oDbf:nNumUni
               ::oDbf:nIvaTot    += nIvaLFacRec( ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
               ::oDbf:nTotFin    += nImpLFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
               ::oDbf:nTotFin    += nIvaLFacRec( ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )

               ::AcuPesVol( ::oFacRecL:cRef, nTotNFacRec( ::oFacRecL ), ::oDbf:nImpTot, .t. )

               ::oDbf:Save()

            else

               ::oDbf:Append()

               ::oDbf:cCodPrv    := cPrvHab
               ::oDbf:cNomPrv    := oRetFld( cPrvHab, ::oDbfPrv )
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
               ::oDbf:nNumUni    := nTotNFacRec( ::oFacRecL )
               ::oDbf:nImpArt    := nTotUFacRec( ::oFacRecL:cAlias, ::nDecOut, ::nValDiv )
               ::oDbf:nImpTrn    := nTrnUFacRec( ::oFacRecL:cAlias, ::nDecOut, ::nValDiv )
               ::oDbf:nPntVer    := nPntUFacRec( ::oFacRecL:cAlias, ::nDecOut, ::nValDiv )
               ::oDbf:nImpTot    := nImpLFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
               ::oDbf:nIvaTot    := nIvaLFacRec( ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
               ::oDbf:nTotFin    := ::oDbf:nImpTot + ::oDbf:nIvaTot
               ::oDbf:nPreMed    := ::oDbf:nImpTot / ::oDbf:nNumUni

               ::AcuPesVol( ::oFacRecL:cRef, nTotNFacRec( ::oFacRecL ), ::oDbf:nImpTot, .f. )

               ::oDbf:Save()

            end if

           end if

           ::oFacRecL:Skip()

        end while

     end if

     ::oFacRecT:Skip()

     ::oMtrInf:AutoInc()

   end while

   ::oMtrInf:AutoInc( ::oFacRecT:Lastrec() )

   ::oFacRecT:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oFacRecT:cFile ) )

   ::oFacRecL:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oFacRecL:cFile ) )

   /*
   Tikets ---------------------------------------------------------------------
   */

   ::oTikCliT:OrdSetFocus( "dFecTik" )
   ::oTikCliL:OrdSetFocus( "cNumTil" )

   ::oMtrInf:cText   := "Filtrando tikets..."

   cExpHead          := 'dFecTik >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecTik <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   if !::lAllCli
      cExpHead       += ' .and. cCliTik >= "' + ::cCliOrg + '" .and. cCliTik <= "' + ::cCliDes + '"'
   end if

   cExpHead          += ' .and. ( cTipTik == "1" .or. cTipTik == "4" )'

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter 
   end if

   ::oTikCliT:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oTikCliT:cFile ), ::oTikCliT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:cText   := "Filtrando lineas de tikets..."
   ::oMtrInf:SetTotal( ::oTikCliT:OrdKeyCount() )

   cExpLine          := '!lControl '

   if ::lAllArt
      cExpLine       += ' .and. (!Empty( cCbaTil ) .or. !Empty( cComTil ))'
   else
      cExpLine       += ' .and. ( ( !Empty( cCbaTil ) .and. cCbaTil >= "' + ::cArtOrg + '" .and. cCbaTil <= "' + ::cArtDes + '" )'
      cExpLine       += ' .or. '
      cExpLine       += '( !Empty( cComTil ) .and. cComTil >= "' + ::cArtOrg + '" .and. cComTil <= "' + ::cArtDes + '" ) )'
   end if

   ::oTikCliL:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oTikCliL:cFile ), ::oTikCliL:OrdKey(), cAllTrimer( cExpLine ), , , , , , , , .t. )

   ::oMtrInf:cText   := "Procesando tikets"

   ::oTikCliT:GoTop()
   while !::lBreak .and. !::oTikCliT:Eof()

      if lChkSer( ::oTikCliT:cSerTik, ::aSer )                                            .AND.;
         ::oTikCliL:Seek( ::oTikCliT:cSerTik + ::oTikCliT:cNumTik + ::oTikCliT:cSufTik )

         while ::oTikCliT:cSerTik + ::oTikCliT:cNumTik + ::oTikCliT:cSufTik == ::oTikCliL:cSerTil + ::oTikCliL:cNumTil + ::oTikCliL:cSufTil .and. !::oTikCliL:Eof()

            cPrvHab  := oRetFld( ::oTikCliL:cCbaTil, ::oDbfArt , "cPrvHab")

            if !Empty( ::oTikCliL:cCbaTil )                                              .AND.;
               ( ::lAllPrv .or. ( cPrvHab >= ::cPrvOrg .AND. cPrvHab <= ::cPrvDes ) )    .AND.;
               !( ::lExcCero .AND. ::oTikCLiL:nUntTil == 0 )                             .AND.;
               !( ::lExcImp .AND. ::oTikCliL:nPvpTil == 0 )

               if !::oDbf:Seek( cPrvHab + ::oTikCliL:cCbaTil )

                  ::oDbf:Append()

                  ::oDbf:cCodPrv    := cPrvHab
                  ::oDbf:cNomPrv    := oRetFld( cPrvHab, ::oDbfPrv )
                  ::oDbf:cCodArt    := ::oTikCliL:cCbaTil
                  ::oDbf:cNomArt    := RetArticulo( ::oTikCliL:cCbaTil, ::oDbfArt )
                  ::oDbf:cCodPr1    := ::oTikCliL:cCodPr1
                  ::oDbf:cNomPr1    := retProp( ::oTikCliL:cCodPr1 )
                  ::oDbf:cCodPr2    := ::oTikCliL:cCodPr2
                  ::oDbf:cNomPr2    := retProp( ::oTikCliL:cCodPr2 )
                  ::oDbf:cValPr1    := ::oTikCliL:cValPr1
                  ::oDbf:cNomVl1    := retValProp( ::oTikCliL:cCodPr1 + ::oTikCliL:cValPr1 )
                  ::oDbf:cValPr2    := ::oTikCliL:cValPr2
                  ::oDbf:cNomVl2    := retValProp( ::oTikCliL:cCodPr2 + ::oTikCliL:cValPr2 )

                  if ::oTikCliT:cTipTik == "4"
                     ::oDbf:nNumUni := - ::oTikCliL:nUntTil
                  else
                     ::oDbf:nNumUni := ::oTikCliL:nUntTil
                  end if

                  ::oDbf:nImpArt       := nImpUTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nValDiv, nil, 1 )
                  ::oDbf:nImpTot       := nImpLTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nDerOut, ::nValDiv, nil, 1 )
                  ::oDbf:nIvaTot       := nIvaLTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nDerOut, ::nValDiv, 1 )
                  ::oDbf:nTotFin       := ::oDbf:nImpTot + ::oDbf:nIvaTot

                  ::AcuPesVol( ::oTikCliL:cCbaTil, ::oTikCliL:nUntTil, ::oDbf:nImpTot, .f. )

                  ::oDbf:Save()

               else

                  ::oDbf:Load()

                  if ::oTikCliT:cTipTik == "4"
                     ::oDbf:nNumUni     -= ::oTikCliL:nUntTil
                  else
                     ::oDbf:nNumUni     += ::oTikCliL:nUntTil
                  end if

                  ::oDbf:nImpArt       += nImpUTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nValDiv, nil, 1 )
                  ::oDbf:nImpTot       += nImpLTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nDerOut, ::nValDiv, nil, 1 )
                  ::oDbf:nIvaTot       += nIvaLTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nDerOut, ::nValDiv, 1 )
                  ::oDbf:nTotFin       := ::oDbf:nImpTot + ::oDbf:nIvaTot

                  ::AcuPesVol( ::oTikCliL:cCbaTil, ::oTikCliL:nUntTil, ::oDbf:nImpTot, .t. )

                  ::oDbf:Save()

               end if

            end if

            cPrvHab  := oRetFld( ::oTikCliL:cComTil, ::oDbfArt , "cPrvHab")

            if !Empty( ::oTikCliL:cComTil )                       .AND.;
               ( ::lAllPrv .or. ( cPrvHab >= ::cPrvOrg .AND. cPrvHab <= ::cPrvDes ) )    .AND.;
               !( ::lExcCero .AND. ::oTikCliL:nUntTil == 0 )                             .AND.;
               !( ::lExcImp .AND. ::oTikCliL:nPcmTil == 0 )

               if !::oDbf:Seek( cPrvHab + ::oTikCliL:cComTil )

                  ::oDbf:Append()

                  ::oDbf:cCodPrv    := cPrvHab
                  ::oDbf:cNomPrv    := oRetFld( cPrvHab, ::oDbfPrv )
                  ::oDbf:cCodArt    := ::oTikCliL:cComTil
                  ::oDbf:cNomArt    := RetArticulo( ::oTikCliL:cComTil, ::oDbfArt )
                  ::oDbf:cCodPr1    := ::oTikCliL:cCodPr1
                  ::oDbf:cNomPr1    := retProp( ::oTikCliL:cCodPr1 )
                  ::oDbf:cCodPr2    := ::oTikCliL:cCodPr2
                  ::oDbf:cNomPr2    := retProp( ::oTikCliL:cCodPr2 )
                  ::oDbf:cValPr1    := ::oTikCliL:cValPr1
                  ::oDbf:cNomVl1    := retValProp( ::oTikCliL:cCodPr1 + ::oTikCliL:cValPr1 )
                  ::oDbf:cValPr2    := ::oTikCliL:cValPr2
                  ::oDbf:cNomVl2    := retValProp( ::oTikCliL:cCodPr2 + ::oTikCliL:cValPr2 )

                  if ::oTikCliT:cTipTik == "4"
                     ::oDbf:nNumUni := - ::oTikCliL:nUntTil
                  else
                     ::oDbf:nNumUni := ::oTikCliL:nUntTil
                  end if

                  ::oDbf:nImpArt       := nImpUTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nValDiv, nil, 2 )
                  ::oDbf:nImpTot       := nImpLTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nDerOut, ::nValDiv, nil, 2 )
                  ::oDbf:nIvaTot       := nIvaLTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nDerOut, ::nValDiv, 2 )
                  ::oDbf:nTotFin       := ::oDbf:nImpTot + ::oDbf:nIvaTot

                  ::AcuPesVol( ::oTikCliL:cComTil, ::oTikCliL:nUntTil, ::oDbf:nImpTot, .f. )

                  ::oDbf:Save()

               else

                  ::oDbf:Load()

                  if ::oTikCliT:cTipTik == "4"
                     ::oDbf:nNumUni     -= ::oTikCliL:nUntTil
                  else
                     ::oDbf:nNumUni     += ::oTikCliL:nUntTil
                  end if

                  ::oDbf:nImpArt       += nImpUTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nValDiv, nil, 2 )
                  ::oDbf:nImpTot       += nImpLTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nDerOut, ::nValDiv, nil, 2 )
                  ::oDbf:nIvaTot       += nIvaLTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nDerOut, ::nValDiv, 2 )
                  ::oDbf:nTotFin       := ::oDbf:nImpTot + ::oDbf:nIvaTot

                  ::AcuPesVol( ::oTikCliL:cComTil, ::oTikCliL:nUntTil, ::oDbf:nImpTot, .t. )

                  ::oDbf:Save()

               end if

            end if

            ::oTikCliL:Skip()

         end while

      end if

      ::oTikCliT:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oTikCliT:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oTikCliT:cFile ) )

   ::oTikCliL:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oTikCliL:cFile ) )

   ::oMtrInf:AutoInc( ::oTikCliT:Lastrec() )

   /*Calculamos el procentaje que representa un art�culo para un proveedor*/

   ::PosGenerate()

   if !::lExcCero
      ::IncluyeCero()
   end if

   if ::oDbf:RecCount() > 0

      do case
         case ::oCmbPrv:nAt == 1 .and. ::oCmbArt:nAt == 1
            ::oDbf:OrdSetFocus( "CCODPRV1" )
         case ::oCmbPrv:nAt == 2 .and. ::oCmbArt:nAt == 1
            ::oDbf:OrdSetFocus( "CNOMPRV1" )
         case ::oCmbPrv:nAt == 1 .and. ::oCmbArt:nAt == 2
            ::oDbf:OrdSetFocus( "CCODPRV2" )
         case ::oCmbPrv:nAt == 2 .and. ::oCmbArt:nAt == 2
            ::oDbf:OrdSetFocus( "CNOMPRV2" )
      end case

   end if

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//

METHOD IncluyeCero()

   ::oDbfPrv:GoTop()
   while !::oDbfArt:Eof()

      if ( ::lAllPrv .or. ( ::oDbfArt:cPrvHab >= ::cPrvOrg  .AND. ::oDbfArt:cPrvHab <= ::cPrvDes ) ) .AND.;
         ( ::lAllArt .or. ( ::oDbfArt:Codigo >= ::cArtOrg   .AND. ::oDbfArt:Codigo <= ::cArtDes ) ) .AND.;
         !::oDbf:Seek( ::oDbfArt:cPrvHab + ::oDbfArt:Codigo )

         ::oDbf:Append()
         ::oDbf:Blank()
         ::oDbf:cCodPrv    := ::oDbfArt:cPrvHab
         ::oDbf:cNomPrv    := oRetFld( ::oDbfArt:cPrvHab, ::oDbfPrv )
         ::oDbf:cCodArt    := ::oDbfArt:Codigo
         ::oDbf:cNomArt    := ::oDbfArt:Nombre
         ::oDbf:Save()

      end if

      ::oDbfArt:Skip()

   end while

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD PosGenerate()

   local nTotPrv     := 0

   ::oDbf:GoTop()

   ::oMtrInf:cText   := "Calculando porcentajes..."
   ::oMtrInf:SetTotal( ::oDbf:OrdKeyCount() )

   while !::oDbf:Eof()

      if ::oDbf:nTotFin != 0

         nTotPrv              := ::nTotPrv( ::oDbf:cCodPrv )
         if nTotPrv != 0
            ::oDbf:Load()
            ::oDbf:nPorPrv    := ( ::oDbf:nTotFin / nTotPrv ) * 100
            ::oDbf:Save()
         end if

      end if

   ::oDbf:Skip()

   ::oMtrInf:AutoInc( ::oDbf:OrdKeyNo() )

   end while

   ::oMtrInf:AutoInc( ::oDbf:LastRec() )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD nTotPrv( cCodPrv )

   local nRec     := ::oDbf:Recno()
   local nOrdAnt  := ::oDbf:OrdSetFocus( "CCODPRV" )
   local nTotal   := 0

   if ::oDbf:Seek( cCodPrv )

      while ::oDbf:cCodPrv == cCodPrv .and. !::oDbf:Eof()

         nTotal += ::oDbf:nTotFin

      ::oDbf:Skip()

      end while

   end if

   ::oDbf:OrdSetFocus( nOrdAnt )
   ::oDbf:GoTo( nRec )

RETURN ( nTotal )

//---------------------------------------------------------------------------//