#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TInfPedPrv FROM TInfGen

   DATA  oDbfIva

   DATA  lExcPre           AS LOGIC    INIT  .t.
   DATA  lExcObsoletos     AS LOGIC    INIT  .t.

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD Resource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD OpenFiles

   DATABASE NEW ::oDbfIva PATH ( cPatDat() ) FILE "TIVA.DBF" VIA ( cDriver() ) SHARED INDEX "TIVA.CDX"

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD CloseFiles

   ::oDbfIva:End()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField( "Codigo",  "C", 18, 0, {|| "@!" },     "Código",      .t., "Código del artículo",            14, .f. )
   ::AddField( "CodeBar", "C", 20, 0, {|| "@!" },     "Cód. barras", .t., "Código de barras",               14, .f. )
   ::AddField( "Nombre",  "C", 50, 0, {|| "" },       "Artículo",    .t., "Nombre del artículo",            30, .f. )
   ::AddField( "cDesTik", "C", 20, 0, {|| "" },       "Des. tiket",  .f., "Descripción para tiket",         14, .f. )
   ::AddField( "pCosto",  "N", 15, 6, {|| PicIn() },  "Costo" ,      .f., "Precio de costo",                10, .f. )
   ::AddField( "pVprec",  "N", 15, 6, {|| PicOut() }, "P.V.R.",      .f., "Precio venta recomendado" ,      10, .f. )
   ::AddField( "Benef1",  "N",  6, 2, {|| "@EZ 999.99" },"%Bnf. 1",  .f., "Porcentaje beneficio precio 1" ,  4, .f. )
   ::AddField( "Benef2",  "N",  6, 2, {|| "@EZ 999.99" },"%Bnf. 2" , .f., "Porcentaje beneficio precio 2" ,  4, .f. )
   ::AddField( "Benef3",  "N",  6, 2, {|| "@EZ 999.99" },"%Bnf. 3" , .f., "Porcentaje beneficio precio 3" ,  4, .f. )
   ::AddField( "Benef4",  "N",  6, 2, {|| "@EZ 999.99" },"%Bnf. 4" , .f., "Porcentaje beneficio precio 4" ,  4, .f. )
   ::AddField( "Benef5",  "N",  6, 2, {|| "@EZ 999.99" },"%Bnf. 5" , .f., "Porcentaje beneficio precio 5" ,  4, .f. )
   ::AddField( "Benef6",  "N",  6, 2, {|| "@EZ 999.99" },"%Bnf. 6" , .f., "Porcentaje beneficio precio 6" ,  4, .f. )
   ::AddField( "pVenta1", "N", 15, 6, {|| PicOut() },  "PVP 1" ,     .t., "Precio de venta precio 1" ,      10, .f. )
   ::AddField( "pVenta2", "N", 15, 6, {|| PicOut() },  "PVP 2" ,     .f., "Precio de venta precio 2" ,      10, .f. )
   ::AddField( "pVenta3", "N", 15, 6, {|| PicOut() },  "PVP 3" ,     .f., "Precio de venta precio 3" ,      10, .f. )
   ::AddField( "pVenta4", "N", 15, 6, {|| PicOut() },  "PVP 4" ,     .f., "Precio de venta precio 4" ,      10, .f. )
   ::AddField( "pVenta5", "N", 15, 6, {|| PicOut() },  "PVP 5" ,     .f., "Precio de venta precio 5" ,      10, .f. )
   ::AddField( "pVenta6", "N", 15, 6, {|| PicOut() },  "PVP 6" ,     .f., "Precio de venta precio 6" ,      10, .f. )
   ::AddField( "pVtaIva1","N", 15, 6, {|| PicOut() },  "PVP 1 I.I." ,.t., "Precio de venta 1 " + cImp() + " incluido", 10, .f. )
   ::AddField( "pVtaIva2","N", 15, 6, {|| PicOut() },  "PVP 2 I.I." ,.f., "Precio de venta 2 " + cImp() + " incluido", 10, .f. )
   ::AddField( "pVtaIva3","N", 15, 6, {|| PicOut() },  "PVP 3 I.I." ,.f., "Precio de venta 3 " + cImp() + " incluido", 10, .f. )
   ::AddField( "pVtaIva4","N", 15, 6, {|| PicOut() },  "PVP 4 I.I." ,.f., "Precio de venta 4 " + cImp() + " incluido", 10, .f. )
   ::AddField( "pVtaIva5","N", 15, 6, {|| PicOut() },  "PVP 5 I.I." ,.f., "Precio de venta 5 " + cImp() + " incluido", 10, .f. )
   ::AddField( "pVtaIva6","N", 15, 6, {|| PicOut() },  "PVP 6 I.I." ,.f., "Precio de venta 6 " + cImp() + " incluido", 10, .f. )
   ::AddField( "nPntVer1","N", 15, 6, {|| PicOut() },  "P.V.",       .f., "Contribución punto verde" ,      10, .f. )
   ::AddField( "nPnvIva1","N", 15, 6, {|| PicOut() },  "P.V. I.I.",  .f., "Contribución punto verde " + cImp() + " inc.", 10, .f. )
   ::AddField( "nIva",    "N",  5, 2, {|| "@EZ 99.9" },"%" + cImp(),    .t., "Tipo de " + cImp(),                  6, .f. )
   ::AddField( "Familia", "C",  8, 0, {|| "@!" },      "Familia",    .f., "Familia del artículo",            8, .f. )

   ::AddTmpIndex( "Familia", "Familia" )

   ::AddGroup( {|| ::oDbf:Familia }, {|| "Familia : " + Rtrim( ::oDbf:Familia ) + "-" + oRetFld( ::oDbf:Familia, ::oDbfFam ) }, {||""} )

   ::lDefFecInf   := .f.
   ::lDefSerInf   := .f.

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Resource( cFld )

   if !::StdResource( "INF_ART01" )
      return .f.
   end if

   /*
   Monta los articulos de manera automatica
   */

   ::lDefFamInf( 70, 80, 90, 100 )

   ::lDefArtInf( 110, 120, 130, 140 )

   REDEFINE CHECKBOX ::lExcPre ;
      ID       190 ;
      OF       ::oFld:aDialogs[1]

   REDEFINE CHECKBOX ::lSalto ;
      ID       200 ;
      OF       ::oFld:aDialogs[1]

   REDEFINE CHECKBOX ::lExcObsoletos ;
      ID       210 ;
      OF       ::oFld:aDialogs[1]

   ::CreateFilter( aItmArt(), ::oDbfArt )

   /*
   Damos valor al meter
   */

   ::oMtrInf:SetTotal( ::oDbfArt:Lastrec() )

