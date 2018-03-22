#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"
//---------------------------------------------------------------------------//

CLASS TIUltCom FROM TInfGen

   DATA  lSinCom     AS LOGIC    INIT .f.
   DATA  nSinCom     AS NUMERIC  INIT 15
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

   METHOD lResource( cFld )

   METHOD lGenerate()

   METHOD GetInfPrv()

   METHOD GetFactura()
   METHOD AddFactura()

   METHOD GetAlbaran()
   METHOD AddAlbaran()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField ( "cCodPrv", "C", 12, 0, {|| "@!" },         "Cód. Prv",                .f., "Código Prvente"          ,  8 )
   ::AddField ( "cNomPrv", "C", 50, 0, {|| "@!" },         "Prvente",                 .f., "Nombre Prvente"          , 25 )
   ::AddField ( "cNifPrv", "C", 15, 0, {|| "@!" },         "Nif",                     .f., "Nif"                     ,  8 )
   ::AddField ( "cDomPrv", "C", 35, 0, {|| "@!" },         "Domicilio",               .f., "Domicilio"               , 25 )
   ::AddField ( "cPobPrv", "C", 25, 0, {|| "@!" },         "Población",               .f., "Población"               , 20 )
   ::AddField ( "cProPrv", "C", 20, 0, {|| "@!" },         "Provincia",               .f., "Provincia"               , 20 )
   ::AddField ( "cCdpPrv", "C",  7, 0, {|| "@!" },         "CP",                      .f., "Código postal"           , 20 )
   ::AddField ( "cTlfPrv", "C", 12, 0, {|| "@!" },         "Tlf",                     .f., "Teléfono"                ,  7 )
   ::AddField ( "cTipDoc", "C", 10, 0, {|| "@!" },         "Tipo documento",          .f., "Tipo documento"          , 12 )
   ::AddField ( "cDocFac", "C", 12, 0, {|| "@!" },         "Documento",               .f., "Documento"               , 12 )
   ::AddField ( "dFecFac", "D",  8, 0, {|| "" },           "Fecha",                   .f., "Fecha factura"           ,  8 )
   ::AddField ( "nBasFac", "N", 16, 6, {|| ::cPicOut },    "Base",                    .f., "Base"                    , 12 )
   ::AddField ( "nIvaFac", "N", 16, 6, {|| ::cPicOut },    cImp(),                  .f., cImp()                  , 12 )
   ::AddField ( "nReqFac", "N", 16, 6, {|| ::cPicOut },    "R.E.",                    .f., "R.E."                    , 12 )
   ::AddField ( "nTotFac", "N", 16, 6, {|| ::cPicOut },    "Total",                   .f., "Total"                   , 12 )
   ::AddField ( "nTotCob", "N", 16, 6, {|| ::cPicOut },    "Cobrado",                 .f., "Total cobrado"           , 12 )
   ::AddField ( "cCodFam", "C", 16, 0, {|| "" },           "Cod. fam.",               .t., "Código família"          ,  8 )
   ::AddField ( "cNomFam", "C", 40, 0, {|| "" },           "Nom. fam.",               .t., "Nombre família"          , 20 )
   ::AddField ( "nCajFam", "N", 16, 6, {|| ::cPicOut },    cNombreCajas(),            lUseCaj(), cNombreCajas()      , 12 )
   ::AddField ( "nUndFam", "N", 16, 6, {|| ::cPicOut },    cNombreUnidades(),         lUseCaj(), cNombreUnidades()   , 12 )
   ::AddField ( "nTotFam", "N", 16, 6, {|| ::cPicOut },    "Tot. " + cNombreUnidades(),.t., "Total " + cNombreUnidades(), 12 )
   ::AddField ( "nImpFam", "N", 16, 6, {|| ::cPicOut },    "Tot. imp.",               .t., "Total importe"           , 12 )

   ::AddTmpIndex ( "cCodPrv", "cCodPrv + cCodFam" )
   ::AddGroup( {|| ::oDbf:cCodPrv }, {|| ::GetInfPrv() }, {||"Total Proveedor..."} )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   DATABASE NEW ::oFacPrvT PATH ( cPatEmp() ) FILE "FACPRVT.DBF"  VIA ( cDriver() ) SHARED INDEX "FACPRVT.CDX"

   DATABASE NEW ::oFacPrvL PATH ( cPatEmp() ) FILE "FACPRVL.DBF"  VIA ( cDriver() ) SHARED INDEX "FACPRVL.CDX"

   DATABASE NEW ::oFacPrvP PATH ( cPatEmp() ) FILE "FACPRVP.DBF"  VIA ( cDriver() ) SHARED INDEX "FACPRVP.CDX"

   DATABASE NEW ::oAlbPrvT PATH ( cPatEmp() ) FILE "ALBPROVT.DBF" VIA ( cDriver() ) SHARED INDEX "ALBPROVT.CDX"

   DATABASE NEW ::oAlbPrvL PATH ( cPatEmp() ) FILE "ALBPROVL.DBF" VIA ( cDriver() ) SHARED INDEX "ALBPROVL.CDX"

   DATABASE NEW ::oDbfIva  PATH ( cPatDat() ) FILE "TIVA.DBF"     VIA ( cDriver() ) SHARED INDEX "TIVA.CDX"

   DATABASE NEW ::oDbfArt  PATH ( cPatArt() ) FILE "ARTICULO.DBF" VIA ( cDriver() ) SHARED INDEX "ARTICULO.CDX"

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos" )
      ::CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles()

   if !Empty( ::oFacPrvT ) .and. ::oFacPrvT:Used()
      ::oFacPrvT:End()
   end if
   if !Empty( ::oFacPrvL ) .and. ::oFacPrvL:Used()
      ::oFacPrvL:End()
   end if
   if !Empty( ::oFacPrvP ) .and. ::oFacPrvP:Used()
      ::oFacPrvP:End()
   end if
   if !Empty( ::oAlbPrvT ) .and. ::oAlbPrvT:Used()
      ::oAlbPrvT:End()
   end if
   if !Empty( ::oAlbPrvL ) .and. ::oAlbPrvL:Used()
      ::oAlbPrvL:End()
   end if
   if !Empty( ::oDbfIva ) .and. ::oDbfIva:Used()
      ::oDbfIva:End()
   end if
   if !Empty( ::oDbfArt ) .and. ::oDbfArt:Used()
      ::oDbfArt:End()
   end if

   ::oFacPrvT := nil
   ::oFacPrvL := nil
   ::oFacPrvP := nil
   ::oAlbPrvT := nil
   ::oAlbPrvL := nil
   ::oDbfIva  := nil
   ::oDbfArt  := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld )

   if !::StdResource( "INF_GEN29A" )
      return .f.
   end if

   /*
   Montamos Prventes
   */

   ::oDefPrvInf( 70, 80, 90, 100, 900 )

   /*
   Montamos familias
   */

   ::lDefFamInf( 150, 160, 170, 180, 600 )

   REDEFINE CHECKBOX ::lSinCom ;
      ID       190;
      OF       ::oFld:aDialogs[1]

   REDEFINE GET ::nSinCom ;
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

   ::CreateFilter( aItmPrv(), ::oDbfPrv:cAlias )

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   local aTotFac
   local cExpHead := ""

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
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
                     {|| "Família   : " + Rtrim( ::cFamOrg )+ " > " + Rtrim( ::cFamDes ) } }

   ::oDbfPrv:OrdSetFocus( "COD" )

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       := ::oFilter:cExpresionFilter
   else
      cExpHead       := '.t.'
   end if

   ::oDbfPrv:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oDbfPrv:cFile ), ::oDbfPrv:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oDbfPrv:GoTop()

   while !::lBreak .and. !::oDbfPrv:Eof()

      if ( ::lAllPrv .or. ( ::oDbfPrv:Cod >= ::cPrvOrg .and. ::oDbfPrv:Cod <= ::cPrvDes ) )

         ::GetFactura()
         ::GetAlbaran()

         do case
            case !Empty( ::dLasFac )                        .and.;
               ::dLasFac >= ::dLasAlb                       .and.;
               if( ::lSinCom, ( GetSysDate() - ::dLasFac ) >= ::nSinCom, .t. )

               ::AddFactura()

            case !Empty( ::dLasAlb )                        .and.;
               ::dLasAlb > ::dLasFac                        .and.;
               if( ::lSinCom, ( GetSysDate() - ::dLasFac ) >= ::nSinCom, .t. )

               ::AddAlbaran()

         end case

      end if

      ::oDbfPrv:Skip()

      ::oMtrInf:AutoInc( ::oDbfPrv:OrdKeyNo() )

   end while

   ::oDbfPrv:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oDbfPrv:cFile ) )

   ::oMtrInf:AutoInc( ::oDbfPrv:LastRec() )

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
   local cCodFam

   /*
   Si obtenemos un numero de factura valida
   */

   if ::oFacPrvL:Seek( ::cNumFac )

      while ::oFacPrvL:cSerFac + Str( ::oFacPrvL:nNumFac ) + ::oFacPrvL:cSufFac == ::cNumFac .and. !::oFacPrvL:Eof()

         /*
         Obtenemos la familia
         */

         cCodFam  := RetFamArt( ::oFacPrvL:cRef, ::oDbfArt:cAlias )

         /*
         Vemos si esta en el rango de las familias
         */

         if ( ::lAllFam .or. ( cCodFam >= ::cFamOrg .and. cCodFam <= ::cFamDes ) )

            /*
            Ahora trabajamos con las linas de las factruras
            */

            if !::oDbf:Seek( ::cPrvFac + cCodFam )

               ::oDbf:Append()
               ::oDbf:Blank()

               ::oDbf:cCodPrv := ::oDbfPrv:Cod
               ::oDbf:cNomPrv := ::oDbfPrv:Titulo
               ::AddProveedor( ::oDbfPrv:Cod )
               ::oDbf:dFecFac := ::dLasFac
               ::oDbf:cCodFam := cCodFam

               ::oDbf:cTipDoc := "Factura"
               ::oDbf:cDocFac := StrTran( ::cNumFac, " ", "" )
               aTotFac        := aTotFacPrv( ::cNumFac, ::oFacPrvT:cAlias, ::oFacPrvL:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias, ::oFacPrvP:cAlias, nil, ::cDivInf )
               ::oDbf:nBasFac := aTotFac[ 1 ]
               ::oDbf:nIvaFac := aTotFac[ 2 ]
               ::oDbf:nReqFac := aTotFac[ 3 ]
               ::oDbf:nTotFac := aTotFac[ 4 ]

               ::oDbf:cNomFam := Rtrim( oRetFld( cCodFam, ::oDbfFam ) )

               ::oDbf:nCajFam := ::oFacPrvL:nCanEnt
               ::oDbf:nUndFam := ::oFacPrvL:nUniCaja
               ::oDbf:nTotFam := nTotNFacPrv( ::oFacPrvL )
               ::oDbf:nImpFam := nTotLFacPrv( ::oFacPrvL:cAlias, ::nDecOut, ::nDerOut )

               ::oDbf:Save()

            else

               ::oDbf:Load()

               ::oDbf:nCajFam += ::oFacPrvL:nCanEnt
               ::oDbf:nUndFam += ::oFacPrvL:nUniCaja
               ::oDbf:nTotFam += nTotNFacPrv( ::oFacPrvL )
               ::oDbf:nImpFam += nTotLFacPrv( ::oFacPrvL:cAlias, ::nDecOut, ::nDerOut )

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
   local cCodFam

   /*
   Si obtenemos un numero de Albtura valida
   */

   if ::oAlbPrvL:Seek( ::cNumAlb )

      while ::oAlbPrvL:cSerAlb + Str( ::oAlbPrvL:nNumAlb ) + ::oAlbPrvL:cSufAlb == ::cNumAlb .and. !::oAlbPrvL:Eof()

         /*
         Obtenemos la familia
         */

         cCodFam  := RetFamArt( ::oAlbPrvL:cRef, ::oDbfArt:cAlias )

         /*
         Vemos si esta en el rango de las familias
         */

         if ( ::lAllFam .or. ( cCodFam >= ::cFamOrg .and. cCodFam <= ::cFamDes ) )

            /*
            Ahora trabajamos con las linas de las Albtruras
            */

            if !::oDbf:Seek( ::cPrvAlb + cCodFam )

               ::oDbf:Append()
               ::oDbf:Blank()

               ::oDbf:cCodPrv := ::oDbfPrv:Cod
               ::oDbf:cNomPrv := ::oDbfPrv:Titulo
               ::AddProveedor( ::oDbfPrv:Cod )
               ::oDbf:dFecFac := ::dLasAlb
               ::oDbf:cCodFam := cCodFam

               ::oDbf:cTipDoc := "Albaran"
               ::oDbf:cDocFac := StrTran( ::cNumAlb, " ", "" )
               aTotAlb        := aTotAlbPrv( ::cNumAlb, ::oAlbPrvT:cAlias, ::oAlbPrvL:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias, ::cDivInf )
               ::oDbf:nBasFac := aTotAlb[ 1 ]
               ::oDbf:nIvaFac := aTotAlb[ 2 ]
               ::oDbf:nReqFac := aTotAlb[ 3 ]
               ::oDbf:nTotFac := aTotAlb[ 4 ]

               ::oDbf:cNomFam := Rtrim( oRetFld( cCodFam, ::oDbfFam ) )

               ::oDbf:nCajFam := ::oAlbPrvL:nCanEnt
               ::oDbf:nUndFam := ::oAlbPrvL:nUniCaja
               ::oDbf:nTotFam := nTotNAlbPrv( ::oAlbPrvL )
               ::oDbf:nImpFam := nTotLAlbPrv( ::oAlbPrvL:cAlias, ::nDecOut, ::nDerOut )

               ::oDbf:Save()

            else

               ::oDbf:Load()

               ::oDbf:nCajFam += ::oAlbPrvL:nCanEnt
               ::oDbf:nUndFam += ::oAlbPrvL:nUniCaja
               ::oDbf:nTotFam += nTotNAlbPrv( ::oAlbPrvL )
               ::oDbf:nImpFam += nTotLAlbPrv( ::oAlbPrvL:cAlias, ::nDecOut, ::nDerOut )

               ::oDbf:Save()

            end if

         end if

         ::oAlbPrvL:Skip()

      end while

   end if

RETURN ( Self )

//---------------------------------------------------------------------------//


































































































































































































































