#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS oUbiRAlb FROM TInfGen

   DATA  oAlbPrvT    AS OBJECT
   DATA  oAlbPrvL    AS OBJECT
   DATA  oFacPrvT    AS OBJECT
   DATA  oFacPrvL    AS OBJECT
   DATA  oDbfAlm     AS OBJECT
   DATA  oDbfUbicaL  AS OBJECT
   DATA  oUbiAlm1    AS OBJECT
   DATA  oUbiAlm2    AS OBJECT
   DATA  oUbiAlm3    AS OBJECT
   DATA  oCodUbi1    AS OBJECT
   DATA  oCodUbi2    AS OBJECT
   DATA  oCodUbi3    AS OBJECT
   DATA  oNomUbi1    AS OBJECT
   DATA  oNomUbi2    AS OBJECT
   DATA  oNomUbi3    AS OBJECT
   DATA  oAllUbi     AS OBJECT
   DATA  lAllUbi     AS LOGIC    INIT .t.
   DATA  cAlmacen    AS CHARACTER     INIT cDefAlm()
   DATA  cSayAlm     AS CHARACTER     INIT RetAlmacen( cDefAlm() )
   DATA  cUbiAlm1    AS CHARACTER     INIT ""
   DATA  cUbiAlm2    AS CHARACTER     INIT ""
   DATA  cUbiAlm3    AS CHARACTER     INIT ""
   DATA  cCodUbi1    AS CHARACTER     INIT ""
   DATA  cCodUbi2    AS CHARACTER     INIT ""
   DATA  cCodUbi3    AS CHARACTER     INIT ""
   DATA  cNomUbi1    AS CHARACTER     INIT ""
   DATA  cNomUbi2    AS CHARACTER     INIT ""
   DATA  cNomUbi3    AS CHARACTER     INIT ""

   METHOD create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

   METHOD cNomUbica( cCodAlm )

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField( "cCodAlm", "C",  3, 0, {|| "@!" },        "Alm",            .f., "Cod. almacén",        3, .f. )
   ::AddField( "cNomAlm", "C", 50, 0, {|| "@!" },        "Almacém",        .f., "Nombre almacén",     15, .f. )
   ::AddField( "cCodUbi1","C",  5, 0, {|| "@!" },        "Cod. 1",         .t., "Código ubicación 1",  7, .f. )
   ::AddField( "cUbica1", "C", 30, 0, {|| "@!" },        "Ubicación 1",    .t., "Nombre ubicación 1", 20, .f. )
   ::AddField( "cCodUbi2","C",  5, 0, {|| "@!" },        "Cod. 2",         .t., "Código ubicación 2",  7, .f. )
   ::AddField( "cUbica2", "C", 30, 0, {|| "@!" },        "Ubicación 2",    .t., "Nombre ubicación 2", 20, .f. )
   ::AddField( "cCodUbi3","C",  5, 0, {|| "@!" },        "Cod. 3",         .t., "Código ubicación 3",  7, .f. )
   ::AddField( "cUbica3", "C", 30, 0, {|| "@!" },        "Ubicación 3",    .t., "Nombre ubicación 3", 20, .f. )
   ::AddField( "cCodArt", "C", 18, 0, {|| "@!" },        "Código",         .t., "Cod. artículo",      10, .f. )
   ::AddField( "cNomArt", "C",100, 0, {|| "@!" },        "Descripción",    .t., "Descripción",        50, .f. )
   ::AddField( "nUniDad", "N", 16, 6, {|| MasUnd() },    "Und.",           .t., "Unidades",           10, .t. )

   ::AddTmpIndex( "CCODALM", "CCODALM + cCodUbi1 + cCodUbi2 + cCodUbi3 + cCodArt" )

   ::AddGroup( {|| ::oDbf:cCodAlm }, {|| "Almacén  : " + Rtrim( ::oDbf:cCodAlm ) + "-" + Rtrim( oRetFld( ::oDbf:cCodAlm, ::oDbfAlm ) ) }, {||"Total almacén..."} )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   DATABASE NEW ::oAlbPrvT    PATH ( cPatEmp() ) FILE "ALBPROVT.DBF" VIA ( cDriver() ) SHARED INDEX "ALBPROVT.CDX"

   DATABASE NEW ::oAlbPrvL    PATH ( cPatEmp() ) FILE "ALBPROVL.DBF" VIA ( cDriver() ) SHARED INDEX "ALBPROVL.CDX"

   DATABASE NEW ::oFacPrvT    PATH ( cPatEmp() ) FILE "FACPRVT.DBF"  VIA ( cDriver() ) SHARED INDEX "FACPRVT.CDX"

   DATABASE NEW ::oFacPrvL    PATH ( cPatEmp() ) FILE "FACPRVL.DBF"  VIA ( cDriver() ) SHARED INDEX "FACPRVL.CDX"

   DATABASE NEW ::oDbfAlm     PATH ( cPatAlm() ) FILE "ALMACEN.DBF"  VIA ( cDriver() ) SHARED INDEX "ALMACEN.CDX"

   DATABASE NEW ::oDbfUbicaL  PATH ( cPatAlm() ) FILE "UBICAL.DBF"   VIA ( cDriver() ) SHARED INDEX "UBICAL.CDX"

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
   if !Empty( ::oDbfAlm ) .and. ::oDbfAlm:Used()
      ::oDbfAlm:End()
   end if
   if !Empty( ::oDbfUbicaL ) .and. ::oDbfUbicaL:Used()
      ::oDbfUbicaL:End()
   end if

   ::oAlbPrvT   := nil
   ::oAlbPrvL   := nil
   ::oFacPrvT   := nil
   ::oFacPrvL   := nil
   ::oDbfAlm    := nil
   ::oDbfUbicaL := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource ( cFld )

   local oSayAlm
   local oAlmacen

   ::lDefFecInf := .f.
   ::lDefSerInf := .f.

   if !::StdResource( "INF_UBI01" )
      return .f.
   end if

   REDEFINE GET oAlmacen VAR ::cAlmacen;
      ID       70 ;
      WHEN     ( ::cNomUbica( ::cAlmacen ) ) ;
      VALID    ( cAlmacen( oAlmacen, ::oDbfAlm:cAlias, oSayAlm ), ::cNomUbica( ::cAlmacen ) ) ;
      BITMAP   "LUPA" ;
      ON HELP  BrwAlmacen( oAlmacen, oSayAlm ) ;
		COLOR 	CLR_GET ;
      OF       ::oFld:aDialogs[1]

   REDEFINE GET oSayAlm VAR ::cSayAlm ;
      ID       80 ;
      WHEN     .f.;
      COLOR    CLR_GET ;
      OF       ::oFld:aDialogs[1]

   REDEFINE CHECKBOX ::oAllUbi VAR ::lAllUbi;
      ID       90 ;
      OF       ::oFld:aDialogs[1]

   REDEFINE SAY ::oUbiAlm1 VAR ::cUbiAlm1;
      ID       881 ;
      OF       ::oFld:aDialogs[1]

   REDEFINE GET ::oCodUbi1 VAR ::cCodUbi1;
      ID       100 ;
      BITMAP   "LUPA" ;
      WHEN     ( !::lAllUbi );
      OF       ::oFld:aDialogs[1]

   ::oCodUbi1:bHelp  := {|| BrwUbiLin( ::oCodUbi1, ::oNomUbi1, ::cUbiAlm1, ::oDbfUbicaL:cAlias ) }

   REDEFINE GET ::oNomUbi1 VAR ::cNomUbi1;
      WHEN     .F. ;
      ID       101 ;
      OF       ::oFld:aDialogs[1]

   REDEFINE SAY ::oUbiAlm2 VAR ::cUbiAlm2;
      ID       882 ;
      OF       ::oFld:aDialogs[1]

   REDEFINE GET ::oCodUbi2 VAR ::cCodUbi2 ;
      ID       110 ;
      BITMAP   "LUPA" ;
      WHEN     ( !::lAllUbi );
      OF       ::oFld:aDialogs[1]

   ::oCodUbi2:bHelp  := {|| BrwUbiLin( ::oCodUbi2, ::oNomUbi2, ::cUbiAlm2, ::oDbfUbicaL:cAlias ) }

   REDEFINE GET ::oNomUbi2 VAR ::cNomUbi2;
      WHEN     .F. ;
      ID       111 ;
      OF       ::oFld:aDialogs[1]

   REDEFINE SAY ::oUbiAlm3 VAR ::cUbiAlm3;
      ID       883 ;
      OF       ::oFld:aDialogs[1]

   REDEFINE GET ::oCodUbi3 VAR ::cCodUbi3 ;
      ID       120 ;
      BITMAP   "LUPA" ;
      WHEN     ( !::lAllUbi );
      OF       ::oFld:aDialogs[1]

   ::oCodUbi3:bHelp  := {|| BrwUbiLin( ::oCodUbi3, ::oNomUbi3, ::cUbiAlm3, ::oDbfUbicaL:cAlias ) }

   REDEFINE GET ::oNomUbi3 VAR ::cNomUbi3;
      WHEN     .F. ;
      ID       121 ;
      OF       ::oFld:aDialogs[1]

   /*
   Monta los articulos de manera automatica
   */

   if !::lDefArtInf( 140, 150, 160, 170, 130 )
      return .f.
   end if

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   ::oDlg:Disable()

   ::oDbf:Zap()

   ::aHeader      := {  {|| "Fecha     : " + Dtoc( Date() ) },;
                        {|| "Almacen   : " + ::cAlmacen + " - " + ::cSayAlm },;
                        {|| "Artículos : " + if( ::lAllArt, "Todos", AllTrim( ::cArtOrg ) + " > " + AllTrim( ::cArtDes ) ) } }

   //--Nos movemos por los albaranes de proveedor no facturados

   ::oMtrInf:SetTotal( ::oAlbPrvT:Lastrec() )

   ::oAlbPrvT:GoTop()

   while !::oAlbPrvT:Eof()

      if !::oAlbPrvT:lFacturado                                                                 .AND.;
         ::oAlbPrvL:Seek( ::oAlbPrvT:cSerAlb + Str( ::oAlbPrvT:nNumAlb ) + ::oAlbPrvT:cSufAlb )

         while ::oAlbPrvT:cSerAlb + Str( ::oAlbPrvT:nNumAlb ) + ::oAlbPrvT:cSufAlb == ::oAlbPrvL:cSerAlb + Str( ::oAlbPrvL:nNumAlb ) + ::oAlbPrvL:cSufAlb .AND. ! ::oAlbPrvL:eof()

            if ::oAlbPrvL:cAlmLin == ::cAlmacen                                                 .AND.;
               !Empty( ::oAlbPrvL:cRef )                                                        .AND.;
               ( ::lAllArt .or. ( ::oAlbPrvL:cRef >= ::cArtOrg .and. ::oAlbPrvL:cRef <= ::cArtDes  ) )

               ::oDbf:Append()

               ::oDbf:cCodAlm    := ::oAlbPrvL:cAlmLin
               ::oDbf:cNomAlm    := RetAlmacen( ::oAlbPrvL:cAlmLin )
               ::oDbf:cCodUbi1   := AllTrim( ::oAlbPrvL:cValUbi1 )
               ::oDbf:cUbica1    := AllTrim( ::oAlbPrvL:cNomUbi1 )
               ::oDbf:cCodUbi2   := AllTrim( ::oAlbPrvL:cValUbi2 )
               ::oDbf:cUbica2    := AllTrim( ::oAlbPrvL:cNomUbi2 )
               ::oDbf:cCodUbi3   := AllTrim( ::oAlbPrvL:cValUbi3 )
               ::oDbf:cUbica3    := AllTrim( ::oAlbPrvL:cNomUbi3 )
               ::oDbf:cCodArt    := ::oAlbPrvL:cRef
               ::oDbf:cNomArt    := ::oAlbPrvL:cDetalle
               ::oDbf:nUniDad    := ::oAlbPrvL:nUniCaja

               ::oDbf:Save()

            end if

            ::oAlbPrvL:Skip()

         end while

      end if

      ::oAlbPrvT:Skip()

      ::oMtrInf:AutoInc( ::oAlbPrvT:OrdKeyNo() )

   end while

   //--Nos movemos por las facturas de proveedor

   ::oMtrInf:SetTotal( ::oFacPrvT:Lastrec() )

   ::oFacPrvT:GoTop()

   while !::oFacPrvT:Eof()

      if ::oFacPrvL:Seek( ::oFacPrvT:cSerFac + Str( ::oFacPrvT:nNumFac ) + ::oFacPrvT:cSufFac )

         while ::oFacPrvT:cSerFac + Str( ::oFacPrvT:nNumFac ) + ::oFacPrvT:cSufFac == ::oFacPrvL:cSerFac + Str( ::oFacPrvL:nNumFac ) + ::oFacPrvL:cSufFac .AND. ! ::oFacPrvL:eof()

            if ::oFacPrvL:cAlmLin == ::cAlmacen                                                 .AND.;
               !Empty( ::oFacPrvL:cRef )                                                        .AND.;
               ( ::lAllArt .or. ( ::oFacPrvL:cRef >= ::cArtOrg .and. ::oFacPrvL:cRef <= ::cArtDes  ) )

               ::oDbf:Append()

               ::oDbf:cCodAlm    := ::oFacPrvL:cAlmLin
               ::oDbf:cNomAlm    := RetAlmacen( ::oFacPrvL:cAlmLin )
               ::oDbf:cCodUbi1   := AllTrim( ::oFacPrvL:cValUbi1 )
               ::oDbf:cUbica1    := AllTrim( ::oFacPrvL:cNomUbi1 )
               ::oDbf:cCodUbi2   := AllTrim( ::oFacPrvL:cValUbi2 )
               ::oDbf:cUbica2    := AllTrim( ::oFacPrvL:cNomUbi2 )
               ::oDbf:cCodUbi3   := AllTrim( ::oFacPrvL:cValUbi3 )
               ::oDbf:cUbica3    := AllTrim( ::oFacPrvL:cNomUbi3 )
               ::oDbf:cCodArt    := ::oFacPrvL:cRef
               ::oDbf:cNomArt    := ::oFacPrvL:cDetalle
               ::oDbf:nUniDad    := ::oFacPrvL:nUniCaja

               ::oDbf:Save()

            end if

            ::oFacPrvL:Skip()

         end while

      end if

      ::oFacPrvT:Skip()

      ::oMtrInf:AutoInc( ::oFacPrvT:OrdKeyNo() )

   end while

   ::oMtrInf:AutoInc( ::oFacPrvT:Lastrec() )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//

