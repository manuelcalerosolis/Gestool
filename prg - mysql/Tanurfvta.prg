#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TAnuRFVta FROM TInfGen

   DATA  lExcCero    AS LOGIC    INIT .f.
   DATA  oAlbCliT    AS OBJECT
   DATA  oAlbCliL    AS OBJECT
   DATA  oFacCliT    AS OBJECT
   DATA  oFacCliL    AS OBJECT
   DATA  oFacRecT    AS OBJECT
   DATA  oFacRecL    AS OBJECT
   DATA  oTikCliT    AS OBJECT
   DATA  oTikCliL    AS OBJECT
   DATA  oCmbFam     AS OBJECT
   DATA  oCmbArt     AS OBJECT

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

   METHOD IncluyeCero()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create ()

   ::AddField ( "cCodFam", "C", 16, 0, {|| "@!" },         "Cod. Fam",      .f., "Cod. Fam",        14, .f. )
   ::AddField ( "cNomFam", "C", 50, 0, {|| "@!" },         "Familia",       .f., "Familia",         35, .f. )
   ::AddField ( "cCodArt", "C", 18, 0, {|| "@!" },         "Cod. articulo", .t., "Cod. Artículo",   14, .f. )
   ::AddField ( "cNomArt", "C",100, 0, {|| "@!" },         "Artículo",      .t., "Nom. Artículo",   20, .f. )
   ::AddField ( "nImpEne", "N", 16, 6, {|| ::cPicOut },    "Ene",           .t., "Enero",           12, .t. )
   ::AddField ( "nImpFeb", "N", 16, 6, {|| ::cPicOut },    "Feb",           .t., "Febrero",         12, .t. )
   ::AddField ( "nImpMar", "N", 16, 6, {|| ::cPicOut },    "Mar",           .t., "Marzo",           12, .t. )
   ::AddField ( "nImpAbr", "N", 16, 6, {|| ::cPicOut },    "Abr",           .t., "Abril",           12, .t. )
   ::AddField ( "nImpMay", "N", 16, 6, {|| ::cPicOut },    "May",           .t., "Mayo",            12, .t. )
   ::AddField ( "nImpJun", "N", 16, 6, {|| ::cPicOut },    "Jun",           .t., "Junio",           12, .t. )
   ::AddField ( "nImpJul", "N", 16, 6, {|| ::cPicOut },    "Jul",           .t., "Julio",           12, .t. )
   ::AddField ( "nImpAgo", "N", 16, 6, {|| ::cPicOut },    "Ago",           .t., "Agosto",          12, .t. )
   ::AddField ( "nImpSep", "N", 16, 6, {|| ::cPicOut },    "Sep",           .t., "Septiembre",      12, .t. )
   ::AddField ( "nImpOct", "N", 16, 6, {|| ::cPicOut },    "Oct",           .t., "Octubre",         12, .t. )
   ::AddField ( "nImpNov", "N", 16, 6, {|| ::cPicOut },    "Nov",           .t., "Noviembre",       12, .t. )
   ::AddField ( "nImpDic", "N", 16, 6, {|| ::cPicOut },    "Dic",           .t., "Diciembre",       12, .t. )
   ::AddField ( "nImpTot", "N", 16, 6, {|| ::cPicOut },    "Tot",           .t., "Total",           12, .t. )

   ::AddTmpIndex( "cCodFam1", "cCodFam + cCodArt" )
   ::AddTmpIndex( "cCodFam2", "cCodFam + cNomArt" )
   ::AddTmpIndex( "cNomFam1", "cNomFam + cCodArt" )
   ::AddTmpIndex( "cNomFam2", "cNomFam + cNomArt" )

   ::AddGroup( {|| ::oDbf:cCodFam }, {|| "Familia  : " + Rtrim( ::oDbf:cCodFam ) + "-" + Rtrim( ::oDbf:cNomFam ) }, {|| "Total familia..." } )

   ::lDefFecInf   := .f.
   ::lDefGraph    := .t.

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   ::oAlbCliT := TDataCenter():oAlbCliT()

   DATABASE NEW ::oAlbCliL PATH ( cPatEmp() ) FILE "ALBCLIL.DBF"  VIA ( cDriver() ) SHARED INDEX "ALBCLIL.CDX"

   ::oFacCliT := TDataCenter():oFacCliT()

   DATABASE NEW ::oFacCliL PATH ( cPatEmp() ) FILE "FACCLIL.DBF"  VIA ( cDriver() ) SHARED INDEX "FACCLIL.CDX"

   DATABASE NEW ::oFacRecT PATH ( cPatEmp() ) FILE "FACRECT.DBF"  VIA ( cDriver() ) SHARED INDEX "FACRECT.CDX"

   DATABASE NEW ::oFacRecL PATH ( cPatEmp() ) FILE "FACRECL.DBF"  VIA ( cDriver() ) SHARED INDEX "FACRECL.CDX"

   DATABASE NEW ::oTikCliT PATH ( cPatEmp() ) FILE "TIKET.DBF"    VIA ( cDriver() ) SHARED INDEX "TIKET.CDX"

   DATABASE NEW ::oTikCliL PATH ( cPatEmp() ) FILE "TIKEL.DBF"    VIA ( cDriver() ) SHARED INDEX "TIKEL.CDX"

   DATABASE NEW ::oDbfCli  PATH ( cPatCli() ) FILE "CLIENT.DBF"   VIA ( cDriver() ) SHARED INDEX "CLIENT.CDX"

   RECOVER

      msgStop( 'Imposible abrir todas las bases de datos' )
      ::CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles()

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
   if !Empty( ::oDbfCli ) .and. ::oDbfCli:Used()
      ::oDbfCli:End()
   end if

   ::oAlbCliT := nil
   ::oAlbCliL := nil
   ::oFacCliT := nil
   ::oFacCliL := nil
   ::oFacRecT := nil
   ::oFacRecL := nil
   ::oTikCliT := nil
   ::oTikCliL := nil
   ::oDbfCli  := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld )

   local cCmbFam  := "Código"
   local cCmbArt  := "Código"

   if !::StdResource( "INFANUARTFAM" )
      return .f.
   end if

   ::CreateFilter( , ::oDbf, .t. )

   ::oDefYea()

   if !::lDefFamInf( 310, 311, 320, 321, 300 )
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

   REDEFINE COMBOBOX ::oCmbFam VAR cCmbFam ;
      ID       330 ;
      ITEMS    { "Código", "Nombre" } ;
      OF       ::oFld:aDialogs[1]

   REDEFINE COMBOBOX ::oCmbArt VAR cCmbArt ;
      ID       110 ;
      ITEMS    { "Código", "Nombre" } ;
      OF       ::oFld:aDialogs[1]

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
                     {|| "Año       : " + AllTrim( Str( ::nYeaInf ) ) },;
                     {|| "Familias  : " + if( ::lAllFam, "Todas", AllTrim( ::cFamOrg ) + " > " + AllTrim (::cFamDes ) ) },;
                     {|| "Artículos : " + if( ::lAllArt, "Todos", AllTrim( ::cArtOrg ) + " > " + AllTrim (::cArtDes ) ) },;
                     {|| "Clientes  : " + if( ::lAllArt, "Todos", AllTrim( ::cCliOrg ) + " > " + AllTrim (::cCliDes ) ) } }

   ::oDbf:OrdSetFocus( "CCODFAM1" )

   /*Albaranes*/

   ::oAlbCliT:OrdSetFocus( "dFecAlb" )
   ::oAlbCliL:OrdSetFocus( "nNumAlb" )

   cExpHead          := 'nFacturado < 3'

   if !::lAllCli
      cExpHead       += ' .and. cCodCli >= "' + ::cCliOrg + '" .and. cCodCli <= "' + ::cCliDes + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter ) 
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oAlbCliT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oAlbCliT:cFile ), ::oAlbCliT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:cText   := "Procesando albaranes"
   ::oMtrInf:SetTotal( ::oAlbCliT:OrdKeyCount() )

   cExpLine          := '!lTotLin .and. !lControl'

   if !::lAllFam
      cExpLine       += ' .and. cCodFam >= "' + ::cFamOrg + '" .and. cCodFam <= "' + ::cFamDes + '"'
   end if

   if !::lAllArt
      cExpLine       += ' .and. cRef >= "' + ::cArtOrg + '" .and. cRef <= "' + ::cArtDes + '"'
   end if

   ::oAlbCliL:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oAlbCliL:cFile ), ::oAlbCliL:OrdKey(), cAllTrimer( cExpLine ), , , , , , , , .t. )

   ::oAlbCliT:GoTop()
   while !::lBreak .and. !::oAlbCliT:Eof()

      if Year( ::oAlbCliT:dFecAlb ) == ::nYeaInf                                            .AND.;
         lChkSer( ::oAlbCliT:cSerAlb, ::aSer )

         if ::oAlbCliL:Seek( ::oAlbCliT:cSerAlb + Str( ::oAlbCliT:nNumAlb ) + ::oAlbCliT:cSufAlb )

            while ::oAlbCliT:cSerAlb + Str( ::oAlbCliT:nNumAlb ) + ::oAlbCliT:cSufAlb == ::oAlbCliL:cSerAlb + Str( ::oAlbCliL:nNumAlb ) + ::oAlbCliL:cSufAlb .AND. ! ::oAlbCliL:eof()

               if !( ::lExcCero .AND. nTotNAlbCli( ::oAlbCliL ) == 0 ) .AND.;
                  !( ::lExcImp .AND. nImpLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv ) == 0 )

                  if !::oDbf:Seek( ::oAlbCliL:cCodFam + ::oAlbCliL:cRef )

                     ::oDbf:Blank()
                     ::oDbf:cCodFam := ::oAlbCliL:cCodFam
                     ::oDbf:cNomFam := cNomFam( ::oAlbCliL:cCodFam, ::oDbfFam )
                     ::oDbf:cCodArt := ::oAlbCliL:cRef
                     ::oDbf:cNomArt := oRetFld( ::oAlbCliL:cRef, ::oDbfArt )
                     ::oDbf:Insert()

                  end if

                  ::AddImporte( ::oAlbCliT:dFecAlb, nImpLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv  ) )

               end if

               ::oAlbCliL:Skip()

            end while

         end if

      end if

      ::oAlbCliT:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oAlbCliT:IdxDelete( cCurUsr(), GetFileNoExt( ::oAlbCliT:cFile ) )
   ::oAlbCliL:IdxDelete( cCurUsr(), GetFileNoExt( ::oAlbCliL:cFile ) )

   /*Facturas*/

   ::oFacCliT:OrdSetFocus( "dFecFac" )
   ::oFacCliL:OrdSetFocus( "nNumFac" )

   if !::lAllCli
      cExpHead       := 'cCodCli >= "' + ::cCliOrg + '" .and. cCodCli <= "' + ::cCliDes + '"'
   else
      cExpHead       := '.t.'
   end if

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oFacCliT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oFacCliT:cFile ), ::oFacCliT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:cText   := "Procesando facturas"
   ::oMtrInf:SetTotal( ::oFacCliT:OrdKeyCount() )

   cExpLine          := '!lTotLin .and. !lControl'

   if !::lAllFam
      cExpLine       += ' .and. cCodFam >= "' + ::cFamOrg + '" .and. cCodFam <= "' + ::cFamDes + '"'
   end if

   if !::lAllArt
      cExpLine       += ' .and. cRef >= "' + ::cArtOrg + '" .and. cRef <= "' + ::cArtDes + '"'
   end if

   ::oFacCliL:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oFacCliL:cFile ), ::oFacCliL:OrdKey(), cAllTrimer( cExpLine ), , , , , , , , .t. )

   ::oFacCliT:GoTop()

   while !::lBreak .and. !::oFacCliT:Eof()

      if Year( ::oFacCliT:dFecFac ) == ::nYeaInf                             .AND.;
         lChkSer( ::oFacCliT:cSerie, ::aSer )

         if ::oFacCliL:Seek( ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac )

            while ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac == ::oFacCliL:cSerie + Str( ::oFacCliL:nNumFac ) + ::oFacCliL:cSufFac .AND. ! ::oFacCliL:eof()

               if !( ::lExcCero .AND. nTotNFacCli( ::oFacCliL ) == 0 )       .AND.;
                  !( ::lExcImp .AND. nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv  ) == 0 )

                  if !::oDbf:Seek( ::oFacCliL:cCodFam + ::oFacCliL:cRef )

                     ::oDbf:Blank()
                     ::oDbf:cCodFam := ::oFacCliL:cCodFam
                     ::oDbf:cNomFam := cNomFam( ::oFacCliL:cCodFam, ::oDbfFam )
                     ::oDbf:cCodArt := ::oFacCliL:cRef
                     ::oDbf:cNomArt := oRetFld( ::oFacCliL:cRef, ::oDbfArt )
                     ::oDbf:Insert()

                  end if

                  ::AddImporte( ::oFacCliT:dFecFac, nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv  ) )

               end if

               ::oFacCliL:Skip()

            end while

         end if

      end if

      ::oFacCliT:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oFacCliT:IdxDelete( cCurUsr(), GetFileNoExt( ::oFacCliT:cFile ) )
   ::oFacCliL:IdxDelete( cCurUsr(), GetFileNoExt( ::oFacCliL:cFile ) )

   /*Facturas Rectificativas*/

   ::oFacCliT:OrdSetFocus( "dFecFac" )
   ::oFacRecL:OrdSetFocus( "nNumFac" )

   if !::lAllCli
      cExpHead       := 'cCodCli >= "' + ::cCliOrg + '" .and. cCodCli <= "' + ::cCliDes + '"'
   else
      cExpHead       := '.t.'
   end if

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter 
   end if

   ::oFacRecT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oFacRecT:cFile ), ::oFacRecT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:cText   := "Procesando fac. rec."
   ::oMtrInf:SetTotal( ::oFacCliT:OrdKeyCount() )

   cExpLine          := '!lTotLin .and. !lControl'

   if !::lAllFam
      cExpLine       += ' .and. cCodFam >= "' + ::cFamOrg + '" .and. cCodFam <= "' + ::cFamDes + '"'
   end if

   if !::lAllArt
      cExpLine       += ' .and. cRef >= "' + ::cArtOrg + '" .and. cRef <= "' + ::cArtDes + '"'
   end if

   ::oFacRecL:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oFacRecL:cFile ), ::oFacRecL:OrdKey(), cAllTrimer( cExpLine ), , , , , , , , .t. )

   ::oFacRecT:GoTop()

   while !::lBreak .and. !::oFacRecT:Eof()

      if Year( ::oFacRecT:dFecFac ) == ::nYeaInf                             .AND.;
         lChkSer( ::oFacRecT:cSerie, ::aSer )

         if ::oFacRecL:Seek( ::oFacRecT:cSerie + Str( ::oFacRecT:nNumFac ) + ::oFacRecT:cSufFac )

            while ::oFacRecT:cSerie + Str( ::oFacRecT:nNumFac ) + ::oFacRecT:cSufFac == ::oFacRecL:cSerie + Str( ::oFacRecL:nNumFac ) + ::oFacRecL:cSufFac .AND. ! ::oFacRecL:eof()

               if !( ::lExcCero .AND. nTotNFacRec( ::oFacRecL ) == 0 )       .AND.;
                  !( ::lExcImp .AND. nImpLFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv  ) == 0 )

                  if !::oDbf:Seek( ::oFacRecL:cCodFam + ::oFacRecL:cRef )

                     ::oDbf:Blank()
                     ::oDbf:cCodFam := ::oFacRecL:cCodFam
                     ::oDbf:cNomFam := cNomFam( ::oFacRecL:cCodFam, ::oDbfFam )
                     ::oDbf:cCodArt := ::oFacRecL:cRef
                     ::oDbf:cNomArt := oRetFld( ::oFacRecL:cRef, ::oDbfArt )
                     ::oDbf:Insert()

                  end if

                  ::AddImporte( ::oFacRecT:dFecFac, nImpLFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv  ) )

               end if

               ::oFacRecL:Skip()

            end while

         end if

      end if

      ::oFacRecT:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oFacRecT:IdxDelete( cCurUsr(), GetFileNoExt( ::oFacRecT:cFile ) )
   ::oFacRecL:IdxDelete( cCurUsr(), GetFileNoExt( ::oFacRecL:cFile ) )

   /*Tickets*/

   ::oTikCliT:OrdSetFocus( "dFecTik" )
   ::oTikCliL:OrdSetFocus( "cNumTil" )

   cExpHead          := '( cTipTik == "1" .or. cTipTik == "4" )'

   if !::lAllCli
      cExpHead       += ' .and. cCliTik >= "' + ::cCliOrg + '" .and. cCliTik <= "' + ::cCliDes + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter 
   end if

   ::oTikCliT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oTikCliT:cFile ), ::oTikCliT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:cText   := "Procesando tickets"
   ::oMtrInf:SetTotal( ::oTikCliT:OrdKeyCount() )

   cExpLine          := '!lControl'

   if !::lAllFam
      cExpLine       += ' .and. ( cCodFam >= "' + Rtrim( ::cFamOrg ) + '" .and. cCodFam <= "' + Rtrim( ::cFamDes ) + '" )'
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

      if Year( ::oTikCliT:dFecTik ) == ::nYeaInf                        .AND.;
         lChkSer( ::oTikCliT:cSerTik, ::aSer )

         if ::oTikCliL:Seek( ::oTikCliT:cSerTik + ::oTikCliT:cNumTik + ::oTikCliT:cSufTik )

            while ::oTikCliT:cSerTik + ::oTikCliT:cNumTik + ::oTikCliT:cSufTik == ::oTikCliL:cSerTil + ::oTikCliL:cNumTil + ::oTikCliL:cSufTil .AND. !::oTikCliL:eof()

               if !Empty( ::oTikCliL:cCbaTil )                       .AND.;
                  !( ::lExcCero .AND. ::oTikCLiL:nUntTil == 0 )      .AND.;
                  !( ::lExcImp .AND. ::oTikCliL:nPvpTil == 0 )

                  if !::oDbf:Seek( ::oTikCliL:cCodFam + ::oTikCliL:cCbaTil )

                     ::oDbf:Blank()
                     ::oDbf:cCodArt := ::oTikCliL:cCodFam
                     ::oDbf:cNomArt := cNomFam( ::oTikCliL:cCodFam, ::oDbfFam )
                     ::oDbf:cCodArt := ::oTikCliL:cCbaTil
                     ::oDbf:cNomArt := oRetFld( ::oTikCliL:cCbaTil, ::oDbfArt )
                     ::oDbf:Insert()

                  end if

                  ::AddImporte( ::oTikCliT:dFecTik, nImpLTpv( ::oTikCliT:cAlias, ::oTikCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, nil, 1 ) )

               end if

               if !Empty( ::oTikCliL:cComTil )                       .AND.;
                  !( ::lExcCero .AND. ::oTikCliT:nUntTil == 0 )      .AND.;
                  !( ::lExcImp .AND. ::oTikCliL:nPcmTil == 0 )

                  if !::oDbf:Seek( ::oTikCliL:cCodFam + ::oTikCliL:cComTil )

                     ::oDbf:Blank()
                     ::oDbf:cCodFam := ::oTikCliL:cCodFam
                     ::oDbf:cNomFam := cNomFam( ::oTikCliL:cCodFam, ::oDbfFam )
                     ::oDbf:cCodArt := ::oTikCliL:cComTil
                     ::oDbf:cNomArt := oRetFld( ::oTikCliL:cComTil, ::oDbfArt )
                     ::oDbf:Insert()

                  end if

                  ::AddImporte( ::oTikCliT:dFecTik, nImpLTpv( ::oTikCliT:cAlias, ::oTikCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, nil, 2 ) )

               end if

               ::oTikCliL:Skip()

            end while

         end if

      end if

      ::oTikCliT:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oTikCliT:IdxDelete( cCurUsr(), GetFileNoExt( ::oTikCliT:cFile ) )
   ::oTikCliL:IdxDelete( cCurUsr(), GetFileNoExt( ::oTikCliL:cFile ) )

   ::oMtrInf:AutoInc( ::oTikCliT:LastRec() )

   if !::lExcCero
      ::IncluyeCero()
   end if

   if ::oDbf:RecCount() > 0

      do case
         case ::oCmbFam:nAt == 1 .and. ::oCmbArt:nAt == 1
            ::oDbf:OrdSetFocus( "CCODFAM1" )
         case ::oCmbFam:nAt == 2 .and. ::oCmbArt:nAt == 1
            ::oDbf:OrdSetFocus( "CNOMFAM1" )
         case ::oCmbFam:nAt == 1 .and. ::oCmbArt:nAt == 2
            ::oDbf:OrdSetFocus( "CCODFAM2" )
         case ::oCmbFam:nAt == 2 .and. ::oCmbArt:nAt == 2
            ::oDbf:OrdSetFocus( "CNOMFAM2" )
      end case

   end if

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//

METHOD IncluyeCero()

   ::oDbfArt:GoTop()
   while !::oDbfArt:Eof()

      if ( ::lAllFam .or. ( ::oDbfArt:Familia >= ::cFamOrg   .AND. ::oDbfArt:Familia <= ::cFamDes ) ) .AND.;
         ( ::lAllArt .or. ( ::oDbfArt:Codigo >= ::cArtOrg   .AND. ::oDbfArt:Codigo <= ::cArtDes ) ) .AND.;
         !::oDbf:Seek( ::oDbfArt:Familia + ::oDbfArt:Codigo )

         ::oDbf:Append()
         ::oDbf:Blank()
         ::oDbf:cCodFam    := ::oDbfArt:Familia
         ::oDbf:cNomFam    := cNomFam( ::oDbfArt:Familia, ::oDbfFam )
         ::oDbf:cCodArt    := ::oDbfArt:Codigo
         ::oDbf:cNomArt    := ::oDbfArt:Nombre
         ::oDbf:Save()

      end if

      ::oDbfArt:Skip()

   end while

RETURN ( Self )

//---------------------------------------------------------------------------//