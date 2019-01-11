#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS XMovArt FROM XInfMov

   DATA  lExcCero    AS LOGIC    INIT .f.

   METHOD Create()

   METHOD lResource( cFld )

   METHOD lGenerate()

   METHOD nTotStock()

   METHOD lValArt( cCodArt, cCodAlm, nTotUnd )

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::FldCreate()

   ::AddTmpIndex( "cCodArt", "cCodArt + cCodAlm + cValPr1 + cValPr2 + dtos( dFecMov ) + cTimMov" )

   ::AddGroup( {|| ::oDbf:cCodArt }, {|| "Artículo : " + Rtrim( ::oDbf:cCodArt ) + "-" + Rtrim( oRetFld( ::oDbf:cCodArt, ::oDbfArt ) ) }, {|| "Total artículo " + ::nTotStock( ::oDbf:cCodArt ) } )
   ::AddGroup( {|| ::oDbf:cCodArt + ::oDbf:cCodAlm }, {|| "Almacén  : " + Rtrim( ::oDbf:cCodAlm ) + "-" + Rtrim( oRetFld( ::oDbf:cCodAlm, ::oDbfAlm ) ) }, {|| "Total almacén..." } )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld )

   if !::StdResource( "INF_GEN06" )
      return .f.
   end if

   ::oBtnFilter:Disable()

   if !::oDefAlmInf( 70, 80, 90, 100, 600 )
      return .f.
   end if

   if !::lDefArtInf( 110, 120, 130, 140, 800 )
      return .f.
   end if

   REDEFINE CHECKBOX ::lDesPrp ;
      ID       180;
      OF       ::oFld:aDialogs[1]

   ::oDefExcInf()

   ::oDefResInf()

   ::bPreGenerate    := {|| ::NewGroup() }
   ::bPostGenerate   := {|| ::QuiGroup() }

RETURN .t.

//---------------------------------------------------------------------------//

