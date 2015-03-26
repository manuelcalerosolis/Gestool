#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TRnkGFRVta FROM TInfGen

   DATA  oDbfIva     AS OBJECT
   DATA  oAlbCliT    AS OBJECT
   DATA  oAlbCliL    AS OBJECT
   DATA  oFacCliT    AS OBJECT
   DATA  oFacCliL    AS OBJECT
   DATA  oFacRecT    AS OBJECT
   DATA  oFacRecL    AS OBJECT
   DATA  oTikCliT    AS OBJECT
   DATA  oTikCliL    AS OBJECT
   DATA  oLimit      AS OBJECT
   DATA  nLimit      AS NUMERIC   INIT 0
   DATA  lAllPrc     AS LOGIC    INIT .t.

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField( "cCodGrp", "C",  3, 0, {|| "@!"          },"Grupo",                     .f., "Código grupo",               9 )
   ::AddField( "cNomGrp", "C", 30, 0, {|| "@!"          },"Nom. Grp.",                 .f., "Nombre grupo",               9 )
   ::AddField( "cCodFam", "C", 16, 0, {|| "@!"          },"Familia",                   .f., "Código familia",             9 )
   ::AddField( "cNomFam", "C", 40, 0, {|| "@!"          },"Nom. Fam.",                 .f., "Nombre familia",             9 )
   ::AddField( "cCodArt", "C", 18, 0, {|| "@!"          },"Código",                    .t., "Código artículo",            9 )
   ::AddField( "cNomArt", "C",100, 0, {|| "@!"          },"Artículo",                  .t., "Nombre artículo",           35 )
   ::AddField( "nTotUni", "N", 16, 3, {|| MasUnd()      },"Tot. " + cNombreUnidades(), .t., "Total " + cNombreunidades(),10 )
   ::AddField( "nTotNet", "N", 16, 6, {|| ::cPicOut     },"Neto",                      .t., "Neto",                      10 )
   ::AddField( "nTotIva", "N", 16, 6, {|| ::cPicOut     },cImp(),                       .t., cImp(),                       10 )
   ::AddField( "nTotDoc", "N", 16, 6, {|| ::cPicOut     },"Total",                     .t., "Total",                     10 )

   ::AddTmpIndex( "CCODART", "CCODGRP + CCODFAM + CCODART" )
   ::AddTmpIndex( "NTOTDOC", "CCODGRP + CCODFAM + Str( NTOTDOC )", , , , .t. )

   ::AddGroup( {|| ::oDbf:cCodGrp }, {|| "Grupo familia : " + AllTrim( ::oDbf:cCodGrp ) + "-" + AllTrim( ::oDbf:cNomGrp ) }, {|| "Total grupo familia..." } )
   ::AddGroup( {|| ::oDbf:cCodGrp + ::oDbf:cCodFam }, {|| "Familia : " + AllTrim( ::oDbf:cCodFam ) + "-" + AllTrim( ::oDbf:cNomFam ) }, {|| "Total familia..." } )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS TRnkGFRVta

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   ::oAlbCliT := TDataCenter():oAlbCliT()

   DATABASE NEW ::oAlbCliL  PATH ( cPatEmp() ) FILE "ALBCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "ALBCLIL.CDX"

   ::oFacCliT := TDataCenter():oFacCliT()

   DATABASE NEW ::oFacCliL  PATH ( cPatEmp() ) FILE "FACCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "FACCLIL.CDX"

   DATABASE NEW ::oFacRecT  PATH ( cPatEmp() ) FILE "FACRECT.DBF" VIA ( cDriver() ) SHARED INDEX "FACRECT.CDX"

   DATABASE NEW ::oFacRecL  PATH ( cPatEmp() ) FILE "FACRECL.DBF" VIA ( cDriver() ) SHARED INDEX "FACRECL.CDX"

   DATABASE NEW ::oTikCliT  PATH ( cPatEmp() ) FILE "TIKET.DBF"   VIA ( cDriver() ) SHARED INDEX "TIKET.CDX"

   DATABASE NEW ::oTikCliL  PATH ( cPatEmp() ) FILE "TIKEL.DBF"   VIA ( cDriver() ) SHARED INDEX "TIKEL.CDX"

   DATABASE NEW ::oDbfIva   PATH ( cPatDat() ) FILE "TIVA.DBF"    VIA ( cDriver() ) SHARED INDEX "TIVA.CDX"

   ::bForReport   := {|| ::lAllPrc .or. ::oDbf:nTotNet >= ::nLimit }

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos" )
      ::CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TRnkGFRVta

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
   if !Empty( ::oDbfIva ) .and. ::oDbfIva:Used()
      ::oDbfIva:End()
   end if

   ::oAlbCliT := nil
   ::oAlbCliL := nil
   ::oFacCliT := nil
   ::oFacCliL := nil
   ::oFacRecT := nil
   ::oFacRecL := nil
   ::oTikCliT := nil
   ::oTikCliL := nil
   ::oDbfIva  := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld ) CLASS TRnkGFRVta

   if !::StdResource( "RNKVTAGFR" )
      return .f.
   end if

   ::CreateFilter( , ::oDbf, .t. )

   if !::oDefGrFInf( 200, 201, 210, 211, 220 )
      return .f.
   end if

   if !::lDefFamInf( 300, 301, 310, 311, 320 )
      return .f.
   end if

   if !::lDefArtInf( 110, 120, 130, 140, 800 )
      return .f.
   end if

   REDEFINE CHECKBOX ::lAllPrc ;
      ID       160 ;
      OF       ::oFld:aDialogs[1]

   REDEFINE GET ::oLimit VAR ::nLimit ;
		COLOR 	CLR_GET ;
      PICTURE  PicOut() ;
      WHEN     !::lAllPrc ;
      ID       150 ;
      OF       ::oFld:aDialogs[1]

   ::oMtrInf:SetTotal( ::oAlbCliT:Lastrec() )

