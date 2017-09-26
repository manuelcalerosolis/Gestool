#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"
//---------------------------------------------------------------------------//

CLASS TIUltArtN FROM TInfGen

   DATA  lSinVta     AS LOGIC    INIT .f.
   DATA  nSinVta     AS NUMERIC  INIT 15
   DATA  oFacPrvT    AS OBJECT
   DATA  oFacPrvL    AS OBJECT
   DATA  oFacPrvP    AS OBJECT
   DATA  oAlbPrvT    AS OBJECT
   DATA  oAlbPrvL    AS OBJECT
   DATA  oDbfIva     AS OBJECT
   DATA  cPrvFac     AS CHARACTER     INIT ""
   DATA  dLasFac
   DATA  cNumFac     AS CHARACTER     INIT ""
   DATA  cPrvAlb     AS CHARACTER     INIT ""
   DATA  dLasAlb
   DATA  cNumAlb     AS CHARACTER     INIT ""


   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD Resource( cFld )

   METHOD lGenerate()

   METHOD GetInfPrv()

   METHOD GetFactura()
   METHOD AddFactura()

   METHOD GetAlbaran()
   METHOD AddAlbaran()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField ( "cCodPrv", "C", 12, 0, {|| "@!" },         "Cód. Prv",                .f., "Código Prvente"          ,  8 } )
   ::AddField ( "cNomPrv", "C", 50, 0, {|| "@!" },         "Prvente",                 .f., "Nombre Prvente"          , 25 } )
   ::AddField ( "cNifPrv", "C", 15, 0, {|| "@!" },         "Nif",                     .f., "Nif"                     ,  8 } )
   ::AddField ( "cDomPrv", "C", 35, 0, {|| "@!" },         "Domicilio",               .f., "Domicilio"               , 25 } )
   ::AddField ( "cPobPrv", "C", 25, 0, {|| "@!" },         "Población",               .f., "Población"               , 20 } )
   ::AddField ( "cProPrv", "C", 20, 0, {|| "@!" },         "Provincia",               .f., "Provincia"               , 20 } )
   ::AddField ( "cCdpPrv", "C",  7, 0, {|| "@!" },         "CP",                      .f., "Código postal"           , 20 } )
   ::AddField ( "cTlfPrv", "C", 12, 0, {|| "@!" },         "Tlf",                     .f., "Teléfono"                ,  7 } )
   ::AddField ( "cTipDoc", "C", 10, 0, {|| "@!" },         "Tipo documento",          .f., "Tipo documento"          , 12 } )
   ::AddField ( "cDocFac", "C", 12, 0, {|| "@!" },         "Documento",               .f., "Documento"               , 12 } )
   ::AddField ( "dFecFac", "D",  8, 0, {|| "" },           "Fecha",                   .f., "Fecha factura"           ,  8 } )
   ::AddField ( "nBasFac", "N", 16, 6, {|| ::cPicOut },    "Base",                    .f., "Base"                    , 12 } )
   ::AddField ( "nIvaFac", "N", 16, 6, {|| ::cPicOut },    cImp(),                  .f., cImp()                  , 12 } )
   ::AddField ( "nReqFac", "N", 16, 6, {|| ::cPicOut },    "R.E.",                    .f., "R.E."                    , 12 } )
   ::AddField ( "nTotFac", "N", 16, 6, {|| ::cPicOut },    "Total",                   .f., "Total"                   , 12 } )
   ::AddField ( "nTotCob", "N", 16, 6, {|| ::cPicOut },    "Cobrado",                 .f., "Total cobrado"           , 12 } )
   ::AddField ( "cCodArt", "C", 18, 0, {|| "" },           "Código artículo",               .t., "Código artículo"         , 12 } )
   ::AddField ( "cNomArt", "C",100, 0, {|| "" },           "Nom. art.",               .t., "Nombre artículo"         , 30 } )
   ::AddField ( "nCajArt", "N", 16, 6, {|| ::cPicOut },    cNombreCajas(),            lUseCaj(), cNombreCajas()      , 12 } )
   ::AddField ( "nUndArt", "N", 16, 6, {|| ::cPicOut },    cNombreUnidades(),         lUseCaj(), cNombreUnidades()   , 12 } )
   ::AddField ( "nTotArt", "N", 16, 6, {|| ::cPicOut },    "Tot. " + cNombreUnidades(), .t., "Total " + cNombreUnidades(), 12 } )
   ::AddField ( "nImpArt", "N", 16, 6, {|| ::cPicOut },    "Tot. imp.",               .t., "Total importe"           , 12 } )

   ::AddTmpIndex( "cCodPrv", "cCodPrv + cCodArt" )
   ::AddGroup( {|| ::oDbf:cCodPrv }, {|| ::GetInfPrv() }, {||"Total proveedor..."} )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   /*
   Ficheros necesarios
   */

   DATABASE NEW ::oFacPrvT PATH ( cPatEmp() ) FILE  "FacPrvT.DBF" VIA ( cDriver() ) SHARED INDEX "FacPrvT.CDX"

   DATABASE NEW ::oFacPrvL PATH ( cPatEmp() ) FILE  "FacPrvL.DBF" VIA ( cDriver() ) SHARED INDEX "FacPrvL.CDX"

   DATABASE NEW ::oFacPrvP PATH ( cPatEmp() ) FILE  "FacPrvP.DBF" VIA ( cDriver() ) SHARED INDEX "FacPrvP.CDX"

   DATABASE NEW ::oAlbPrvT PATH ( cPatEmp() ) FILE  "AlbProvT.DBF" VIA ( cDriver() ) SHARED INDEX "AlbProvT.CDX"

   DATABASE NEW ::oAlbPrvL PATH ( cPatEmp() ) FILE  "AlbProvL.DBF" VIA ( cDriver() ) SHARED INDEX "AlbProvL.CDX"

   DATABASE NEW ::oDbfIva  PATH ( cPatDat() ) FILE  "TIVA.DBF" VIA ( cDriver() ) SHARED INDEX "TIVA.CDX"

   DATABASE NEW ::oDbfArt PATH ( cPatArt() ) FILE "ARTICULO.DBF" VIA ( cDriver() ) SHARED INDEX "ARTICULO.CDX"

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD CloseFiles()

   ::oFacPrvT:End()
   ::oFacPrvL:End()
   ::oFacPrvP:End()
   ::oAlbPrvT:End()
   ::oAlbPrvL:End()
   ::oDbfIva:End()
   ::oDbfArt:End()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Resource( cFld )

   if !::StdResource( "INF_GEN29C" )
      return .f.
   end if

   /*
   Montamos Prventes
   */

   ::oDefPrvInf( 70, 80, 90, 100 )

   /*
   Montamos Articulos
   */

   ::lDefArtInf( 150, 160, 170, 180 )

   REDEFINE CHECKBOX ::lSinVta ;
      ID       190;
      OF       ::oFld:aDialogs[1]

   REDEFINE GET ::nSinVta ;
      PICTURE  "999" ;
      SPINNER ;
      MIN      0 ;
      MAX      999 ;
      ID       200 ;
      OF       ::oFld:aDialogs[1]

   /*
   Damos valor al meter
   */

   ::oMtrInf:SetTotal( ::oDbfPrv:Lastrec() )

