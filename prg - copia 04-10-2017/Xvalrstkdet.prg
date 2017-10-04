#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS XValRStkDet FROM XInfMov

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
   DATA  oHisMov     AS OBJECT

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

   METHOD CreaSaldo()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField( "dFecMov", "D",  8, 0, {|| "@!" },          "Fecha",         .t., "Fecha",                    10, .f. )
   ::AddField( "cTimMov", "C",  5, 0, {|| "@!" },          "Hora",          .t., "Hora",                      5, .f. )
   ::AddField( "cCodArt", "C", 18, 0, {|| "@!" },          "Código artículo",     .f., "Código artículo",          14, .f. )
   ::AddField( "cNomArt", "C",100, 0, {|| "@!" },          "Artículo",      .f., "Nombre artículo",          35, .f. )
   ::FldPropiedades()
   ::AddField( "cCodAlm", "C", 16, 0, {|| "@!" },          "Cod.",          .t., "Código almacén",           10, .f. )
   ::AddField( "cNomAlm", "C", 20, 0, {|| "@!" },          "Almacén",       .f., "Nombre almacén",           30, .f. )
   ::AddField( "cCodCli", "C", 12, 0, {|| "@!" },          "Cod.",          .t., "Código cliente",            9, .f. )
   ::AddField( "cNomCli", "C", 50, 0, {|| "@!" },          "Cli. - Prv.",   .t., "Cliente-Proveedor",        35, .f. )
   ::AddField( "nCajEnt", "N", 16, 6, {|| MasUnd() },      "Caj.Com.",      .f., "Cajas compra",             10, .t. )
   ::AddField( "nUndEnt", "N", 16, 6, {|| MasUnd() },      "Und.Com.",      .f., "Unidades compra",          10, .t. )
   ::AddField( "nTotEnt", "N", 16, 6, {|| MasUnd() },      "Tot.Com.",      .t., "Total compra",             10, .t. )
   ::AddField( "nPreEnt", "N", 16, 6, {|| ::cPicCom },     "Pre.Com.",      .t., "Precio compra",            10, .t. )
   ::AddField( "nImpEnt", "N", 16, 6, {|| ::cPicIn },      "Imp.Com.",      .t., "Importe compra",           10, .t. )
   ::AddField( "nCajSal", "N", 16, 6, {|| MasUnd() },      "Caj.Vta.",      .f., "Cajas venta",              10, .t. )
   ::AddField( "nUndSal", "N", 16, 6, {|| MasUnd() },      "Und.Vta.",      .f., "Unidades venta",           10, .t. )
   ::AddField( "nTotSal", "N", 16, 6, {|| MasUnd() },      "Tot.Vta.",      .t., "Total venta",              10, .t. )
   ::AddField( "nPreSal", "N", 16, 6, {|| ::cPicImp },     "Pre.Vta.",      .t., "Precio venta",             10, .t. )
   ::AddField( "nImpSal", "N", 16, 6, {|| ::cPicOut },     "Imp.Vta.",      .t., "Importe venta",            10, .t. )
   ::AddField( "nTotStk", "N", 16, 6, {|| MasUnd() },      "Und.Stk.",      .t., "Total stock",              10, .f. )
   ::AddField( "nPreStk", "N", 16, 6, {|| ::cPicImp },     "Pre.Med.",      .t., "Precio stock",             10, .f. )
   ::AddField( "nImpStk", "N", 16, 6, {|| ::cPicOut },     "Imp.Stk.",      .t., "Total stock",              10, .f. )
   ::AddField( "cDocMov", "C", 14, 0, {|| "@!" },          "Documento",     .f., "Documento",                10, .f. )
   ::AddField( "cTipDoc", "C", 14, 0, {|| "@!" },          "Tipo",          .f., "Tipo",                     14, .f. )

   ::AddTmpIndex( "cCodArt", "cCodArt + cCodAlm + cValPr1 + cValPr2 + dtos( dFecMov ) + cTimMov" )

   ::AddGroup( {|| ::oDbf:cCodArt }, {|| "Artículo : " + Rtrim( ::oDbf:cCodArt ) + "-" + Rtrim( oRetFld( ::oDbf:cCodArt, ::oDbfArt ) ) }, {|| "Total artículo " } )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   DATABASE NEW ::oAlbPrvT PATH ( cPatEmp() )   FILE "ALBPROVT.DBF"  VIA ( cDriver() ) SHARED INDEX "ALBPROVT.CDX"

   DATABASE NEW ::oAlbPrvL PATH ( cPatEmp() )   FILE "ALBPROVL.DBF"  VIA ( cDriver() ) SHARED INDEX "ALBPROVL.CDX"

   DATABASE NEW ::oFacPrvT PATH ( cPatEmp() )   FILE "FACPRVT.DBF"   VIA ( cDriver() ) SHARED INDEX "FACPRVT.CDX"

   DATABASE NEW ::oFacPrvL PATH ( cPatEmp() )   FILE "FACPRVL.DBF"   VIA ( cDriver() ) SHARED INDEX "FACPRVL.CDX"

   ::oAlbCliT := TDataCenter():oAlbCliT()

   DATABASE NEW ::oAlbCliL PATH ( cPatEmp() )   FILE "ALBCLIL.DBF"   VIA ( cDriver() ) SHARED INDEX "ALBCLIL.CDX"

   ::oFacCliT := TDataCenter():oFacCliT()

   DATABASE NEW ::oFacCliL PATH ( cPatEmp() )   FILE "FACCLIL.DBF"   VIA ( cDriver() ) SHARED INDEX "FACCLIL.CDX"

   DATABASE NEW ::oFacRecT PATH ( cPatEmp() )   FILE "FACRECT.DBF"   VIA ( cDriver() ) SHARED INDEX "FACRECT.CDX"

   DATABASE NEW ::oFacRecL PATH ( cPatEmp() )   FILE "FACRECL.DBF"   VIA ( cDriver() ) SHARED INDEX "FACRECL.CDX"

   DATABASE NEW ::oTikCliT PATH ( cPatEmp() )   FILE "TIKET.DBF"     VIA ( cDriver() ) SHARED INDEX "TIKET.CDX"

   DATABASE NEW ::oTikCliL PATH ( cPatEmp() )   FILE "TIKEL.DBF"     VIA ( cDriver() ) SHARED INDEX "TIKEL.CDX"

   DATABASE NEW ::oHisMov  PATH ( cPatEmp() )   FILE "HISMOV.DBF"    VIA ( cDriver() ) SHARED INDEX "HISMOV.CDX"

   DATABASE NEW ::oDbfFam  PATH ( cPatArt() )   FILE "FAMILIAS.DBF"  VIA ( cDriver() ) SHARED INDEX "FAMILIAS.CDX"

   RECOVER

      msgStop( 'Imposible abrir todas las bases de datos' )
      ::CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles()

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

   if !Empty( ::oHisMov ) .and. ::oHisMov:Used()
      ::oHisMov:End()
   end if

   if !Empty( ::oDbfFam ) .and. ::oDbfFam:Used()
      ::oDbfFam:End()
   end if

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
   ::oHisMov  := nil
   ::oDbfFam  := nil