RETURN ( Self )

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   ::oDlg:Disable()
   ::oDbf:Zap()

   ::aoGroup[1]:lEject := ::lSalto

   ::oDbfArt:GoTop()

   WHILE !::oDbfArt:Eof()

      if ::oDbfArt:Familia >= ::cFamOrg               .AND.;
         ::oDbfArt:Familia <= ::cFamDes               .AND.;
         if( ::lExcObsoletos, !::oDbfArt:lObs, .t. )  .AND.;
         if( ::lExcPre, ::oDbfArt:pVenta1 != 0 .or. ::oDbfArt:pVenta2 != 0 .or. ::oDbfArt:pVenta3 != 0 .or. ::oDbfArt:pVenta4 != 0 .or. ::oDbfArt:pVenta5 != 0 .or. ::oDbfArt:pVenta6 != 0, .t. ) .AND. ;
         ::EvalFilter()

         ::oDbf:Append()
         ::oDbf:Codigo     := ::oDbfArt:Codigo
         ::oDbf:CodeBar    := ::oDbfArt:Familia
         ::oDbf:Nombre     := ::oDbfArt:Nombre
         ::oDbf:cDesTik    := ::oDbfArt:cDesTik
         ::oDbf:pCosto     := ::oDbfArt:pCosto
         ::oDbf:pVprec     := ::oDbfArt:pVprec
         ::oDbf:Benef1     := ::oDbfArt:Benef1
         ::oDbf:Benef2     := ::oDbfArt:Benef2
         ::oDbf:Benef3     := ::oDbfArt:Benef3
         ::oDbf:Benef4     := ::oDbfArt:Benef4
         ::oDbf:Benef5     := ::oDbfArt:Benef5
         ::oDbf:Benef6     := ::oDbfArt:Benef6
         ::oDbf:pVenta1    := ::oDbfArt:pVenta1
         ::oDbf:pVenta2    := ::oDbfArt:pVenta2
         ::oDbf:pVenta3    := ::oDbfArt:pVenta3
         ::oDbf:pVenta4    := ::oDbfArt:pVenta4
         ::oDbf:pVenta5    := ::oDbfArt:pVenta5
         ::oDbf:pVenta6    := ::oDbfArt:pVenta6
         ::oDbf:pVtaIva1   := ::oDbfArt:pVtaIva1
         ::oDbf:pVtaIva2   := ::oDbfArt:pVtaIva2
         ::oDbf:pVtaIva3   := ::oDbfArt:pVtaIva3
         ::oDbf:pVtaIva4   := ::oDbfArt:pVtaIva4
         ::oDbf:pVtaIva5   := ::oDbfArt:pVtaIva5
         ::oDbf:pVtaIva6   := ::oDbfArt:pVtaIva6
         ::oDbf:nPntVer1   := ::oDbfArt:nPntVer1
         ::oDbf:nPnvIva1   := ::oDbfArt:nPnvIva1
         ::oDbf:Familia    := ::oDbfArt:Familia
         ::oDbf:nIva       := nIva( ::oDbfIva, ::oDbfArt:TipoIva )
         ::oDbf:Save()

      end if

      ::oDbfArt:Skip()

      ::oMtrInf:AutoInc( ::oDbfArt:OrdKeyNo() )

   END DO

   ::oMtrInf:AutoInc( ::oDbfArt:LastRec() )
   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//