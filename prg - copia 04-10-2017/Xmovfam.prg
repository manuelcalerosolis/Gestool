#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS XMovFam FROM XInfMov

   DATA  lExcCero    AS LOGIC    INIT .f.

   METHOD Create()

   METHOD lResource( cFld )

   METHOD lGenerate()

   METHOD nTotStock()

   METHOD lValArt( cCodFam, cCodAlm, nTotUnd )

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField( "cCodFam", "C", 16, 0, {|| "@!" },          "Cod. Fam.",     .f., "Código familia",            8, .f. )
   ::AddField( "cNomFam", "C", 50, 0, {|| "@!" },          "Fam.",          .f., "Nombre familia",           35, .f. )
   ::FldCreate ()

   ::AddTmpIndex( "cCodAlm", "cCodAlm + cCodFam + cValPr1 + cValPr2 + dtos( dFecMov ) + cTimMov" )

   ::AddGroup( {|| ::oDbf:cCodFam }, {|| "Familia : " + Rtrim( ::oDbf:cCodFam ) + "-" + Rtrim( oRetFld( ::oDbf:cCodFam, ::oDbfFam ) ) }, {|| "Total familia " + ::nTotStock() } )
   ::AddGroup( {|| ::oDbf:cCodAlm }, {|| "Almacén : " + Rtrim( ::oDbf:cCodAlm ) + "-" + Rtrim( oRetFld( ::oDbf:cCodAlm, ::oDbfAlm ) ) }, {|| "Total almacén..." } )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld )

   if !::StdResource( "INFMOVFAM" )
      return .f.
   end if

   ::oBtnFilter:Disable()

   REDEFINE CHECKBOX ::lDesPrp ;
      ID       180;
      OF       ::oFld:aDialogs[1]

   /*
   Monta los almacenes de manera automatica
   */

   if !::oDefAlmInf( 70, 80, 90, 100, 600 )
      return .f.
   end if

   /*
   Monta los articulos de manera automatica
   */

   if !::lDefFamInf( 110, 120, 130, 140, 800 )
      return .f.
   end if

   ::oDefExcInf()

   ::oDefResInf()

   ::bPreGenerate    := {|| ::NewGroup() }
   ::bPostGenerate   := {|| ::QuiGroup() }

RETURN .t.

//---------------------------------------------------------------------------//