RETURN ( Self )

//-----------------------------------------------------------------------------

METHOD lResource( cFld )

   if !::StdResource( "XVALRSTK" )
      return .f.
   end if

   ::oBtnFilter:Disable()

   if !::oDefAlmInf( 70, 80, 90, 100, 600 )
      return .f.
   end if

   if !::lDefArtInf( 110, 120, 130, 140, 800 )
      return .f.
   end if

   ::oDefExcInf( 210 )

   ::oDefExcImp( 211 )

   ::oMtrInf:SetTotal( ::oAlbPrvT:Lastrec() )

RETURN .t.

//---------------------------------------------------------------------------//

METHOD lGenerate()

   local cRet
   local nEvery
   local cExpHead    := ""
   local cExpLine    := ""

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   ::aHeader         := {  {|| "Fecha     : " + Dtoc( Date() ) },;
                           {|| "Periodo   : " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) } ,;
                           {|| "Artículos : " + if( ::lAllArt, "Todos", AllTrim( ::cArtOrg ) + " > " + AllTrim( ::cArtDes ) ) },;
                           {|| "Almacén   : " + if( ::lAllAlm, "Todos", AllTrim( ::cAlmOrg ) + " > " + AllTrim( ::cAlmDes ) ) } }


   /*
   Albaranes de proveedor------------------------------------------------------
   */

   ::oAlbPrvT:OrdSetFocus( "dFecAlb" )
   ::oAlbPrvL:OrdSetFocus( "nNumAlb" )

   cExpHead          := '!lFacturado .and. dFecAlb >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecAlb <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   ::oAlbPrvT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oAlbPrvT:cFile ), ::oAlbPrvT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oAlbPrvT:OrdKeyCount() )
   ::oMtrInf:cText   := "Procesando albarán proveedor"

   if !::lAllAlm
      cExpLine       := 'cAlmLin >= "' + Rtrim( ::cAlmOrg ) + '" .and. cAlmLin <= "' + Rtrim( ::cAlmDes ) + '"'
   else
      cExpLine       := '.t.'
   end if

   if !::lAllArt
      cExpLine       += ' .and. cRef >= "' + ::cArtOrg + '" .and. cRef <= "' + ::cArtDes + '"'
   end if

   ::oAlbPrvL:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oAlbPrvL:cFile ), ::oAlbPrvL:OrdKey(), cAllTrimer( cExpLine ), , , , , , , , .t. )

   ::oAlbPrvT:GoTop()

   while !::lBreak .and. !::oAlbPrvT:Eof()

      if lChkSer( ::oAlbPrvT:cSerAlb, ::aSer )

         if ::oAlbPrvL:Seek( ::oAlbPrvT:cSerAlb + Str( ::oAlbPrvT:nNumAlb ) + ::oAlbPrvT:cSufAlb )

            while ::oAlbPrvT:cSerAlb + Str( ::oAlbPrvT:nNumAlb ) + ::oAlbPrvT:cSufAlb == ::oAlbPrvL:cSerAlb + Str( ::oAlbPrvL:nNumAlb ) + ::oAlbPrvL:cSufAlb .AND. ! ::oAlbPrvL:eof()

               if !Empty( ::oAlbPrvL:cAlmLin )                                      .AND.;
                  ( oRetFld( ::oAlbPrvL:cRef, ::oDbfArt, "nCtlStock" ) != 3 )       .AND.;
                  !( ::lExcCero .and. nTotNAlbPrv( ::oAlbPrvL ) == 0 )              .AND.;
                  !( ::lExcImp .and. nTotLAlbPrv( ::oAlbPrvL, ::nDecIn, ::nDerIn ) == 0 )

                  ::oDbf:Append()
                  ::oDbf:Blank()

                  ::oDbf:cCodCli := ::oAlbPrvT:cCodPrv
                  ::oDbf:cNomCli := ::oAlbPrvT:cNomPrv
                  ::oDbf:dFecMov := ::oAlbPrvT:dFecAlb
                  ::oDbf:cTimMov := ::oAlbPrvT:cTimChg

                  ::oDbf:cCodAlm := ::oAlbPrvL:cAlmLin
                  ::oDbf:cNomAlm := oRetFld( ::oAlbPrvL:cAlmLin, ::oDbfAlm )

                  ::oDbf:cCodArt := ::oAlbPrvL:cRef
                  ::oDbf:cNomArt := ::oAlbPrvL:cDetalle
                  ::oDbf:cCodPr1 := ::oAlbPrvL:cCodPr1
                  ::oDbf:cNomPr1 := retProp( ::oAlbPrvL:cCodPr1 )
                  ::oDbf:cCodPr2 := ::oAlbPrvL:cCodPr2
                  ::oDbf:cNomPr2 := retProp( ::oAlbPrvL:cCodPr2 )
                  ::oDbf:cValPr1 := ::oAlbPrvL:cValPr1
                  ::oDbf:cNomVl1 := RetValProp( ::oAlbPrvL:cCodPr1 + ::oAlbPrvL:cValPr1 )
                  ::oDbf:cValPr2 := ::oAlbPrvL:cValPr2
                  ::oDbf:cNomVl2 := RetValProp( ::oAlbPrvL:cCodPr2 + ::oAlbPrvL:cValPr2 )

                  ::oDbf:nCajEnt := ::oAlbPrvL:nCanEnt
                  ::oDbf:nUndEnt := ::oAlbPrvL:nUniCaja
                  ::oDbf:nTotEnt := nTotNAlbPrv( ::oAlbPrvL )
                  ::oDbf:nPreEnt := nTotUAlbPrv( ::oAlbPrvL, ::nDecIn )
                  ::oDbf:nImpEnt := nTotLAlbPrv( ::oAlbPrvL, ::nDecIn, ::nDerIn )

                  ::oDbf:cTipDoc := "Alb. Prv."
                  ::oDbf:cDocMov := ::oAlbPrvL:cSerAlb + "/" + AllTrim( Str( ::oAlbPrvL:nNumAlb ) ) + "/" + ::oAlbPrvL:cSufAlb

                  ::oDbf:Save()

               end if

               ::oAlbPrvL:Skip()

            end while

         end if

      end if

      ::oAlbPrvT:Skip()

      ::oMtrInf:Set( ::oAlbPrvT:OrdKeyNo() )

   end while

   ::oAlbPrvT:IdxDelete( cCurUsr(), GetFileNoExt( ::oAlbPrvT:cFile ) )
   ::oAlbPrvL:IdxDelete( cCurUsr(), GetFileNoExt( ::oAlbPrvL:cFile ) )

   /*
   Facturas de proveedor-------------------------------------------------------
   */

   ::oFacPrvT:OrdSetFocus( "dFecFac" )
   ::oFacPrvL:OrdSetFocus( "nNumFac" )

   cExpHead          := 'dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   ::oFacPrvT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oFacPrvT:cFile ), ::oFacPrvT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oFacPrvT:OrdKeyCount() )
   ::oMtrInf:cText   := "Procesando factura proveedor"

   if !::lAllAlm
      cExpLine       := 'cAlmLin >= "' + Rtrim( ::cAlmOrg ) + '" .and. cAlmLin <= "' + Rtrim( ::cAlmDes ) + '"'
   else
      cExpLine       := '.t.'
   end if

   if !::lAllArt
      cExpLine       += ' .and. cRef >= "' + ::cArtOrg + '" .and. cRef <= "' + ::cArtDes + '"'
   end if

   ::oFacPrvL:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oFacPrvL:cFile ), ::oFacPrvL:OrdKey(), cAllTrimer( cExpLine ), , , , , , , , .t. )

   ::oFacPrvT:GoTop()

   while !::lBreak .and. !::oFacPrvT:Eof()

      if lChkSer( ::oFacPrvT:cSerFac, ::aSer )

         if ::oFacPrvL:Seek( ::oFacPrvT:cSerFac + Str( ::oFacPrvT:nNumFac ) + ::oFacPrvT:cSufFac )

            while ::oFacPrvT:cSerFac + Str( ::oFacPrvT:nNumFac ) + ::oFacPrvT:cSufFac == ::oFacPrvL:cSerFac + Str( ::oFacPrvL:nNumFac ) + ::oFacPrvL:cSufFac .AND. !::oFacPrvL:Eof()

               if !Empty( ::oFacPrvL:cAlmLin )                                      .AND.;
                  ( oRetFld( ::oFacPrvL:cRef, ::oDbfArt, "nCtlStock" ) != 3 )       .AND.;
                  !( ::lExcCero .and. nTotNFacPrv( ::oFacPrvL ) == 0 )              .AND.;
                  !( ::lExcImp .and. nTotLFacPrv( ::oFacPrvL, ::nDecIn, ::nDerIn ) == 0 )

                  ::oDbf:Append()
                  ::oDbf:Blank()

                  ::oDbf:cCodCli := ::oFacPrvT:cCodPrv
                  ::oDbf:cNomCli := ::oFacPrvT:cNomPrv
                  ::oDbf:dFecMov := ::oFacPrvT:dFecFac
                  ::oDbf:cTimMov := ::oFacPrvT:cTimChg

                  ::oDbf:cCodAlm := ::oFacPrvL:cAlmLin
                  ::oDbf:cNomAlm := oRetFld( ::oFacPrvL:cAlmLin, ::oDbfAlm )

                  ::oDbf:cCodArt := ::oFacPrvL:cRef
                  ::oDbf:cNomArt := ::oFacPrvL:cDetalle
                  ::oDbf:cCodPr1 := ::oFacPrvL:cCodPr1
                  ::oDbf:cNomPr1 := RetProp( ::oFacPrvL:cCodPr1 )
                  ::oDbf:cCodPr2 := ::oFacPrvL:cCodPr2
                  ::oDbf:cNomPr2 := RetProp( ::oFacPrvL:cCodPr2 )
                  ::oDbf:cValPr1 := ::oFacPrvL:cValPr1
                  ::oDbf:cNomVl1 := RetValProp( ::oFacPrvL:cCodPr1 + ::oFacPrvL:cValPr1 )
                  ::oDbf:cValPr2 := ::oFacPrvL:cValPr2
                  ::oDbf:cNomVl2 := RetValProp( ::oFacPrvL:cCodPr2 + ::oFacPrvL:cValPr2 )

                  ::oDbf:nCajEnt := ::oFacPrvL:nCanEnt
                  ::oDbf:nUndEnt := ::oFacPrvL:nUniCaja
                  ::oDbf:nTotEnt := nTotNFacPrv( ::oFacPrvL )
                  ::oDbf:nPreEnt := nTotUFacPrv( ::oFacPrvL, ::nDecIn )
                  ::oDbf:nImpEnt := nTotLFacPrv( ::oFacPrvL, ::nDecIn, ::nDerIn )

                  ::oDbf:cTipDoc := "Fac. Prv."
                  ::oDbf:cDocMov := ::oFacPrvL:cSerFac + "/" + AllTrim( Str( ::oFacPrvL:nNumFac ) ) + "/" + ::oFacPrvL:cSufFac

                  ::oDbf:Save()

               end if

               ::oFacPrvL:Skip()

            end while

         end if

      end if

      ::oFacPrvT:Skip()

      ::oMtrInf:Set( ::oFacPrvT:OrdKeyNo() )

   end while

   ::oFacPrvT:IdxDelete( cCurUsr(), GetFileNoExt( ::oFacPrvT:cFile ) )
   ::oFacPrvL:IdxDelete( cCurUsr(), GetFileNoExt( ::oFacPrvL:cFile ) )

   /*
   Albaranes de clientes-------------------------------------------------------
   */

   ::oAlbCliT:OrdSetFocus( "dFecAlb" )
   ::oAlbCliL:OrdSetFocus( "nNumAlb" )

   cExpHead          := 'nFacturado < 3 .and. dFecAlb >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecAlb <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   ::oAlbCliT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oAlbCliT:cFile ), ::oAlbCliT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oAlbCliT:OrdKeyCount() )
   ::oMtrInf:cText   := "Procesando albarán cliente"

   if !::lAllAlm
      cExpLine       := 'cAlmLin >= "' + Rtrim( ::cAlmOrg ) + '" .and. cAlmLin <= "' + Rtrim( ::cAlmDes ) + '"'
   else
      cExpLine       := '.t.'
   end if

   if !::lAllArt
      cExpLine       += ' .and. cRef >= "' + ::cArtOrg + '" .and. cRef <= "' + ::cArtDes + '"'
   end if

   ::oAlbCliL:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oAlbCliL:cFile ), ::oAlbCliL:OrdKey(), cAllTrimer( cExpLine ), , , , , , , , .t. )

   ::oAlbCliT:GoTop()

   while !::lBreak .and. !::oAlbCliT:Eof()

      if lChkSer( ::oAlbCliT:cSerAlb, ::aSer )

         if ::oAlbCliL:Seek( ::oAlbCliT:cSerAlb + Str( ::oAlbCliT:nNumAlb ) + ::oAlbCliT:cSufAlb )

            while ::oAlbCliT:cSerAlb + Str( ::oAlbCliT:nNumAlb ) + ::oAlbCliT:cSufAlb == ::oAlbCliL:cSerAlb + Str( ::oAlbCliL:nNumAlb ) + ::oAlbCliL:cSufAlb .AND. !::oAlbCliL:eof()

               if !Empty( ::oAlbCliL:cAlmLin )                                      .AND.;
                  ( oRetFld( ::oAlbCliL:cRef, ::oDbfArt, "nCtlStock" ) != 3 )       .AND.;
                  !( ::lExcCero .and. nTotNAlbCli( ::oAlbCliL ) == 0 )              .AND.;
                  !( ::lExcImp .and. nTotLAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut ) == 0 )

                  ::oDbf:Append()
                  ::oDbf:Blank()

                  ::oDbf:cCodCli := ::oAlbCliT:cCodCli
                  ::oDbf:cNomCli := ::oAlbCliT:cNomCli
                  ::oDbf:dFecMov := ::oAlbCliT:dFecAlb
                  ::oDbf:cTimMov := ::oAlbCliT:cTimCre

                  ::oDbf:cCodAlm := ::oAlbCliL:cAlmLin
                  ::oDbf:cNomAlm := oRetFld( ::oAlbCliL:cAlmLin, ::oDbfAlm )

                  ::oDbf:cCodArt := ::oAlbCliL:cRef
                  ::oDbf:cNomArt := ::oAlbCliL:cDetalle
                  ::oDbf:cCodPr1 := ::oAlbCliL:cCodPr1
                  ::oDbf:cNomPr1 := retProp( ::oAlbCliL:cCodPr1 )
                  ::oDbf:cCodPr2 := ::oAlbCliL:cCodPr2
                  ::oDbf:cNomPr2 := retProp( ::oAlbCliL:cCodPr2 )
                  ::oDbf:cValPr1 := ::oAlbCliL:cValPr1
                  ::oDbf:cNomVl1 := retValProp( ::oAlbCliL:cCodPr1 + ::oAlbCliL:cValPr1 )
                  ::oDbf:cValPr2 := ::oAlbCliL:cValPr2
                  ::oDbf:cNomVl2 := retValProp( ::oAlbCliL:cCodPr2 + ::oAlbCliL:cValPr2 )

                  ::oDbf:nCajSal := ::oAlbCliL:nCanEnt
                  ::oDbf:nUndSal := ::oAlbCliL:nUniCaja
                  ::oDbf:nTotSal := nTotNAlbCli( ::oAlbCliL )
                  ::oDbf:nPreSal := nTotUAlbCli( ::oAlbCliL, ::nDecOut )
                  ::oDbf:nImpSal := nTotLAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut )

                  ::oDbf:cTipDoc := "Alb. Cli."
                  ::oDbf:cDocMov := ::oAlbCliL:cSerAlb + "/" + AllTrim( Str( ::oAlbCliL:nNumAlb ) ) + "/" + ::oAlbCliL:cSufAlb

                  ::oDbf:Save()

               end if

               ::oAlbCliL:Skip()

            end while

         end if

      end if

      ::oAlbCliT:Skip()

      ::oMtrInf:Set( ::oAlbCliT:OrdKeyNo() )

   end while

   ::oAlbCliT:IdxDelete( cCurUsr(), GetFileNoExt( ::oAlbCliT:cFile ) )
   ::oAlbCliL:IdxDelete( cCurUsr(), GetFileNoExt( ::oAlbCliL:cFile ) )

   /*
   Facturas de clientes--------------------------------------------------------
   */

   ::oFacCliT:OrdSetFocus( "dFecFac" )
   ::oFacCliL:OrdSetFocus( "nNumFac" )

   cExpHead          := 'dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   ::oFacCliT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oFacCliT:cFile ), ::oFacCliT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oFacCliT:OrdKeyCount() )
   ::oMtrInf:cText   := "Procesando factura cliente"

   if !::lAllAlm
      cExpLine       := 'cAlmLin >= "' + Rtrim( ::cAlmOrg ) + '" .and. cAlmLin <= "' + Rtrim( ::cAlmDes ) + '"'
   else
      cExpLine       := '.t.'
   end if

   if !::lAllArt
      cExpLine       += ' .and. cRef >= "' + ::cArtOrg + '" .and. cRef <= "' + ::cArtDes + '"'
   end if

   ::oFacCliL:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oFacCliL:cFile ), ::oFacCliL:OrdKey(), cAllTrimer( cExpLine ), , , , , , , , .t. )

   ::oFacCliT:GoTop()

   while !::lBreak .and. !::oFacCliT:Eof()

      if lChkSer( ::oFacCliT:cSerie, ::aSer )

         if ::oFacCliL:Seek( ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac )

            while ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac == ::oFacCliL:cSerie + Str( ::oFacCliL:nNumFac ) + ::oFacCliL:cSufFac .AND. !::oFacCliL:eof()

               if !Empty( ::oFacCliL:cAlmLin )                                      .AND.;
                  ( oRetFld( ::oFacCliL:cRef, ::oDbfArt, "nCtlStock" ) != 3 )       .AND.;
                  !( ::lExcCero .and. nTotNFacCli( ::oFacCliL ) == 0 )              .AND.;
                  !( ::lExcImp .and. nTotLFacCli( ::oFacCliL:cAlias, ::nDecOut, ::nDerOut ) == 0 )

                  ::oDbf:Append()
                  ::oDbf:Blank()

                  ::oDbf:cCodCli := ::oFacCliT:cCodCli
                  ::oDbf:cNomCli := ::oFacCliT:cNomCli
                  ::oDbf:dFecMov := ::oFacCliT:dFecFac
                  ::oDbf:cTimMov := ::oFacCliT:cTimCre

                  ::oDbf:cCodAlm := ::oFacCliL:cAlmLin
                  ::oDbf:cNomAlm := oRetFld( ::oFacCliL:cAlmLin, ::oDbfAlm )

                  ::oDbf:cCodArt := ::oFacCliL:cRef
                  ::oDbf:cNomArt := ::oFacCliL:cDetalle
                  ::oDbf:cCodPr1 := ::oFacCliL:cCodPr1
                  ::oDbf:cNomPr1 := retProp( ::oFacCliL:cCodPr1 )
                  ::oDbf:cCodPr2 := ::oFacCliL:cCodPr2
                  ::oDbf:cNomPr2 := retProp( ::oFacCliL:cCodPr2 )
                  ::oDbf:cValPr1 := ::oFacCliL:cValPr1
                  ::oDbf:cNomVl1 := retValProp( ::oFacCliL:cCodPr1 + ::oFacCliL:cValPr1 )
                  ::oDbf:cValPr2 := ::oFacCliL:cValPr2
                  ::oDbf:cNomVl2 := retValProp( ::oFacCliL:cCodPr2 + ::oFacCliL:cValPr2 )

                  ::oDbf:nCajSal := ::oFacCliL:nCanEnt
                  ::oDbf:nUndSal := ::oFacCliL:nUniCaja
                  ::oDbf:nTotSal := nTotNFacCli( ::oFacCliL:cAlias )
                  ::oDbf:nPreSal := nTotUFacCli( ::oFacCliL:cAlias, ::nDecOut )
                  ::oDbf:nImpSal := nTotLFacCli( ::oFacCliL:cAlias, ::nDecOut, ::nDerOut )

                  ::oDbf:cTipDoc := "Fac. Cli."
                  ::oDbf:cDocMov := ::oFacCliL:cSerie + "/" + AllTrim( Str( ::oFacCliL:nNumFac ) ) + "/" + ::oFacCliL:cSufFac

                  ::oDbf:Save()

               end if

               ::oFacCliL:Skip()

            end while

         end if

      end if

      ::oFacCliT:Skip()

      ::oMtrInf:Set( ::oFacCliT:OrdKeyNo() )

   end while

   ::oFacCliT:IdxDelete( cCurUsr(), GetFileNoExt( ::oFacCliT:cFile ) )
   ::oFacCliL:IdxDelete( cCurUsr(), GetFileNoExt( ::oFacCliL:cFile ) )

   /*
   Facturas rectificativas-----------------------------------------------------
   */

   ::oFacRecT:OrdSetFocus( "dFecFac" )
   ::oFacRecL:OrdSetFocus( "nNumFac" )

   cExpHead          := 'dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   ::oFacRecT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oFacRecT:cFile ), ::oFacRecT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oFacRecT:OrdKeyCount() )
   ::oMtrInf:cText   := "Procesando factura rectificativa"

   if !::lAllAlm
      cExpLine       := 'cAlmLin >= "' + Rtrim( ::cAlmOrg ) + '" .and. cAlmLin <= "' + Rtrim( ::cAlmDes ) + '"'
   else
      cExpLine       := '.t.'
   end if

   if !::lAllArt
      cExpLine       += ' .and. cRef >= "' + ::cArtOrg + '" .and. cRef <= "' + ::cArtDes + '"'
   end if

   ::oFacRecL:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oFacRecL:cFile ), ::oFacRecL:OrdKey(), cAllTrimer( cExpLine ), , , , , , , , .t. )

   ::oFacRecT:GoTop()

   while !::lBreak .and. !::oFacRecT:Eof()

      if lChkSer( ::oFacRecT:cSerie, ::aSer )

        if ::oFacRecL:Seek( ::oFacRecT:cSerie + Str( ::oFacRecT:nNumFac ) + ::oFacRecT:cSufFac )

            while ::oFacRecT:cSerie + Str( ::oFacRecT:nNumFac ) + ::oFacRecT:cSufFac == ::oFacRecL:cSerie + Str( ::oFacRecL:nNumFac ) + ::oFacRecL:cSufFac .AND. !::oFacRecL:eof()

               if !Empty( ::oFacRecL:cAlmLin )                                      .AND.;
                  ( oRetFld( ::oFacRecL:cRef, ::oDbfArt, "nCtlStock" ) != 3 )       .AND.;
                  !( ::lExcCero .and. nTotNFacRec( ::oFacRecL ) == 0 )              .AND.;
                  !( ::lExcImp .and. nTotLFacRec( ::oFacRecL:cAlias, ::nDecOut, ::nDerOut ) == 0 )

                  ::oDbf:Append()
                  ::oDbf:Blank()

                  ::oDbf:cCodCli := ::oFacRecT:cCodCli
                  ::oDbf:cNomCli := ::oFacRecT:cNomCli

                  ::oDbf:dFecMov := ::oFacRecT:dFecFac
                  ::oDbf:cTimMov := ::oFacRecT:cTimCre

                  ::oDbf:cCodAlm := ::oFacRecL:cAlmLin
                  ::oDbf:cNomAlm := oRetFld( ::oFacRecL:cAlmLin, ::oDbfAlm )

                  ::oDbf:cCodArt := ::oFacRecL:cRef
                  ::oDbf:cNomArt := ::oFacRecL:cDetalle
                  ::oDbf:cCodPr1 := ::oFacRecL:cCodPr1
                  ::oDbf:cNomPr1 := retProp( ::oFacRecL:cCodPr1 )
                  ::oDbf:cCodPr2 := ::oFacRecL:cCodPr2
                  ::oDbf:cNomPr2 := retProp( ::oFacRecL:cCodPr2 )
                  ::oDbf:cValPr1 := ::oFacRecL:cValPr1
                  ::oDbf:cNomVl1 := retValProp( ::oFacRecL:cCodPr1 + ::oFacRecL:cValPr1 )
                  ::oDbf:cValPr2 := ::oFacRecL:cValPr2
                  ::oDbf:cNomVl2 := retValProp( ::oFacRecL:cCodPr2 + ::oFacRecL:cValPr2 )

                  ::oDbf:nCajEnt := ::oFacRecL:nCanEnt
                  ::oDbf:nUndEnt := ::oFacRecL:nUniCaja
                  ::oDbf:nTotEnt := nTotNFacRec( ::oFacRecL:cAlias )
                  ::oDbf:nPreEnt := nTotUFacRec( ::oFacRecL:cAlias, ::nDecOut )
                  ::oDbf:nImpEnt := nTotLFacRec( ::oFacRecL:cAlias, ::nDecOut, ::nDerOut )

                  ::oDbf:cTipDoc := "Fac. Rec."
                  ::oDbf:cDocMov := ::oFacRecL:cSerie + "/" + AllTrim( Str( ::oFacRecL:nNumFac ) ) + "/" + ::oFacRecL:cSufFac

                  ::oDbf:Save()

               end if

               ::oFacRecL:Skip()

            end while

         end if

      end if

      ::oFacRecT:Skip()

      ::oMtrInf:Set( ::oFacRecT:OrdKeyNo() )

   end while

   ::oFacRecT:IdxDelete( cCurUsr(), GetFileNoExt( ::oFacRecT:cFile ) )
   ::oFacRecL:IdxDelete( cCurUsr(), GetFileNoExt( ::oFacRecL:cFile ) )

   /*
   Tickets --------------------------------------------------------------------
   */

   ::oTikCliT:OrdSetFocus( "cNumTik" )
   ::oTikCliL:OrdSetFocus( "cNumTil" )

   cExpHead          := 'dFecTik >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecTik <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   cExpHead          += ' .and. ( cTipTik == "1" .or. cTipTik == "4" )'

   if !::lAllAlm
      cExpHead       += ' .and. cAlmTik >= "' + Rtrim( ::cAlmOrg ) + '" .and. cAlmTik <= "' + Rtrim( ::cAlmDes ) + '"'
   end if

   ::oTikCliT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oTikCliT:cFile ), ::oTikCliT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   if ::lAllArt
      cExpLine       := '( !Empty( cCbaTil ) .or. !Empty( cComTil ) )'
   else
      cExpLine       := '( ( !Empty( cCbaTil ) .and. cCbaTil >= "' + ::cArtOrg + '" .and. cCbaTil <= "' + ::cArtDes + '" )'
      cExpLine       += '.or.  ( !Empty( cComTil ) .and. cComTil >= "' + ::cArtOrg + '" .and. cComTil <= "' + ::cArtDes + '" ) )'
   end if

   ::oTikCliL:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oTikCliL:cFile ), ::oTikCliL:OrdKey(), cAllTrimer( cExpLine ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oTikCliL:OrdKeyCount() )
   ::oMtrInf:cText   := "Procesando tiket"

   ::oTikCliL:GoTop()

   while !::lBreak .and. !::oTikCliT:Eof()

      if lChkSer( ::oTikCliT:cSerTik, ::aSer )                                   .and.;
         ::oTikCliL:Seek( ::oTikCliT:cSerTik + ::oTikCliT:cNumTik + ::oTikCliT:cSufTik )

         while ::oTikCliT:cSerTik + ::oTikCliT:cNumTik + ::oTikCliT:cSufTik == ::oTikCliL:cSerTil + ::oTikCliL:cNumTil + ::oTikCliL:cSufTil .AND. !::oTikCliL:Eof()

            if !Empty( ::oTikCliT:cAlmTik ) .and. !Empty( ::oTikCliL:cCbaTil )                   .and.;
               ( oRetFld( ::oTikCliL:cCbaTil, ::oDbfArt, "nCtlStock" ) != 3 )                    .and.;
               !( ::lExcCero .AND. ::oTikCliL:nUntTil == 0 )                                     .and.;
               !( ::lExcImp .AND. ::oTikCliL:nPvpTil == 0 )

               ::oDbf:Append()
               ::oDbf:Blank()

               ::oDbf:cCodCli := ::oTikClit:cCliTik
               ::oDbf:cNomCli := ::oTikClit:cNomTik

               ::oDbf:cCodAlm := ::oTikClit:cAlmTik
               ::oDbf:cNomAlm := oRetFld( ::oTikCliT:cAlmTik, ::oDbfAlm )

               ::oDbf:dFecMov := ::oTikClit:dFecTik
               ::oDbf:cTimMov := ::oTikCliT:cHorTik

               ::oDbf:cCodArt := ::oTikCliL:cCbaTil
               ::oDbf:cDocMov := ::oTikClit:cSerTik + "/" + AllTrim( ::oTikClit:cNumTik ) + "/" + ::oTikClit:cSufTik
               ::oDbf:cTipDoc := "Tiket"

               ::oDbf:cCodPr1 := ::oTikCliL:cCodPr1
               ::oDbf:cNomPr1 := retProp( ::oTikCliL:cCodPr1 )
               ::oDbf:cCodPr2 := ::oTikCliL:cCodPr2
               ::oDbf:cNomPr2 := retProp( ::oTikCliL:cCodPr2 )
               ::oDbf:cValPr1 := ::oTikCliL:cValPr1
               ::oDbf:cNomVl1 := retValProp( ::oTikCliL:cCodPr1 + ::oTikCliL:cValPr1 )
               ::oDbf:cValPr2 := ::oTikCliL:cValPr2
               ::oDbf:cNomVl2 := retValProp( ::oTikCliL:cCodPr2 + ::oTikCliL:cValPr2 )

               if ::oTikCliT:cTipTik == "4"
                  ::oDbf:nUndEnt := ::oTikCliL:nUntTil
                  ::oDbf:nTotEnt := ::oTikCliL:nUntTil
                  ::oDbf:nPreEnt := nTotLTpv( ::oTikCliL, ::nDecOut, ::nDerOut )
               else
                  ::oDbf:nUndSal := ::oTikCliL:nUntTil
                  ::oDbf:nTotSal := ::oTikCliL:nUntTil
                  ::oDbf:nPreSal := nTotLTpv( ::oTikCliL, ::nDecOut, ::nDerOut )
               end if

               ::oDbf:Save()

            end if

            if !Empty( ::oTikCliT:cAlmTik ) .and. !Empty( ::oTikCliL:cComTil )                   .and.;
               ( oRetFld( ::oTikCliL:cComTil, ::oDbfArt, "nCtlStock" ) != 3 )                    .and.;
               !( ::lExcCero .AND. ::oTikCliL:nUntTil == 0 )                                     .and.;
               !( ::lExcImp .AND. ::oTikCliL:nPcmTil == 0 )

               ::oDbf:Append()
               ::oDbf:Blank()

               ::oDbf:cCodCli := ::oTikClit:cCliTik
               ::oDbf:cNomCli := ::oTikClit:cNomTik

               ::oDbf:cCodAlm := ::oTikClit:cAlmTik
               ::oDbf:cNomAlm := oRetFld( ::oTikCliT:cAlmTik, ::oDbfAlm )

               ::oDbf:dFecMov := ::oTikClit:dFecTik
               ::oDbf:cTimMov := ::oTikCliT:cHorTik

               ::oDbf:cCodArt := ::oTikCliL:cComTil
               ::oDbf:cDocMov := ::oTikClit:cSerTik + "/" + AllTrim( ::oTikClit:cNumTik ) + "/" + ::oTikClit:cSufTik
               ::oDbf:cTipDoc := "Tiket"

               ::oDbf:cCodPr1 := ::oTikCliL:cCodPr1
               ::oDbf:cNomPr1 := retProp( ::oTikCliL:cCodPr1 )
               ::oDbf:cCodPr2 := ::oTikCliL:cCodPr2
               ::oDbf:cNomPr2 := retProp( ::oTikCliL:cCodPr2 )
               ::oDbf:cValPr1 := ::oTikCliL:cValPr1
               ::oDbf:cNomVl1 := retValProp( ::oTikCliL:cCodPr1 + ::oTikCliL:cValPr1 )
               ::oDbf:cValPr2 := ::oTikCliL:cValPr2
               ::oDbf:cNomVl2 := retValProp( ::oTikCliL:cCodPr2 + ::oTikCliL:cValPr2 )

               if ::oTikCliT:cTipTik == "4"
                  ::oDbf:nUndEnt := ::oTikCliL:nUntTil
                  ::oDbf:nTotEnt := ::oTikCliL:nUntTil
                  ::oDbf:nPreEnt := nTotLTpv( ::oTikCliL, ::nDecOut, ::nDerOut )
               else
                  ::oDbf:nUndSal := ::oTikCliL:nUntTil
                  ::oDbf:nTotSal := ::oTikCliL:nUntTil
                  ::oDbf:nPreSal := nTotLTpv( ::oTikCliL, ::nDecOut, ::nDerOut )
               end if

               ::oDbf:Save()

            end if

            ::oTikCliL:Skip()

         end while

      end if

      ::oTikCliT:Skip()

      ::oMtrInf:Set( ::oTikCliT:OrdKeyNo() )

   end while

   ::oTikCliT:IdxDelete( cCurUsr(), GetFileNoExt( ::oTikCliT:cFile ) )
   ::oTikCliL:IdxDelete( cCurUsr(), GetFileNoExt( ::oTikCliL:cFile ) )

   /*
   Histórico de movimientos-------------------------------------------------
   */

   ::oHisMov:OrdSetFocus( "dFecMov" )

   cExpHead          := 'dFecMov >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecMov <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   if !::lAllArt
      cExpHead       += ' .and. cRefMov >= "' + ::cArtOrg + '" .and. cRefMov <= "' + ::cArtDes + '"'
   end if

   ::oHisMov:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oHisMov:cFile ), ::oHisMov:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oHisMov:OrdKeyCount() )
   ::oMtrInf:cText   := "Procesando movimiento"

   ::oHisMov:GoTop()

   while !::lBreak .and. !::oHisMov:Eof()

         /*
         Salidas____________________________________________________________
         */

         if !Empty( ::oHisMov:cAloMov )                           .AND.;
            ( ::lAllAlm .or. ( ::oHisMov:cAloMov >= Rtrim( ::cAlmOrg ) .and. ::oHisMov:cAloMov <= RTrim( ::cAlmDes ) ) ) .AND.;
            ( oRetFld( ::oHisMov:cRefMov, ::oDbfArt, "nCtlStock" ) != 3 )                                                .AND.;
            !( ::lExcCero .and. nTotNMovAlm( ::oHisMov ) == 0 )   .AND.;
            !( ::lExcImp .and. nTotLMovAlm( ::oHisMov ) == 0 )

               ::oDbf:Append()
               ::oDbf:Blank()

               ::oDbf:cCodCli := ""
               ::oDbf:cNomCli := "Movimientos entre almacenes"

               ::oDbf:cCodAlm := ::oHisMov:cAloMov
               ::oDbf:cNomAlm := oRetFld( ::oHisMov:cAloMov, ::oDbfAlm )

               ::oDbf:dFecMov := ::oHisMov:dFecMov
               ::oDbf:cTimMov := ::oHisMov:cTimMov

               ::oDbf:cCodArt := ::oHisMov:cRefMov
               ::oDbf:cCodPr1 := ::oHisMov:cCodPr1
               ::oDbf:cNomPr1 := retProp( ::oHisMov:cCodPr1 )
               ::oDbf:cCodPr2 := ::oHisMov:cCodPr2
               ::oDbf:cNomPr2 := retProp( ::oHisMov:cCodPr2 )
               ::oDbf:cValPr1 := ::oHisMov:cValPr1
               ::oDbf:cNomVl1 := retValProp( ::oHisMov:cCodPr1 + ::oHisMov:cValPr1 )
               ::oDbf:cValPr2 := ::oHisMov:cValPr2
               ::oDbf:cNomVl2 := retValProp( ::oHisMov:cCodPr2 + ::oHisMov:cValPr2 )

               if nTotNMovAlm( ::oHisMov ) > 0
                  ::oDbf:nCajSal := ::oHisMov:nCajMov
                  ::oDbf:nUndSal := ::oHisMov:nUndMov
                  ::oDbf:nTotSal := nTotNMovAlm( ::oHisMov )
                  ::oDbf:nPreSal := ::oHisMov:nPreDiv
                  ::oDbf:nImpSal := nTotLMovAlm( ::oHisMov )
               else
                  ::oDbf:nCajEnt := Abs( ::oHisMov:nCajMov )
                  ::oDbf:nUndEnt := Abs( ::oHisMov:nUndMov )
                  ::oDbf:nTotEnt := Abs( nTotNMovAlm( ::oHisMov ) )
                  ::oDbf:nPreEnt := Abs( ::oHisMov:nPreDiv )
                  ::oDbf:nImpEnt := Abs( nTotLMovAlm( ::oHisMov ) )
               end if

               ::oDbf:cDocMov := Str( ::oHisMov:nNumRem ) + "/" + ::oHisMov:cSufRem
               ::oDbf:cTipDoc := "Sal. almacén"

               ::oDbf:Save()

         end if

         /*
         Entradas___________________________________________________________
         */

         if !Empty( ::oHisMov:cAliMov )                           .AND.;
            ( ::lAllAlm .or. ( ::oHisMov:cAliMov >= Rtrim( ::cAlmOrg ) .and. ::oHisMov:cAliMov <= RTrim( ::cAlmDes ) ) ) .AND.;
            ( oRetFld( ::oHisMov:cRefMov, ::oDbfArt, "nCtlStock" ) != 3 )                                                .AND.;
            !( ::lExcCero .and. nTotNMovAlm( ::oHisMov ) == 0 )   .AND.;
            !( ::lExcImp .and. nTotLMovAlm( ::oHisMov ) == 0 )

               ::oDbf:Append()
               ::oDbf:Blank()

               ::oDbf:cCodCli := ""
               ::oDbf:cNomCli := "Movimientos entre almacenes"

               ::oDbf:cCodAlm := ::oHisMov:cAliMov
               ::oDbf:cNomAlm := oRetFld( ::oHisMov:cAliMov, ::oDbfAlm )

               ::oDbf:dFecMov := ::oHisMov:dFecMov
               ::oDbf:cTimMov := ::oHisMov:cTimMov

               ::oDbf:cCodArt := ::oHisMov:cRefMov
               ::oDbf:cCodPr1 := ::oHisMov:cCodPr1
               ::oDbf:cNomPr1 := retProp( ::oHisMov:cCodPr1 )
               ::oDbf:cCodPr2 := ::oHisMov:cCodPr2
               ::oDbf:cNomPr2 := retProp( ::oHisMov:cCodPr2 )
               ::oDbf:cValPr1 := ::oHisMov:cValPr1
               ::oDbf:cNomVl1 := retValProp( ::oHisMov:cCodPr1 + ::oHisMov:cValPr1 )
               ::oDbf:cValPr2 := ::oHisMov:cValPr2
               ::oDbf:cNomVl2 := retValProp( ::oHisMov:cCodPr2 + ::oHisMov:cValPr2 )

               if nTotNMovAlm( ::oHisMov ) > 0
                  ::oDbf:nCajEnt := ::oHisMov:nCajMov
                  ::oDbf:nUndEnt := ::oHisMov:nUndMov
                  ::oDbf:nTotEnt := nTotNMovAlm( ::oHisMov )
                  ::oDbf:nPreEnt := ::oHisMov:nPreDiv
                  ::oDbf:nImpEnt := nTotLMovAlm( ::oHisMov )
               else
                  ::oDbf:nCajSal := Abs( ::oHisMov:nCajMov )
                  ::oDbf:nUndSal := Abs( ::oHisMov:nUndMov )
                  ::oDbf:nTotSal := Abs( nTotNMovAlm( ::oHisMov ) )
                  ::oDbf:nPreSal := Abs( ::oHisMov:nPreDiv )
                  ::oDbf:nImpSal := Abs( nTotLMovAlm( ::oHisMov ) )
               end if

               ::oDbf:cDocMov := Str( ::oHisMov:nNumRem ) + "/" + ::oHisMov:cSufRem
               ::oDbf:cTipDoc := "Ent. almacén"

               ::oDbf:Save()

         end if

         ::oHisMov:Skip()

         ::oMtrInf:Set( ::oHisMov:OrdKeyNo() )

   end while

   ::oHisMov:IdxDelete( cCurUsr(), GetFileNoExt( ::oHisMov:cFile ) )

   ::oMtrInf:Set( ::oHisMov:LastRec() )

   ::CreaSaldo()

   ::oDlg:Enable()

   ::oBtnFilter:Disable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//

