#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS EInfRMov FROM TInfGen

   DATA  lResumen    AS LOGIC    INIT .f.
   DATA  lExcCero    AS LOGIC    INIT .f.
   DATA  lDesPrp     AS LOGIC    INIT .f.
   DATA  oAlbPrvT    AS OBJECT
   DATA  oAlbPrvL    AS OBJECT
   DATA  oFacPrvT    AS OBJECT
   DATA  oFacPrvL    AS OBJECT
   DATA  oAlbCliT    AS OBJECT
   DATA  oAlbCliL    AS OBJECT
   DATA  oFacCliT    AS OBJECT
   DATA  oFacCliL    AS OBJECT
   DATA  oTikCliT    AS OBJECT
   DATA  oTikCliL    AS OBJECT
   DATA  oHisMov     AS OBJECT
   DATA  oArt        AS OBJECT

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHod lResource( cFld )

   METHOD lGenerate()

   METHOD lValArt( cCodArt, cCodAlm, nTotUnd )

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField( "cCodArt", "C", 18, 0, {|| "@!" },          "Código artículo",     .t., "Código artículo",          14, .f. )
   ::AddField( "cCodAlm", "C", 18, 0, {|| "@!" },          "Cod. alm.",     .f., "Código almacén",           14, .f. )
   ::AddField( "cNomArt", "C",100, 0, {|| "@!" },          "Artículo",      .t., "Artículo",                 50, .f. )
   ::AddField( "nExtArt", "N", 10, 0, {|| "@!" },          "Existencias",   .t., "Existencias",              10, .f. )
   ::AddField( "nCosArt", "N", 10, 0, {|| "@!" },          "Costo",         .t., "Costo",                    10, .f. )
   ::AddField( "nTotArt", "N", 10, 0, {|| "@!" },          "Total",         .t., "Total",                    10, .f. )

   if ::xOthers
      ::AddTmpIndex( "cCodArt", "cCodArt + cNomArt" )
      ::AddGroup( {|| ::oDbf:cCodAlm }, {|| "Almacen  : " + Rtrim( ::oDbf:cCodAlm ) + "-" + Rtrim( oRetFld( ::oDbf:cCodAlm, ::oDbfAlm ) ) }, {|| "Total almacen..." } )
      ::AddGroup( {|| ::oDbf:cCodAlm + ::oDbf:cCodArt }, {|| "Artículo : " + Rtrim( ::oDbf:cCodArt ) + "-" + Rtrim( oRetFld( ::oDbf:cCodArt, ::oDbfArt ) ) }, {|| "Total articulo..." } )
   else
      ::AddTmpIndex( "cCodArt", "cCodArt + cNomArt" )
      ::AddGroup( {|| ::oDbf:cCodArt }, {|| "Artículo : " + Rtrim( ::oDbf:cCodArt ) + "-" + Rtrim( oRetFld( ::oDbf:cCodArt, ::oDbfArt ) ) }, {|| "Total articulo..." } )
   end if

   ::aHeader      := {  {|| "Fecha   : " + Dtoc( Date() ) },;
                        {|| "Periodo : " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                        {|| "Almacén : " + ::cAlmOrg         + " > " + ::cAlmDes },;
                        {|| "Artículo: " + Rtrim( ::cArtOrg )+ " > " + Rtrim( ::cArtDes ) } }

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   DATABASE NEW ::oAlbPrvT PATH ( cPatEmp() ) FILE "ALBPROVT.DBF" VIA ( cDriver() ) SHARED INDEX "ALBPROVT.CDX"

   DATABASE NEW ::oAlbPrvL PATH ( cPatEmp() ) FILE "ALBPROVL.DBF" VIA ( cDriver() ) SHARED INDEX "ALBPROVL.CDX"

   DATABASE NEW ::oFacPrvT PATH ( cPatEmp() ) FILE "FACPRVT.DBF" VIA ( cDriver() ) SHARED INDEX "FACPRVT.CDX"

   DATABASE NEW ::oFacPrvL PATH ( cPatEmp() ) FILE "FACPRVL.DBF" VIA ( cDriver() ) SHARED INDEX "FACPRVL.CDX"

   ::oAlbCliT := TDataCenter():oAlbCliT()

   DATABASE NEW ::oAlbCliL PATH ( cPatEmp() ) FILE "ALBCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "ALBCLIL.CDX"

   ::oFacCliT := TDataCenter():oFacCliT()

   DATABASE NEW ::oFacCliL PATH ( cPatEmp() ) FILE "FACCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "FACCLIL.CDX"

   DATABASE NEW ::oTikCliT PATH ( cPatEmp() )  FILE "TIKET.DBF" VIA ( cDriver() ) SHARED INDEX "TIKET.CDX"

   DATABASE NEW ::oTikCliL PATH ( cPatEmp() )  FILE "TIKEL.DBF" VIA ( cDriver() ) SHARED INDEX "TIKEL.CDX"

   DATABASE NEW ::oArt     PATH ( cPatArt() )  FILE "ARTICULO.DBF" VIA ( cDriver() ) SHARED INDEX "ARTICULO.CDX"

   DATABASE NEW ::oHisMov  PATH ( cPatEmp() )  FILE "HISMOV.DBF" VIA ( cDriver() ) SHARED INDEX "HISMOV.CDX"

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos" )
      CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles()

   if !Empty( ::oAlbPrvT )
      ::oAlbPrvT:End()
   end if
   if !Empty( ::oAlbPrvL )
      ::oAlbPrvL:End()
   end if
   if !Empty( ::oFacPrvT )
      ::oFacPrvT:End()
   end if
   if !Empty( ::oFacPrvL )
      ::oFacPrvL:End()
   end if
   if !Empty( ::oAlbCliT )
      ::oAlbCliT:End()
   end if
   if !Empty( ::oAlbCliL )
      ::oAlbCliL:End()
   end if
   if !Empty( ::oFacCliT )
      ::oFacCliT:End()
   end if
   if !Empty( ::oFacCliL )
      ::oFacCliL:End()
   end if
   if !Empty( ::oTikCliT )
      ::oTikCliT:End()
   end if
   if !Empty( ::oTikCliL )
      ::oTikCliL:End()
   end if
   if !Empty( :oArt )
      ::oArt:End()
   end if
   if !Empty( ::oHisMov )
      ::oHisMov:End()
   end if

   ::oAlbPrvT := Nil
   ::oAlbPrvL := Nil
   ::oFacPrvT := Nil
   ::oFacPrvL := Nil
   ::oAlbCliT := Nil
   ::oAlbCliL := Nil
   ::oFacCliT := Nil
   ::oFacCliL := Nil
   ::oTikCliT := Nil
   ::oTikCliL := Nil
   ::oHisMov  := Nil
   ::oArt     := Nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHod lResource( cFld )

   if !::StdResource( "INF_GEN06" )
      return .f.
   end if

   REDEFINE CHECKBOX ::lDesPrp ;
      ID       180;
      OF       ::oFld:aDialogs[1]

   /*
   Monta los almacenes de manera automatica
   */

   ::oDefAlmInf( 70, 80, 90, 100 )

   /*
   Monta los articulos de manera automatica
   */

   ::lDefArtInf( 110, 120, 130, 140 )

   ::oDefExcInf()

   ::oDefResInf()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lGenerate()

   local nLasTik  := ::oTikCliT:Lastrec()
   local nLasAlb  := ::oAlbCliT:Lastrec()
   local nLasFac  := ::oFacCliT:Lastrec()
   local nLasAPr  := ::oAlbPrvT:Lastrec()
   local nLasFPr  := ::oFacPrvT:Lastrec()

   ::oDlg:Disable()

   ::oDbf:Zap()

   /*
   Recorremos albaranes de proveedores
   */

   ::oAlbPrvT:GoTop()
   ::oMtrInf:SetTotal( nLasAPr )
   ::oMtrInf:cText := "Procesando albaranes proveedores"

   while ! ::oAlbPrvT:Eof ()

      if !::oAlbPrvT:lFacturado                                 .AND.;
         ::oAlbPrvT:DFECALB >= ::dIniInf                        .AND.;
         ::oAlbPrvT:DFECALB <= ::dFinInf                        .AND.;
         lChkSer( ::oAlbPrvT:CSERALB, ::aSer )

         /*
         Nos posicionamos en las lineas de detalle de albaranes de proveedores
         */

         if ::oAlbPrvL:Seek( ::oAlbPrvT:cSerAlb + Str( ::oAlbPrvT:nNumAlb ) + ::oAlbPrvT:cSufAlb )

         while ( ::oAlbPrvT:cSerAlb + Str( ::oAlbPrvT:nNumAlb ) + ::oAlbPrvT:cSufAlb ) == ( ::oAlbPrvL:cSerAlb + Str( ::oAlbPrvL:nNumAlb ) + ::oAlbPrvL:cSufAlb) .AND. ! ::oAlbPrvL:eof()

            if ::lValArt( ::oAlbPrvL:cRef, ::oAlbPrvL:cAlmLin, nTotNAlbPrv( ::oAlbPrvL ) )

               if ::oDbf:Seek( ::oAlbPrvL:cRef )

                  ::oDbf:Load()
                  ::oDbf:nExtArt += nTotNAlbPrv( ::oAlbPrvL )
                  ::oDbf:Save()

               else

                  ::oDbf:Append()
                  ::oDbf:cCodArt := ::oAlbPrvL:cRef
                  ::oDbf:cNomArt := ::oAlbPrvL:cDetalle
                  ::oDbf:cCodAlm := ::oAlbPrvL:cAlmLin
                  ::oDbf:nExtArt := nTotNAlbPrv( ::oAlbPrvL )
                  ::oDbf:nCosArt := nPreMedCom( ::oDbfArt:Codigo, ::oDbfAlm:cCodAlm,::oAlbPrvT:cAlias, ::oAlbPrvL:cAlias, ::oFacPrvT:cAlias, ::oFacPrvL:cAlias, ::nValDiv, ::nDecOut, ::nDerOut )
                  ::oDbf:nTotArt := ::oDbf:nExtArt * ::oDbf:nCosArt
                  ::oDbf:Save()

               end if


            end if

            ::oAlbPrvL:Skip()

         end while

         end if

      end if

   ::oAlbPrvT:Skip()

   ::oMtrInf:AutoInc( ::oAlbPrvT:OrdKeyNo() )

   end while

   /*
    Recorremos facturas de proveedores
   */

   ::oFacPrvT:GoTop()
   ::oMtrInf:SetTotal( nLasFPr )
   ::oMtrInf:cText := "Procesando facturas proveedores"

   while ! ::oFacPrvT:Eof()

      if ::oFacPrvT:DFECFAC >= ::dIniInf                                                 .AND.;
         ::oFacPrvT:DFECFAC <= ::dFinInf                                                 .AND.;
         lChkSer( ::oFacPrvT:CSERFAC, ::aSer )

         /*
         Nos posicionamos en las lineas de detalle de facturas de proveedores
         */

         if ::oFacPrvL:Seek( ::oFacPrvT:cSerFac + Str( ::oFacPrvT:nNumFac ) + ::oFacPrvT:cSufFac )

         while ::oFacPrvT:cSerFac + Str( ::oFacPrvT:nNumFac ) + ::oFacPrvT:cSufFac == ::oFacPrvL:cSerFac + Str( ::oFacPrvL:nNumFac ) + ::oFacPrvL:cSufFac .AND. ! ::oFacPrvL:Eof()

            if ::lValArt( ::oFacPrvL:cRef, ::oFacPrvL:cAlmLin, nTotNFacPrv( ::oFacPrvL ) )

                 if ::oDbf:Seek( ::oFacPrvL:cRef )

                    ::oDbf:Load()
                    ::oDbf:nExtArt += nTotNFacPrv( ::oFacPrvL )
                    ::oDbf:Save()

                 else

                    ::oDbf:Append()
                    ::oDbf:cCodArt := ::oFacPrvL:cRef
                    ::oDbf:cNomArt := ::oFacPrvL:cDetalle
                    ::oDbf:cCodAlm := ::oFacPrvL:cAlmLin
                    ::oDbf:nExtArt := nTotNFacPrv( ::oFacPrvL )
                    ::oDbf:nCosArt := nPreMedCom( ::oDbfArt:Codigo, ::oDbfAlm:cCodAlm, ::oAlbPrvT:cAlias, ::oAlbPrvL:cAlias, ::oFacPrvT:cAlias, ::oFacPrvL:cAlias, ::nValDiv, ::nDecOut, ::nDerOut )
                    ::oDbf:nTotArt := ::oDbf:nExtArt * ::oDbf:nCosArt
                    ::oDbf:Save()

                 end if

            end if

            ::oFacPrvL:Skip()

         end while

      end if

   end if

   ::oFacPrvT:Skip()

  ::oMtrInf:AutoInc( ::oFacPrvT:OrdKeyNo() )

   end while

   /*
   Recorremos albaranes de clientes
   */

   ::oAlbCliT:GoTop()
   ::oMtrInf:SetTotal( nLasAlb )
   ::oMtrInf:cText := "Procesando albaranes clientes"

   while ! ::oAlbCliT:Eof ()

      if !lFacturado( ::oAlbCliT )                              .AND.;
         ::oAlbCliT:dFecAlb >= ::dIniInf                        .AND.;
         ::oAlbCliT:dFecAlb <= ::dFinInf                        .AND.;
         lChkSer( ::oAlbCliT:cSerAlb, ::aSer )

         /*
         Nos posicionamos en las lineas de detalle de albaranes de proveedores
         */

         if ::oAlbCliL:Seek( ::oAlbCliT:cSerAlb + Str( ::oAlbCliT:nNumAlb ) + ::oAlbCliT:cSufAlb )

         while ( ::oAlbCliT:cSerAlb + Str( ::oAlbCliT:nNumAlb ) + ::oAlbCliT:cSufAlb ) == ( ::oAlbCliL:cSerAlb + Str( ::oAlbCliL:nNumAlb ) + ::oAlbCliL:cSufAlb) .AND. ! ::oAlbCliL:eof()

            if ::lValArt( ::oAlbCliL:cRef, ::oAlbCliL:cAlmLin, nTotNAlbCli( ::oAlbCliL ) )

               if ::oDbf:Seek( ::oAlbCliL:cRef )

                  ::oDbf:Load()
                  ::oDbf:nExtArt -= nTotNAlbCli( ::oAlbCliL )
                  ::oDbf:Save()

               else

                  ::oDbf:Append()
                  ::oDbf:cCodArt := ::oAlbCliL:cRef
                  ::oDbf:cNomArt := ::oAlbCliL:cDetalle
                  ::oDbf:cCodAlm := ::oAlbCliL:cAlmLin
                  ::oDbf:nExtArt := nTotNAlbCli( ::oAlbCliL )
                  ::oDbf:nCosArt := nPreMedCom( ::oDbfArt:Codigo, ::oDbfAlm:cCodAlm, ::oAlbPrvT:cAlias, ::oAlbPrvL:cAlias, ::oFacPrvT:cAlias, ::oFacPrvL:cAlias, ::nValDiv, ::nDecOut, ::nDerOut )
                  ::oDbf:nTotArt := ::oDbf:nExtArt * ::oDbf:nCosArt
                  ::oDbf:Save()

               end if


            end if

            ::oAlbCliL:Skip()

         end while

         end if

      end if

   ::oAlbCliT:Skip()

   ::oMtrInf:AutoInc()

   end while

   /*
    Recorremos facturas de clientes
   */

   ::oFacCliT:GoTop()
   ::oMtrInf:SetTotal( nLasFPr )
   ::oMtrInf:cText := "Procesando facturas clientes"

   while ! ::oFacCliT:Eof()

      if ::oFacCliT:dFecFac >= ::dIniInf                                                 .AND.;
         ::oFacCliT:dFecFac <= ::dFinInf                                                 .AND.;
         lChkSer( ::oFacCliT:cSerie, ::aSer )

         /*
         Nos posicionamos en las lineas de detalle de facturas de proveedores
         */

         if ::oFacCliL:Seek( ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac )

         while ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac == ::oFacCliL:cSerie + Str( ::oFacCliL:nNumFac ) + ::oFacCliL:cSufFac .AND. ! ::oFacCliL:Eof()

            if ::lValArt( ::oFacCliL:cRef, ::oFacCliL:cAlmLin, nTotNFacCli( ::oFacCliL ) )

                 if ::oDbf:Seek( ::oFacCliL:cRef )

                    ::oDbf:Load()
                    ::oDbf:nExtArt -= nTotNFacCli( ::oFacCliL )
                    ::oDbf:Save()

                 else

                    ::oDbf:Append()
                    ::oDbf:cCodArt := ::oFacCliL:cRef
                    ::oDbf:cNomArt := ::oFacCliL:cDetalle
                    ::oDbf:cCodAlm := ::oFacCliL:cAlmLin
                    ::oDbf:nExtArt := nTotNFacCli( ::oFacCliL )
                    ::oDbf:nCosArt := nPreMedCom( ::oDbfArt:Codigo, ::oDbfAlm:cCodAlm, ::oAlbPrvT:cAlias, ::oAlbPrvL:cAlias, ::oFacPrvT:cAlias, ::oFacPrvL:cAlias, ::nValDiv, ::nDecOut, ::nDerOut )
                    ::oDbf:nTotArt := ::oDbf:nExtArt * ::oDbf:nCosArt
                    ::oDbf:Save()

                 end if

            end if

            ::oFacCliL:Skip()

         end while

      end if

   end if

   ::oFacCliT:Skip()

   ::oMtrInf:AutoInc()

   end while

   /*
    Recorremos tikets
   */

   ::oTikCliT:GoTop()
   ::oMtrInf:SetTotal( nLasTik )
   ::oMtrInf:cText := "Procesando tikets"

   while ! ::oTikCliT:Eof()

      if ::oTikCliT:cTipTik == "1" .OR. ::oTikCliT:cTipTik == "4"                        .AND.;
         ::oTikCliT:dFecTik >= ::dIniInf                                                 .AND.;
         ::oTikCliT:dFecTik <= ::dFinInf                                                 .AND.;
         lChkSer( ::oTikCliT:cSerTik, ::aSer )

         /*
         Nos posicionamos en las lineas de detalle de tikets
         */

         if ::oTikCliL:Seek( ::oTikCliT:cSerTik + ::oTikCliT:cNumTik + ::oTikCliT:cSufTik )

            while ::oTikCliT:cSerTik + ::oTikCliT:cNumTik + ::oTikCliT:cSufTik == ::oTikCliL:cSerTil + ::oTikCliL:cNumTil + ::oTikCliL:cSufTil

               if !Empty( ::oTikCliL:cCbaTil )                      .AND.;
                  ::oTikCliL:cCbaTil >= ::cArtOrg                   .AND.;
                  ::oTikCliL:cCbaTil <= ::cArtDes                   .AND.;
                  ::oTikCliL:cAlmLin >= ::cAlmOrg                   .AND.;
                  ::oTikCliL:cAlmLin <= ::cAlmDes                   .AND.;
                  !( ::lExcCero .AND. ::oTikeL:nPvpTil == 0 )

                     if ::oDbf:Seek( ::oTikCliL:cCbaTil )

                        ::oDbf:Load()
                        ::oDbf:nExtArt -= ::oTikCliL:nUntTil
                        ::oDbf:Save()

                     else

                        ::oDbf:Append()
                        ::oDbf:cCodArt := ::oTikCliL:cCbaTil
                        ::oDbf:cNomArt := RetArticulo( ::oTikCliL:cCbaTil, ::oArt )
                        ::oDbf:cCodAlm := ::oTikCliL:cAlmLin
                        ::oDbf:nExtArt := ::oTikCliL:nUntTil
                        ::oDbf:nCosArt := nPreMedCom( ::oDbfArt:Codigo, ::oDbfAlm:cCodAlm, ::oAlbPrvT:cAlias, ::oAlbPrvL:cAlias, ::oFacPrvT:cAlias, ::oFacPrvL:cAlias, ::nValDiv, ::nDecOut, ::nDerOut )
                        ::oDbf:nTotArt := ::oDbf:nExtArt * ::oDbf:nCosArt
                        ::oDbf:Save()

                     end if

               end if

               if !Empty( ::oTikCliL:cComTil )                      .AND.;
                  ::oTikCliL:cComTil >= ::cArtOrg                   .AND.;
                  ::oTikCliL:cComTil <= ::cArtDes                   .AND.;
                  ::oTikCliL:cAlmLin >= ::cAlmOrg                   .AND.;
                  ::oTikCliL:cAlmLin <= ::cAlmDes                   .AND.;
                  !( ::lExcCero .AND. ::oTikeL:nPvpTil == 0 )

                     if ::oDbf:Seek( ::oTikCliL:cComTil )

                        ::oDbf:Load()
                        ::oDbf:nExtArt -= ::oTikeL:nUntTil
                        ::oDbf:Save()

                     else

                        ::oDbf:Append()
                        ::oDbf:cCodArt := ::oTikCliL:cComTil
                        ::oDbf:cNomArt := RetArticulo( ::oTikCliL:cComTil, ::oArt )
                        ::oDbf:cCodAlm := ::oTikCliL:cAlmLin
                        ::oDbf:nExtArt := ::oTikCliL:nUntTil
                        ::oDbf:nCosArt := ::nTotUTpv( ::oTikCliL:cAlias, ::nDecOut, ::nValDiv )
                        ::oDbf:nTotArt := ::oDbf:nExtArt * ::oDbf:nCosArt
                        ::oDbf:Save()

                     end if

               end if

               ::oTikCliL:Skip()

            end while

         end if

      end if

   ::oTikCliT:Skip()

   ::oMtrInf:AutoInc()

   end while

   ::oHisMov:GoTop()

   ::oMtrInf:SetTotal( ::oHisMov:Lastrec() )
   nEvery         := Int( ::oMtrInf:nTotal / 10 )

   WHILE !::oHisMov:Eof()

      if ::oHisMov:dFecMov >= ::dIniInf                              .AND.;
         ::oHisMov:dFecMov <= ::dFinInf

         /*
         Salidas____________________________________________________________
         */

         /*if ::lValArt( ::oHisMov:cRefMov, ::oHisMov:cAloMov, nTotNMovAlm( ::oHisMov ) )

            if ::oDbf:Seek( ::oHisMov:cRefMov )

               ::oDbf:Load()
               ::oDbf:nExtArt -= nTotNMovAlm( ::oHisMov )
               ::oDbf:Save()

            else

               ::oDbf:Append()
               ::oDbf:cCodArt := ::oHisMov:cRefMov
               ::oDbf:cNomArt := RetArticulo( ::oHisMov:cRefMov, ::oArt )
               ::oDbf:cCodAlm := ::oHisMov:cAloMov
               ::oDbf:nExtArt := nTotNMovAlm( ::oHisMov )
               ::oDbf:nCosArt := nPreMedCom( ::oDbfAlm:cCodAlm, ::oDbfArt:Codigo, ::oAlbPrvT:cAlias, ::oAlbPrvL:cAlias, ::oFacPrvT:cAlias, ::oFacPrvL:cAlias, ::nValDiv, ::nDecOut, ::nDerOut )
               ::oDbf:nTotArt := ::oDbf:nExtArt * ::oDbf:nCosArt
               ::oDbf:Save()

            end if

         end if*/

         /*
         Entradas___________________________________________________________
         */

         if ::lValArt( ::oHisMov:cRefMov, ::oHisMov:cAliMov, nTotNMovAlm( ::oHisMov ) )

            if ::oDbf:Seek( ::oHisMov:cRefMov )

               ::oDbf:Load()
               ::oDbf:nExtArt += nTotNMovAlm( ::oHisMov )
               ::oDbf:Save()

            else

               ::oDbf:Append()
               ::oDbf:cCodArt := ::oHisMov:cRefMov
               ::oDbf:cNomArt := RetArticulo( ::oHisMov:cRefMov, ::oArt )
               ::oDbf:cCodAlm := ::oHisMov:cAliMov
               ::oDbf:nExtArt := nTotNMovAlm( ::oHisMov )
               ::oDbf:nCosArt := nPreMedCom( ::oDbfArt:Codigo, ::oDbfAlm:cCodAlm, ::oAlbPrvT:cAlias, ::oAlbPrvL:cAlias, ::oFacPrvT:cAlias, ::oFacPrvL:cAlias, ::nValDiv, ::nDecOut, ::nDerOut )
               ::oDbf:nTotArt := ::oDbf:nExtArt * ::oDbf:nCosArt
               ::oDbf:Save()

            end if

         end if

      end if

      ::oHisMov:Skip()

      ::oMtrInf:AutoInc( ::oHisMov:OrdKeyNo() )

   end while

   ::oMtrInf:AutoInc( nLasTik )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//

METHOD lValArt( cCodArt, cCodAlm, nTotUnd )

   local lValArt  := cCodArt >= ::cArtOrg                   .and.;
                     cCodArt <= ::cArtDes                   .and.;
                     cCodAlm >= ::cAlmOrg                   .and.;
                     cCodAlm <= ::cAlmDes                   .and.;
                     !( ::lExcCero .and. nTotUnd == 0 )

RETURN ( lValArt )

//---------------------------------------------------------------------------//