METHOD lGenerate()

   local cRet
   local nEvery
   local cCodAlm
   local cCodFam

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   ::aHeader      := {  {|| "Fecha   : " + Dtoc( Date() ) },;
                        {|| "Periodo : " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                        {|| "Almacén : " + if( ::lAllAlm, "Todos", AllTrim( ::cAlmOrg ) + " > " + AllTrim( ::cAlmDes ) ) },;
                        {|| "Familia : " + if( ::lAllFam, "Todas", AllTrim( ::cFamOrg ) + " > " + AllTrim( ::cFamDes ) ) } }

   ::oAlbPrvT:GoTop()
   ::oAlbPrvL:GoTop()
   ::oFacPrvT:GoTop()
   ::oFacPrvL:GoTop()
   ::oAlbCliT:GoTop()
   ::oAlbCliL:GoTop()
   ::oFacCliT:GoTop()
   ::oFacCliL:GoTop()
   ::oFacRecT:GoTop()
   ::oFacRecL:GoTop()
   ::oTikCliT:GoTop()
   ::oTikCliL:GoTop()
   ::oProCab:GoTop()
   ::oProLin:GoTop()
   ::oProMat:GoTop()
   ::oHisMov:GoTop()

   /*
   Albaranes de Proveedores----------------------------------------------------
	*/

   ::oMtrInf:SetTotal( ::oAlbPrvT:Lastrec() )
   nEvery            := Int( ::oMtrInf:nTotal / 10 )
   ::oMtrInf:cText   := "Albaranes de proveedores"

   while !::lBreak .and. !::oAlbPrvT:Eof ()

      if ::oAlbPrvT:dFecAlb >= ::dIniInf                        .AND.;
         ::oAlbPrvT:dFecAlb <= ::dFinInf                        .AND.;
         !::oAlbPrvT:lFacturado                                 .AND.;
         lChkSer( ::oAlbPrvT:cSerAlb, ::aSer )

         if ::oAlbPrvL:Seek( ::oAlbPrvT:cSerAlb + Str( ::oAlbPrvT:nNumAlb ) + ::oAlbPrvT:cSufAlb )

         while ( ::oAlbPrvT:cSerAlb + Str( ::oAlbPrvT:nNumAlb ) + ::oAlbPrvT:cSufAlb ) == ( ::oAlbPrvL:cSerAlb + Str( ::oAlbPrvL:nNumAlb ) + ::oAlbPrvL:cSufAlb) .AND. ! ::oAlbPrvL:eof()

            if !Empty( ::oAlbPrvL:cAlmLin )                     .AND.;
               ( oRetFld( ::oAlbPrvL:cRef, ::oDbfArt, "nCtlStock" ) != 3 )       .AND.;
               ::lValArt( ::oAlbPrvL:cCodFam, ::oAlbPrvL:cAlmLin, nTotNAlbPrv( ::oAlbPrvL ) )

               ::AddAlbPrv()
               ::oDbf:Load()
               ::oDbf:cCodFam := ::oAlbPrvL:cCodFam
               ::oDbf:cNomFam := Rtrim( oRetFld( ::oAlbPrvL:cCodFam, ::oDbfFam ))
               ::oDbf:Save()

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

      if ::oFacPrvT:dFecFac >= ::dIniInf              .AND.;
         ::oFacPrvT:dFecFac <= ::dFinInf              .AND.;
         lChkSer( ::oFacPrvT:cSerFac, ::aSer )

         if ::oFacPrvL:Seek( ::oFacPrvT:cSerFac + Str( ::oFacPrvT:nNumFac ) + ::oFacPrvT:cSufFac )

         while ::oFacPrvT:cSerFac + Str( ::oFacPrvT:nNumFac ) + ::oFacPrvT:cSufFac == ::oFacPrvL:cSerFac + Str( ::oFacPrvL:nNumFac ) + ::oFacPrvL:cSufFac .AND. ! ::oFacPrvL:Eof()

            if !Empty( ::oFacPrvL:cAlmLin )     .AND.;
               ( oRetFld( ::oFacPrvL:cRef, ::oDbfArt, "nCtlStock" ) != 3 )       .AND.;
               ::lValArt( ::oFacPrvL:cCodFam, ::oFacPrvL:cAlmLin, nTotNFacPrv( ::oFacPrvL ) )

               ::AddFacPrv()
               ::oDbf:Load()
               ::oDbf:cCodFam := ::oFacPrvL:cCodFam
               ::oDbf:cNomFam := Rtrim( oRetFld( ::oFacPrvL:cCodFam, ::oDbfFam ))
               ::oDbf:Save()

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

      if ::oAlbCliT:dFecAlb >= ::dIniInf                                      .AND.;
         ::oAlbCliT:dFecAlb <= ::dFinInf                                      .AND.;
         !lFacturado( ::oAlbCliT )                                            .AND.;
         lChkSer( ::oAlbCliT:cSerAlb, ::aSer )

         if ::oAlbCliL:Seek( ::oAlbCliT:cSerAlb + Str( ::oAlbCliT:nNumAlb ) + ::oAlbCliT:cSufAlb )

         while ::oAlbCliT:cSerAlb + Str( ::oAlbCliT:nNumAlb ) + ::oAlbCliT:cSufAlb == ::oAlbCliL:cSerAlb + Str( ::oAlbCliL:nNumAlb ) + ::oAlbCliL:cSufAlb .AND. !::oAlbCliL:eof()

            if !Empty( ::oAlbCliL:cAlmLin )  .AND.;
               ( oRetFld( ::oAlbCliL:cRef, ::oDbfArt, "nCtlStock" ) != 3 )       .AND.;
               ::lValArt( ::oAlbCliL:cCodFam, ::oAlbCliL:cAlmLin, nTotNAlbCli( ::oAlbCliL ) )

               ::AddAlbCli()
               ::oDbf:Load()
               ::oDbf:cCodFam := ::oAlbCliL:cCodFam
               ::oDbf:cNomFam := Rtrim( oRetFld( ::oAlbCliL:cCodFam, ::oDbfFam ))
               ::oDbf:Save()

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

      if ::oFacCliT:dFecFac >= ::dIniInf           .AND.;
         ::oFacCliT:dFecFac <= ::dFinInf           .AND.;
         lChkSer( ::oFacCliT:cSerie, ::aSer )

         if ::oFacCliL:Seek( ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac )

         while ( ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac) == ( ::oFacCliL:cSerie + Str( ::oFacCliL:nNumFac ) + ::oFacCliL:cSufFac) .AND. !::oFacCliL:eof()

            if !Empty( ::oFacCliL:cAlmLin )     .AND.;
               ( oRetFld( ::oFacCliL:cRef, ::oDbfArt, "nCtlStock" ) != 3 )       .AND.;
               ::lValArt( ::oFacCliL:cCodFam, ::oFacCliL:cAlmLin, nTotNFacCli( ::oFacCliL ) )

               ::AddFacCli()
               ::oDbf:Load()
               ::oDbf:cCodFam := ::oFacCliL:cCodFam
               ::oDbf:cNomFam := Rtrim( oRetFld( ::oFacCliL:cCodFam, ::oDbfFam ))
               ::oDbf:Save()

            end if

            ::oFacCliL:Skip()

         end while

         end if

      end if

      ::oFacCliT:Skip()

      ::oMtrInf:AutoInc()

   end while

   /*
   Facturas rectificativas---------------------------------------------------------
   */

   ::oMtrInf:SetTotal( ::oFacRecT:Lastrec() )
   ::oMtrInf:cText   := "Fac. rec."
   nEvery            := Int( ::oMtrInf:nTotal / 10 )

   while !::lBreak .and. !::oFacRecT:Eof()

      if ::oFacRecT:dFecFac >= ::dIniInf              .AND.;
         ::oFacRecT:dFecFac <= ::dFinInf              .AND.;
         lChkSer( ::oFacRecT:cSerie, ::aSer )

         if ::oFacRecL:Seek( ::oFacRecT:cSerie + Str( ::oFacRecT:nNumFac ) + ::oFacRecT:cSufFac )

         while ( ::oFacRecT:cSerie + Str( ::oFacRecT:nNumFac ) + ::oFacRecT:cSufFac) == ( ::oFacRecL:cSerie + Str( ::oFacRecL:nNumFac ) + ::oFacRecL:cSufFac) .AND. !::oFacRecL:eof()

            if !Empty( ::oFacRecL:cAlmLin )     .AND.;
               ( oRetFld( ::oFacRecL:cRef, ::oDbfArt, "nCtlStock" ) != 3 )       .AND.;
               ::lValArt( ::oFacRecL:cCodFam, ::oFacRecL:cAlmLin, nTotNFacRec( ::oFacRecL ) )

               ::AddFacRec()
               ::oDbf:Load()
               ::oDbf:cCodFam := ::oFacRecL:cCodFam
               ::oDbf:cNomFam := Rtrim( oRetFld( ::oFacRecL:cCodFam, ::oDbfFam ))
               ::oDbf:Save()

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

      if !Empty( ::oTikCliT:cAlmTik )                                                             .AND.;
         ::oTikCliT:dFecTik >= ::dIniInf                                                          .AND.;
         ::oTikCliT:dFecTik <= ::dFinInf                                                          .AND.;
         ::lAllAlm .or. ( ::oTikCliT:cAlmTik >= ::cAlmOrg .AND. ::oTikCliT:cAlmTik <= ::cAlmDes ) .AND.;
         ::oTikCliL:Seek( ::oTikCliT:cSerTik +  ::oTikCliT:cNumTik + ::oTikCliT:cSufTik )

         while ::oTikCliT:cSerTik + ::oTikCliT:cNumTik + ::oTikCliT:cSufTik == ::oTikCliL:cSerTil + ::oTikCliL:cNumTil + ::oTikCliL:cSufTil .AND. ! ::oTikCliL:Eof();

            cRet  := RetCode( ::oTikCliL:cCbaTil, ::oDbfArt:cAlias )

            if !Empty( cRet )                                             .and.;
               ::oTikCliT:cTipTik $ "145"                                 .and.;
               ( oRetFld( cRet, ::oDbfArt, "nCtlStock" ) != 3 )           .AND.;
               ::lValArt( ::oTikCliL:cCodFam, ::oTikClit:cAlmTik, ::oTikCliL:nUntTil )

               ::AddTikCli( cRet )
               ::oDbf:Load()
               ::oDbf:cCodFam := ::oTikCliL:cCodFam
               ::oDbf:cNomFam := Rtrim( oRetFld( ::oTikCliL:cCodFam, ::oDbfFam ))
               ::oDbf:Save()

            end if

            if !Empty( ::oTikCliL:cComTil )

               cRet  := retCode( ::oTikCliL:cComTil, ::oDbfArt:cAlias )

               if !Empty( cRet )                                           .and.;
                  ::oTikCliT:cTipTik $ "145"                               .and.;
                  ( oRetFld( cRet, ::oDbfArt, "nCtlStock" ) != 3 )           .AND.;
                  ::lValArt( ::oTikCliL:cCodFam, ::oTikClit:cAlmTik, ::oTikCliL:nUntTil )

                  ::AddTikCli( cRet )
                  ::oDbf:Load()
                  ::oDbf:cCodFam := ::oTikCliL:cCodFam
                  ::oDbf:cNomFam := Rtrim( oRetFld( ::oTikCliL:cCodFam, ::oDbfFam ))
                  ::oDbf:Save()

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

      if ::oHisMov:dFecMov >= ::dIniInf      .and.;
         ::oHisMov:dFecMov <= ::dFinInf

         /*
         Salidas____________________________________________________________
         */

         cCodFam := cCodFam( ::oHisMov:cRefMov, ::oDbfArt )

         if !Empty( ::oHisMov:cAloMov )  .AND.;
            ( oRetFld( ::oHisMov:cRefMov, ::oDbfArt, "nCtlStock" ) != 3 )           .AND.;
            ::lValArt( cCodFam, ::oHisMov:cAloMov, nTotNMovAlm( ::oHisMov ) )

            ::AddSal()
            ::oDbf:Load()
            ::oDbf:cCodFam := cCodFam
            ::oDbf:cNomFam := Rtrim( oRetFld( ::oDbf:cCodFam, ::oDbfFam ))
            ::oDbf:Save()

         end if

         /*
         Entradas___________________________________________________________
         */

         cCodFam := cCodFam( ::oHisMov:cRefMov, ::oDbfArt )

         if !Empty( ::oHisMov:cAliMov )    .AND.;
            ( oRetFld( ::oHisMov:cRefMov, ::oDbfArt, "nCtlStock" ) != 3 )           .AND.;
            ::lValArt( cCodFam, ::oHisMov:cAliMov, nTotNMovAlm( ::oHisMov ) )

            ::AddEnt()
            ::oDbf:Load()
            ::oDbf:cCodFam := cCodFam
            ::oDbf:cNomFam := Rtrim( oRetFld( ::oDbf:cCodFam, ::oDbfFam ))
            ::oDbf:Save()

         end if

      end if

      ::oHisMov:Skip()

      ::oMtrInf:AutoInc()

   end while

   /*
   Partes de producción--------------------------------------------------------
   */

   ::oMtrInf:SetTotal( ::oProCab:Lastrec() )
   ::oMtrInf:cText   := "Partes de producción"
   nEvery            := Int( ::oMtrInf:nTotal / 10 )

   while !::lBreak .and. !::oProCab:Eof()

      if ::oProCab:dFecOrd >= ::dIniInf           .AND.;
         ::oProCab:dFecFin <= ::dFinInf           .AND.;
         lChkSer( ::oProCab:cSerOrd, ::aSer )

         if ::oProLin:Seek( ::oProCab:cSerOrd + Str( ::oProCab:nNumOrd ) + ::oProCab:cSufOrd )

            while ( ::oProCab:cSerOrd + Str( ::oProCab:nNumOrd ) + ::oProCab:cSufOrd ) == ( ::oProLin:cSerOrd + Str( ::oProLin:nNumOrd ) + ::oProLin:cSufOrd ) .AND. !::oProLin:eof()

               cCodFam           := oRetFld( ::oProLin:cCodArt, ::oDbfArt, "Familia" )

               if !Empty( ::oProLin:cAlmOrd )                                          .AND.;
                  ( oRetFld( ::oProLin:cCodArt, ::oDbfArt, "nCtlStock" ) != 3 )        .AND.;
                  ::lValArt( cCodFam, ::oProLin:cAlmOrd, nTotNProduccion( ::oProLin ) )

                  ::AddProLin()
                  ::oDbf:Load()
                  ::oDbf:cCodFam := cCodFam
                  ::oDbf:cNomFam := Rtrim( oRetFld( cCodFam, ::oDbfFam ))
                  ::oDbf:Save()

               end if

               ::oProLin:Skip()

            end while

         end if

         if ::oProMat:Seek( ::oProCab:cSerOrd + Str( ::oProCab:nNumOrd ) + ::oProCab:cSufOrd )

            while ( ::oProCab:cSerOrd + Str( ::oProCab:nNumOrd ) + ::oProCab:cSufOrd ) == ( ::oProMat:cSerOrd + Str( ::oProMat:nNumOrd ) + ::oProMat:cSufOrd ) .AND. !::oProMat:eof()

               cCodFam           := oRetFld( ::oProMat:cCodArt, ::oDbfArt, "Familia" )

               if !Empty( ::oProMat:cAlmOrd )                                          .AND.;
                  ( oRetFld( ::oProMat:cCodArt, ::oDbfArt, "nCtlStock" ) != 3 )        .AND.;
                  ::lValArt( cCodFam, ::oProMat:cAlmOrd, nTotNMaterial( ::oProMat ) )

                  ::AddProMat()
                  ::oDbf:Load()
                  ::oDbf:cCodFam := cCodFam
                  ::oDbf:cNomFam := Rtrim( oRetFld( cCodFam, ::oDbfFam ) )
                  ::oDbf:Save()

               end if

               ::oProMat:Skip()

            end while

         end if

      end if

      ::oProCab:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::CreaSaldo()

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//

METHOD nTotStock()

   local nTotStock   := 0
   local cCodAlm     := ::oReport:aGroups[ 1 ]:cValue
   local cCodFam     := ::oReport:aGroups[ 2 ]:cValue

   ::oDbf:GetStatus()

   if ::oDbf:Seek( cCodAlm + cCodFam )
      while ::oDbf:cCodAlm + ::oDbf:cCodFam == cCodAlm + cCodFam .and. !::oDbf:eof()

         nTotStock   += ::oDbf:nTotEnt

         ::oDbf:Skip()

      end while
   end if

   ::oDbf:SetStatus()

return ( Trans( nTotStock, MasUnd() ) )

//---------------------------------------------------------------------------//

METHOD lValArt( cCodFam, cCodAlm, nTotUnd )

   local lValArt  := ( ::lAllFam .or. ( cCodFam >= ::cFamOrg .and. cCodFam <= ::cFamDes ) ) .and.;
                     ( ::lAllAlm .or. ( cCodAlm >= ::cAlmOrg .and. cCodAlm <= ::cAlmDes ) ) .and.;
                     !( ::lExcCero .and. nTotUnd == 0 )

RETURN ( lValArt )

//---------------------------------------------------------------------------//