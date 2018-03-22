#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS OInfBRap FROM TPrvInf

   DATA  oAlbPrvT    AS OBJECT
   DATA  oAlbPrvL    AS OBJECT
   DATA  oFacPrvT    AS OBJECT
   DATA  oFacPrvL    AS OBJECT
   DATA  oFacPrvP    AS OBJECT

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField( "cTipDoc", "C", 10, 0, {|| "@!" },       "Tipo documento",            .t., "Tipo documento",             12, .f. )
   ::AddField( "cDocMov", "C", 14, 0, {|| "@!" },       "Doc.",                      .t., "Documento",                   8, .f. )
   ::AddField( "dFecMov", "D",  8, 0, {|| "@!" },       "Fecha",                     .t., "Fecha",                      10, .f. )
   ::AddField( "cCodPrv", "C", 12, 0, {|| "@!" },       "Prv.",                      .f., "Cod. Proveedor",              9 )
   ::AddField( "cNomPrv", "C", 50, 0, {|| "@!" },       "Proveedor",                 .f., "Nombre Proveedor",           35 )
   ::AddField( "cNifPrv", "C", 15, 0, {|| "@!" },       "Nif",                       .f., "Nif",                        15 )
   ::AddField( "cDomPrv", "C", 35, 0, {|| "@!" },       "Domicilio",                 .f., "Domicilio",                  35 )
   ::AddField( "cPobPrv", "C", 25, 0, {|| "@!" },       "Población",                 .f., "Población",                  25 )
   ::AddField( "cProPrv", "C", 20, 0, {|| "@!" },       "Provincia",                 .f., "Provincia",                  20 )
   ::AddField( "cCdpPrv", "C",  7, 0, {|| "@!" },       "CP",                        .f., "Cod. Postal",                 7 )
   ::AddField( "cTlfPrv", "C", 12, 0, {|| "@!" },       "Tlf",                       .f., "Teléfono",                   12 )
   ::AddField( "cCodArt", "C", 18, 0, {|| "@!" },       "Art.",                      .t., "Cod. artículo",              14, .f. )
   ::AddField( "cNomArt", "C",100, 0, {|| "@!" },       "Artículo",                  .t., "Artículo",                   40, .f. )
   ::AddField( "cCodAlm", "C",  3, 0, {|| "@!" },       "Alm",                       .t., "Cod. almacén",                3, .f. )
   ::AddField( "nComRap", "N", 16, 6, {|| ::cPicOut },  "% Rap.",                    .t., "Comisión rappels",           12, .f. )
   ::AddField( "nImpTot", "N", 16, 6, {|| ::cPicOut },  "Importe",                   .t., "Importe",                    12, .t. )
   ::AddField( "nTotRap", "N", 16, 6, {|| ::cPicOut },  "Total Rap.",                .t., "Total rappels",              12, .t. )

   ::AddTmpIndex( "cCodPrv", "cCodPrv + cCodArt" )
   ::AddGroup( {|| ::oDbf:cCodPrv }, {|| "Proveedor : " + Rtrim( ::oDbf:cCodPrv ) + "-" + Rtrim( ::oDbf:cNomPrv ) }, {||"Total proveedor..."} )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   DATABASE NEW ::oAlbPrvT PATH ( cPatEmp() ) FILE "ALBPROVT.DBF" VIA ( cDriver() ) SHARED INDEX "ALBPROVT.CDX"

   DATABASE NEW ::oAlbPrvL PATH ( cPatEmp() ) FILE "ALBPROVL.DBF" VIA ( cDriver() ) SHARED INDEX "ALBPROVL.CDX"

   DATABASE NEW ::oFacPrvT PATH ( cPatEmp() ) FILE "FACPRVT.DBF" VIA ( cDriver() ) SHARED INDEX "FACPRVT.CDX"

   DATABASE NEW ::oFacPrvL PATH ( cPatEmp() ) FILE "FACPRVL.DBF" VIA ( cDriver() ) SHARED INDEX "FACPRVL.CDX"

   DATABASE NEW ::oFacPrvP PATH ( cPatEmp() ) FILE "FACPRVP.DBF" VIA ( cDriver() ) SHARED INDEX "FACPRVP.CDX"

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos" )
      ::CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles()

   if !Empty( ::oAlbPrvT ) .and. ::oAlbPrvT:Used()
      ::oAlbPrvT:End()
   end if
   if !Empty( ::oAlbPrvL ) .and. ::oAlbPrvL:Used()
      ::oAlbPrvL:End()
   end if
   if !Empty( ::oFacPrvT ) .and. ::oFacPrvT:Used()
      ::oFacPrvT:End()
   end if
   if !Empty( ::oFacPrvL ) .and. ::oFacPrvL:Used()
      ::oFacPrvL:End()
   end if
   if !Empty( ::oFacPrvP ) .and. ::oFacPrvP:Used()
      ::oFacPrvP:End()
   end if

   ::oAlbPrvT := nil
   ::oAlbPrvL := nil
   ::oFacPrvT := nil
   ::oFacPrvL := nil
   ::oFacPrvP := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld )

   if !::StdResource( "INFRAPP" )
      return .f.
   end if

   ::CreateFilter( aItmCompras(), { ::oAlbPrvT, ::oFacPrvT }, .t. )

   /*
   Monta los obras de manera automatica
   */

   if !::oDefPrvInf( 70, 80, 90, 100, 600 )
      return .f.
   end if

   /*
   Monta los clientes de manera automatica
   */

   if !::lDefArtInf( 110, 120, 130, 140, 800 )
      return .f.
   end if

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   local cExpHead := ""

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   ::aHeader   := {  {|| "Fecha     : " + Dtoc( Date() ) },;
                     {|| "Periodo   : " + Dtoc( ::dIniInf )   + " > " + Dtoc( ::dFinInf ) },;
                     {|| "Proveedor : " + if( ::lAllPrv, "Todos", AllTrim( ::cPrvOrg ) + " > " + AllTrim (::cPrvDes ) ) },;
                     {|| "Artículos : " + if( ::lAllArt, "Todos", AllTrim( ::cArtOrg ) + " > " + AllTrim (::cArtDes ) ) } }


   ::oAlbPrvT:OrdSetFocus( "dFecAlb" )

   cExpHead          := '!lFacturado .and. dFecAlb >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecAlb <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   if !::lAllPrv
      cExpHead       += ' .and. cCodPrv >= "' + ::cPrvOrg + '" .and. cCodPrv <= "' + ::cPrvDes + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter ) 
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oAlbPrvT:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oAlbPrvT:cFile ), ::oAlbPrvT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:cText   := "Procesando albaranes"
   ::oMtrInf:SetTotal( ::oAlbPrvT:OrdKeyCount() )

   ::oAlbPrvT:GoTop()

   while !::lBreak .and. !::oAlbPrvT:Eof()

      if lChkSer( ::oAlbPrvT:cSerAlb, ::aSer )

         if ::oAlbPrvL:Seek( ::oAlbPrvT:cSerAlb + Str( ::oAlbPrvT:nNumAlb ) + ::oAlbPrvT:cSufAlb )

            while ::oAlbPrvT:cSerAlb + Str( ::oAlbPrvT:nNumAlb ) + ::oAlbPrvT:cSufAlb == ::oAlbPrvL:cSerAlb + Str( ::oAlbPrvL:nNumAlb ) + ::oAlbPrvL:cSufAlb .AND. ! ::oAlbPrvL:eof()

               ::oDbf:Append()

               ::oDbf:cTipDoc := "Albarán"
               ::oDbf:cDocMov := AllTrim( ::oAlbPrvT:cSerAlb ) + "/" + AllTrim( Str( ::oAlbPrvT:nNumAlb ) ) + "/" + AllTrim( ::oAlbPrvT:cSufAlb )
               ::oDbf:dFecMov := ::oAlbPrvT:dFecAlb
               ::oDbf:cCodArt := ::oAlbPrvL:cRef
               ::oDbf:cNomArt := ::oAlbPrvL:cDetalle
               ::oDbf:cCodAlm := ::oAlbPrvL:cAlmLin
               ::oDbf:nComRap := ::oAlbPrvL:nDtoRap
               ::oDbf:nImpTot := nTotLAlbPrv( ::oAlbPrvL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
               ::oDbf:nTotRap := ( ::oDbf:nImpTot * ::oDbf:nComRap ) / 100
               ::AddProveedor( ::oAlbPrvT:cCodPrv )

               ::oDbf:Save()

               ::oAlbPrvL:Skip()

            end while

         end if

      end if

      ::oAlbPrvT:Skip()

      ::oMtrInf:AutoInc( ::oAlbPrvT:OrdKeyNo() )

   end while

   ::oAlbPrvT:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oAlbPrvT:cFile ) )

   /*Facturas*/

   ::oFacPrvT:OrdSetFocus( "dFecFac" )

   cExpHead          := 'dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   if !::lAllPrv
      cExpHead       += ' .and. cCodPrv >= "' + ::cPrvOrg + '" .and. cCodPrv <= "' + ::cPrvDes + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oFacPrvT:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oFacPrvT:cFile ), ::oFacPrvT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:cText   := "Procesando facturas"
   ::oMtrInf:SetTotal( ::oFacPrvT:OrdKeyCount() )

   ::oFacPrvT:GoTop()

   while ::oFacPrvT:dFecFac <= ::dFinInf .and. !::oFacPrvT:Eof()

      if ( ::lAllPrv .or. ( ::oFacPrvT:cCodPrv >= ::cPrvOrg .AND. ::oFacPrvT:cCodPrv <= ::cPrvDes ) ) .AND.;
         lChkSer( ::oFacPrvT:cSerFac, ::aSer )

         if ::oFacPrvL:Seek( ::oFacPrvT:cSerFac + Str( ::oFacPrvT:nNumFac ) + ::oFacPrvT:cSufFac )

            while ::oFacPrvT:cSerFac + Str( ::oFacPrvT:nNumFac ) + ::oFacPrvT:cSufFac == ::oFacPrvL:cSerFac + Str( ::oFacPrvL:nNumFac ) + ::oFacPrvL:cSufFac .AND. ! ::oFacPrvL:eof()

               if ( ::lAllPrv .or. ( ::oFacPrvL:cRef >= ::cArtOrg .AND. ::oFacPrvL:cRef <= ::cArtDes ) )

                  ::oDbf:Append()

                  ::oDbf:cTipDoc := "Factura"
                  ::oDbf:cDocMov := AllTrim( ::oFacPrvT:cSerFac ) + "/" + AllTrim( Str( ::oFacPrvT:nNumFac ) ) + "/" + AllTrim( ::oFacPrvT:cSufFac )
                  ::oDbf:dFecMov := ::oFacPrvT:dFecFac
                  ::oDbf:cCodArt := ::oFacPrvL:cRef
                  ::oDbf:cNomArt := ::oFacPrvL:cDetalle
                  ::oDbf:cCodAlm := ::oFacPrvL:cAlmLin
                  ::oDbf:nComRap := ::oFacPrvL:nDtoRap
                  ::oDbf:nImpTot := nTotLFacPrv( ::oFacPrvL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
                  ::oDbf:nTotRap := ( ::oDbf:nImpTot * ::oDbf:nComRap ) / 100
                  ::AddProveedor( ::oFacPrvT:cCodPrv )

                  ::oDbf:Save()

               end if

               ::oFacPrvL:Skip()

            end while

         end if

      end if

      ::oFacPrvT:Skip()

      ::oMtrInf:AutoInc( ::oFacPrvT:OrdKeyNo() )

   end while

   ::oMtrInf:AutoInc( ::oAlbPrvT:Lastrec() )

   ::oFacPrvT:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oFacPrvT:cFile ) )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//