METHOD CreaSaldo()

// Esto es para crear los saldos-----------------------------------------------

   local cCodArt
   local cCodAlm
   local nSalAnt           := 0
   local nImpAnt           := 0
   local nPreAnt           := 0
   local nTotStk           := 0

   ::oDbf:GoTop()

   ::oMtrInf:SetTotal( ::oDbf:OrdKeyCount() )
   ::oMtrInf:cText   := "Calculando saldos"

   while !::oDbf:Eof()

      //Inicializamos las variables para cuando cambiamos de almacén o de artículo

      ::oDbf:Load()

      nTotStk       += ::oDbf:nTotEnt
      nTotStk       -= ::oDbf:nTotSal

      if ::oDbf:nTotEnt != 0 //Al comprar calculamos el precio medio

         nSalAnt           += ::oDbf:nTotEnt
         nImpAnt           += ::oDbf:nImpEnt
         nPreAnt           := nImpAnt / nSalAnt

         ::oDbf:nPreStk    := nPreAnt
         ::oDbf:nImpStk    := nSalAnt * nPreAnt

      end if

      if ::oDbf:nTotSal != 0 .and. nSalAnt > 0 //Al vender Ponemos el último precio

         nSalAnt           -= Min( ::oDbf:nTotSal, nSalAnt )

         ::oDbf:nPreStk    := nPreAnt
         ::oDbf:nImpStk    := ::oDbf:nTotSal * nPreAnt

      end if

      cCodAlm              := ::oDbf:cCodAlm
      cCodArt              := ::oDbf:cCodArt

      ::oDbf:nTotStk       := nTotStk

      ::oDbf:Save()

      ::oDbf:Skip()

      if ::oDbf:cCodAlm != cCodAlm .or. ::oDbf:cCodArt != cCodArt

         nSalAnt           := 0
         nImpAnt           := 0
         nPreAnt           := 0

      end if

      ::oMtrInf:Set( ::oDbf:OrdKeyNo() )

   end while

RETURN ( self )

//---------------------------------------------------------------------------//