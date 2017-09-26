#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TInfDetMov FROM XInfDetMov

   METHOD Create()

   METHod lResource( cFld )

   METHOD lGenerate()

   METHOD lValArt( cCodArt, cCodAlm, nTotUnd )

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::FldCreate()

   ::AddTmpIndex( "cCodArt", "cCodArt + cValPr1 + cValPr2 + cCodAlm + dtos( dFecMov )" )

   ::AddGroup( {|| ::oDbf:cCodArt }, {|| "Artículo : " + Rtrim( ::oDbf:cCodArt ) + "-" + Rtrim( oRetFld( ::oDbf:cCodArt, ::oDbfArt ) ) }, {|| "Total artículo " + ::nTotStock() } )
   ::AddGroup( {|| ::oDbf:cCodAlm }, {|| "Almacen  : " + Rtrim( ::oDbf:cCodAlm ) + "-" + Rtrim( oRetFld( ::oDbf:cCodAlm, ::oDbfAlm ) ) }, {|| "Total almacen..." } )

   ::aHeader      := {  {|| "Fecha   : " + Dtoc( Date() ) },;
                        {|| "Periodo : " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                        {|| "Artículo: " + Rtrim( ::cArtOrg )+ " > " + Rtrim( ::cArtDes ) },;
                        {|| "Almacén : " + ::cAlmOrg         + " > " + ::cAlmDes } }

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

   ::bPreGenerate    := {|| ::NewGroup() }
   ::bPostGenerate   := {|| ::QuiGroup() }

RETURN .t.

//---------------------------------------------------------------------------//

METHOD lGenerate()

   local cRet
   local nEvery
   local cCodArt
   local cCodAlm

   ::oDlg:Disable()

   ::oDbf:Zap()

   /*
   Albaranes de Proveedores----------------------------------------------------
	*/

   if ::lAlbPrv

   ::oAlbPrvT:GoTop()

   ::oMtrInf:SetTotal( ::oAlbPrvT:Lastrec() )
   nEvery            := Int( ::oMtrInf:nTotal / 10 )
   ::oMtrInf:cText   := "Albaranes de proveedores"

   while ! ::oAlbPrvT:Eof ()

      if !::oAlbPrvT:lFacturado                                 .AND.;
         ::oAlbPrvT:dFecAlb >= ::dIniInf                        .AND.;
         ::oAlbPrvT:dFecAlb <= ::dFinInf                        .AND.;
         lChkSer( ::oAlbPrvT:cSerAlb, ::aSer )

         if ::oAlbPrvL:Seek( ::oAlbPrvT:cSerAlb + Str( ::oAlbPrvT:nNumAlb ) + ::oAlbPrvT:cSufAlb )

         while ( ::oAlbPrvT:cSerAlb + Str( ::oAlbPrvT:nNumAlb ) + ::oAlbPrvT:cSufAlb ) == ( ::oAlbPrvL:cSerAlb + Str( ::oAlbPrvL:nNumAlb ) + ::oAlbPrvL:cSufAlb) .AND. ! ::oAlbPrvL:eof()

            if ::lValArt( ::oAlbPrvL:cRef, ::oAlbPrvL:cAlmLin, nTotNAlbPrv( ::oAlbPrvL ) )

               ::AddAlbPrv()

            end if

            ::oAlbPrvL:Skip()

         end while

         end if

      end if

   ::oAlbPrvT:Skip()

   ::oMtrInf:AutoInc( ::oAlbPrvT:OrdKeyNo() )

   end while

   end if

   /*
   Factura de Proveedores------------------------------------------------------
   */

   if ::lFacPrv

   ::oFacPrvT:GoTop()

   ::oMtrInf:SetTotal( ::oFacPrvT:Lastrec() )
   ::oMtrInf:cText   := "Facturas de proveedores"
   nEvery            := Int( ::oMtrInf:nTotal / 10 )

   while ! ::oFacPrvT:Eof()

      if ::oFacPrvT:dFecFac >= ::dIniInf                                                 .AND.;
         ::oFacPrvT:dFecFac <= ::dFinInf                                                 .AND.;
         lChkSer( ::oFacPrvT:cSerFac, ::aSer )

         if ::oFacPrvL:Seek( ::oFacPrvT:cSerFac + Str( ::oFacPrvT:nNumFac ) + ::oFacPrvT:cSufFac )

         while ::oFacPrvT:cSerFac + Str( ::oFacPrvT:nNumFac ) + ::oFacPrvT:cSufFac == ::oFacPrvL:cSerFac + Str( ::oFacPrvL:nNumFac ) + ::oFacPrvL:cSufFac .AND. ! ::oFacPrvL:Eof()

            if ::lValArt( ::oFacPrvL:cRef, ::oFacPrvL:cAlmLin, nTotNFacPrv( ::oFacPrvL ) )

               ::AddFacPrv()

            end if

            ::oFacPrvL:Skip()

         end while

      end if

   end if

   ::oFacPrvT:Skip()

   ::oMtrInf:AutoInc( ::oFacPrvT:OrdKeyNo() )

   end while

   end if

   /*
   Albaranes de Clientes
   */

   if ::lAlbCli

   ::oAlbCliT:GoTop()

   ::oMtrInf:SetTotal( ::oAlbCliT:Lastrec() )
   ::oMtrInf:cText   := "Albaranes de clientes"
   nEvery            := Int( ::oMtrInf:nTotal / 10 )

   while ! ::oAlbCliT:Eof()

      if !lFacturado( ::oAlbCliT )                                            .AND.;
         ::oAlbCliT:dFecAlb >= ::dIniInf                                      .AND.;
         ::oAlbCliT:dFecAlb <= ::dFinInf                                      .AND.;
         lChkSer( ::oAlbCliT:cSerAlb, ::aSer )

         if ::oAlbCliL:Seek( ::oAlbCliT:cSerAlb + Str( ::oAlbCliT:nNumAlb ) + ::oAlbCliT:cSufAlb )

         while ::oAlbCliT:cSerAlb + Str( ::oAlbCliT:nNumAlb ) + ::oAlbCliT:cSufAlb == ::oAlbCliL:cSerAlb + Str( ::oAlbCliL:nNumAlb ) + ::oAlbCliL:cSufAlb .AND. !::oAlbCliL:eof()

            if ::lValArt( ::oAlbCliL:cRef, ::oAlbCliL:cAlmLin, nTotNAlbCli( ::oAlbCliL ) )

               ::AddAlbCli()

            end if

            ::oAlbCliL:Skip()

         end while

         end if

      end if

      ::oAlbCliT:Skip()

      ::oMtrInf:AutoInc()

   end while

   end if

   /*
   Factura de Clientes---------------------------------------------------------
   */

   if ::lFacCli

   ::oFacCliT:GoTop()

   ::oMtrInf:SetTotal( ::oFacCliT:Lastrec() )
   ::oMtrInf:cText   := "Facturas de clientes"
   nEvery            := Int( ::oMtrInf:nTotal / 10 )

   while ! ::oFacCliT:Eof()

      if ::oFacCliT:dFecFac >= ::dIniInf                                                 .AND.;
         ::oFacCliT:dFecFac <= ::dFinInf                                                 .AND.;
         lChkSer( ::oFacCliT:cSerie, ::aSer )

         /*
         Lineas de detalle
         */

         if ::oFacCliL:Seek( ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac )

         while ( ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac) == ( ::oFacCliL:cSerie + Str( ::oFacCliL:nNumFac ) + ::oFacCliL:cSufFac) .AND. !::oFacCliL:eof()

            if ::lValArt( ::oFacCliL:cRef, ::oFacCliL:cAlmLin, nTotNFacCli( ::oFacCliL ) )

               ::AddFacCli()

            end if

            ::oFacCliL:Skip()

         end while

         end if

      end if

      ::oFacCliT:Skip()

      ::oMtrInf:AutoInc()

   end while

   end if

   /*
   Tickets --------------------------------------------------------------------
   */

   if ::lTikCli

   ::oTikCliT:GoTop()

   ::oMtrInf:SetTotal( ::oTikCliT:Lastrec() )
   ::oMtrInf:cText   := "Tickets de clientes"
   nEvery            := Int( ::oMtrInf:nTotal / 10 )

   while ! ::oTikCliT:Eof()

      if ::oTikCliT:dFecTik >= ::dIniInf                                                    .AND.;
         ::oTikCliT:dFecTik <= ::dFinInf                                                    .AND.;
         ::oTikCliT:cAlmTik >= ::cAlmOrg                                                    .AND.;
         ::oTikCliT:cAlmTik <= ::cAlmDes                                                    .AND.;
         ::oTikCliT:Seek( ::oTikClit:cSerTik +  ::oTikClit:cNumTik + ::oTikClit:cSufTik )

         while ::oTikClit:cSerTik + ::oTikClit:cNumTik + ::oTikClit:cSufTik == ::oTikCliL:cSerTil + ::oTikCliL:cNumTil + ::oTikCliL:cSufTil .AND. ! ::oTikCliL:Eof();

            cRet  := RetCode( ::oTikCliL:cCbaTil, ::oArt:cAlias )

            if !Empty( cRet )                                             .and.;
               ::oTikCliT:cTipTik $ "145"                                 .and.;
               ::lValArt( cRet, ::oTikClit:cAlmTik, ::oTikCliL:nUntTil )

               ::AddTikCli( cRet )

            end if

            if !Empty( ::oTikCliL:cComTil )

               cRet  := retCode( ::oTikCliL:cComTil, ::oArt:cAlias )

               if !Empty( cRet )                                           .and.;
                  ::oTikCliT:cTipTik $ "145"                               .and.;
                  ::lValArt( cRet, ::oTikClit:cAlmTik, ::oTikCliL:nUntTil )

                  ::AddTikCli( cRet )

               end if

            end if

            ::oTikCliL:Skip()

         end while

      end if

      ::oTikClit:Skip()

      ::oMtrInf:AutoInc()

   end while

   end if

   /*
   Histórico de movimientos-------------------------------------------------
   */

   if ::lMovAlm

   ::oHisMov:GoTop()

   ::oMtrInf:SetTotal( ::oHisMov:Lastrec() )
   ::oMtrInf:cText   := "Movimientos de almacen"
   nEvery            := Int( ::oMtrInf:nTotal / 10 )

   while !::oHisMov:Eof()

      if ::oHisMov:dFecMov >= ::dIniInf                              .AND.;
         ::oHisMov:dFecMov <= ::dFinInf

         /*
         Salidas____________________________________________________________
         */

         if ::lValArt( ::oHisMov:cRefMov, ::oHisMov:cAloMov, nTotNMovAlm( ::oHisMov ) )

            ::AddSal()

         end if

         /*
         Entradas___________________________________________________________
         */

         if ::lValArt( ::oHisMov:cRefMov, ::oHisMov:cAliMov, nTotNMovAlm( ::oHisMov ) )

            ::AddEnt()

         end if

      end if

      ::oHisMov:Skip()

      ::oMtrInf:AutoInc( ::oHisMov:OrdKeyNo() )

   end while

   end if

   ::CreaSaldo()

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