METHOD cNomUbica( cCodAlm )

   ::cUbiAlm1      := cGetUbica( cCodAlm, ::oDbfAlm:cAlias, 1 )
   ::cUbiAlm2      := cGetUbica( cCodAlm, ::oDbfAlm:cAlias, 2 )
   ::cUbiAlm3      := cGetUbica( cCodAlm, ::oDbfAlm:cAlias, 3 )

   if Empty( ::cUbiAlm1 )
      ::oUbiAlm1:Hide()
      ::oCodUbi1:Hide()
      ::oNomUbi1:Hide()
   else
      ::oUbiAlm1:Show()
      ::oCodUbi1:Show()
      ::oNomUbi1:Show()
   end if

   if Empty( ::cUbiAlm2 )
      ::oUbiAlm2:Hide()
      ::oCodUbi2:Hide()
      ::oNomUbi2:Hide()
   else
      ::oUbiAlm2:Show()
      ::oCodUbi2:Show()
      ::oNomUbi2:Show()
   end if

   if Empty( ::cUbiAlm3 )
      ::oUbiAlm3:Hide()
      ::oCodUbi3:Hide()
      ::oNomUbi3:Hide()
   else
      ::oUbiAlm3:Show()
      ::oCodUbi3:Show()
      ::oNomUbi3:Show()
   end if

   ::oUbiAlm1:Refresh()
   ::oUbiAlm2:Refresh()
   ::oUbiAlm3:Refresh()
   ::oCodUbi1:Refresh()
   ::oCodUbi2:Refresh()
   ::oCodUbi3:Refresh()
   ::oNomUbi1:Refresh()
   ::oNomUbi2:Refresh()
   ::oNomUbi3:Refresh()

RETURN ( .t. )

//---------------------------------------------------------------------------//