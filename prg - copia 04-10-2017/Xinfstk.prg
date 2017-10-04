#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS XInfDetMov FROM TInfGen

   DATA  lResumen    AS LOGIC    INIT .f.
   DATA  lDesPrp     AS LOGIC    INIT .f.
   DATA  nEstado     AS NUMERIC  INIT 1
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
   DATA  oEstado     AS OBJECT
   DATA  aEstado     AS ARRAY       INIT { "Precios de costo medio", "Ultimo precio costo", "Precio 1", "Precio 2", "Precio 3", "Precio 4", "Precio 5", "Precio 6" }
   DATA  cEstado     AS CHARACTER   INIT "Ultimo precio costo"

   DATA  lAlbPrv     AS LOGIC    INIT .t.
   DATA  lFacPrv     AS LOGIC    INIT .t.
   DATA  lAlbCli     AS LOGIC    INIT .t.
   DATA  lFacCli     AS LOGIC    INIT .t.
   DATA  lTikCli     AS LOGIC    INIT .t.
   DATA  lMovAlm     AS LOGIC    INIT .t.

   DATA  lUniAlm     AS LOGIC    INIT .f.

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD Resource( cFld )

   METHOD lGenerate()

   METHOD NewGroup()

   METHOD QuiGroup()

   METHOD lValArt( cCodArt, cCodAlm, nTotUnd )

   METHOD nRetPrecio()

   METHOD nCalStock( cCodArt )


