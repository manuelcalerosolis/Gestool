#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"
//---------------------------------------------------------------------------//

CLASS TIUltFam FROM TInfGen

   DATA  lSinVta     AS LOGIC    INIT .f.
   DATA  nSinVta     AS NUMERIC  INIT 15
   DATA  oFacCliT    AS OBJECT
   DATA  oFacCliL    AS OBJECT
   DATA  oFacCliP    AS OBJECT
   DATA  oAlbCliT    AS OBJECT
   DATA  oAlbCliL    AS OBJECT
   DATA  oAntCliT    AS OBJECT
   DATA  oDbfIva     AS OBJECT
   DATA  cAgeDoc     AS CHARACTER     INIT ""
   DATA  cCliDoc     AS CHARACTER     INIT ""
   DATA  cNomDoc     AS CHARACTER     INIT ""
   DATA  dLasDoc
   DATA  cNumDoc     AS CHARACTER     INIT ""
   DATA  cTipDoc     AS CHARACTER     INIT ""

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

   METHOD GetInfCli()

   METHOD GetDocument()
   METHOD AddDocument()

   METHOD AddEmpty()
   METHOD AddFactura()
   METHOD AddAlbaran()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField ( "cCodAge", "C",  3, 0, {|| "@!" },         "Cód. age.",               .f., "Código agente"           ,  8 )
   ::AddField ( "cNomAge", "C", 50, 0, {|| "@!" },         "Agente",                  .f., "Nombre agente"           , 25 )
   ::AddField ( "cCodCli", "C", 12, 0, {|| "@!" },         "Cód. cli",                .f., "Código cliente"          ,  8 )
   ::AddField ( "cNomCli", "C", 50, 0, {|| "@!" },         "Cliente",                 .f., "Nombre cliente"          , 25 )
   ::AddField ( "cNifCli", "C", 15, 0, {|| "@!" },         "Nif",                     .f., "Nif"                     ,  8 )
   ::AddField ( "cDomCli", "C", 35, 0, {|| "@!" },         "Domicilio",               .f., "Domicilio"               , 25 )
   ::AddField ( "cPobCli", "C", 25, 0, {|| "@!" },         "Población",               .f., "Población"               , 20 )
   ::AddField ( "cProCli", "C", 20, 0, {|| "@!" },         "Provincia",               .f., "Provincia"               , 20 )
   ::AddField ( "cCdpCli", "C",  7, 0, {|| "@!" },         "CP",                      .f., "Código postal"           , 20 )
   ::AddField ( "cTlfCli", "C", 12, 0, {|| "@!" },         "Tlf",                     .f., "Teléfono"                ,  7 )
   ::AddField ( "cTipDoc", "C", 10, 0, {|| "@!" },         "Tipo documento",          .f., "Tipo documento"          , 12 )
   ::AddField ( "cDocFac", "C", 12, 0, {|| "@!" },         "Documento",               .f., "Documento"               , 12 )
   ::AddField ( "dFecFac", "D",  8, 0, {|| "" },           "Fecha",                   .f., "Fecha factura"           , 10 )
   ::AddField ( "nBasFac", "N", 16, 6, {|| ::cPicOut },    "Base",                    .f., "Base"                    , 12 )
   ::AddField ( "nIvaFac", "N", 16, 6, {|| ::cPicOut },    cImp(),                  .f., cImp()                  , 12 )
   ::AddField ( "nReqFac", "N", 16, 6, {|| ::cPicOut },    "R.E.",                    .f., "R.E."                    , 12 )
   ::AddField ( "nTotFac", "N", 16, 6, {|| ::cPicOut },    "Total",                   .f., "Total"                   , 12 )
   ::AddField ( "nTotCob", "N", 16, 6, {|| ::cPicOut },    "Cobrado",                 .f., "Total cobrado"           , 12 )
   ::AddField ( "cCodFam", "C", 16, 0, {|| "" },           "Cod. fam.",               .t., "Código família"          ,  8 )
   ::AddField ( "cNomFam", "C", 40, 0, {|| "" },           "Nom. família",            .t., "Nombre família"          , 30 )
   ::AddField ( "cCodAlm", "C",  3, 0, {|| "" },           "Alm.",                    .t., "Código almecén"          ,  4 )
   ::AddField ( "nCajArt", "N", 16, 6, {|| ::cPicOut },    cNombreCajas(),            lUseCaj(), cNombreCajas()      , 12 )
   ::AddField ( "nUndArt", "N", 16, 6, {|| ::cPicOut },    cNombreunidades(),         lUseCaj(), cNombreunidades()   , 12 )
   ::AddField ( "nTotArt", "N", 16, 6, {|| ::cPicOut },    "Tot. " + cNombreunidades(),.t., "Total " + cNombreunidades() , 12 )
   ::AddField ( "nImpArt", "N", 16, 6, {|| ::cPicOut },    "Tot. imp.",               .t., "Total importe"           , 12 )

   ::AddTmpIndex( "cCodAge", "cCodAge + cCodCli + cCodFam" )

   ::AddGroup( {|| ::oDbf:cCodAge }, {|| "Agente : " + Rtrim( ::oDbf:cCodAge ) + "-" + Rtrim( oRetFld( ::oDbf:cCodAge, ::oDbfAge ) ) }, {||"Total agente..."} )
   ::AddGroup( {|| ::oDbf:cCodAge + ::oDbf:cCodCli }, {|| ::GetInfCli() }, {||"Total cliente..."} )


RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   ::oFacCliT     := TDataCenter():oFacCliT() 

   DATABASE NEW ::oFacCliL PATH ( cPatEmp() ) FILE  "FACCLIL.DBF"  VIA ( cDriver() ) SHARED INDEX "FACCLIL.CDX"

   ::oFacCliP := TDataCenter():oFacCliP()

   ::oAlbCliT := TDataCenter():oAlbCliT()

   DATABASE NEW ::oAlbCliL PATH ( cPatEmp() ) FILE  "ALBCLIL.DBF"  VIA ( cDriver() ) SHARED INDEX "ALBCLIL.CDX"

   DATABASE NEW ::oAntCliT PATH ( cPatEmp() ) FILE  "ANTCLIT.DBF"  VIA ( cDriver() ) SHARED INDEX "ANTCLIT.CDX"

   DATABASE NEW ::oDbfIva  PATH ( cPatDat() ) FILE  "TIVA.DBF"     VIA ( cDriver() ) SHARED INDEX "TIVA.CDX"

   DATABASE NEW ::oDbfArt  PATH ( cPatArt() ) FILE  "ARTICULO.DBF" VIA ( cDriver() ) SHARED INDEX "ARTICULO.CDX"

   RECOVER

      msgStop( 'Imposible abrir todas las bases de datos' )
      ::CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles()

   if !Empty( ::oFacCliT ) .and. ::oFacCliT:Used()
      ::oFacCliT:End()
   end if
   if !Empty( ::oFacCliL ) .and. ::oFacCliL:Used()
      ::oFacCliL:End()
   end if
   if !Empty( ::oFacCliP ) .and. ::oFacCliP:Used()
      ::oFacCliP:End()
   end if
   if !Empty( ::oAlbCliT ) .and. ::oAlbCliT:Used()
      ::oAlbCliT:End()
   end if
   if !Empty( ::oAlbCliL ) .and. ::oAlbCliL:Used()
      ::oAlbCliL:End()
   end if
   if !Empty( ::oDbfIva ) .and. ::oDbfIva:Used()
      ::oDbfIva:End()
   end if
   if !Empty( ::oDbfArt ) .and. ::oDbfArt:Used()
      ::oDbfArt:End()
   end if
   if !Empty( ::oAntCliT ) .and. ::oAntCliT:Used()
      ::oAntCliT:End()
   end if

   ::oFacCliT := nil
   ::oFacCliL := nil
   ::oFacCliP := nil
   ::oAlbCliT := nil
   ::oAlbCliL := nil
   ::oAntCliT := nil
   ::oDbfIva  := nil
   ::oDbfArt  := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld )

   if !::StdResource( "INF_GEN29" )
      return .f.
   end if

   /*
   Montamos agentes
   */

   if !::oDefAgeInf( 110, 120, 130, 140, 620 )
      return .f.
   end if

   /*
   Montamos clientes
   */

   if !::oDefCliInf( 70, 80, 90, 100, , 600 )
      return .f.
   end if

   /*
   Montamos familias
   */

   if !::lDefFamInf( 150, 160, 170, 180, 610 )
      return .f.
   end if

   REDEFINE CHECKBOX ::lSinVta ;
      ID       190;
      OF       ::oFld:aDialogs[1]

   REDEFINE GET ::nSinVta ;
      PICTURE  "999" ;
      WHEN     ::lSinVta ;
      SPINNER ;
      MIN      0 ;
      MAX      999 ;
      ID       200 ;
      OF       ::oFld:aDialogs[1]

   /*
   Damos valor al meter
   */

   ::oMtrInf:SetTotal( ::oDbfCli:Lastrec() )

   ::CreateFilter( aItmCli(), ::oDbfCli:cAlias )

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

   ::oFacCliT:GetStatus()
   ::oFacCliT:OrdSetFocus( "cCodCli" )

   ::oAlbCliT:GetStatus()
   ::oAlbCliT:OrdSetFocus( "cCodCli" )

   /*
   Nos movemos por las cabeceras de los facturas de Clientes-------------------
	*/

   ::aHeader   := {  {|| "Fecha     : " + Dtoc( Date() ) },;
                     {|| "Periodo   : " + Dtoc( ::dIniInf )   + " > " + Dtoc( ::dFinInf )    },;
                     {|| "Cliente   : " + Rtrim( ::cCliOrg )  + " > " + Rtrim( ::cCliDes )   },;
                     {|| "Agente    : " + Rtrim( ::cAgeOrg )  + " > " + Rtrim( ::cAgeDes )   },;
                     {|| "Família   : " + Rtrim( ::cFamOrg )  + " > " + Rtrim( ::cFamDes ) } }

   ::oDbfCli:OrdSetFocus( "COD" )

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       := ::oFilter:cExpresionFilter
   else
      cExpHead       := '.t.'
   end if

   ::oDbfCli:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oDbfCli:cFile ), ::oDbfCli:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oDbfCli:GoTop()
   while !::lBreak .and. !::oDbfCli:Eof()

      if ( ::lAllCli .or. ( ::oDbfCli:Cod >= ::cCliOrg .AND. ::oDbfCli:Cod <= ::cCliDes ) )         .AND.;
         ( ::lAgeAll .or. ( ::oDbfCli:cAgente >= ::cAgeOrg .and. ::oDbfCli:cAgente <= ::cAgeDes ) )

         ::GetDocument()

         if ::lSinVta

            if Empty( ::dLasDoc ) .or. ( GetSysDate() - ::dLasDoc ) >= ::nSinVta
               ::AddDocument()
            end if

         else

            if !Empty( ::dLasDoc )
               ::AddDocument()
            end if

         end if

      end if

      ::oDbfCli:Skip()

      ::oMtrInf:AutoInc( ::oDbfCli:OrdKeyNo() )

   end while

   ::oDbfCli:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oDbfCli:cFile ) )

   ::oMtrInf:AutoInc( ::oDbfCli:LastRec() )

   ::oFacCliT:SetStatus()
   ::oAlbCliT:SetStatus()

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//