RETURN ( Self )

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   local aTotFac

   ::oDlg:Disable()

   ::oDbf:Zap()

   ::oFacPrvT:GetStatus()
   ::oFacPrvT:OrdSetFocus( "cCodPrv" )

   ::oAlbPrvT:GetStatus()
   ::oAlbPrvT:OrdSetFocus( "cCodPrv" )

   /*
   Nos movemos por las cabeceras de los facturas de Prventes-------------------
	*/

   ::aHeader   := {  {|| "Fecha     : " + Dtoc( Date() ) },;
                     {|| "Periodo   : " + Dtoc( ::dIniInf )   + " > " + Dtoc( ::dFinInf )    },;
                     {|| "Proveedor : " + Rtrim( ::cPrvOrg )  + " > " + Rtrim( ::cPrvDes )   },;
                     {|| "Artículos : " + Rtrim( ::cArtOrg )  + " > " + Rtrim( ::cArtDes ) } }

   ::oDbfPrv:GoTop()
   while !::oDbfPrv:Eof()

      if ::oDbfPrv:Cod >= ::cPrvOrg                         .and.;
         ::oDbfPrv:Cod <= ::cPrvDes

         ::GetFactura()
         ::GetAlbaran()

         do case
            case !Empty( ::dLasFac )                        .and.;
               ::dLasFac >= ::dLasAlb                       .and.;
               if( ::lSinVta, ( GetSysDate() - ::dLasFac ) >= ::nSinVta, .t. )

               ::AddFactura()

            case !Empty( ::dLasAlb )                        .and.;
               ::dLasAlb > ::dLasFac                        .and.;
               if( ::lSinVta, ( GetSysDate() - ::dLasFac ) >= ::nSinVta, .t. )

               ::AddAlbaran()

         end case

      end if

      ::oDbfPrv:Skip()

      ::oMtrInf:AutoInc( ::oDbfPrv:OrdKeyNo() )

   end while

   ::oFacPrvT:SetStatus()
   ::oAlbPrvT:SetStatus()

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//