METHOD lGenerate()

   local cRet
   local nEvery

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   ::aHeader      := {  {|| "Fecha     : " + Dtoc( Date() ) },;
                        {|| "Periodo   : " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                        {|| "Artículos : " + if( ::lAllArt, "Todos", AllTrim( ::cArtOrg ) + " > " + AllTrim( ::cArtDes ) ) },;
                        {|| "Almacén   : " + if( ::lAllAlm, "Todos", AllTrim( ::cAlmOrg ) + " > " + AllTrim( ::cAlmDes ) ) } }

   ::oAlbPrvT:GoTop()
   ::oFacPrvT:GoTop()
   ::oAlbCliT:GoTop()
   ::oFacCliT:GoTop()
   ::oFacRecT:GoTop()
   ::oTikCliT:GoTop()
   ::oHisMov:GoTop()

   /*
   Albaranes de Proveedores----------------------------------------------------
	*/

   ::oMtrInf:SetTotal( ::oAlbPrvT:Lastrec() )
   nEvery            := Int( ::oMtrInf:nTotal / 10 )
   ::oMtrInf:cText   := "Albaranes de proveedores"

   while !::lBreak .and. !::oAlbPrvT:Eof()

      if !::oAlbPrvT:lFacturado                                .and.;
         ::oAlbPrvT:dFecAlb >= ::dIniInf                       .and.;
         ::oAlbPrvT:dFecAlb <= ::dFinInf                       .and.;
         lChkSer( ::oAlbPrvT:cSerAlb, ::aSer )

         if ::oAlbPrvL:Seek( ::oAlbPrvT:cSerAlb + Str( ::oAlbPrvT:nNumAlb ) + ::oAlbPrvT:cSufAlb )

         while ::oAlbPrvT:cSerAlb + Str( ::oAlbPrvT:nNumAlb ) + ::oAlbPrvT:cSufAlb == ::oAlbPrvL:cSerAlb + Str( ::oAlbPrvL:nNumAlb ) + ::oAlbPrvL:cSufAlb .AND. ! ::oAlbPrvL:eof()

            if !Empty( ::oAlbPrvL:cAlmLin )                     .AND.;
               ::lValArt( ::oAlbPrvL:cRef, ::oAlbPrvL:cAlmLin, nTotNAlbPrv( ::oAlbPrvL ) )
               ::AddAlbPrv()
            end if

            ::oAlbPrvL:Skip()

         end while

         end if

      end if

      ::oAlbPrvT:Skip()

      ::oMtrInf:AutoInc()

   end while

   /*
   Factura de Proveedores------------------------------------------------------
   */

   ::oMtrInf:SetTotal( ::oFacPrvT:Lastrec() )
   ::oMtrInf:cText   := "Facturas de proveedores"
   nEvery            := Int( ::oMtrInf:nTotal / 10 )

   while !::lBreak .and. !::oFacPrvT:Eof()

      if ::oFacPrvT:dFecFac >= ::dIniInf           .and.;
         ::oFacPrvT:dFecFac <= ::dFinInf           .and.;
         lChkSer( ::oFacPrvT:cSerFac, ::aSer )

         if ::oFacPrvL:Seek( ::oFacPrvT:cSerFac + Str( ::oFacPrvT:nNumFac ) + ::oFacPrvT:cSufFac )

            while ::oFacPrvT:cSerFac + Str( ::oFacPrvT:nNumFac ) + ::oFacPrvT:cSufFac == ::oFacPrvL:cSerFac + Str( ::oFacPrvL:nNumFac ) + ::oFacPrvL:cSufFac .AND. !::oFacPrvL:Eof()

               if !Empty( ::oFacPrvL:cAlmLin )              .AND.;
                  ::lValArt( ::oFacPrvL:cRef, ::oFacPrvL:cAlmLin, nTotNFacPrv( ::oFacPrvL ) )
                  ::AddFacPrv()
               end if

               ::oFacPrvL:Skip()

            end while

         end if

      end if

      ::oFacPrvT:Skip()

      ::oMtrInf:AutoInc()

   end while

   /*
   Albaranes de Clientes
   */

   ::oMtrInf:SetTotal( ::oAlbCliT:Lastrec() )
   ::oMtrInf:cText   := "Albaranes de clientes"
   nEvery            := Int( ::oMtrInf:nTotal / 10 )

   while !::lBreak .and. !::oAlbCliT:Eof()

      if !lFacturado( ::oAlbCliT )           .AND.;
         ::oAlbCliT:dFecAlb >= ::dIniInf     .AND.;
         ::oAlbCliT:dFecAlb <= ::dFinInf     .AND.;
         lChkSer( ::oAlbCliT:cSerAlb, ::aSer )

         if ::oAlbCliL:Seek( ::oAlbCliT:cSerAlb + Str( ::oAlbCliT:nNumAlb ) + ::oAlbCliT:cSufAlb )

            while ::oAlbCliT:cSerAlb + Str( ::oAlbCliT:nNumAlb ) + ::oAlbCliT:cSufAlb == ::oAlbCliL:cSerAlb + Str( ::oAlbCliL:nNumAlb ) + ::oAlbCliL:cSufAlb .AND. !::oAlbCliL:eof()

               if !Empty( ::oAlbCliL:cAlmLin )             .AND.;
                  ::lValArt( ::oAlbCliL:cRef, ::oAlbCliL:cAlmLin, nTotNAlbCli( ::oAlbCliL ) )
                  ::AddAlbCli()
               end if

               ::oAlbCliL:Skip()

            end while

         end if

      end if

      ::oAlbCliT:Skip()

      ::oMtrInf:AutoInc()

   end while

   /*
   Factura de Clientes---------------------------------------------------------
   */

   ::oMtrInf:SetTotal( ::oFacCliT:Lastrec() )
   ::oMtrInf:cText   := "Facturas de clientes"
   nEvery            := Int( ::oMtrInf:nTotal / 10 )

   while !::lBreak .and. !::oFacCliT:Eof()

      if ::oFacCliT:dFecFac >= ::dIniInf     .AND.;
         ::oFacCliT:dFecFac <= ::dFinInf     .AND.;
         lChkSer( ::oFacCliT:cSerie, ::aSer )

         /*
         Lineas de detalle
         */

         if ::oFacCliL:Seek( ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac )

            while ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac == ::oFacCliL:cSerie + Str( ::oFacCliL:nNumFac ) + ::oFacCliL:cSufFac .AND. !::oFacCliL:eof()

               if !Empty( ::oFacCliL:cAlmLin )             .AND.;
                  ::lValArt( ::oFacCliL:cRef, ::oFacCliL:cAlmLin, nTotNFacCli( ::oFacCliL ) )
                  ::AddFacCli()
               end if

               ::oFacCliL:Skip()

            end while

         end if

      end if

      ::oFacCliT:Skip()

      ::oMtrInf:AutoInc()

   end while

   /*
   Factura rectificativa-------------------------------------------------------
   */

   ::oMtrInf:SetTotal( ::oFacPrvT:Lastrec() )
   ::oMtrInf:cText   := "Fac. rec."
   nEvery            := Int( ::oMtrInf:nTotal / 10 )

   while !::lBreak .and. !::oFacRecT:Eof()

      if ::oFacRecT:dFecFac >= ::dIniInf           .AND.;
         ::oFacRecT:dFecFac <= ::dFinInf           .AND.;
         lChkSer( ::oFacRecT:cSerie, ::aSer )

         /*
         Lineas de detalle
         */

         if ::oFacRecL:Seek( ::oFacRecT:cSerie + Str( ::oFacRecT:nNumFac ) + ::oFacRecT:cSufFac )

            while ::oFacRecT:cSerie + Str( ::oFacRecT:nNumFac ) + ::oFacRecT:cSufFac == ::oFacRecL:cSerie + Str( ::oFacRecL:nNumFac ) + ::oFacRecL:cSufFac .AND. !::oFacRecL:eof()

               if !Empty( ::oFacRecL:cAlmLin )             .AND.;
                  ::lValArt( ::oFacRecL:cRef, ::oFacRecL:cAlmLin, nTotNFacRec( ::oFacRecL ) )
                  ::AddFacRec()
               end if

               ::oFacRecL:Skip()

            end while

         end if

      end if

      ::oFacRecT:Skip()

      ::oMtrInf:AutoInc()

   end while

   /*
   Tickets --------------------------------------------------------------------
   */

   ::oMtrInf:SetTotal( ::oTikCliT:Lastrec() )
   ::oMtrInf:cText   := "Tickets de clientes"
   nEvery            := Int( ::oMtrInf:nTotal / 10 )

   while !::lBreak .and. !::oTikCliT:Eof()

      if ::oTikCliT:cTipTik $ "145"                                 .and.;
         ::oTikCliT:dFecTik >= ::dIniInf                            .and.;
         ::oTikCliT:dFecTik <= ::dFinInf                            .and.;
         ::oTikCliL:Seek( ::oTikCliT:cSerTik + ::oTikCliT:cNumTik + ::oTikCliT:cSufTik )

         while ::oTikCliT:cSerTik + ::oTikCliT:cNumTik + ::oTikCliT:cSufTik == ::oTikCliL:cSerTil + ::oTikCliL:cNumTil + ::oTikCliL:cSufTil .AND. !::oTikCliL:Eof()

            cRet  := RetCode( ::oTikCliL:cCbaTil, ::oDbfArt:cAlias )

            if !Empty( ::oTikCliT:cAlmTik )         .AND.;
               !Empty( cRet ) .and. ::lValArt( cRet, ::oTikCliT:cAlmTik, ::oTikCliL:nUntTil )
               ::AddTikCli( cRet )
            end if

            if !Empty( ::oTikCliL:cComTil )

               cRet  := retCode( ::oTikCliL:cComTil, ::oDbfArt:cAlias )

               if !Empty( ::oTikCliT:cAlmTik )         .AND.;
                  !Empty( cRet ) .and. ::lValArt( cRet, ::oTikCliT:cAlmTik, ::oTikCliL:nUntTil )
                  ::AddTikCli( cRet )
               end if

            end if

            ::oTikCliL:Skip()

         end while

      end if

      ::oTikCliT:Skip()

      ::oMtrInf:AutoInc()

   end while

   /*
   Histórico de movimientos-------------------------------------------------
   */

   ::oMtrInf:SetTotal( ::oHisMov:Lastrec() )
   ::oMtrInf:cText   := "Movimientos de almacén"
   nEvery            := Int( ::oMtrInf:nTotal / 10 )

   while !::lBreak .and. !::oHisMov:Eof()

      if ::oHisMov:dFecMov >= ::dIniInf   .AND.;
         ::oHisMov:dFecMov <= ::dFinInf

         /*
         Salidas____________________________________________________________
         */

         if !Empty( ::oHisMov:cAloMov )   .AND.;
            ::lValArt( ::oHisMov:cRefMov, ::oHisMov:cAloMov, nTotNMovAlm( ::oHisMov ) )
            ::AddSal()
         end if

         /*
         Entradas___________________________________________________________
         */

         if !Empty( ::oHisMov:cAliMov )   .AND.;
            ::lValArt( ::oHisMov:cRefMov, ::oHisMov:cAliMov, nTotNMovAlm( ::oHisMov ) )
            ::AddEnt()
         end if

      end if

      ::oHisMov:Skip()

      ::oMtrInf:AutoInc()

   end while

   /*
   Partes de produccion--------------------------------------------------------
   */

   ::oMtrInf:SetTotal( ::oProCab:Lastrec() )
   ::oMtrInf:cText   := "Partes de producción"
   nEvery            := Int( ::oMtrInf:nTotal / 10 )

   ::oProCab:GoTop()
   ::oProLin:GoTop()
   ::oProMat:GoTop()

   while !::lBreak .and. !::oProCab:Eof()

      if ::oProCab:dFecOrd >= ::dIniInf     .AND.;
         ::oProCab:dFecFin <= ::dFinInf     .AND.;
         lChkSer( ::oProCab:cSerOrd, ::aSer )

         if ::oProLin:Seek( ::oProCab:cSerOrd + Str( ::oProCab:nNumOrd ) + ::oProCab:cSufOrd )

            while ::oProCab:cSerOrd + Str( ::oProCab:nNumOrd ) + ::oProCab:cSufOrd == ::oProLin:cSerOrd + Str( ::oProLin:nNumOrd ) + ::oProLin:cSufOrd .AND. !::oProLin:eof()

               if !Empty( ::oProLin:cAlmOrd )             .AND.;
                  ::lValArt( ::oProLin:cCodArt, ::oProLin:cAlmOrd, nTotNProduccion( ::oProLin ) )
                  ::AddProLin()
               end if

               ::oProLin:Skip()

            end while

         end if

         if ::oProMat:Seek( ::oProCab:cSerOrd + Str( ::oProCab:nNumOrd ) + ::oProCab:cSufOrd )

            while ::oProCab:cSerOrd + Str( ::oProCab:nNumOrd ) + ::oProCab:cSufOrd == ::oProMat:cSerOrd + Str( ::oProMat:nNumOrd ) + ::oProMat:cSufOrd .AND. !::oProMat:eof()

               if !Empty( ::oProMat:cAlmOrd )             .AND.;
                  ::lValArt( ::oProMat:cCodArt, ::oProMat:cAlmOrd, nTotNMaterial( ::oProMat ) )
                  ::AddProMat()
               end if

               ::oProMat:Skip()

            end while

         end if

      end if

      ::oProCab:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oMtrInf:Set( ::oProCab:LastRec() )

   ::CreaSaldo()

   ::oDlg:Enable()

   ::oBtnFilter:Disable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//

METHOD nTotStock( cCodArt )

   local nTotStock   := 0

   ::oDbf:GetStatus()

   if ::oDbf:Seek( cCodArt )
      while ::oDbf:cCodArt == cCodArt .and. !::oDbf:eof()

         nTotStock   += ::oDbf:nTotEnt

         ::oDbf:Skip()

      end while
   end if

   ::oDbf:SetStatus()

return ( Trans( nTotStock, MasUnd() ) )

//---------------------------------------------------------------------------//

METHOD lValArt( cCodArt, cCodAlm, nTotUnd )

   local lValArt  := ( ::lAllArt .or. ( cCodArt >= ::cArtOrg .and. cCodArt <= ::cArtDes ) ) .and.;
                     ( ::lAllAlm .or. ( cCodAlm >= ::cAlmOrg .and. cCodAlm <= ::cAlmDes ) ) .and.;
                     ( oRetFld( cCodArt, ::oDbfArt, "nCtlStock" ) != 3 )                    .and.;
                     !( ::lExcCero .and. nTotUnd == 0 )

RETURN ( lValArt )

//---------------------------------------------------------------------------//