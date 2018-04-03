#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TInfArtTip FROM TInfGen

   DATA  oDbfKit           AS OBJECT
   DATA  oDbfIva           AS OBJECT
   DATA  oCmbArt           AS OBJECT
   DATA  lExcPre           AS LOGIC    INIT  .t.
   DATA  lExcObsoletos     AS LOGIC    INIT  .t.
   DATA  lActCos           AS LOGIC    INIT  .f.
   DATA  aCmbArt           AS ARRAY    INIT  { "C�digo", "Nombre" }

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField( "cCodTip", "C",  4, 0, {|| "@!" },     "Cod. Tip.",   .f., "C�digo del tipo de art�culo",     8, .f. )
   ::AddField( "cNomTip", "C", 35, 0, {|| "@!" },     "Nom. Tip.",   .f., "Nombre del tipo de art�culo",    20, .f. )
   ::AddField( "Codigo",  "C", 28, 0, {|| "@!" },     "C�digo",      .t., "C�digo del art�culo",            14, .f. )
   ::AddField( "CodeBar", "C", 20, 0, {|| "@!" },     "C�d. barras", .t., "C�digo de barras",               14, .f. )
   ::AddField( "ImgBar",  "C", 20, 0, {|| "" },       "",            .f., "Imagen del c�digo de barras",    20, .f., {|| 4 } )
   ::AddField( "Nombre",  "C",100, 0, {|| "" },       "Art�culo",    .t., "Nombre del art�culo",            30, .f. )
   ::AddField( "cDesTik", "C", 20, 0, {|| "" },       "Des. tiket",  .f., "Descripci�n para tiket",         14, .f. )
   ::AddField( "pCosto",  "N", 15, 6, {|| cPinDiv()}, "Costo" ,      .f., "Precio de costo",                10, .f. )
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
   ::AddField( "nPntVer1","N", 15, 6, {|| PicOut() },  "P.V.",       .f., "Contribuci�n punto verde" ,      10, .f. )
   ::AddField( "nPnvIva1","N", 15, 6, {|| PicOut() },  "P.V. I.I.",  .f., "Contribuci�n punto verde " + cImp() + " inc.", 10, .f. )
   ::AddField( "nIva",    "N",  5, 2, {|| "@EZ 99.9" },"%" + cImp(), .t., "Tipo de " + cImp(),                  6, .f. )

   ::AddTmpIndex( "CodTip", "cCodTip + Codigo" )
   ::AddTmpIndex( "NomTip", "cCodTip + Nombre" )

   ::AddGroup( {|| ::oDbf:cCodTip }, {|| "Tipo de art�culo : " + Rtrim( ::oDbf:cCodTip ) + "-" + Rtrim( ::oDbf:cNomTip ) }, {|| "Total tipo..." } )

   ::lDefFecInf   := .f.
   ::lDefSerInf   := .f.

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS TInfArtTip

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   DATABASE NEW ::oDbfKit PATH ( cPatEmp() ) FILE "ARTKIT.DBF" VIA ( cDriver() ) SHARED INDEX "ARTKIT.CDX"

   DATABASE NEW ::oDbfIva PATH ( cPatDat() ) FILE "TIVA.DBF" VIA ( cDriver() ) SHARED INDEX "TIVA.CDX"

   RECOVER

      msgStop( 'Imposible abrir todas las bases de datos' )
      ::CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TInfArtTip

   if !Empty( ::oDbfKit ) .and. ::oDbfKit:Used()
      ::oDbfKit:End()
   end if
   if !Empty( ::oDbfIva ) .and. ::oDbfIva:Used()
      ::oDbfIva:End()
   end if

   ::oDbfKit   := nil
   ::oDbfIva   := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld )

   local cCmbArt   := "C�digo"

   /*Monta el recurso*/
   if !::StdResource( "INF_ART03" )
      return .f.
   end if

   /*Monta los tipos de art�culos*/
   if !::oDefTipInf( 70, 80, 90, 100, 600 )
      return .f.
   end if

   /*Monta los art�culos*/
   if !::lDefArtInf( 110, 120, 130, 140, 800 )
      return .f.
   end if

   /*L�gico para excluir los art�culos que tengan precios a cero*/
   REDEFINE CHECKBOX ::lExcPre ;
      ID       190 ;
      OF       ::oFld:aDialogs[1]

   /*L�gico para excluir los art�culos marcados como obsoleto*/
   REDEFINE CHECKBOX ::lExcObsoletos ;
      ID       210 ;
      OF       ::oFld:aDialogs[1]

   /*Monta el combo para los �rdenes*/
   REDEFINE COMBOBOX ::oCmbArt VAR cCmbArt ;
      ID       220 ;
      ITEMS    ::aCmbArt ;
      OF       ::oFld:aDialogs[1]

   /*Damos valor al meter*/
   ::oMtrInf:SetTotal( ::oDbfArt:Lastrec() )

   /*Montamos los filtros*/
   ::CreateFilter( aItmArt(), ::oDbfArt:cAlias )

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   local cExpArt  := ".t."

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   ::aHeader      := {  {|| "Fecha         : " + Dtoc( Date() ) },;
                        {|| "Tipo art�culo : " + if( ::lAllTip, "Todos", AllTrim( ::cTipOrg ) + " > " + AllTrim( ::cTipDes ) ) },;
                        {|| "Art�culos     : " + if( ::lAllArt, "Todos", AllTrim( ::cArtOrg ) + " > " + AllTrim( ::cArtDes ) ) },;
                        {|| "Ordenado por  : " + ::aCmbArt[ ::oCmbArt:nAt ] } }

   ::oDbfArt:OrdSetFocus( "Codigo" )

   if !::lAllArt
      cExpArt     += ' .and. Codigo >= "' + ::cArtOrg + '" .and. Codigo <= "' + ::cArtDes + '"'
   end if

   if !::lAllTip
      cExpArt     += ' .and. cCodTip >= "' + ::cTipOrg + '" .and. cCodTip <= "' + ::cTipDes + '"'
   end if

   if ::lExcObsoletos
      cExpArt     += ' .and. !lObs'
   end if

   if ::lExcPre
      cExpArt     += ' .and. ( pVenta1 != 0 .or. pVenta2 != 0 .or. pVenta3 != 0 .or. pVenta4 != 0 .or. pVenta5 != 0 .or. pVenta6 != 0 )'
   end if

   if !Empty( ::oFilter:cExpresionFilter )
      cExpArt     += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oDbfArt:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oDbfArt:cFile ), ::oDbfArt:OrdKey(), ( cExpArt ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oDbfArt:OrdKeyCount() )

   ::oDbfArt:GoTop()

   while !::lBreak .and. !::oDbfArt:Eof()

      ::oDbf:Append()
      ::oDbf:Codigo     := ::oDbfArt:Codigo
      ::oDbf:CodeBar    := ::oDbfArt:CodeBar
      ::oDbf:ImgBar     := cEan13( Rtrim( ::oDbfArt:CodeBar ) )
      ::oDbf:Nombre     := ::oDbfArt:Nombre
      ::oDbf:cDesTik    := ::oDbfArt:cDesTik
      ::oDbf:pCosto     := nCosto( nil, ::oDbfArt:cAlias, ::oDbfKit:cAlias )
      ::oDbf:pVpRec     := ::oDbfArt:pVpRec
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
      ::oDbf:nIva       := nIva( ::oDbfIva, ::oDbfArt:TipoIva )
      ::oDbf:cCodTip    := ::oDbfArt:cCodTip
      ::oDbf:cNomTip    := oRetFld( ::oDbfArt:cCodTip, ::oTipArt:oDbf, "cNomTip" )

      ::oDbf:Save()

      ::oDbfArt:Skip()

      ::oMtrInf:AutoInc( ::oDbfArt:OrdKeyNo() )

   end do

   ::oDbfArt:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oDbfArt:cFile ) )

   ::oMtrInf:AutoInc( ::oDbfArt:LastRec() )

   if ::oDbf:RecCount() > 0
      ::oDbf:OrdSetFocus( ::oCmbArt:nAt )
   end if

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//