METHOD GetInfPrv()

   local cTxt  := "Proveedor : " + Rtrim( ::oDbf:cCodPrv ) + " - " + Rtrim( oRetFld( ::oDbf:cCodPrv, ::oDbfPrv ) ) + " - "
         cTxt  += AllTrim( ::oDbf:cTipDoc ) + " : " + AllTrim( ::oDbf:cDocFac ) + " - "
         cTxt  += "Fecha : " + Dtoc( ::oDbf:dFecFac ) + " - "
         cTxt  += "Importe : " + Ltrim( Trans( ::oDbf:nBasFac, ::cPicOut ) )

RETURN ( cTxt )

//---------------------------------------------------------------------------//

METHOD GetFactura()

   local lGetFac  := .f.

   ::dLasFac      := Ctod( "" )

   if ::oFacPrvT:Seek( ::oDbfPrv:Cod )

      while ::oFacPrvT:cCodPrv == ::oDbfPrv:Cod .and. !::oFacPrvT:Eof()

         if ::oFacPrvT:dFecFac >= ::dIniInf           .and.;
            ::oFacPrvT:dFecFac <= ::dFinInf           .and.;
            lChkSer( ::oFacPrvT:cSerFac, ::aSer )      .and.;
            ::oFacPrvT:dFecFac > ::dLasFac

            ::cPrvFac   := ::oFacPrvT:cCodPrv
            ::dLasFac   := ::oFacPrvT:dFecFac
            ::cNumFac   := ::oFacPrvT:cSerFac + Str( ::oFacPrvT:nNumFac ) + ::oFacPrvT:cSufFac
            lGetFac     := .t.

         end if

         ::oFacPrvT:Skip()

      end while

   end if

RETURN ( lGetFac )

//---------------------------------------------------------------------------//

METHOD AddFactura()

   local aTotFac

   /*
   Si obtenemos un numero de factura valida
   */

   if ::oFacPrvL:Seek( ::cNumFac )

      while ::oFacPrvL:cSerFac + Str( ::oFacPrvL:nNumFac ) + ::oFacPrvL:cSufFac == ::cNumFac .and. !::oFacPrvL:Eof()

         /*
         Vemos si esta en el rango de las familias
         */

         if !Empty( ::oFacPrvL:cRef )                    .and. ;
            ::oFacPrvL:cRef >= ::cArtOrg                 .and. ;
            ::oFacPrvL:cRef <= ::cArtDes

            /*
            Ahora trabajamos con las linas de las factruras
            */

            if !::oDbf:Seek( ::cPrvFac + ::oFacPrvL:cRef )

               ::oDbf:Append()
               ::oDbf:Blank()

               ::oDbf:cCodPrv := ::oDbfPrv:Cod
               ::oDbf:cNomPrv := ::oDbfPrv:Titulo
               ::AddProveedor( ::oDbfPrv:Cod )
               ::oDbf:dFecFac := ::dLasFac
               ::oDbf:cCodArt := ::oFacPrvL:cRef

               ::oDbf:cTipDoc := "Factura"
               ::oDbf:cDocFac := StrTran( ::cNumFac, " ", "" )
               aTotFac        := aTotFacPrv( ::cNumFac, ::oFacPrvT:cAlias, ::oFacPrvL:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias, ::oFacPrvP:cAlias, nil, ::cDivInf )
               ::oDbf:nBasFac := aTotFac[ 1 ]
               ::oDbf:nIvaFac := aTotFac[ 2 ]
               ::oDbf:nReqFac := aTotFac[ 3 ]
               ::oDbf:nTotFac := aTotFac[ 4 ]

               ::oDbf:cNomArt := ::oFacPrvL:cDetalle

               ::oDbf:nCajArt := ::oFacPrvL:nCanEnt
               ::oDbf:nUndArt := ::oFacPrvL:nUniCaja
               ::oDbf:nTotArt := nTotNFacPrv( ::oFacPrvL )
               ::oDbf:nImpArt := nTotLFacPrv( ::oFacPrvL:cAlias, ::nDecOut, ::nDerOut )

               ::oDbf:Save()

            else

               ::oDbf:Load()

               ::oDbf:nCajArt += ::oFacPrvL:nCanEnt
               ::oDbf:nUndArt += ::oFacPrvL:nUniCaja
               ::oDbf:nTotArt += nTotNFacPrv( ::oFacPrvL )
               ::oDbf:nImpArt += nTotLFacPrv( ::oFacPrvL:cAlias, ::nDecOut, ::nDerOut )

               ::oDbf:Save()

            end if

         end if

         ::oFacPrvL:Skip()

      end while

   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD GetAlbaran()

   local lGetAlb  := .f.

   ::dLasAlb      := Ctod( "" )

   if ::oAlbPrvT:Seek( ::oDbfPrv:Cod )

      while ::oAlbPrvT:cCodPrv == ::oDbfPrv:Cod .and. !::oAlbPrvT:Eof()

         if !::oAlbPrvT:lFacturado                    .and.;
            ::oAlbPrvT:dFecAlb >= ::dIniInf           .and.;
            ::oAlbPrvT:dFecAlb <= ::dFinInf           .and.;
            lChkSer( ::oAlbPrvT:cSerAlb, ::aSer )     .and.;
            ::oAlbPrvT:dFecAlb > ::dLasAlb

            ::cPrvAlb   := ::oAlbPrvT:cCodPrv
            ::dLasAlb   := ::oAlbPrvT:dFecAlb
            ::cNumAlb   := ::oAlbPrvT:cSerAlb + Str( ::oAlbPrvT:nNumAlb ) + ::oAlbPrvT:cSufAlb
            lGetAlb     := .t.

         end if

         ::oAlbPrvT:Skip()

      end while

   end if

