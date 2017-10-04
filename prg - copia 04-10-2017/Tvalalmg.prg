#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TValAlmGrp FROM XInfMov

   METHOD Create()

   METHOD Resource( cFld )

   METHOD lGenerate()

   METHOD nTotStock()

   METHOD lValArt( cCodArt, nTotUnd )

   METHOD NewGroup()

   METHOD QuiGroup()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField( "cCodArt", "C", 18, 0, {|| "@!" },          "Código artículo",     .t., "Código artículo",          14, .f. )
   ::AddField( "cNomArt", "C",100, 0, {|| "@!" },          "Artículo",      .t., "Artículo",                 35, .f. )
   ::AddField( "cValPr1", "C", 20, 0, {|| "@!" },          "Prp. 1",        .f., "Propiedad 1",               6, .f. )
   ::AddField( "cValPr2", "C", 20, 0, {|| "@!" },          "Prp. 2",        .f., "Propiedad 2",               6, .f. )
   ::AddField( "cCodAlm", "C",  3, 0, {|| "@!" },          "Alm.",          .f., "Código almacen",            3, .f. )
   ::AddField( "cCodCli", "C", 12, 0, {|| "@!" },          "Cod. cli.",     .f., "Código cliente",            9, .f. )
   ::AddField( "cNomCli", "C", 50, 0, {|| "@!" },          "Cliente",       .f., "Cliente",                  35, .f. )
   ::AddField( "nCajEnt", "N", 16, 6, {|| MasUnd() },      cNombreCajas(),  .f., cNombreCajas(),             10, .t. )
   ::AddField( "nUntEnt", "N", 16, 6, {|| MasUnd() },      cNombreUnidades(),.f., cNombreUnidades(),         10, .t. )
   ::AddField( "nTotEnt", "N", 16, 6, {|| MasUnd() },      "Tot. " + cNombreUnidades(), .t., "Total " + cNombreUnidades(), 10, .t. )
   ::AddField( "nSalTot", "N", 16, 6, {|| MasUnd() },      "Sal. tot.",     .t., "Total saldo",              10, .f. )
   ::AddField( "nValOra", "N", 16, 6, {|| ::cPicImp },     "Tot. imp.",     .t., "Total importe",            10, .t. )
   ::AddField( "cDocMov", "C", 14, 0, {|| "@!" },          "Documento",     .t., "Documento",                10, .f. )
   ::AddField( "cTipDoc", "C", 14, 0, {|| "@!" },          "Tipo",          .t., "Tipo",                     14, .f. )
   ::AddField( "dFecMov", "D",  8, 0, {|| "@!" },          "Fecha",         .t., "Fecha",                    10, .f. )
   ::AddField( "cCodFam", "C", 16, 0, {|| "@!" },          "Fam.",          .f., "Familia",                   8, .f. )
   ::AddField( "cCodGrp", "C",  3, 0, {|| "@!" },          "Grp.",          .f., "Grupo familia",             3, .f. )

   ::AddTmpIndex( "cCodAlm", "cCodAlm + cCodGrp + dtos( dFecMov )" )

   ::aHeader      := {  {|| "Fecha   : " + Dtoc( Date() ) },;
                        {|| "Periodo : " + Dtoc( ::dIniInf )      + " > " + Dtoc( ::dFinInf ) },;
                        {|| "Almacén : " + ::cAlmOrg              + " > " + ::cAlmDes },;
                        {|| "Grp. Fam: " + Rtrim( ::cGruFamOrg )  + " > " + Rtrim( ::cGruFamDes ) } }

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Resource( cFld )

   if !::StdResource( "INF_GEN08D" )
      return .f.
   end if

   /*
   Monta los almacenes de manera automatica
   */

   ::oDefAlmInf( 70, 80, 90, 100 )

   REDEFINE CHECKBOX ::lUniAlm ;
      ID       ( 105 );
      OF       ::oFld:aDialogs[1]

   /*
   Monta las familias de manera automatica
   */

   ::oDefGrfInf( 110, 120, 130, 140 )

   ::oDefExcInf()

   ::oDefResInf()

   REDEFINE COMBOBOX ::oEstado ;
      VAR      ::cEstado ;
      ID       218 ;
      ITEMS    ::aEstado ;
      OF       ::oFld:aDialogs[1]

   ::bPreGenerate    := {|| ::NewGroup() }
   ::bPostGenerate   := {|| ::QuiGroup() }

