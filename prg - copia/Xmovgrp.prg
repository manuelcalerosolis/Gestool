#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS XMovGrp FROM XInfMov

   DATA  lExcCero    AS LOGIC    INIT .f.

   METHOD Create()

   METHOD lResource( cFld )

   METHOD lGenerate()

   METHOD lValArt( cCodGrp, cCodAlm, nTotUnd )

   METHOD nTotStock()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField( "cCodGrp", "C",  3, 0, {|| "@!" }, "Grp.",      .f., "Código grupo",      3, .f. )
   ::AddField( "cNomGrp", "C", 50, 0, {|| "@!" }, "Grp. Fam.", .f., "Grupo de familia", 35, .f. )
   ::FldCreate()

   ::AddTmpIndex( "cCodAlm", "cCodAlm + cCodGrp + dtos( dFecMov ) + cTimMov" )

   ::AddGroup( {|| ::oDbf:cCodAlm }, {|| "Almacen  : " + Rtrim( ::oDbf:cCodAlm ) + "-" + Rtrim( oRetFld( ::oDbf:cCodAlm, ::oDbfAlm ) ) }, {|| "Total almacen..." } )
   ::AddGroup( {|| ::oDbf:cCodGrp }, {|| "Grp. Fam.: " + Rtrim( ::oDbf:cCodGrp ) + "-" + Rtrim( oRetFld( ::oDbf:cCodGrp, ::oGruFam:oDbf ) ) }, {|| "Total grupo " + ::nTotStock() } )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld )

   if !::StdResource( "INF_GEN08B" )
      return .f.
   end if

   ::oBtnFilter:Disable()

   REDEFINE CHECKBOX ::lDesPrp ;
      ID       180;
      OF       ::oFld:aDialogs[1]

   /*
   Monta los almacenes de manera automatica
   */

   if !::oDefAlmInf( 70, 80, 90, 100, 700 )
      return .f.
   end if

   /*
   Monta los articulos de manera automatica
   */

   if !::oDefGrFInf( 110, 120, 130, 140, 800 )
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
   local cCodGrp

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   ::aHeader      := {  {|| "Fecha    : " + Dtoc( Date() ) },;
                        {|| "Periodo  : " + Dtoc( ::dIniInf )     + " > " + Dtoc( ::dFinInf ) },;
                        {|| "Almacén  : " + ::cAlmOrg             + " > " + ::cAlmDes },;
                        {|| "Grp. Fam.: " + Rtrim( ::cGruFamOrg ) + " > " + Rtrim( ::cGruFamDes ) } }

   /*
   Albaranes de Proveedores----------------------------------------------------
	*/

   ::oMtrInf:SetTotal( ::oAlbPrvT:Lastrec() )
   nEvery            := Int( ::oMtrInf:nTotal / 10 )
   ::oMtrInf:cText   := "Albaranes de proveedores"

   ::oAlbPrvT:GoTop()

   while !::lBreak .and. !::oAlbPrvT:Eof ()

      if !::oAlbPrvT:lFacturado                                .AND.;
         ::oAlbPrvT:dFecAlb >= ::dIniInf                       .AND.;
         ::oAlbPrvT:dFecAlb <= ::dFinInf                       .AND.;
         lChkSer( ::oAlbPrvT:cSerAlb, ::aSer )

         if ::oAlbPrvL:Seek( ::oAlbPrvT:cSerAlb + Str( ::oAlbPrvT:nNumAlb ) + ::oAlbPrvT:cSufAlb )

         while ( ::oAlbPrvT:cSerAlb + Str( ::oAlbPrvT:nNumAlb ) + ::oAlbPrvT:cSufAlb ) == ( ::oAlbPrvL:cSerAlb + Str( ::oAlbPrvL:nNumAlb ) + ::oAlbPrvL:cSufAlb) .AND. ! ::oAlbPrvL:eof()

            cCodGrp := cCodGruFam( ::oAlbPrvL:cRef, ::oDbfArt, ::oDbfFam )

            if !Empty( ::oAlbPrvL:cAlmLin )                       .AND.;
               ( oRetFld( ::oAlbPrvL:cRef, ::oDbfArt, "nCtlStock" ) != 3 )           .AND.;
               ::lValArt( cCodGrp, ::oAlbPrvL:cAlmLin, nTotNAlbPrv( ::oAlbPrvL ) )

               ::AddAlbPrv()
               ::oDbf:Load()
               ::oDbf:cCodGrp := cCodGrp
               ::oDbf:cNomGrp := Rtrim( oRetFld( ::oDbf:cCodGrp, ::oGruFam:oDbf ) )
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

   ::oFacPrvT:GoTop()

   while !::lBreak .and. !::oFacPrvT:Eof()

      if ::oFacPrvT:dFecFac >= ::dIniInf           .AND.;
         ::oFacPrvT:dFecFac <= ::dFinInf           .AND.;
         lChkSer( ::oFacPrvT:cSerFac, ::aSer )

         if ::oFacPrvL:Seek( ::oFacPrvT:cSerFac + Str( ::oFacPrvT:nNumFac ) + ::oFacPrvT:cSufFac )

         while ::oFacPrvT:cSerFac + Str( ::oFacPrvT:nNumFac ) + ::oFacPrvT:cSufFac == ::oFacPrvL:cSerFac + Str( ::oFacPrvL:nNumFac ) + ::oFacPrvL:cSufFac .AND. ! ::oFacPrvL:Eof()

            cCodGrp := cCodGruFam( ::oFacPrvL:cRef, ::oDbfArt, ::oDbfFam )

            if !Empty( ::oFacPrvL:cAlmLin )                       .AND.;
               ( oRetFld( ::oFacPrvL:cRef, ::oDbfArt, "nCtlStock" ) != 3 )           .AND.;
               ::lValArt( cCodGrp, ::oFacPrvL:cAlmLin, nTotNFacPrv( ::oFacPrvL ) )

               ::AddFacPrv()
               ::oDbf:Load()
               ::oDbf:cCodGrp := cCodGrp
               ::oDbf:cNomGrp := Rtrim( oRetFld( ::oDbf:cCodGrp, ::oGruFam:oDbf ) )
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

   ::oAlbCliT:GoTop()

   while !::lBreak .and. !::oAlbCliT:Eof()

      if !lFacturado( ::oAlbCliT )                                            .AND.;
         ::oAlbCliT:dFecAlb >= ::dIniInf                                      .AND.;
         ::oAlbCliT:dFecAlb <= ::dFinInf                                      .AND.;
         lChkSer( ::oAlbCliT:cSerAlb, ::aSer )

         if ::oAlbCliL:Seek( ::oAlbCliT:cSerAlb + Str( ::oAlbCliT:nNumAlb ) + ::oAlbCliT:cSufAlb )

         while ::oAlbCliT:cSerAlb + Str( ::oAlbCliT:nNumAlb ) + ::oAlbCliT:cSufAlb == ::oAlbCliL:cSerAlb + Str( ::oAlbCliL:nNumAlb ) + ::oAlbCliL:cSufAlb .AND. !::oAlbCliL:eof()

            cCodGrp := cCodGruFam( ::oAlbCliL:cRef, ::oDbfArt, ::oDbfFam )

            if !Empty( ::oAlbCliL:cAlmLin )                                    .AND.;
               ( oRetFld( ::oAlbCliL:cRef, ::oDbfArt, "nCtlStock" ) != 3 )           .AND.;
               ::lValArt( cCodGrp, ::oAlbCliL:cAlmLin, nTotNAlbCli( ::oAlbCliL ) )

               ::AddAlbCli()
               ::oDbf:Load()
               ::oDbf:cCodGrp := cCodGrp
               ::oDbf:cNomGrp := Rtrim( oRetFld( ::oDbf:cCodGrp, ::oGruFam:oDbf ) )
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

   ::oFacCliT:GoTop()

   while !::lBreak .and. !::oFacCliT:Eof()

      if ::oFacCliT:dFecFac >= ::dIniInf                          .AND.;
         ::oFacCliT:dFecFac <= ::dFinInf                          .AND.;
         lChkSer( ::oFacCliT:cSerie, ::aSer )

         /*
         Lineas de detalle
         */

         if ::oFacCliL:Seek( ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac )

         while ( ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac) == ( ::oFacCliL:cSerie + Str( ::oFacCliL:nNumFac ) + ::oFacCliL:cSufFac) .AND. !::oFacCliL:eof()

            cCodGrp := cCodGruFam( ::oFacCliL:cRef, ::oDbfArt, ::oDbfFam )

            if !Empty( ::oFacCliL:cAlmLin )                         .AND.;
               ( oRetFld( ::oFacCliL:cRef, ::oDbfArt, "nCtlStock" ) != 3 )           .AND.;
               ::lValArt( cCodGrp, ::oFacCliL:cAlmLin, nTotNFacCli( ::oFacCliL ) )

               ::AddFacCli()
               ::oDbf:Load()
               ::oDbf:cCodGrp := cCodGrp
               ::oDbf:cNomGrp := Rtrim( oRetFld( ::oDbf:cCodGrp, ::oGruFam:oDbf ) )
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
   Factura rectificativa-------------------------------------------------------
   */

   ::oMtrInf:SetTotal( ::oFacRecT:Lastrec() )
   ::oMtrInf:cText   := "Fac. rec."
   nEvery            := Int( ::oMtrInf:nTotal / 10 )

   ::oFacRecT:GoTop()

   while !::lBreak .and. !::oFacRecT:Eof()

      if ::oFacRecT:dFecFac >= ::dIniInf              .AND.;
         ::oFacRecT:dFecFac <= ::dFinInf              .AND.;
         lChkSer( ::oFacRecT:cSerie, ::aSer )

         /*
         Lineas de detalle
         */

         if ::oFacRecL:Seek( ::oFacRecT:cSerie + Str( ::oFacRecT:nNumFac ) + ::oFacRecT:cSufFac )

         while ( ::oFacRecT:cSerie + Str( ::oFacRecT:nNumFac ) + ::oFacRecT:cSufFac) == ( ::oFacRecL:cSerie + Str( ::oFacRecL:nNumFac ) + ::oFacRecL:cSufFac) .AND. !::oFacRecL:eof()

            cCodGrp := cCodGruFam( ::oFacRecL:cRef, ::oDbfArt, ::oDbfFam )

            if !Empty( ::oFacRecL:cAlmLin )                         .AND.;
               ( oRetFld( ::oFacRecL:cRef, ::oDbfArt, "nCtlStock" ) != 3 )           .AND.;
               ::lValArt( cCodGrp, ::oFacRecL:cAlmLin, nTotNFacRec( ::oFacRecL ) )

               ::AddFacRec()
               ::oDbf:Load()
               ::oDbf:cCodGrp := cCodGrp
               ::oDbf:cNomGrp := Rtrim( oRetFld( ::oDbf:cCodGrp, ::oGruFam:oDbf ) )
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

   ::oTikCliT:GoTop()

   ::oMtrInf:SetTotal( ::oTikCliT:Lastrec() )
   ::oMtrInf:cText   := "Tickets de clientes"
   nEvery            := Int( ::oMtrInf:nTotal / 10 )

   while !::lBreak .and. !::oTikCliT:Eof()

      if ::oTikCliT:dFecTik >= ::dIniInf                                                    .AND.;
         ::oTikCliT:dFecTik <= ::dFinInf                                                    .AND.;
         ::oTikCliT:cAlmTik >= ::cAlmOrg                                                    .AND.;
         ::oTikCliT:cAlmTik <= ::cAlmDes                                                    .AND.;
         ::oTikCliL:Seek( ::oTikCliT:cSerTik +  ::oTikCliT:cNumTik + ::oTikCliT:cSufTik )

         while ::oTikClit:cSerTik + ::oTikClit:cNumTik + ::oTikClit:cSufTik == ::oTikCliL:cSerTil + ::oTikCliL:cNumTil + ::oTikCliL:cSufTil .AND. ! ::oTikCliL:Eof();

            cRet  := RetCode( ::oTikCliL:cCbaTil, ::oDbfArt:cAlias )
            cCodGrp := cCodGruFam( cRet, ::oDbfArt, ::oDbfFam )

            if !Empty( cRet )                                             .and.;
               ::oTikCliT:cTipTik $ "145"                                 .and.;
               !Empty( ::oTikClit:cAlmTik )                               .and.;
               ( oRetFld( cRet, ::oDbfArt, "nCtlStock" ) != 3 )           .AND.;
               ::lValArt( cCodGrp, ::oTikClit:cAlmTik, ::oTikCliL:nUntTil )

               ::AddTikCli( cRet )
               ::oDbf:Load()
               ::oDbf:cCodGrp := cCodGrp
               ::oDbf:cNomGrp := Rtrim( oRetFld( ::oDbf:cCodGrp, ::oGruFam:oDbf ) )
               ::oDbf:Save()

            end if

            if !Empty( ::oTikCliL:cComTil )

               cRet  := retCode( ::oTikCliL:cComTil, ::oDbfArt:cAlias )
               cCodGrp := cCodGruFam( cRet, ::oDbfArt, ::oDbfFam )

               if !Empty( cRet )                                           .and.;
                  ::oTikCliT:cTipTik $ "145"                               .and.;
                  !Empty( ::oTikClit:cAlmTik )                             .and.;
                  ( oRetFld( cRet, ::oDbfArt, "nCtlStock" ) != 3 )           .AND.;
                  ::lValArt( cCodGrp, ::oTikClit:cAlmTik, ::oTikCliL:nUntTil )

                  ::AddTikCli( cRet )
                  ::oDbf:Load()
                  ::oDbf:cCodGrp := cCodGrp
                  ::oDbf:cNomGrp := Rtrim( oRetFld( ::oDbf:cCodGrp, ::oGruFam:oDbf ) )
                  ::oDbf:Save()

               end if

            end if

            ::oTikCliL:Skip()

         end while

      end if

      ::oTikClit:Skip()

      ::oMtrInf:AutoInc()

   end while

   /*
   Histórico de movimientos-------------------------------------------------
   */

   ::oMtrInf:SetTotal( ::oHisMov:Lastrec() )
   ::oMtrInf:cText   := "Movimientos de almacén"
   nEvery            := Int( ::oMtrInf:nTotal / 10 )

   ::oHisMov:GoTop()

   while !::lBreak .and. !::oHisMov:Eof()

      if ::oHisMov:dFecMov >= ::dIniInf      .AND.;
         ::oHisMov:dFecMov <= ::dFinInf

         /*
         Salidas____________________________________________________________
         */

         cCodGrp := cCodGruFam( ::oHisMov:cRefMov, ::oDbfArt, ::oDbfFam )

         if !Empty( ::oHisMov:cAloMov )                                 .AND.;
            ( oRetFld( ::oHisMov:cRefMov, ::oDbfArt, "nCtlStock" ) != 3 )           .AND.;
            ::lValArt( cCodGrp, ::oHisMov:cAloMov, nTotNMovAlm( ::oHisMov ) )

            ::AddSal()
            ::oDbf:Load()
            ::oDbf:cCodGrp := cCodGrp
            ::oDbf:cNomGrp := Rtrim( oRetFld( ::oDbf:cCodGrp, ::oGruFam:oDbf ) )
            ::oDbf:Save()

         end if

         /*
         Entradas___________________________________________________________
         */

         cCodGrp := cCodGruFam( ::oHisMov:cRefMov, ::oDbfArt, ::oDbfFam )

         if !Empty( ::oHisMov:cAliMov )                                 .AND.;
            ( oRetFld( ::oHisMov:cRefMov, ::oDbfArt, "nCtlStock" ) != 3 )           .AND.;
            ::lValArt( cCodGrp, ::oHisMov:cAliMov, nTotNMovAlm( ::oHisMov ) )

            ::AddEnt()
            ::oDbf:Load()
            ::oDbf:cCodGrp := cCodGrp
            ::oDbf:cNomGrp := Rtrim( oRetFld( ::oDbf:cCodGrp, ::oGruFam:oDbf ) )
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

   ::oProCab:GoTop()

   while !::lBreak .and. !::oProCab:Eof()

      if ::oProCab:dFecOrd >= ::dIniInf                                       .AND.;
         ::oProCab:dFecOrd <= ::dFinInf                                       .AND.;
         lChkSer( ::oProCab:cSerOrd, ::aSer )

         if ::oProLin:Seek( ::oProCab:cSerOrd + Str( ::oProCab:nNumOrd ) + ::oProCab:cSufOrd )

            while ( ::oProCab:cSerOrd + Str( ::oProCab:nNumOrd ) + ::oProCab:cSufOrd ) == ( ::oProLin:cSerOrd + Str( ::oProLin:nNumOrd ) + ::oProLin:cSufOrd ) .AND. !::oProLin:eof()

               cCodGrp := cCodGruFam( ::oProLin:cCodArt, ::oDbfArt, ::oDbfFam )

               if !Empty( ::oProLin:cAlmOrd )                                       .AND.;
                  ( oRetFld( ::oProLin:cCodArt, ::oDbfArt, "nCtlStock" ) != 3 )     .AND.;
                  ::lValArt( cCodGrp, ::oProLin:cAlmOrd, nTotNProduccion( ::oProLin ) )

                  ::AddProLin()
                  ::oDbf:Load()
                  ::oDbf:cCodGrp := cCodGrp
                  ::oDbf:cNomGrp := Rtrim( oRetFld( ::oDbf:cCodGrp, ::oGruFam:oDbf ) )
                  ::oDbf:Save()

               end if

               ::oProLin:Skip()

            end while

         end if

         if ::oProMat:Seek( ::oProCab:cSerOrd + Str( ::oProCab:nNumOrd ) + ::oProCab:cSufOrd )

            while ( ::oProCab:cSerOrd + Str( ::oProCab:nNumOrd ) + ::oProCab:cSufOrd ) == ( ::oProMat:cSerOrd + Str( ::oProMat:nNumOrd ) + ::oProMat:cSufOrd ) .AND. !::oProMat:eof()

               cCodGrp := cCodGruFam( ::oProMat:cCodArt, ::oDbfArt, ::oDbfFam )

               if !Empty( ::oProMat:cAlmOrd )                                       .AND.;
                  ( oRetFld( ::oProMat:cCodArt, ::oDbfArt, "nCtlStock" ) != 3 )     .AND.;
                  ::lValArt( cCodGrp, ::oProMat:cAlmOrd, nTotNMaterial( ::oProMat ) )

                  ::AddProMat()
                  ::oDbf:Load()
                  ::oDbf:cCodGrp := cCodGrp
                  ::oDbf:cNomGrp := Rtrim( oRetFld( ::oDbf:cCodGrp, ::oGruFam:oDbf ) )
                  ::oDbf:Save()

               end if

               ::oProMat:Skip()

            end while

         end if

      end if

      ::oProCab:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oMtrInf:AutoInc( ::oProCab:LastRec() )

   ::oDlg:Enable()

   ::oBtnFilter:Disable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//

METHOD lValArt( cCodGrp, cCodAlm, nTotUnd )

   local lValArt  := ( ::lAllGrp .or. ( cCodGrp >= ::cGruFamOrg .and. cCodGrp <= ::cGruFamDes ) ) .and.;
                     ( ::lAllAlm .or. ( cCodAlm >= ::cAlmOrg .and. cCodAlm <= ::cAlmDes ) )       .and.;
                     !( ::lExcCero .and. nTotUnd == 0 )

RETURN ( lValArt )

//---------------------------------------------------------------------------//

METHOD nTotStock()

   local nTotStock   := 0
   local cCodAlm     := ::oReport:aGroups[ 1 ]:cValue
   local cCodGrp     := ::oReport:aGroups[ 2 ]:cValue

   ::oDbf:GetStatus()

   if ::oDbf:Seek( cCodAlm + cCodGrp )
      while ::oDbf:cCodAlm + ::oDbf:cCodGrp == cCodAlm + cCodGrp .and. !::oDbf:eof()

         nTotStock   += ::oDbf:nTotEnt

         ::oDbf:Skip()

      end while
   end if

   ::oDbf:SetStatus()

return ( Trans( nTotStock, MasUnd() ) )

//---------------------------------------------------------------------------//