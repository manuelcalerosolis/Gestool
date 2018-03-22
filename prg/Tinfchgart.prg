#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TInfChgArt FROM TInfGen

   DATA  oDbfArt    AS OBJECT
   DATA  oDbfTIva   AS OBJECT
   DATA  oDbfKit    AS OBJECT
   DATA  oDbfDiv    AS OBJECT

   METHOD create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField( "cCodFam",  "C", 16, 0, {|| "@!" },        'Familia',        .f., 'Familia'                ,  5, .f. )
   ::AddField( "cCodArt",  "C", 18, 0, {|| "@!" },        'Código artículo',      .t., 'Cod. artículo'          , 15, .f. )
   ::AddField( "cNomArt",  "C",100, 0, {|| "@!" },        'Descripción',    .t., 'Descripción'            , 50, .f. )
   ::AddField( "LastChg",  "D",  8, 0, {|| "@!" },        'Cambio',         .t., 'Fecha de cambio'        , 10, .f. )
   ::AddField( "TipoIva",  "N",  5, 1, {|| "@!" },        '% impuestos',       .t., '% I.V.A'                ,  8, .f. )
   ::AddField( "pCosto",   "N", 15, 6, {|| ::cPicin },    'Pre. costo',     .f., 'Precio de costo'        , 12, .f. )
   ::AddField( "pVenta1",  "N", 15, 6, {|| ::cPicOut },   'Precio 1',       .f., 'Precio de venta 1'      , 12, .f. )
   ::AddField( "pVtaIva1", "N", 15, 6, {|| ::cPicOut },   'Precio 1 impuestos',   .t., 'Precio de venta 1 impuestos'  , 12, .f. )
   ::AddField( "pVenta2",  "N", 15, 6, {|| ::cPicOut },   'Precio 2',       .f., 'Precio de venta 2'      , 12, .f. )
   ::AddField( "pVtaIva2", "N", 15, 6, {|| ::cPicOut },   'Precio 2 impuestos',   .f., 'Precio de venta 2 impuestos'  , 12, .f. )
   ::AddField( "pVenta3",  "N", 15, 6, {|| ::cPicOut },   'Precio 3',       .f., 'Precio de venta 3'      , 12, .f. )
   ::AddField( "pVtaIva3", "N", 15, 6, {|| ::cPicOut },   'Precio 3 impuestos',   .f., 'Precio de venta 3 impuestos'  , 12, .f. )
   ::AddField( "pVenta4",  "N", 15, 6, {|| ::cPicOut },   'Precio 4',       .f., 'Precio de venta 4'      , 12, .f. )
   ::AddField( "pVtaIva4", "N", 15, 6, {|| ::cPicOut },   'Precio 4 impuestos',   .f., 'Precio de venta 4 impuestos'  , 12, .f. )
   ::AddField( "pVenta5",  "N", 15, 6, {|| ::cPicOut },   'Precio 5',       .f., 'Precio de venta 5'      , 12, .f. )
   ::AddField( "pVtaIva5", "N", 15, 6, {|| ::cPicOut },   'Precio 5 impuestos',   .f., 'Precio de venta 5 impuestos'  , 12, .f. )
   ::AddField( "pVenta6",  "N", 15, 6, {|| ::cPicOut },   'Precio 6',       .f., 'Precio de venta 6'      , 12, .f. )
   ::AddField( "pVtaIva6", "N", 15, 6, {|| ::cPicOut },   'Precio 6 impuestos',   .f., 'Precio de venta 6 impuestos'  , 12, .f. )

   ::AddTmpIndex( "CCODFAM", "CCODFAM + CCODART" )

   ::AddGroup( {|| ::oDbf:cCodFam }, {|| "Familia  : " + Rtrim( ::oDbf:cCodFam ) + "-" + oRetFld( ::oDbf:cCodFam, ::oDbfFam ) }, {|| "Total familia..." } )

   ::lDefSerInf   := .f.
   ::lDefDivInf   := .f.

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   DATABASE NEW ::oDbfArt  PATH ( cPatArt() ) FILE "ARTICULO.DBF" VIA ( cDriver() ) SHARED INDEX "ARTICULO.CDX"

   DATABASE NEW ::oDbfTIva PATH ( cPatDat() ) FILE "TIVA.DBF"     VIA ( cDriver() ) SHARED INDEX "TIVA.CDX"

   DATABASE NEW ::oDbfKit  PATH ( cPatArt() ) FILE "ARTKIT.DBF"   VIA ( cDriver() ) SHARED INDEX "ARTKIT.CDX"

   DATABASE NEW ::oDbfDiv  PATH ( cPatDat() ) FILE "DIVISAS.DBF"  VIA ( cDriver() ) SHARED INDEX "DIVISAS.CDX"

   RECOVER

      msgStop( 'Imposible abrir todas las bases de datos' )
      ::CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles()

   if !Empty( ::oDbfArt ) .and. ::oDbfArt:Used()
      ::oDbfArt:End()
   end if

   if !Empty( ::oDbfTIva ) .and. ::oDbfTIva:Used()
      ::oDbfTIva:End()
   end if
   if !Empty( ::oDbfKit ) .and. ::oDbfKit:Used()
      ::oDbfKit:End()
   end if
   if !Empty( ::oDbfDiv ) .and. ::oDbfDiv:Used()
      ::oDbfDiv:End()
   end if

   ::oDbfArt  := nil
   ::oDbfTIva := nil
   ::oDbfKit  := nil
   ::oDbfDiv  := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource ( cFld )

   if !::StdResource( "INFCHGART" )
      return .f.
   end if

   if !::lDefFamInf( 110, 120, 130, 140, 600 )
      return .f.
   end if

   ::CreateFilter( aItmArt(), ::oDbfArt:cAlias )

   /*
   Damos valor al meter
   */

   ::oMtrInf:SetTotal( ::oDbfArt:Lastrec() )

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

   ::aHeader      := {  {|| 'Fecha    : ' + Dtoc( Date() ) },;
                        {|| 'Periodo  : ' + Dtoc( ::dIniInf ) + ' > ' + Dtoc( ::dFinInf ) },;
                        {|| 'Familias : ' + if( ::lAllFam, "Todas", AllTrim( ::cFamOrg ) + ' > ' + AllTrim( ::cFamDes ) ) } }

   ::oDbfArt:OrdSetFocus( "CODIGO" )

   cExpHead          := '( dFecChg >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecChg <= Ctod( "' + Dtoc( ::dFinInf ) + '" ) )'

   if !::lAllFam
      cExpHead       += ' .and. familia >= "' + Rtrim( ::cFamOrg ) + '" .and. familia <= "' + Rtrim( ::cFamDes ) + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oDbfArt:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oDbfArt:cFile ), ::oDbfArt:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oDbfArt:OrdKeyCount() )

   ::oDbfArt:GoTop()

   while !::lBreak .and. !::oDbfArt:Eof()

      ::oDbf:Append()

      ::oDbf:LastChg := ::oDbfArt:dFecChg

      ::oDbf:cCodArt    := ::oDbfArt:Codigo
      ::oDbf:cNomArt    := ::oDbfArt:Nombre
      ::oDbf:pCosto     := nCosto( nil, ::oDbfArt:cAlias, ::oDbfKit:cAlias, .f., nil, ::oDbfDiv )
      ::oDbf:TipoIva    := nIva( ::oDbfTIva ,::oDbfArt:TipoIva )
      ::oDbf:pVenta1    := ::oDbfArt:pVenta1
      ::oDbf:pVtaIva1   := ::oDbfArt:pVtaIva1
      ::oDbf:pVenta2    := ::oDbfArt:pVenta2
      ::oDbf:pVtaIva2   := ::oDbfArt:pVtaIva2
      ::oDbf:pVenta3    := ::oDbfArt:pVenta3
      ::oDbf:pVtaIva3   := ::oDbfArt:pVtaIva3
      ::oDbf:pVenta4    := ::oDbfArt:pVenta4
      ::oDbf:pVtaIva4   := ::oDbfArt:pVtaIva4
      ::oDbf:pVenta5    := ::oDbfArt:pVenta5
      ::oDbf:pVtaIva5   := ::oDbfArt:pVtaIva5
      ::oDbf:pVenta6    := ::oDbfArt:pVenta6
      ::oDbf:pVtaIva6   := ::oDbfArt:pVtaIva6
      ::oDbf:cCodFam    := ::oDbfArt:Familia

      ::oDbf:Save()

      ::oDbfArt:Skip()

      ::oMtrInf:AutoInc( ::oDbfArt:OrdKeyNo() )

   end while

   ::oDbfArt:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oDbfArt:cFile ) )

   ::oMtrInf:AutoInc( ::oDbfArt:Lastrec() )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//