RETURN ( Self )

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
               ::oDbf:Load()
               ::oDbf:cCodFam := cCodFam( ::oAlbPrvL:cRef, ::oArt )
               ::oDbf:cCodGrp := cCodGruFam( ::oAlbPrvL:cRef, ::oArt, ::oDbfFam )
               ::oDbf:Save()

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
               ::oDbf:Load()
               ::oDbf:cCodFam := cCodFam( ::oFacPrvL:cRef, ::oArt )
               ::oDbf:cCodGrp := cCodGruFam( ::oFacPrvL:cRef, ::oArt, ::oDbfFam )
               ::oDbf:Save()

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
               ::oDbf:Load()
               ::oDbf:cCodFam := cCodFam( ::oAlbCliL:cRef, ::oArt )
               ::oDbf:cCodGrp := cCodGruFam( ::oAlbCliL:cRef, ::oArt, ::oDbfFam )
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

            if ::lValArt( ::oFacCliL:cRef, ::oFacCliL:cAlmLin, nTotNFacCli( ::oFacCliL ) )

               ::AddFacCli()
               ::oDbf:Load()
               ::oDbf:cCodFam := cCodFam( ::oFacCliL:cRef, ::oArt )
               ::oDbf:cCodGrp := cCodGruFam( ::oFacCliL:cRef, ::oArt, ::oDbfFam )
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

            if !Empty( cRet )                                             .and.;
               ::oTikCliT:cTipTik $ "145"                                 .and.;
               ::lValArt( cRet, ::oTikClit:cAlmTik, ::oTikCliL:nUntTil )

               ::AddTikCli( cRet )
               ::oDbf:Load()
               ::oDbf:cCodFam := cCodFam( cRet, ::oArt )
               ::oDbf:cCodGrp := cCodGruFam( cRet, ::oArt, ::oDbfFam )
               ::oDbf:Save()

            end if

            if !Empty( ::oTikCliL:cComTil )

               cRet  := retCode( ::oTikCliL:cComTil, ::oArt:cAlias )

               if !Empty( cRet )                                           .and.;
                  ::oTikCliT:cTipTik $ "145"                               .and.;
                  ::lValArt( cRet, ::oTikClit:cAlmTik, ::oTikCliL:nUntTil )

                  ::AddTikCli( cRet )
                  ::oDbf:Load()
                  ::oDbf:cCodFam := cCodFam( cRet, ::oArt )
                  ::oDbf:cCodGrp := cCodGruFam( cRet, ::oArt, ::oDbfFam )
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

         if ::lValArt( ::oHisMov:cRefMov, ::oHisMov:cAloMov, nTotNMovAlm( ::oHisMov ) )

            ::AddSal()
            ::oDbf:Load()
            ::oDbf:cCodFam := cCodFam( ::oHisMov:cRefMov, ::oArt )
            ::oDbf:cCodGrp := cCodGruFam( ::oHisMov:cRefMov, ::oArt, ::oDbfFam )
            ::oDbf:Save()

         end if

         /*
         Entradas___________________________________________________________
         */

         if ::lValArt( ::oHisMov:cRefMov, ::oHisMov:cAliMov, nTotNMovAlm( ::oHisMov ) )

            ::AddEnt()
            ::oDbf:Load()
            ::oDbf:cCodFam := cCodFam( ::oHisMov:cRefMov, ::oArt )
            ::oDbf:cCodGrp := cCodGruFam( ::oHisMov:cRefMov, ::oArt, ::oDbfFam )
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

METHOD nTotStock()

   local nTotStock   := 0
   local cCodAlm
   local cCodGrp

   if ::lUniAlm

      cCodGrp        := ::oReport:aGroups[ 1 ]:cValue

      ::oDbf:GetStatus()
      ::oDbfAlm:GetStatus()

      ::oDbfAlm:GoTop()
      while !::oDbfAlm:eof()
         if ::oDbf:Seek( ::oDbfAlm:cCodAlm + cCodGrp )
            while ::oDbf:cCodAlm + ::oDbf:cCodGrp == ::oDbfAlm:cCodAlm + cCodGrp .and. !::oDbf:eof()
               nTotStock   += ::oDbf:nTotEnt
               ::oDbf:Skip()
            end while
         end if
         ::oDbfAlm:Skip()
      end while

      ::oDbf:SetStatus()
      ::oDbfAlm:SetStatus()

   else

      cCodAlm        := ::oReport:aGroups[ 1 ]:cValue
      cCodGrp        := ::oReport:aGroups[ 2 ]:cValue

      ::oDbf:GetStatus()

      if ::oDbf:Seek( cCodAlm + cCodGrp )
         while ::oDbf:cCodAlm + ::oDbf:cCodGrp == cCodAlm + cCodGrp .and. !::oDbf:eof()
            nTotStock   += ::oDbf:nTotEnt
            ::oDbf:Skip()
         end while
      end if

      ::oDbf:SetStatus()

   end if

return ( Trans( nTotStock, MasUnd() ) )

//---------------------------------------------------------------------------//

METHOD lValArt( cCodArt, cCodAlm, nTotUnd )

   local lValArt  := cCodGruFam( cCodArt, ::oArt, ::oDbfFam ) >= ::cGruFamOrg                .and.;
                     cCodGruFam( cCodArt, ::oArt, ::oDbfFam ) <= ::cGruFamDes                .and.;
                     cCodAlm >= ::cAlmOrg                                                    .and.;
                     cCodAlm <= ::cAlmDes                                                    .and.;
                     !( ::lExcCero .and. nTotUnd == 0 )

RETURN ( lValArt )

//---------------------------------------------------------------------------//

METHOD NewGroup()

   if !::lUniAlm
      ::AddGroup( {|| ::oDbf:cCodAlm }, {|| "Almacén  : " + if( ::lUniAlm, "Todos", Rtrim( ::oDbf:cCodAlm ) + "-" + oRetFld( ::oDbf:cCodAlm, ::oDbfAlm ) ) }, {|| "Total almacen..." } )
   end if

   ::AddGroup( {|| ::oDbf:cCodGrp }, {|| "Grp. fam. : " + Rtrim( ::oDbf:cCodGrp ) + "-" + oRetFld( ::oDbf:cCodGrp, ::oGruFam:oDbf ) }, {|| "Total grp. fam. " + ::nTotStock() } )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD QuiGroup()

   if !::lUniAlm
      ::DelGroup()
   end if

   ::DelGroup()

RETURN ( Self )

//---------------------------------------------------------------------------//