RETURN .t.

//---------------------------------------------------------------------------//

METHOD lGenerate() CLASS TRnkGFRVta

   local cExpHead    := ""
   local cExpLine    := ""

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   ::oDbf:OrdSetFocus( "CCODART" )

   ::aHeader   :={ {|| "Fecha     : "  + Dtoc( Date() ) },;
                   {|| "Grp.Fam.  : "  + if( ::lAllGrp, "Todos", AllTrim( ::cGruFamOrg ) + " > " + AllTrim( ::cGruFamDes ) ) },;
                   {|| "Familia   : "  + if( ::lAllFam, "Todas", AllTrim( ::cFamOrg ) + " > " + AllTrim( ::cFamDes ) ) },;
                   {|| "Artículos : "  + if( ::lAllArt, "Todos", AllTrim( ::cArtOrg ) + " > " + AllTrim( ::cArtDes ) ) },;
                   {|| "Importe   : "  + if( ::lAllPrc, "Todos los importes", "Mayor de : " + AllTrim( Str( ::nLimit ) ) ) } }

   /*Procesamos los albaranes no facturados*/

   ::oAlbCliT:OrdSetFocus( "dFecAlb" )
   ::oAlbCliL:OrdSetFocus( "nNumAlb" )

   cExpHead          := 'nFacturado < 3 .and. dFecAlb >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecAlb <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   if !Empty( ::oFilter:cExpresionFilter ) 
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oAlbCliT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oAlbCliT:cFile ), ::oAlbCliT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:cText   := "Procesando albaranes"
   ::oMtrInf:SetTotal( ::oAlbCliT:OrdKeyCount() )

   cExpLine          := '!lTotLin .and. !lControl'

   if !::lAllGrp
      cExpLine       += ' .and. cGrpFam >= "' + Rtrim( ::cGruFamOrg ) + '" .and. cGrpFam <= "' + Rtrim( ::cGruFamDes ) + '"'
   end if

   if !::lAllFam
      cExpLine       += ' .and. cCodFam >= "' + Rtrim( ::cFamOrg ) + '" .and. cCodFam <= "' + Rtrim( ::cFamDes ) + '"'
   end if

   if !::lAllArt
      cExpLine       += ' .and. cRef >= "' + ::cArtOrg + '" .and. cRef <= "' + ::cArtDes + '"'
   end if

   ::oAlbCliL:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oAlbCliL:cFile ), ::oAlbCliL:OrdKey(), cAllTrimer( cExpLine ), , , , , , , , .t. )

   ::oAlbCliT:GoTop()

   while !::lBreak .and. !::oAlbCliT:Eof()

      if lChkSer( ::oAlbCliT:cSerAlb, ::aSer )     .and.;
         ::oAlbCliL:Seek( ::oAlbCliT:cSerAlb + Str( ::oAlbCliT:nNumAlb ) + ::oAlbCliT:cSufAlb )

         while ::oAlbCliL:cSerAlb + Str( ::oAlbCliL:nNumAlb ) + ::oAlbCliL:cSufAlb == ::oAlbCliT:cSerAlb + Str( ::oAlbCliT:nNumAlb ) + ::oAlbCliT:cSufAlb .and.;
               !::oAlbCliL:Eof()

               if !::oDbf:Seek( ::oAlbCliL:cGrpFam + ::oAlbCliL:cCodFam + ::oAlbCliL:cRef )

                  ::oDbf:Append()

                  ::oDbf:cCodGrp    := ::oAlbCliL:cGrpFam
                  ::oDbf:cNomGrp    := oRetFld( ::oAlbCliL:cGrpFam, ::oGruFam:oDbf )
                  ::oDbf:cCodFam    := ::oAlbCliL:cCodFam
                  ::oDbf:cNomFam    := cNomFam( ::oAlbCliL:cCodFam, ::oDbfFam )
                  ::oDbf:cCodArt    := ::oAlbCliL:cRef
                  ::oDbf:cNomArt    := ::oAlbCliL:cDetalle
                  ::oDbf:nTotUni    := nTotNAlbCli( ::oAlbCliL )
                  ::oDbf:nTotNet    := nImpLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                  ::oDbf:nTotIva    := nIvaLAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                  ::oDbf:nTotDoc    := ::oDbf:nTotNet + ::oDbf:nTotIva

                  ::oDbf:Save()

               else

                  ::oDbf:Load()

                  ::oDbf:nTotUni    += nTotNAlbCli( ::oAlbCliL )
                  ::oDbf:nTotNet    += nImpLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                  ::oDbf:nTotIva    += nIvaLAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                  ::oDbf:nTotDoc    += nImpLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                  ::oDbf:nTotDoc    += nIvaLAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )

                  ::oDbf:Save()

               end if

         ::oAlbCliL:Skip()

         end while

      end if

   ::oAlbCliT:Skip()

   ::oMtrInf:AutoInc()

   end while

   ::oAlbCliT:IdxDelete( cCurUsr(), GetFileNoExt( ::oAlbCliT:cFile ) )

   ::oAlbCliL:IdxDelete( cCurUsr(), GetFileNoExt( ::oAlbCliL:cFile ) )

   /*Procesamos las facturas*/

   ::oFacCliT:OrdSetFocus( "dFecFac" )
   ::oFacCliL:OrdSetFocus( "nNumFac" )

   cExpHead          := 'dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oFacCliT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oFacCliT:cFile ), ::oFacCliT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oFacCliT:OrdKeyCount() )
   ::oMtrInf:cText   := "Procesando facturas"

   cExpLine          := '!lTotLin .and. !lControl'

   if !::lAllGrp
      cExpLine       += ' .and. cGrpFam >= "' + Rtrim( ::cGruFamOrg ) + '" .and. cGrpFam <= "' + Rtrim( ::cGruFamDes ) + '"'
   end if

   if !::lAllFam
      cExpLine       += ' .and. cCodFam >= "' + Rtrim( ::cFamOrg ) + '" .and. cCodFam <= "' + Rtrim( ::cFamDes ) + '"'
   end if

   if !::lAllArt
      cExpLine       += ' .and. cRef >= "' + ::cArtOrg + '" .and. cRef <= "' + ::cArtDes + '"'
   end if

   ::oFacCliL:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oFacCliL:cFile ), ::oFacCliL:OrdKey(), cAllTrimer( cExpLine ), , , , , , , , .t. )

   ::oFacCliT:GoTop()

   while !::lBreak .and. !::oFacCliT:Eof()

      if lChkSer( ::oFacCliT:cSerie, ::aSer )     .and.;
         ::oFacCliL:Seek( ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac )

         while ::oFacCliL:cSerie + Str( ::oFacCliL:nNumFac ) + ::oFacCliL:cSufFac == ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac .and.;
               !::oFacCliL:Eof()

               if !::oDbf:Seek( ::oFacCliL:cGrpFam + ::oFacCliL:cCodFam + ::oFacCliL:cRef )

                  ::oDbf:Append()

                  ::oDbf:cCodGrp    := ::oFacCliL:cGrpFam
                  ::oDbf:cNomGrp    := oRetFld( ::oFacCliL:cGrpFam, ::oGruFam:oDbf )
                  ::oDbf:cCodFam    := ::oFacCliL:cCodFam
                  ::oDbf:cNomFam    := cNomFam( ::oFacCliL:cCodFam, ::oDbfFam )
                  ::oDbf:cCodArt    := ::oFacCliL:cRef
                  ::oDbf:cNomArt    := ::oFacCliL:cDetalle
                  ::oDbf:nTotUni    := nTotNFacCli( ::oFacCliL )
                  ::oDbf:nTotNet    := nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                  ::oDbf:nTotIva    := nIvaLFacCli( ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                  ::oDbf:nTotDoc    := ::oDbf:nTotNet + ::oDbf:nTotIva

                  ::oDbf:Save()

               else

                  ::oDbf:Load()

                  ::oDbf:nTotUni    += nTotNFacCli( ::oFacCliL )
                  ::oDbf:nTotNet    += nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                  ::oDbf:nTotIva    += nIvaLFacCli( ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                  ::oDbf:nTotDoc    += nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                  ::oDbf:nTotDoc    += nIvaLFacCli( ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )

                  ::oDbf:Save()

               end if

         ::oFacCliL:Skip()

         end while

      end if

   ::oFacCliT:Skip()

   ::oMtrInf:AutoInc()

   end while

   ::oFacCliT:IdxDelete( cCurUsr(), GetFileNoExt( ::oFacCliT:cFile ) )

   ::oFacCliL:IdxDelete( cCurUsr(), GetFileNoExt( ::oFacCliL:cFile ) )

   /*Procesamos las facturas rectificativas*/

   ::oFacRecT:OrdSetFocus( "dFecFac" )
   ::oFacRecL:OrdSetFocus( "nNumFac" )

   cExpHead          := 'dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter 
   end if

   ::oFacRecT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oFacRecT:cFile ), ::oFacRecT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oFacRecT:OrdKeyCount() )
   ::oMtrInf:cText   := "Procesando rectificativas"

   cExpLine          := '!lTotLin .and. !lControl'

   if !::lAllGrp
      cExpLine       += ' .and. cGrpFam >= "' + Rtrim( ::cGruFamOrg ) + '" .and. cGrpFam <= "' + Rtrim( ::cGruFamDes ) + '"'
   end if

   if !::lAllFam
      cExpLine       += ' .and. cCodFam >= "' + Rtrim( ::cFamOrg ) + '" .and. cCodFam <= "' + Rtrim( ::cFamDes ) + '"'
   end if

   if !::lAllArt
      cExpLine       += ' .and. cRef >= "' + ::cArtOrg + '" .and. cRef <= "' + ::cArtDes + '"'
   end if

   ::oFacRecL:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oFacRecL:cFile ), ::oFacRecL:OrdKey(), cAllTrimer( cExpLine ), , , , , , , , .t. )

   ::oFacRecT:GoTop()

   while !::lBreak .and. !::oFacRecT:Eof()

      if lChkSer( ::oFacRecT:cSerie, ::aSer )     .and.;
         ::oFacRecL:Seek( ::oFacRecT:cSerie + Str( ::oFacRecT:nNumFac ) + ::oFacRecT:cSufFac )

         while ::oFacRecL:cSerie + Str( ::oFacRecL:nNumFac ) + ::oFacRecL:cSufFac == ::oFacRecT:cSerie + Str( ::oFacRecT:nNumFac ) + ::oFacRecT:cSufFac .and.;
               !::oFacRecL:Eof()

               if !::oDbf:Seek( ::oFacRecL:cGrpFam + ::oFacRecL:cCodFam + ::oFacRecL:cRef )

                  ::oDbf:Append()

                  ::oDbf:cCodGrp    := ::oFacRecL:cGrpFam
                  ::oDbf:cNomGrp    := oRetFld( ::oFacRecL:cGrpFam, ::oGruFam:oDbf )
                  ::oDbf:cCodFam    := ::oFacRecL:cCodFam
                  ::oDbf:cNomFam    := cNomFam( ::oFacRecL:cCodFam, ::oDbfFam )
                  ::oDbf:cCodArt    := ::oFacRecL:cRef
                  ::oDbf:cNomArt    := ::oFacRecL:cDetalle
                  ::oDbf:nTotUni    := -( nTotNFacRec( ::oFacRecL ) )
                  ::oDbf:nTotNet    := -( nImpLFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) )
                  ::oDbf:nTotIva    := -( nIvaLFacRec( ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) )
                  ::oDbf:nTotDoc    := ::oDbf:nTotNet + ::oDbf:nTotIva

                  ::oDbf:Save()

               else

                  ::oDbf:Load()

                  ::oDbf:nTotUni    += -( nTotNFacRec( ::oFacRecL ) )
                  ::oDbf:nTotNet    += -( nImpLFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) )
                  ::oDbf:nTotIva    += -( nIvaLFacRec( ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) )
                  ::oDbf:nTotDoc    += -( nImpLFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) )
                  ::oDbf:nTotDoc    += -( nIvaLFacRec( ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) )

                  ::oDbf:Save()

               end if

         ::oFacRecL:Skip()

         end while

      end if

   ::oFacRecT:Skip()

   ::oMtrInf:AutoInc()

   end while

   ::oFacRecT:IdxDelete( cCurUsr(), GetFileNoExt( ::oFacRecT:cFile ) )

   ::oFacRecL:IdxDelete( cCurUsr(), GetFileNoExt( ::oFacRecL:cFile ) )

   /*Procesamos los tickets*/

   ::oTikCliT:OrdSetFocus( "dFecTik" )
   ::oTikCliL:OrdSetFocus( "cNumTil" )

   cExpHead          := 'dFecTik >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecTik <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   cExpHead          += ' .and. ( cTipTik == "1" .or. cTipTik == "4" )'

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter 
   end if

   ::oTikCliT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oTikCliT:cFile ), ::oTikCliT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oTikCliT:OrdKeyCount() )
   ::oMtrInf:cText   := "Procesando tickets"

   cExpLine          := '!lControl'

   if !::lAllGrp
      cExpLine       += ' .and. cGrpFam >= "' + Rtrim( ::cGruFamOrg ) + '" .and. cGrpFam <= "' + Rtrim( ::cGruFamDes ) + '"'
   end if

   if !::lAllFam
      cExpLine       += ' .and. cCodFam >= "' + Rtrim( ::cFamOrg ) + '" .and. cCodFam <= "' + Rtrim( ::cFamDes ) + '"'
   end if

   if ::lAllArt
      cExpLine       += ' .and. ( !Empty( cCbaTil ) .or. !Empty( cComTil ) )'
   else
      cExpLine       += ' .and. ( ( !Empty( cCbaTil ) .and. cCbaTil >= "' + ::cArtOrg + '" .and. cCbaTil <= "' + ::cArtDes + '" )'
      cExpLine       += ' .or. '
      cExpLine       += '( !Empty( cComTil ) .and. cComTil >= "' + ::cArtOrg + '" .and. cComTil <= "' + ::cArtDes + '" ) )'
   end if

   ::oTikCliL:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oTikCliL:cFile ), ::oTikCliL:OrdKey(), cAllTrimer( cExpLine ), , , , , , , , .t. )

   ::oTikCliT:GoTop()

   while !::lBreak .and. !::oTikCliT:Eof()

      if lChkSer( ::oTikCliT:cSerTik, ::aSer )     .and.;
         ::oTikCliL:Seek( ::oTikCliT:cSerTik + ::oTikCliT:cNumTik + ::oTikCliT:cSufTik )

         while ::oTikCliL:cSerTil + ::oTikCliL:cNumTil + ::oTikCliL:cSufTil == ::oTikCliT:cSerTik + ::oTikCliT:cNumTik + ::oTikCliT:cSufTik .and.;
               !::oTikCliL:Eof()

               if !Empty( ::oTikCliL:cCbaTil )

                  if !::oDbf:Seek( ::oTikCliL:cGrpFam + ::oTikCliL:cCodFam + ::oTikCliL:cCbaTil )

                     ::oDbf:Append()

                     ::oDbf:cCodArt       := ::oTikCliL:cCbaTil
                     ::oDbf:cNomArt       := ::oTikCliL:cNomTil
                     ::oDbf:cCodGrp       := ::oTikCliL:cGrpFam
                     ::oDbf:cNomGrp       := oRetFld( ::oTikCliL:cGrpFam, ::oGruFam:oDbf )
                     ::oDbf:cCodFam       := ::oTikCliL:cCodFam
                     ::oDbf:cNomFam       := cNomFam( ::oTikCliL:cCodFam, ::oDbfFam )
                     if ::oTikCliT:cTipTik == "4"
                        ::oDbf:nTotUni    := - ::oTikCliL:nUntTil
                     else
                        ::oDbf:nTotUni    := ::oTikCliL:nUntTil
                     end if
                     ::oDbf:nTotNet       := nImpLTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nDerOut, ::nValDiv, nil, 1 )
                     ::oDbf:nTotIva       := nIvaLTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nDerOut, ::nValDiv, 1 )
                     ::oDbf:nTotDoc       := ::oDbf:nTotNet + ::oDbf:nTotIva

                     ::oDbf:Save()

                  else

                     ::oDbf:Load()

                     if ::oTikCliT:cTipTik == "4"
                        ::oDbf:nTotUni    += - ::oTikCliL:nUntTil
                     else
                        ::oDbf:nTotUni    += ::oTikCliL:nUntTil
                     end if
                     ::oDbf:nTotNet       += nImpLTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nDerOut, ::nValDiv, nil, 1 )
                     ::oDbf:nTotIva       += nIvaLTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nDerOut, ::nValDiv, 1)
                     ::oDbf:nTotDoc       += nImpLTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nDerOut, ::nValDiv, nil, 1 )
                     ::oDbf:nTotDoc       += nIvaLTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nDerOut, ::nValDiv, 1 )

                     ::oDbf:Save()

                  end if

               end if

               if !Empty( ::oTikCliL:cComTil )

                  if !::oDbf:Seek( ::oTikCliL:cGrpFam + ::oTikCliL:cCodFam + ::oTikCliL:cComTil )

                     ::oDbf:Append()

                     ::oDbf:cCodArt       := ::oTikCliL:cComTil
                     ::oDbf:cNomArt       := ::oTikCliL:cNcmTil
                     ::oDbf:cCodGrp       := ::oTikCliL:cGrpFam
                     ::oDbf:cNomGrp       := oRetFld( ::oTikCliL:cGrpFam, ::oGruFam:oDbf )
                     ::oDbf:cCodFam       := ::oTikCliL:cCodFam
                     ::oDbf:cNomFam       := cNomFam( ::oTikCliL:cCodFam, ::oDbfFam )
                     if ::oTikCliT:cTipTik == "4"
                        ::oDbf:nTotUni    := - ::oTikCliL:nUntTil
                     else
                        ::oDbf:nTotUni    := ::oTikCliL:nUntTil
                     end if
                     ::oDbf:nTotNet       := nImpLTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nDerOut, ::nValDiv, nil, 2 )
                     ::oDbf:nTotIva       := nIvaLTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nDerOut, ::nValDiv, 2 )
                     ::oDbf:nTotDoc       := ::oDbf:nTotNet + ::oDbf:nTotIva

                     ::oDbf:Save()

                  else

                     ::oDbf:Load()

                     if ::oTikCliT:cTipTik == "4"
                        ::oDbf:nTotUni    += - ::oTikCliL:nUntTil
                     else
                        ::oDbf:nTotUni    += ::oTikCliL:nUntTil
                     end if
                     ::oDbf:nTotNet       += nImpLTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nDerOut, ::nValDiv, nil, 2 )
                     ::oDbf:nTotIva       += nIvaLTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nDerOut, ::nValDiv, 2 )
                     ::oDbf:nTotDoc       += nImpLTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nDerOut, ::nValDiv, nil, 2 )
                     ::oDbf:nTotDoc       += nIvaLTpv( ::oTikCliT, ::oTikCliL, ::nDecOut, ::nDerOut, ::nValDiv, 2 )

                     ::oDbf:Save()

                  end if

               end if

         ::oTikCliL:Skip()

         end while

      end if

   ::oTikCliT:Skip()

   ::oMtrInf:AutoInc()

   end while

   ::oTikCliT:IdxDelete( cCurUsr(), GetFileNoExt( ::oTikCliT:cFile ) )

   ::oTikCliL:IdxDelete( cCurUsr(), GetFileNoExt( ::oTikCliL:cFile ) )

   ::oMtrInf:AutoInc( ::oTikCliT:LastRec() )

   ::oDlg:Enable()

   ::oDbf:OrdSetFocus( "NTOTDOC" )

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//