RETURN ( lGetAlb )

//---------------------------------------------------------------------------//

METHOD AddAlbaran()

   local aTotAlb

   /*
   Si obtenemos un numero de Albtura valida
   */

   if ::oAlbPrvL:Seek( ::cNumAlb )

      while ::oAlbPrvL:cSerAlb + Str( ::oAlbPrvL:nNumAlb ) + ::oAlbPrvL:cSufAlb == ::cNumAlb .and. !::oAlbPrvL:Eof()

         /*
         Vemos si esta en el rango de las familias
         */

         if !Empty( ::oAlbPrvL:cRef )                    .and.;
            ::oAlbPrvL:cRef >= ::cArtOrg                 .and.;
            ::oAlbPrvL:cRef <= ::cArtDes

            /*
            Ahora trabajamos con las linas de las Albtruras
            */

            if !::oDbf:Seek( ::cPrvAlb + ::oAlbPrvL:cRef )

               ::oDbf:Append()
               ::oDbf:Blank()

               ::oDbf:cCodPrv := ::oDbfPrv:Cod
               ::oDbf:cNomPrv := ::oDbfPrv:Titulo
               ::AddProveedor( ::oDbfPrv:Cod )
               ::oDbf:dFecFac := ::dLasAlb
               ::oDbf:cCodArt := ::oAlbPrvL:cRef

               ::oDbf:cTipDoc := "Albaran"
               ::oDbf:cDocFac := StrTran( ::cNumAlb, " ", "" )
               aTotAlb        := aTotAlbPrv( ::cNumAlb, ::oAlbPrvT:cAlias, ::oAlbPrvL:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias, ::cDivInf )
               ::oDbf:nBasFac := aTotAlb[ 1 ]
               ::oDbf:nIvaFac := aTotAlb[ 2 ]
               ::oDbf:nReqFac := aTotAlb[ 3 ]
               ::oDbf:nTotFac := aTotAlb[ 4 ]

               ::oDbf:cNomArt := ::oAlbPrvL:cDetalle

               ::oDbf:nCajArt := ::oAlbPrvL:nCanEnt
               ::oDbf:nUndArt := ::oAlbPrvL:nUniCaja
               ::oDbf:nTotArt := nTotNAlbPrv( ::oAlbPrvL )
               ::oDbf:nImpArt := nTotLAlbPrv( ::oAlbPrvL:cAlias, ::nDecOut, ::nDerOut )

               ::oDbf:Save()

            else

               ::oDbf:Load()

               ::oDbf:nCajArt += ::oAlbPrvL:nCanEnt
               ::oDbf:nUndArt += ::oAlbPrvL:nUniCaja
               ::oDbf:nTotArt += nTotNAlbPrv( ::oAlbPrvL )
               ::oDbf:nImpArt += nTotLAlbPrv( ::oAlbPrvL:cAlias, ::nDecOut, ::nDerOut )

               ::oDbf:Save()

            end if

         end if

         ::oAlbPrvL:Skip()

      end while

   end if

RETURN ( Self )

//---------------------------------------------------------------------------//