METHOD GetInfCli()

   local cTxt  := "Cliente : " + Rtrim( ::oDbf:cCodCli ) + " - " + Rtrim( oRetFld( ::oDbf:cCodCli, ::oDbfCli ) ) + " - "
         cTxt  += AllTrim( ::oDbf:cTipDoc ) + " : " + AllTrim( ::oDbf:cDocFac ) + " - "
         cTxt  += "Fecha : " + Dtoc( ::oDbf:dFecFac )

RETURN ( cTxt )

//---------------------------------------------------------------------------//

METHOD GetDocument()

   ::cCliDoc      := ::oDbfCli:Cod
   ::cNomDoc      := ::oDbfCli:Titulo
   ::cAgeDoc      := ::oDbfCli:cAgente
   ::dLasDoc      := Ctod( "" )
   ::cNumDoc      := ""
   ::cTipDoc      := ""

   if ::oAlbCliT:Seek( ::oDbfCli:Cod )

      while ::oAlbCliT:cCodCli == ::oDbfCli:Cod .and. !::oAlbCliT:Eof()

         if !lFacturado( ::oAlbCliT )                                                                    .AND.;
            ( ::lAgeAll .or. ( ::oAlbCliT:cCodAge >= ::cAgeOrg .and. ::oAlbCliT:cCodAge <= ::cAgeDes ) ) .AND.;
            ::oAlbCliT:dFecAlb >= ::dIniInf                                                              .AND.;
            ::oAlbCliT:dFecAlb <= ::dFinInf                                                              .AND.;
            lChkSer( ::oAlbCliT:cSerAlb, ::aSer )                                                        .AND.;
            ::oAlbCliT:dFecAlb >= ::dLasDoc

            ::cAgeDoc   := ::oAlbCliT:cCodAge
            ::cCliDoc   := ::oAlbCliT:cCodCli
            ::dLasDoc   := ::oAlbCliT:dFecAlb
            ::cNumDoc   := ::oAlbCliT:cSerAlb + Str( ::oAlbCliT:nNumAlb ) + ::oAlbCliT:cSufAlb
            ::cTipDoc   := "Albaran"

         end if

         ::oAlbCliT:Skip()

      end while

   end if

   if ::oFacCliT:Seek( ::oDbfCli:Cod )

      while ::oFacCliT:cCodCli == ::oDbfCli:Cod .and. !::oFacCliT:Eof()

         if ( ::lAgeAll .or. ( ::oFacCliT:cCodAge >= ::cAgeOrg .and. ::oFacCliT:cCodAge <= ::cAgeDes ) ) .AND.;
            ::oFacCliT:dFecFac >= ::dIniInf                                                              .AND.;
            ::oFacCliT:dFecFac <= ::dFinInf                                                              .AND.;
            lChkSer( ::oFacCliT:cSerie, ::aSer )                                                         .AND.;
            ::oFacCliT:dFecFac >= ::dLasDoc

            ::cAgeDoc   := ::oFacCliT:cCodAge
            ::cCliDoc   := ::oFacCliT:cCodCli
            ::dLasDoc   := ::oFacCliT:dFecFac
            ::cNumDoc   := ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac
            ::cTipDoc   := "Factura"

         end if

         ::oFacCliT:Skip()

      end while

   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD AddDocument()

   do case
      case ::cTipDoc == ""
         ::AddEmpty()
      case ::cTipDoc == "Factura"
         ::AddFactura()
      case ::cTipDoc == "Albaran"
         ::AddAlbaran()
   end case

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD AddFactura()

   local cCodFam
   local aTotFac

   /*
   Si obtenemos un numero de factura valida
   */

   if ::oFacCliL:Seek( ::cNumDoc )

      while ::oFacCliL:cSerie + Str( ::oFacCliL:nNumFac ) + ::oFacCliL:cSufFac == ::cNumDoc .and. !::oFacCliL:Eof()

         /*
         Obtenemos la familia
         */

         cCodFam              := RetFamArt( ::oFacCliL:cRef, ::oDbfArt:cAlias )

         /*
         Vemos si esta en el rango de las familias
         */

         if !Empty( cCodFam )                                                       .and.;
            ( ::lAllFam .or. ( cCodFam >= ::cFamOrg .and. cCodFam <= ::cFamDes ) )

            /*
            Ahora trabajamos con las linas de las factruras
            */

            if !::oDbf:Seek( ::cAgeDoc + ::cCliDoc + cCodFam )

               ::oDbf:Append()
               ::oDbf:Blank()

               ::oDbf:cTipDoc := "Factura"
               ::oDbf:dFecFac := ::dLasDoc

               ::oDbf:dFecFac := ::dLasDoc
               ::oDbf:cCodAge := ::cAgeDoc
               ::oDbf:cCodCli := ::cCliDoc
               ::oDbf:cNomCli := ::cNomDoc

               ::AddCliente( ::cCliDoc, ::oFacCliT )

               ::oDbf:cDocFac := StrTran( ::oFacCliL:cSerie + "/" + Str( ::oFacCliL:nNumFac ) + "/" + ::oFacCliL:cSufFac, " ", "" )
               aTotFac        := aTotFacCli( ::cNumDoc, ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias, ::oFacCliP:cAlias, ::oAntCliT:cAlias )
               ::oDbf:nBasFac := aTotFac[ 1 ] - aTotFac[ 5 ] - aTotFac[ 6 ]
               ::oDbf:nIvaFac := aTotFac[ 2 ]
               ::oDbf:nReqFac := aTotFac[ 3 ]
               ::oDbf:nTotFac := aTotFac[ 4 ]

               ::oDbf:cCodFam := cCodFam
               ::oDbf:cNomFam := Rtrim( oRetFld( cCodFam, ::oDbfFam ) )

               ::oDbf:nCajArt := ::oFacCliL:nCanEnt
               ::oDbf:nUndArt := ::oFacCliL:nUniCaja
               ::oDbf:nTotArt := nTotNFacCli( ::oFacCliL )
               ::oDbf:nImpArt := nTotLFacCli( ::oFacCliL:cAlias, ::nDecOut, ::nDerOut )
               ::oDbf:cCodAlm := ::oFacCliL:cAlmLin

               ::oDbf:Save()

            else

               ::oDbf:Load()

               ::oDbf:nCajArt += ::oFacCliL:nCanEnt
               ::oDbf:nUndArt += ::oFacCliL:nUniCaja
               ::oDbf:nTotArt += nTotNFacCli( ::oFacCliL )
               ::oDbf:nImpArt += nTotLFacCli( ::oFacCliL:cAlias, ::nDecOut, ::nDerOut )

               ::oDbf:Save()

            end if

         end if

         ::oFacCliL:Skip()

      end while

   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD AddAlbaran()

   local cCodFam
   local aTotAlb

   /*
   Si obtenemos un numero de Albtura valida
   */

   if ::oAlbCliL:Seek( ::cNumDoc )

      while ::oAlbCliL:cSerAlb + Str( ::oAlbCliL:nNumAlb ) + ::oAlbCliL:cSufAlb == ::cNumDoc .and. !::oAlbCliL:Eof()

         /*
         Obtenemos la familia
         */

         cCodFam              := RetFamArt( ::oFacCliL:cRef, ::oDbfArt:cAlias )

         /*
         Vemos si esta en el rango de las familias
         */

         if !Empty( cCodFam )                                                         .and.;
            ( ::lAllFam .or. ( cCodFam >= ::cFamOrg .and. cCodFam <= ::cFamDes ) )

            /*
            Ahora trabajamos con las linas de las Albtruras
            */

            if !::oDbf:Seek( ::cAgeDoc + ::cCliDoc + cCodFam )

               ::oDbf:Append()
               ::oDbf:Blank()

               ::oDbf:cTipDoc := "Albaran"

               ::oDbf:dFecFac := ::dLasDoc
               ::oDbf:cCodAge := ::cAgeDoc
               ::oDbf:cCodCli := ::cCliDoc
               ::oDbf:cNomCli := ::cNomDoc

               ::AddCliente( ::cCliDoc, ::oAlbCliT )

               ::oDbf:cDocFac := StrTran( ::oAlbCliL:cSerAlb + "/" + Str( ::oAlbCliL:nNumAlb ) + "/" + ::oAlbCliL:cSufAlb, " ", "" )
               aTotAlb        := aTotAlbCli( ::cNumDoc, ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias, ::cDivInf )
               ::oDbf:nBasFac := aTotAlb[ 1 ] - aTotAlb[ 5 ] - aTotAlb[ 6 ]
               ::oDbf:nIvaFac := aTotAlb[ 2 ]
               ::oDbf:nReqFac := aTotAlb[ 3 ]
               ::oDbf:nTotFac := aTotAlb[ 4 ]

               ::oDbf:cCodFam := cCodFam
               ::oDbf:cNomFam := Rtrim( oRetFld( cCodFam, ::oDbfFam ) )

               ::oDbf:nCajArt := ::oAlbCliL:nCanEnt
               ::oDbf:nUndArt := ::oAlbCliL:nUniCaja
               ::oDbf:nTotArt := nTotNAlbCli( ::oAlbCliL )
               ::oDbf:nImpArt := nTotLAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut )
               ::oDbf:cCodAlm := ::oAlbCliL:cAlmLin

               ::oDbf:Save()

            else

               ::oDbf:Load()

               ::oDbf:nCajArt += ::oAlbCliL:nCanEnt
               ::oDbf:nUndArt += ::oAlbCliL:nUniCaja
               ::oDbf:nTotArt += nTotNAlbCli( ::oAlbCliL )
               ::oDbf:nImpArt += nTotLAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut )

               ::oDbf:Save()

            end if

         end if

         ::oAlbCliL:Skip()

      end while

   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD AddEmpty()

   ::oDbf:Append()
   ::oDbf:Blank()

   ::oDbf:cTipDoc := ""
   ::oDbf:dFecFac := ::dLasDoc
   ::oDbf:cCodAge := ::cAgeDoc
   ::oDbf:cCodCli := ::cCliDoc
   ::oDbf:cNomCli := ::cNomDoc

   ::oDbf:Save()

RETURN ( Self )

//---------------------------------------------------------------------------//