END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField( "CCODART", "C", 18, 0, {|| "@!" },          "Código artículo",     .f., "Código artículo",          14, .f. )
   ::AddField( "CNOMART", "C",100, 0, {|| "@!" },          "Artículo",      .f., "Artículo",                 35, .f. )
   ::AddField( "CVALPR1", "C", 20, 0, {|| "@!" },          "Prp. 1",        .f., "Propiedad 1",               6, .f. )
   ::AddField( "CVALPR2", "C", 20, 0, {|| "@!" },          "Prp. 2",        .f., "Propiedad 2",               6, .f. )
   ::AddField( "CCODALM", "C", 16, 0, {|| "@!" },          "Alm.",          .t., "Código almacen",            3, .f. )
   ::AddField( "CCODCLI", "C", 12, 0, {|| "@!" },          "Cod. cli.",     .t., "Código cliente",            9, .f. )
   ::AddField( "CNOMCLI", "C", 50, 0, {|| "@!" },          "Cliente",       .t., "Cliente",                  35, .f. )
   ::AddField( "NCAJENT", "N", 16, 6, {|| MasUnd() },      "Caj.",          .f., "Cajas",                    10, .t. )
   ::AddField( "NUNTENT", "N", 16, 6, {|| MasUnd() },      "Und.",          .f., "Unidades",                 10, .t. )
   ::AddField( "NTOTENT", "N", 16, 6, {|| MasUnd() },      "Tot. und.",     .t., "Total unidades",           10, .t. )
   ::AddField( "NSALTOT", "N", 16, 6, {|| MasUnd() },      "Sal. tot.",     .t., "Total saldo",              10, .f. )
   ::AddField( "NVALORA", "N", 16, 6, {|| MasUnd() },      "Tot. imp.",     .t., "Total importe",            10, .t. )
   ::AddField( "CDOCMOV", "C", 14, 0, {|| "@!" },          "Documento",     .t., "Documento",                10, .f. )
   ::AddField( "CTIPDOC", "C", 14, 0, {|| "@!" },          "Tipo",          .t., "Tipo",                     14, .f. )
   ::AddField( "DFECMOV", "D",  8, 0, {|| "@!" },          "Fecha",         .t., "Fecha",                    10, .f. )
   ::AddField( "CCODFAM", "C", 16, 0, {|| "@!" },          "Fam.",          .f., "Familia",                   8, .f. )
   ::AddField( "CCODGRP", "C",  3, 0, {|| "@!" },          "Grp.",          .f., "Grupo familia",             3, .f. )

   ::AddTmpIndex( "cCodAlm", "cCodAlm + cCodArt + cValPr1 + cValPr2" )

   ::AddGroup( {|| ::oDbf:cCodAlm }, {|| "Almacen  : " + Rtrim( ::oDbf:cCodAlm ) + "-" + Rtrim( oRetFld( ::oDbf:cCodAlm, ::oDbfAlm ) ) }, {|| "Total almacen..." } )

   ::aHeader      := {  {|| "Fecha   : " + Dtoc( Date() ) },;
                        {|| "Periodo : " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                        {|| "Almacén : " + ::cAlmOrg         + " > " + ::cAlmDes } }

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   /*
   Ficheros necesarios
   */

   DATABASE NEW ::oAlbPrvT  PATH ( cPatEmp() ) FILE "ALBPROVT.DBF" VIA ( cDriver() ) SHARED INDEX "ALBPROVT.CDX"

   DATABASE NEW ::oAlbPrvL  PATH ( cPatEmp() ) FILE "ALBPROVL.DBF" VIA ( cDriver() ) SHARED INDEX "ALBPROVL.CDX"
   ::oAlbPrvL:OrdSetFocus( "cRef" )

   DATABASE NEW ::oFacPrvT  PATH ( cPatEmp() ) FILE "FACPRVT.DBF" VIA ( cDriver() ) SHARED INDEX "FACPRVT.CDX"

   DATABASE NEW ::oFacPrvL  PATH ( cPatEmp() ) FILE "FACPRVL.DBF" VIA ( cDriver() ) SHARED INDEX "FACPRVL.CDX"
   ::oFacPrvL:OrdSetFocus( "cRef" )

   ::oAlbCliT := TDataCenter():oAlbCliT()

   DATABASE NEW ::oAlbCliL  PATH ( cPatEmp() ) FILE "ALBCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "ALBCLIL.CDX"
   ::oAlbCliL:OrdSetFocus( "cRef" )

   ::oFacCliT  := TDataCenter():oFacCliT()

   DATABASE NEW ::oFacCliL  PATH ( cPatEmp() ) FILE "FacCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "FacCLIL.CDX"
   ::oFacCliL:OrdSetFocus( "cRef" )

   DATABASE NEW ::oTikCliT  PATH ( cPatEmp() ) FILE "TikeT.DBF" VIA ( cDriver() ) SHARED INDEX "TikeT.CDX"

   DATABASE NEW ::oTikCliL  PATH ( cPatEmp() ) FILE "TikeL.DBF" VIA ( cDriver() ) SHARED INDEX "TikeL.CDX"
   ::oTikCliL:OrdSetFocus( "cCbaTil" )

   DATABASE NEW ::oHisMov  PATH ( cPatEmp() )  FILE "HisMov.DBF" VIA ( cDriver() ) SHARED INDEX "HisMov.CDX"
   ::oHisMov:OrdSetFocus( "cRefMov" )

   DATABASE NEW ::oDbfFam PATH ( cPatArt() ) FILE "FAMILIAS.DBF" VIA ( cDriver() ) SHARED INDEX "FAMILIAS.CDX"

   DATABASE NEW ::oDbfArt PATH ( cPatArt() ) FILE "ARTICULO.DBF" VIA ( cDriver() ) SHARED INDEX "ARTICULO.CDX"

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD CloseFiles()

   ::oAlbPrvT:End()
   ::oAlbPrvL:End()
   ::oFacPrvT:End()
   ::oFacPrvL:End()
   ::oAlbCliT:End()
   ::oAlbCliL:End()
   ::oFacCliT:End()
   ::oFacCliL:End()
   ::oTikCliT:End()
   ::oTikCliL:End()
   ::oHisMov:End()
   ::oDbfFam:End()
   ::oDbfArt:End()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Resource( cFld )

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

   /*
   Damos valor al meter
   */

   ::oMtrInf:SetTotal( ::oAlbPrvT:Lastrec() )

   ::oDefExcInf()

   ::oDefResInf()

   /*
   REDEFINE CHECKBOX ::lAlbPrv ID 210 OF ::oFld:aDialogs[1]
   REDEFINE CHECKBOX ::lFacPrv ID 220 OF ::oFld:aDialogs[1]
   REDEFINE CHECKBOX ::lAlbCli ID 230 OF ::oFld:aDialogs[1]
   REDEFINE CHECKBOX ::lFacCli ID 240 OF ::oFld:aDialogs[1]
   REDEFINE CHECKBOX ::lTikCli ID 250 OF ::oFld:aDialogs[1]
   REDEFINE CHECKBOX ::lMovAlm ID 260 OF ::oFld:aDialogs[1]
   */

   ::bPreGenerate    := {|| ::NewGroup() }
   ::bPostGenerate   := {|| ::QuiGroup() }

RETURN ( Self )

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   local cRet
   local nEvery
   local cCodArt
   local cCodAlm
   local nSalAnt  := 0

   ::oDlg:Disable()

   ::oDbf:Zap()

   /*
   Albaranes de Proveedores----------------------------------------------------
	*/

   ::oDbfArt:GoTop()

   ::oMtrInf:SetTotal( ::oDbfArt:Lastrec() )
   nEvery            := Int( ::oMtrInf:nTotal / 10 )

   while ! ::oDbfArt:Eof ()

      ::oDbfArt:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//

METHOD NewGroup()

   if ::lDesPrp
      ::AddGroup( {|| ::oDbf:cValPr1 + ::oDbf:cValPr2 }, {|| "Propiedades : " + Rtrim( ::oDbf:cValPr1 ) + "-" + Rtrim( ::oDbf:cValPr2 ) } )
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD QuiGroup()

   if ::lDesPrp
      ::DelGroup()
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lValArt( cCodArt, cCodAlm, nTotUnd )

   local lValArt  := cCodArt >= ::cArtOrg                   .and.;
                     cCodArt <= ::cArtDes                   .and.;
                     cCodAlm >= ::cAlmOrg                   .and.;
                     cCodAlm <= ::cAlmDes                   .and.;
                     !( ::lExcCero .and. nTotUnd == 0 )

RETURN ( lValArt )

//---------------------------------------------------------------------------//

METHOD nRetPrecio( cCodArt, cCodAlm )

	local nPreMed 	:= 0

   do case
   case ::cEstado == "Precios de costo medio"
      if ::lUniAlm
         nPreMed := nPreMedCom( cCodArt, nil, ::oAlbPrvT:cAlias, ::oAlbPrvL:cAlias, ::oFacPrvT:cAlias, ::oFacPrvL:cAlias, ::nValDiv, ::nDecOut, ::nDerOut, ::oHisMov:cAlias )
      else
         nPreMed := nPreMedCom( cCodArt, cCodAlm, ::oAlbPrvT:cAlias, ::oAlbPrvL:cAlias, ::oFacPrvT:cAlias, ::oFacPrvL:cAlias, ::nValDiv, ::nDecOut, ::nDerOut, ::oHisMov:cAlias )
      end if
   case ::cEstado == "Ultimo precio costo"
      if ::oDbfArt:Seek( cCodArt )
         nPreMed := Round( ::oDbfArt:pCosto  / ::nValDiv, ::nDerOut )
      end if
   case ::cEstado == "Precio 1"
      if ::oDbfArt:Seek( cCodArt )
         nPreMed := Round( ::oDbfArt:pVenta1 / ::nValDiv, ::nDerOut )
      end if
   case ::cEstado == "Precio 2"
      if ::oDbfArt:Seek( cCodArt )
         nPreMed := Round( ::oDbfArt:pVenta2 / ::nValDiv, ::nDerOut )
      end if
   case ::cEstado == "Precio 3"
      if ::oDbfArt:Seek( cCodArt )
         nPreMed := Round( ::oDbfArt:pVenta3 / ::nValDiv, ::nDerOut )
      end if
   case ::cEstado == "Precio 4"
      if ::oDbfArt:Seek( cCodArt )
         nPreMed := Round( ::oDbfArt:pVenta4 / ::nValDiv, ::nDerOut )
      end if
   case ::cEstado == "Precio 5"
      if ::oDbfArt:Seek( cCodArt )
         nPreMed := Round( ::oDbfArt:pVenta5 / ::nValDiv, ::nDerOut )
      end if
   case ::cEstado == "Precio 6"
      if ::oDbfArt:Seek( cCodArt )
         nPreMed := Round( ::oDbfArt:pVenta6 / ::nValDiv, ::nDerOut )
      end if
   end case

RETURN ( nPreMed )

//---------------------------------------------------------------------------//

METHOD nCalStock( cCodArt )

   local cRet
   local nEvery
   local nCalStock   := 0

   /*
   Albaranes de Proveedores----------------------------------------------------
	*/

   if ::lAlbPrv

      if ::oAlbPrvL:Seek( cCodArt )

         while ::oAlbPrvL:cRef == cCodArt .and. !::oAlbPrvL:Eof()

            if ::oAlbPrvT:Seek( ::oAlbPrvL:cSerAlb + Str( ::oAlbPrvL:nNumAlb ) + ::oAlbPrvL:cSufAlb )

               if !::oAlbPrvT:lFacturado                                 .AND.;
                  ::oAlbPrvT:dFecAlb >= ::dIniInf                        .AND.;
                  ::oAlbPrvT:dFecAlb <= ::dFinInf                        .AND.;
                  lChkSer( ::oAlbPrvT:cSerAlb, ::aSer )

                  nCalStock   += nTotNAlbPrv( ::oAlbPrvL )

               end if

            end if

            ::oAlbPrvL:Skip()

         end while

      end if

   end if

   /*
   Factura de Proveedores------------------------------------------------------
   */

   if ::lFacPrv

      if ::oFacPrvL:Seek( cCodArt )

         while ::oFacPrvL:cRef == cCodArt .and. !::oFacPrvL:Eof()

            if ::oFacPrvT:Seek( ::oFacPrvL:cSerFac + Str( ::oFacPrvL:nNumFac ) + ::oFacPrvL:cSufFac )

               if ::oFacPrvT:dFecFac >= ::dIniInf                        .AND.;
                  ::oFacPrvT:dFecFac <= ::dFinInf                        .AND.;
                  lChkSer( ::oFacPrvT:cSerFac, ::aSer )

                  nCalStock   += nTotNFacPrv( ::oFacPrvL )

               end if

            end if

            ::oFacPrvL:Skip()

         end while

      end if

   end if

   /*
   Albaranes de Clientes
   */

   if ::lAlbCli

      if ::oAlbCliL:Seek( cCodArt )

         while ::oAlbCliL:cRef == cCodArt .and. !::oAlbCliL:Eof()

            if ::oAlbCliT:Seek( ::oAlbCliL:cSerAlb + Str( ::oAlbCliL:nNumAlb ) + ::oAlbCliL:cSufAlb )

               if !lFacturado( ::oAlbCliT )                              .AND.;
                  ::oAlbCliT:dFecAlb >= ::dIniInf                        .AND.;
                  ::oAlbCliT:dFecAlb <= ::dFinInf                        .AND.;
                  lChkSer( ::oAlbCliT:cSerAlb, ::aSer )

                  nCalStock   += nTotNAlbCli( ::oAlbCliL )

               end if

            end if

            ::oAlbCliL:Skip()

         end while

      end if

   end if

   /*
   Factura de Clientes---------------------------------------------------------
   */

   if ::lFacCli

      if ::oFacCliL:Seek( cCodArt )

         while ::oFacCliL:cRef == cCodArt .and. !::oFacCliL:Eof()

            if ::oFacCliT:Seek( ::oFacCliL:cSerie + Str( ::oFacCliL:nNumFac ) + ::oFacCliL:cSufFac )

               if ::oFacCliT:dFecFac >= ::dIniInf                        .AND.;
                  ::oFacCliT:dFecFac <= ::dFinInf                        .AND.;
                  lChkSer( ::oFacCliT:cSerie, ::aSer )

                  nCalStock   += nTotNFacCli( ::oFacCliL )

               end if

            end if

            ::oFacCliL:Skip()

         end while

      end if

   end if

   /*
   Tickets --------------------------------------------------------------------
   */

   if ::lTikCli

      if ::oTikeL:Seek( cCodArt )

         while ::oFacCliL:cRef == cCodArt .and. !::oFacCliL:Eof()

            if ::oFacCliT:Seek( ::oFacCliL:cSerie + Str( ::oFacCliL:nNumFac ) + ::oFacCliL:cSufFac )

               if ::oFacCliT:dFecFac >= ::dIniInf                        .AND.;
                  ::oFacCliT:dFecFac <= ::dFinInf                        .AND.;
                  lChkSer( ::oFacCliT:cSerie, ::aSer )

                  nCalStock   += nTotNFacCli( ::oFacCliL )

               end if

            end if

            ::oFacCliL:Skip()

         end while

      end if


   WHILE ! ::oTiket:Eof()

      IF ::oTiket:dFecTik >= ::dIniInf                                                    .AND.;
         ::oTiket:dFecTik <= ::dFinInf                                                    .AND.;
         ::oTiket:cAlmTik >= ::cAlmOrg                                                    .AND.;
         ::oTiket:cAlmTik <= ::cAlmDes                                                    .AND.;
         ::oTikeL:Seek( ::oTiket:CSERTIK +  ::oTiket:CNUMTIK + ::oTiket:CSUFTIK )

         WHILE ::oTiket:CSERTIK + ::oTiket:CNUMTIK + ::oTiket:CSUFTIK == ::oTikeL:CSERTIL + ::oTikeL:CNUMTIL + ::oTikeL:CSUFTIL .AND. ! ::oTikeL:Eof();

            cRet  := RetCode( ::oTikeL:CCBATIL, ::oArt:cAlias )

            if !Empty( cRet )                                           .and.;
               ::oTikeT:cTipTik $ "145"                                 .and.;
               ::lValArt( cRet, ::oTiket:cAlmTik, ::oTikeL:nUntTil )

               ::oDbf:Append()

               ::oDbf:CCODCLI := ::oTiket:cCliTik
               ::oDbf:CCODALM := ::oTiket:cAlmTik
               ::oDbf:CNOMCLI := ::oTiket:cNomTik
               ::oDbf:DFECMOV := ::oTiket:dFecTik

               if ::oTikeT:cTipTik == "4"
               ::oDbf:nUntEnt := ::oTikeL:nUntTil
               ::oDbf:nTotEnt := ::oTikeL:nUntTil
               ::oDbf:nValora := ::nRetPrecio( cRet, ::oTiket:cAlmTik ) * ::oTikeL:nUntTil
               else
               ::oDbf:nUntEnt := - ::oTikeL:nUntTil
               ::oDbf:nTotEnt := - ::oTikeL:nUntTil
               ::oDbf:nValora := - ::nRetPrecio( cRet, ::oTiket:cAlmTik ) * ::oTikeL:nUntTil
               end if

               ::oDbf:nSalTot := 0
               ::oDbf:CCODART := cRet
               ::oDbf:CDOCMOV := ::oTiket:CSERTIK + "/" + AllTrim( ::oTiket:CNUMTIK ) + "/" + ::oTiket:CSUFTIK
               ::oDbf:CTIPDOC := "Tiket"

               ::oDbf:cValPr1 := ::oTikeL:cValPr1
               ::oDbf:cValPr2 := ::oTikeL:cValPr2

               ::oDbf:cCodFam := oRetFld( cRet, ::oDbfArt, "Familia" )
               ::oDbf:cCodGrp := oRetFld( ::oDbf:cCodFam, ::oDbfFam, "cCodGrp" )

               ::oDbf:Save()

            end if

            /*
            Ahora comprobamos q no haya producto combinado
            */

            IF !Empty( ::oTikeL:CCOMTIL )

               cRet  := retCode( ::oTikeL:CCOMTIL, ::oArt:cAlias )

               if !Empty( cRet )                                           .and.;
                  ::oTikeT:cTipTik $ "145"                                 .and.;
                  ::lValArt( cRet, ::oTiket:cAlmTik, ::oTikeL:nUntTil )

                  ::oDbf:Append()
                  ::oDbf:cCodCli := ::oTiket:CCLITIK
                  ::oDbf:cCodAlm := ::oTiket:CALMTIK
                  ::oDbf:cNomCli := ::oTiket:CNOMTIK
                  ::oDbf:dFecMov := ::oTiket:DFECTIK

                  if ::oTikeT:cTipTik == "4"
                  ::oDbf:nUntEnt := ::oTikeL:nUntTil
                  ::oDbf:nTotEnt := ::oTikeL:nUntTil
                  ::oDbf:nValora := ::nRetPrecio( cRet, ::oTiket:cAlmTik ) * ::oTikeL:nUntTil
                  else
                  ::oDbf:nUntEnt := - ::oTikeL:nUntTil
                  ::oDbf:nTotEnt := - ::oTikeL:nUntTil
                  ::oDbf:nValora := - ::nRetPrecio( cRet, ::oTiket:cAlmTik ) * ::oTikeL:nUntTil
                  end if

                  ::oDbf:nSalTot := 0

                  ::oDbf:cCodArt := cRet
                  ::oDbf:cDocMov := ::oTiket:CSERTIK + "/" + AllTrim( ::oTiket:CNUMTIK ) + "/" + ::oTiket:CSUFTIK
                  ::oDbf:cTipDoc := "Tiket"

                  ::oDbf:cValPr1 := ::oTikeL:cValPr1
                  ::oDbf:cValPr2 := ::oTikeL:cValPr2

                  ::oDbf:cCodFam := oRetFld( cRet, ::oDbfArt, "Familia" )
                  ::oDbf:cCodGrp := oRetFld( ::oDbf:cCodFam, ::oDbfFam, "cCodGrp" )

                  ::oDbf:Save()

               end if

            end if

            ::oTikeL:Skip()

         end while

      end if

      ::oTiket:Skip()

      ::oMtrInf:AutoInc( ::oTiket:OrdKeyNo() )

   END WHILE

   end if

   /*
   Histórico de movimientos-------------------------------------------------
   */

   if ::lMovAlm

   ::oHisMov:GoTop()

   ::oMtrInf:SetTotal( ::oHisMov:Lastrec() )
   ::oMtrInf:cText   := "Movimientos de almacen"
   nEvery            := Int( ::oMtrInf:nTotal / 10 )

   WHILE !::oHisMov:Eof()

      if ::oHisMov:DFECMOV >= ::dIniInf                              .AND.;
         ::oHisMov:DFECMOV <= ::dFinInf

         /*
         Salidas____________________________________________________________
         */

         if ::lValArt( ::oHisMov:cRefMov, ::oHisMov:cAloMov, nTotNMovAlm( ::oHisMov ) ) .and.;
            !::oHisMov:lNoStk

            ::oDbf:Append()
            ::oDbf:Blank()

            ::oDbf:cCodCli := ""
            ::oDbf:cCodAlm := ::oHisMov:cAloMov
            ::oDbf:cNomCli := "MOVIMIENTOS ENTRE ALMACENES"
            ::oDbf:dFecMov := ::oHisMov:dFecMov

            ::oDbf:nCajEnt := - ::oHisMov:nCajMov
            ::oDbf:nUntEnt := - ::oHisMov:nUndMov
            ::oDbf:nTotEnt := - nTotNMovAlm( ::oHisMov )
            ::oDbf:nValora := - ::nRetPrecio( ::oHisMov:cRefMov, ::oHisMov:cAloMov ) * nTotNMovAlm( ::oHisMov )
            ::oDbf:nSalTot := 0

            ::oDbf:cCodArt := ::oHisMov:cRefMov
            ::oDbf:cDocMov := Str( ::oHisMov:nNumRem ) + "/" + ::oHisMov:cSufRem
            ::oDbf:cTipDoc := "Sal. Almacen"

            ::oDbf:cValPr1 := ::oHisMov:cValPr1
            ::oDbf:cValPr2 := ::oHisMov:cValPr2

            ::oDbf:cCodFam := oRetFld( ::oHisMov:cRefMov, ::oDbfArt, "Familia" )
            ::oDbf:cCodGrp := oRetFld( ::oDbf:cCodFam, ::oDbfFam, "cCodGrp" )

            ::oDbf:Save()

         end if

         /*
         Entradas___________________________________________________________
         */

         if ::lValArt( ::oHisMov:cRefMov, ::oHisMov:cAliMov, nTotNMovAlm( ::oHisMov ) ) .and.;
            !::oHisMov:lNoStk

            ::oDbf:Append()

            ::oDbf:CCODCLI := ""
            ::oDbf:CCODALM := ::oHisMov:cAliMov
            ::oDbf:CNOMCLI := "MOVIMIENTOS ENTRE ALMACENES"
            ::oDbf:DFECMOV := ::oHisMov:DFECMOV

            ::oDbf:nCajEnt := ::oHisMov:nCajMov
            ::oDbf:nUntEnt := ::oHisMov:nUndMov
            ::oDbf:nTotEnt := nTotNMovAlm( ::oHisMov )
            ::oDbf:nValora := ::nRetPrecio( ::oHisMov:cRefMov, ::oHisMov:cAliMov ) * nTotNMovAlm( ::oHisMov )

            ::oDbf:nSalTot := 0
            ::oDbf:CCODART := ::oHisMov:CREFMOV
            ::oDbf:cDocMov := Str( ::oHisMov:nNumRem ) + "/" + ::oHisMov:cSufRem
            ::oDbf:CTIPDOC := "Ent. Almacen"


            ::oDbf:cCodFam := oRetFld( ::oHisMov:cRefMov, ::oDbfArt, "Familia" )
            ::oDbf:cCodGrp := oRetFld( ::oDbf:cCodFam, ::oDbfFam, "cCodGrp" )

            ::oDbf:Save()

         end if

      end if

      ::oHisMov:Skip()

      ::oMtrInf:AutoInc()

   end while

   end if

RETURN ( Self )

//---------------------------------------------------------------------------//