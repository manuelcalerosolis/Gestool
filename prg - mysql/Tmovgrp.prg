#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TInfDetGrp FROM XInfMov

   METHOD Create()

   METHOD Resource( cFld )

   METHOD lGenerate()

   METHOD lValArt( cCodGrp, cCodAlm, nTotUnd )

   METHOD nTotStock()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField( "cCodGrp", "C",  3, 0, {|| "@!" },          "Cod.",          .f., "Codigo grupo",             3, .f. )
   ::AddField( "cNomGrp", "C", 50, 0, {|| "@!" },          "Grp. Fam.",     .f., "Grupo de Familia",        35, .f. )
   ::FldCreate()

   ::AddTmpIndex( "cCodAlm", "cCodAlm + cCodGrp + dtos( dFecMov )" )

   ::AddGroup( {|| ::oDbf:cCodAlm }, {|| "Almacen  : " + Rtrim( ::oDbf:cCodAlm ) + "-" + Rtrim( oRetFld( ::oDbf:cCodAlm, ::oDbfAlm ) ) }, {|| "Total almacen..." } )
   ::AddGroup( {|| ::oDbf:cCodGrp }, {|| "Grp. Fam.: " + Rtrim( ::oDbf:cCodGrp ) + "-" + Rtrim( oRetFld( ::oDbf:cCodGrp, ::oGruFam:oDbf ) ) }, {|| "Total grupo " + ::nTotStock() } )

   ::aHeader      := {  {|| "Fecha    : " + Dtoc( Date() ) },;
                        {|| "Periodo  : " + Dtoc( ::dIniInf )     + " > " + Dtoc( ::dFinInf ) },;
                        {|| "Almacén  : " + ::cAlmOrg             + " > " + ::cAlmDes },;
                        {|| "Grp. Fam.: " + Rtrim( ::cGruFamOrg ) + " > " + Rtrim( ::cGruFamDes ) } }

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Resource( cFld )

   if !::StdResource( "INF_GEN08B" )
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

   ::oDefGrFInf( 110, 120, 130, 140 )

   ::oDefExcInf()

   ::oDefResInf()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lGenerate()

   local cRet
   local nEvery
   local cCodGrp
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

            cCodGrp := cCodGruFam( ::oAlbPrvL:cRef, ::oArt, ::oDbfFam )

            if ::lValArt( cCodGrp, ::oAlbPrvL:cAlmLin, nTotNAlbPrv( ::oAlbPrvL ) )

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

            cCodGrp := cCodGruFam( ::oFacPrvL:cRef, ::oArt, ::oDbfFam )

            if ::lValArt( cCodGrp, ::oFacPrvL:cAlmLin, nTotNFacPrv( ::oFacPrvL ) )

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

            cCodGrp := cCodGruFam( ::oAlbCliL:cRef, ::oArt, ::oDbfFam )

            if ::lValArt( cCodGrp, ::oAlbCliL:cAlmLin, nTotNAlbCli( ::oAlbCliL ) )

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

            cCodGrp := cCodGruFam( ::oFacCliL:cRef, ::oArt, ::oDbfFam )

            if ::lValArt( cCodGrp, ::oFacCliL:cAlmLin, nTotNFacCli( ::oFacCliL ) )

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
            cCodGrp := cCodGruFam( cRet, ::oArt, ::oDbfFam )

            if !Empty( cRet )                                             .and.;
               ::oTikCliT:cTipTik $ "145"                                 .and.;
               ::lValArt( cCodGrp, ::oTikClit:cAlmTik, ::oTikCliL:nUntTil )

               ::AddTikCli( cRet )
               ::oDbf:Load()
               ::oDbf:cCodGrp := cCodGrp
               ::oDbf:cNomGrp := Rtrim( oRetFld( ::oDbf:cCodGrp, ::oGruFam:oDbf ) )
               ::oDbf:Save()

            end if

            if !Empty( ::oTikCliL:cComTil )

               cRet  := retCode( ::oTikCliL:cComTil, ::oArt:cAlias )
               cCodGrp := cCodGruFam( cRet, ::oArt, ::oDbfFam )

               if !Empty( cRet )                                           .and.;
                  ::oTikCliT:cTipTik $ "145"                               .and.;
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

         cCodGrp := cCodGruFam( ::oHisMov:cRefMov, ::oArt, ::oDbfFam )

         if ::lValArt( cCodGrp, ::oHisMov:cAloMov, nTotNMovAlm( ::oHisMov ) )

            ::AddSal()
            ::oDbf:Load()
            ::oDbf:cCodGrp := cCodGrp
            ::oDbf:cNomGrp := Rtrim( oRetFld( ::oDbf:cCodGrp, ::oGruFam:oDbf ) )
            ::oDbf:Save()

         end if

         /*
         Entradas___________________________________________________________
         */

         cCodGrp := cCodGruFam( ::oHisMov:cRefMov, ::oArt, ::oDbfFam )

         if ::lValArt( cCodGrp, ::oHisMov:cAliMov, nTotNMovAlm( ::oHisMov ) )

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

   end if

   ::CreaSaldo()

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//

METHOD lValArt( cCodGrp, cCodAlm, nTotUnd )

   local lValArt  := cCodGrp >= ::cGruFamOrg                .and.;
                     cCodGrp <= ::cGruFamDes                .and.;
                     cCodAlm >= ::cAlmOrg                   .and.;
                     cCodAlm <= ::cAlmDes                   .and.;
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