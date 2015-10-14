#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS PruebaInf FROM TNewInfGen

   DATA  oAlqCliT    AS OBJECT
   DATA  oAlqCliL    AS OBJECT

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField( "cCodAlm", "C", 16, 0, {|| "@!" },        "Alm",                        .f., "Cod. almacén",                 3, .f. )
   ::AddField( "cNomAlm", "C", 50, 0, {|| "@!" },        "Almacém",                    .f., "Nombre almacén",              15, .f. )
   ::FldArticulo( .t. )
   ::AddField( "cLote",   "C", 14, 0, ,                  "Lote",                       .f., "Número de lote",              10, .f. )
   ::FldCliente()
   ::AddField( "nNumCaj", "N", 16, 6, {|| MasUnd() },    cNombreCajas(),               .f., cNombreCajas(),                12, .t. )
   ::AddField( "nUniDad", "N", 16, 6, {|| MasUnd() },    cNombreUnidades(),            .f., cNombreUnidades(),             12, .t. )
   ::AddField( "nNumUni", "N", 16, 6, {|| MasUnd() },    "Tot. " + cNombreUnidades(),  .t., "Total " + cNombreUnidades(),  12, .t. )
   ::AddField( "nImpArt", "N", 16, 6, {|| ::cPicImp },   "Precio",                     .t., "Precio",                      12, .f. )
   ::AddField( "nPntVer", "N", 16, 6, {|| ::cPicImp },   "Pnt. ver.",                  .f., "Punto verde",                 10, .f. )
   ::AddField( "nImpTrn", "N", 16, 6, {|| ::cPicImp },   "Portes",                     .f., "Portes",                      10, .f. )
   ::AddField( "nImpTot", "N", 16, 6, {|| ::cPicOut },   "Base",                       .t., "Base",                        12, .t. )
   ::AddField( "nIvaTot", "N", 19, 6, {|| ::cPicOut },   cImp(),                       .t., cImp(),                      12, .t. )
   ::AddField( "nTotFin", "N", 16, 6, {|| ::cPicOut },   "Total",                      .t., "Total",                       12, .t. )
   ::AddField( "nTotPes", "N", 16, 6, {|| MasUnd() },    "Tot. peso",                  .f., "Total peso",                  12, .t. )
   ::AddField( "nPreKgr", "N", 16, 6, {|| ::cPicImp },   "Pre. Kg.",                   .f., "Precio kilo",                 12, .f. )
   ::AddField( "nTotVol", "N", 16, 6, {|| MasUnd() },    "Tot. volumen",               .f., "Total volumen",               12, .t. )
   ::AddField( "nPreVol", "N", 16, 6, {|| ::cPicImp },   "Pre. vol.",                  .f., "Precio volumen",              12, .f. )
   ::AddField( "cDocMov", "C", 14, 0, {|| "@!" },        "Doc.",                       .t., "Documento",                    8, .f. )
   ::AddField( "cTipDoc", "C", 20, 0, {|| "@!" },        "Tipo",                       .f., "Tipo de documento",           10, .f. )
   ::AddField( "dFecMov", "D",  8, 0, {|| "@!" },        "Fecha",                      .t., "Fecha",                       10, .f. )
   ::AddField( "cTipVen", "C", 20, 0, {|| "@!" },        "Venta",                      .f., "Tipo de venta",               10, .f. )

   ::AddTmpIndex( "CCODALM", "CCODALM + CCODART + CCODPR1 + CCODPR2 + CVALPR1 + CVALPR2 + cLOTE" )

   ::AddGroup( {|| ::oDbf:cCodAlm }, {|| "Almacén  : " + Rtrim( ::oDbf:cCodAlm ) + "-" + oRetFld( ::oDbf:cCodAlm, ::oDbfAlm ) }, {||"Total almacén..."} )
   ::AddGroup( {|| ::oDbf:cCodAlm + ::oDbf:cCodArt }, {|| "Artículo : " + Rtrim( ::oDbf:cCodArt ) + "-" + Rtrim( oRetFld( ::oDbf:cCodArt, ::oDbfArt ) ) },{||"Total artículo..."} )


RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   DATABASE NEW ::oAlqCliT PATH ( cPatEmp() ) FILE "ALQCLIT.DBF" VIA ( cDriver() ) SHARED INDEX "ALQCLIT.CDX"

   DATABASE NEW ::oAlqCliL PATH ( cPatEmp() ) FILE "ALQCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "ALQCLIL.CDX"

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos" )
      ::CloseFiles()
      lOpen       := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles()

   if !Empty( ::oAlqCliT ) .and. ::oAlqCliT:Used()
      ::oAlqCliT:End()
   end if
   if !Empty( ::oAlqCliL ) .and. ::oAlqCliL:Used()
      ::oAlqCliL:End()
   end if

   ::oAlqCliT := nil
   ::oAlqCliL := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld )

   ::lNewInforme  := .t.

   if !::NewResource()
      return .f.
   end if

   if !::lGrupoArticulo( .t. )
      Return .f.
   end if

   if !::lGrupoCliente( .f. )
      return .f.
   end if

   ::oMtrInf:SetTotal( ::oAlqCliT:Lastrec() )

   ::CreateFilter( aItmAlqCli(), ::oAlqCliT:cAlias )

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   /*Tomo los valores del tree de rangos*/

   ?"Artículo"
   msginfo( ::oGrupoArticulo:Cargo:Todos, "Todos" )
   msginfo( ::oGrupoArticulo:Cargo:Desde, "Desde" )
   msginfo( ::oGrupoArticulo:Cargo:Hasta, "Hasta" )

   ?"Cliente"
   msginfo( ::oGrupoCliente:Cargo:Todos, "Todos" )
   msginfo( ::oGrupoCliente:Cargo:Desde, "Desde" )
   msginfo( ::oGrupoCliente:Cargo:Hasta, "Hasta" )

   /*Tomo los valores del tree de las condiciones*/

   ?TvGetCheckState( ::oTreeCondiciones:hWnd, ::oDesglosar:hItem )
   ?TvGetCheckState( ::oTreeCondiciones:hWnd, ::oImporteCero:hItem )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//