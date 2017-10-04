#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TInfArtFam FROM TInfGen

   DATA  cDbfArt
   DATA  cDbfDiv
   DATA  cDbfKit
   DATA  cDbfIva
   DATA  cDbfFam
   DATA  oStock

   DATA  lOnlySelected     AS LOGIC    INIT .f.

   DATA  lExcPre           AS LOGIC    INIT  .t.
   DATA  lExcObsoletos     AS LOGIC    INIT  .t.

   DATA  oCmbArt           AS OBJECT
   DATA  oCmbFam           AS OBJECT
   DATA  lActCos           AS LOGIC    INIT  .f.

   METHOD Create()

   METHOD lResource( cFld )

   METHOD lGenerate()

   METHOD Play( lOnlySelected, dbfArticulo, dbfDiv, dbfKit, dbfIva, dbfFam, oStock, oWndBrw )

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField( "Codigo",  "C", 28, 0, {|| "@!" },        "Código",         .t., "Código del artículo",                  14, .f. )
   ::AddField( "CodeBar", "C", 20, 0, {|| "@!" },        "Cód. barras",    .t., "Código de barras",                     14, .f. )
   ::AddField( "ImgBar",  "C", 20, 0, {|| "" },          "",               .f., "Imagen del código de barras",          20, .f., {|| 4 } )
   ::AddField( "Nombre",  "C", 60, 0, {|| "" },          "Artículo",       .t., "Nombre del artículo",                  30, .f. )
   ::AddField( "cDesTik", "C", 20, 0, {|| "" },          "Des. tiket",     .f., "Descripción para tiket",               14, .f. )
   if !oUser():lNotCostos()
   ::AddField( "pCosto",  "N", 15, 6, {|| ::cPicIn },    "Costo" ,         .f., "Precio de costo",                      10, .f. )
   end if

   ::AddField( "pVprec",  "N", 15, 6, {|| ::cPicOut },    "P.V.R.",        .f., "Precio venta recomendado" ,            10, .f. )
   ::AddField( "nStock",  "N", 16, 6, {|| MasUnd() },     "Stock",         .f., "Stock" ,                               10, .f. )
   ::AddField( "Benef1",  "N",  6, 2, {|| "@EZ 999.99" },"%Bnf. 1",        .f., "Porcentaje beneficio precio 1" ,        4, .f. )
   ::AddField( "Benef2",  "N",  6, 2, {|| "@EZ 999.99" },"%Bnf. 2" ,       .f., "Porcentaje beneficio precio 2" ,        4, .f. )
   ::AddField( "Benef3",  "N",  6, 2, {|| "@EZ 999.99" },"%Bnf. 3" ,       .f., "Porcentaje beneficio precio 3" ,        4, .f. )
   ::AddField( "Benef4",  "N",  6, 2, {|| "@EZ 999.99" },"%Bnf. 4" ,       .f., "Porcentaje beneficio precio 4" ,        4, .f. )
   ::AddField( "Benef5",  "N",  6, 2, {|| "@EZ 999.99" },"%Bnf. 5" ,       .f., "Porcentaje beneficio precio 5" ,        4, .f. )
   ::AddField( "Benef6",  "N",  6, 2, {|| "@EZ 999.99" },"%Bnf. 6" ,       .f., "Porcentaje beneficio precio 6" ,        4, .f. )
   ::AddField( "pVenta1", "N", 15, 6, {|| ::cPicOut },   "PVP 1" ,         .t., "Precio de venta 1" ,                   10, .f. )
   ::AddField( "pVenta2", "N", 15, 6, {|| ::cPicOut },   "PVP 2" ,         .f., "Precio de venta 2" ,                   10, .f. )
   ::AddField( "pVenta3", "N", 15, 6, {|| ::cPicOut },   "PVP 3" ,         .f., "Precio de venta 3" ,                   10, .f. )
   ::AddField( "pVenta4", "N", 15, 6, {|| ::cPicOut },   "PVP 4" ,         .f., "Precio de venta 4" ,                   10, .f. )
   ::AddField( "pVenta5", "N", 15, 6, {|| ::cPicOut },   "PVP 5" ,         .f., "Precio de venta 5" ,                   10, .f. )
   ::AddField( "pVenta6", "N", 15, 6, {|| ::cPicOut },   "PVP 6" ,         .f., "Precio de venta 6" ,                   10, .f. )
   ::AddField( "pVtaIva1","N", 15, 6, {|| ::cPicOut },   "PVP 1 I.I." ,    .t., "Precio de venta 1 " + cImp() + " incluido",       10, .f. )
   ::AddField( "pVtaIva2","N", 15, 6, {|| ::cPicOut },   "PVP 2 I.I." ,    .f., "Precio de venta 2 " + cImp() + " incluido",       10, .f. )
   ::AddField( "pVtaIva3","N", 15, 6, {|| ::cPicOut },   "PVP 3 I.I." ,    .f., "Precio de venta 3 " + cImp() + " incluido",       10, .f. )
   ::AddField( "pVtaIva4","N", 15, 6, {|| ::cPicOut },   "PVP 4 I.I." ,    .f., "Precio de venta 4 " + cImp() + " incluido",       10, .f. )
   ::AddField( "pVtaIva5","N", 15, 6, {|| ::cPicOut },   "PVP 5 I.I." ,    .f., "Precio de venta 5 " + cImp() + " incluido",       10, .f. )
   ::AddField( "pVtaIva6","N", 15, 6, {|| ::cPicOut },   "PVP 6 I.I." ,    .f., "Precio de venta 6 " + cImp() + " incluido",       10, .f. )

   ::AddField( "pAlq1",   "N", 15, 6, {|| ::cPicOut },   "Alq. 1" ,        .f., "Precio de alquiler 1" ,                10, .f. )
   ::AddField( "pAlq2",   "N", 15, 6, {|| ::cPicOut },   "Alq 2" ,         .f., "Precio de alquiler 2" ,                10, .f. )
   ::AddField( "pAlq3",   "N", 15, 6, {|| ::cPicOut },   "Alq 3" ,         .f., "Precio de alquiler 3" ,                10, .f. )
   ::AddField( "pAlq4",   "N", 15, 6, {|| ::cPicOut },   "Alq 4" ,         .f., "Precio de alquiler 4" ,                10, .f. )
   ::AddField( "pAlq5",   "N", 15, 6, {|| ::cPicOut },   "Alq 5" ,         .f., "Precio de alquiler 5" ,                10, .f. )
   ::AddField( "pAlq6",   "N", 15, 6, {|| ::cPicOut },   "Alq 6" ,         .f., "Precio de alquiler 6" ,                10, .f. )
   ::AddField( "pAlqIva1","N", 15, 6, {|| ::cPicOut },   "Alq 1 I.I." ,    .f., "Precio de alquiler 1 " + cImp() + " incluido",    10, .f. )
   ::AddField( "pAlqIva2","N", 15, 6, {|| ::cPicOut },   "Alq 2 I.I." ,    .f., "Precio de alquiler 2 " + cImp() + " incluido",    10, .f. )
   ::AddField( "pAlqIva3","N", 15, 6, {|| ::cPicOut },   "Alq 3 I.I." ,    .f., "Precio de alquiler 3 " + cImp() + " incluido",    10, .f. )
   ::AddField( "pAlqIva4","N", 15, 6, {|| ::cPicOut },   "Alq 4 I.I." ,    .f., "Precio de alquiler 4 " + cImp() + " incluido",    10, .f. )
   ::AddField( "pAlqIva5","N", 15, 6, {|| ::cPicOut },   "Alq 5 I.I." ,    .f., "Precio de alquiler 5 " + cImp() + " incluido",    10, .f. )
   ::AddField( "pAlqIva6","N", 15, 6, {|| ::cPicOut },   "Alq 6 I.I." ,    .f., "Precio de alquiler 6 " + cImp() + " incluido",    10, .f. )

   ::AddField( "nPntVer1","N", 15, 6, {|| ::cPicPnt },   "P.V.",           .f., "Contribución punto verde" ,            10, .f. )
   ::AddField( "nPnvIva1","N", 15, 6, {|| ::cPicPnt },   "P.V. I.I.",      .f., "Contribución punto verde " + cImp() + " inc.",    10, .f. )
   ::AddField( "nIva",    "N",  5, 2, {|| "@EZ 99.9" },  "%" + cImp(),        .t., "Tipo de " + cImp(),                        6, .f. )
   ::AddField( "Familia", "C", 16, 0, {|| "@!" },        "Cod. Fam.",      .f., "Código de la familia",                  8, .f. )
   ::AddField( "Nombref", "C", 40, 0, {|| "@!" },        "Nom. Fam.",      .f., "Nombre de la familia",                 20, .f. )

   ::AddField( "cUnidad", "C",  2, 0, {|| "@!" },        "Und. medición",  .f., "Unidad de medición",                   10, .f. )
   ::AddField( "nLngArt", "N", 16, 6, {|| MasUnd() },    "Largo",          .f., "Largo del artículo",                    8, .f. )
   ::AddField( "nAltArt", "N", 16, 6, {|| MasUnd() },    "Alto",           .f., "Alto del artículo",                     8, .f. )
   ::AddField( "nAncArt", "N", 16, 6, {|| MasUnd() },    "Ancho",          .f., "Ancho del artículo",                    8, .f. )
   ::AddField( "nPesoKG", "N", 16, 6, {|| MasUnd() },    "Peso",           .f., "Peso del artículo",                     8, .f. )
   ::AddField( "nVolumen","N", 16, 6, {|| MasUnd() },    "Volumen",        .f., "Volumen del artículo",                  8, .f. )

   ::AddTmpIndex( "FamCod1", "Familia + Codigo" )
   ::AddTmpIndex( "FamNom1", "Familia + Nombre" )
   ::AddTmpIndex( "FamBar1", "Familia + CodeBar" )
   ::AddTmpIndex( "FamCod2", "Nombref + Codigo" )
   ::AddTmpIndex( "FamNom2", "Nombref + Nombre" )
   ::AddTmpIndex( "FamBar2", "Nombref + CodeBar" )

   ::AddGroup( {|| ::oDbf:Familia }, {|| "Familia : " + Rtrim( ::oDbf:Familia ) + "-" + oRetFld( ::oDbf:Familia, ::oDbfFam ) }, {||""} )

   ::lDefFecInf   := .f.
   ::lDefSerInf   := .f.

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld )

   local cCmbArt   := "Código"
   local cCmbFam   := "Código"

   if !::StdResource( "INF_ART01" )
      return .f.
   end if

   /*
   Monta los articulos de manera automatica
   */

   ::lDefFamInf( 70, 80, 90, 100, 600 )

   ::lIntArtInf( 110, 120, 130, 140, 800, ::cDbfArt, ::oDbfDiv, ::cDbfKit, ::cDbfIva )

   REDEFINE CHECKBOX ::lExcPre ;
      ID       190 ;
      OF       ::oFld:aDialogs[1]

   REDEFINE CHECKBOX ::lSalto ;
      ID       200 ;
      OF       ::oFld:aDialogs[1]

   REDEFINE CHECKBOX ::lExcObsoletos ;
      ID       210 ;
      OF       ::oFld:aDialogs[1]

   REDEFINE COMBOBOX ::oCmbFam VAR cCmbFam ;
      ID       219 ;
      ITEMS    { "Código", "Nombre" } ;
      OF       ::oFld:aDialogs[1]

   REDEFINE COMBOBOX ::oCmbArt VAR cCmbArt ;
      ID       220 ;
      ITEMS    { "Código", "Código barras", "Nombre" } ;
      OF       ::oFld:aDialogs[1]

   ::CreateFilter( aItmArt(), ::cDbfArt )

   /*
   Damos valor al meter
   */

   ::oMtrInf:SetTotal( ( ::cDbfArt )->( Lastrec() ) )

   ::oFld:aDialogs[1]:AddFastKey( VK_F12, {|| ::lActCos := .t., MsgInfo( "Coste activado" ) } )

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   ::oDlg:Disable()
   ::oDbf:Zap()

   ::aHeader      := {  {|| "Fecha     : " + Dtoc( Date() ) },;
                        {|| "Familias  : " + if( ::lAllFam, "Todas", AllTrim( ::cFamOrg ) + " > " + AllTrim( ::cFamDes ) ) },;
                        {|| "Artículos : " + if( ::lAllArt, "Todos", AllTrim( ::cArtOrg ) + " > " + AllTrim( ::cArtDes ) ) } }

   ::aoGroup[1]:lEject  := ::lSalto

   ::oMtrInf:SetTotal( ( ::cDbfArt )->( OrdKeyCount() ) )

   ( ::cDbfArt )->( dbGoTop() )

   while !( ::cDbfArt )->( Eof() )

      if ( ::lAllArt .or. ( ( ::cDbfArt )->Codigo >= ::cArtOrg .and. ( ::cDbfArt )->Codigo  <= ::cArtDes ) )   .and.;
         ( ::lAllFam .or. ( ( ::cDbfArt )->Familia >= ::cFamOrg .and. ( ::cDbfArt )->Familia <= ::cFamDes ) )  .and.;
         ( if( ::lExcObsoletos, !( ::cDbfArt )->lObs, .t. ) )                                                  .and.;
         ( if( ::lExcPre, ( ::cDbfArt )->pVenta1 != 0 .or. ( ::cDbfArt )->pVenta2 != 0 .or. ( ::cDbfArt )->pVenta3 != 0 .or. ( ::cDbfArt )->pVenta4 != 0 .or. ( ::cDbfArt )->pVenta5 != 0 .or. ( ::cDbfArt )->pVenta6 != 0, .t. ) ) .and. ;
         ( if( ::lOnlySelected, ( ::cDbfArt )->lLabel, .t. ) )                                                 

         if ::oDbf:Append()

            if ::lActCos
               ::oDbf:Codigo  := AllTrim( ( ::cDbfArt )->Codigo )
               ::oDbf:Codigo  += AllTrim( Str( Int( nCosto( nil, ::cDbfArt, ::cDbfKit ) ) ) )
               ::oDbf:Codigo  += "C"
               ::oDbf:Codigo  += AllTrim( Str( Int( ( nCosto( nil, ::cDbfArt, ::cDbfKit ) - Int( nCosto( nil, ::cDbfArt, ::cDbfKit ) ) ) * 100 ) ) )
               ::oDbf:Codigo  += "1"
            else
               ::oDbf:Codigo  := ( ::cDbfArt )->Codigo
            end if

            ::oDbf:CodeBar    := ( ::cDbfArt )->CodeBar
            ::oDbf:ImgBar     := cEan13( Rtrim( ( ::cDbfArt )->CodeBar ) )
            ::oDbf:Nombre     := ( ::cDbfArt )->Nombre
            ::oDbf:cDesTik    := ( ::cDbfArt )->cDesTik

            if !oUser():lNotCostos()
               ::oDbf:pCosto  := nCosto( nil, ::cDbfArt, ::cDbfKit )
            end if

            ::oDbf:PvpRec     := nCnv2Div( ( ::cDbfArt )->PvpRec, cDivEmp(), ::cDivInf, ::oDbfDiv:cAlias )

            if ( ::cDbfArt )->nCtlStock <= 1
               ::oDbf:nStock  := ::oStock:nStockAlmacen( ( ::cDbfArt )->Codigo )
            else
               ::oDbf:nStock  := 0
            end if

            ::oDbf:Benef1     := ( ::cDbfArt )->Benef1
            ::oDbf:Benef2     := ( ::cDbfArt )->Benef2
            ::oDbf:Benef3     := ( ::cDbfArt )->Benef3
            ::oDbf:Benef4     := ( ::cDbfArt )->Benef4
            ::oDbf:Benef5     := ( ::cDbfArt )->Benef5
            ::oDbf:Benef6     := ( ::cDbfArt )->Benef6

            ::oDbf:pVenta1    := nCnv2Div( ( ::cDbfArt )->pVenta1, cDivEmp(), ::cDivInf )
            ::oDbf:pVenta2    := nCnv2Div( ( ::cDbfArt )->pVenta2, cDivEmp(), ::cDivInf )
            ::oDbf:pVenta3    := nCnv2Div( ( ::cDbfArt )->pVenta3, cDivEmp(), ::cDivInf )
            ::oDbf:pVenta4    := nCnv2Div( ( ::cDbfArt )->pVenta4, cDivEmp(), ::cDivInf )
            ::oDbf:pVenta5    := nCnv2Div( ( ::cDbfArt )->pVenta5, cDivEmp(), ::cDivInf )
            ::oDbf:pVenta6    := nCnv2Div( ( ::cDbfArt )->pVenta6, cDivEmp(), ::cDivInf )
            ::oDbf:pVtaIva1   := nCnv2Div( ( ::cDbfArt )->pVtaIva1, cDivEmp(), ::cDivInf )
            ::oDbf:pVtaIva2   := nCnv2Div( ( ::cDbfArt )->pVtaIva2, cDivEmp(), ::cDivInf )
            ::oDbf:pVtaIva3   := nCnv2Div( ( ::cDbfArt )->pVtaIva3, cDivEmp(), ::cDivInf )
            ::oDbf:pVtaIva4   := nCnv2Div( ( ::cDbfArt )->pVtaIva4, cDivEmp(), ::cDivInf )
            ::oDbf:pVtaIva5   := nCnv2Div( ( ::cDbfArt )->pVtaIva5, cDivEmp(), ::cDivInf )
            ::oDbf:pVtaIva6   := nCnv2Div( ( ::cDbfArt )->pVtaIva6, cDivEmp(), ::cDivInf )
            ::oDbf:nPntVer1   := nCnv2Div( ( ::cDbfArt )->nPntVer1, cDivEmp(), ::cDivInf )
            ::oDbf:nPnvIva1   := nCnv2Div( ( ::cDbfArt )->nPnvIva1, cDivEmp(), ::cDivInf )

            ::oDbf:pAlq1      := nCnv2Div( ( ::cDbfArt )->pAlq1, cDivEmp(), ::cDivInf )
            ::oDbf:pAlq2      := nCnv2Div( ( ::cDbfArt )->pAlq2, cDivEmp(), ::cDivInf )
            ::oDbf:pAlq3      := nCnv2Div( ( ::cDbfArt )->pAlq3, cDivEmp(), ::cDivInf )
            ::oDbf:pAlq4      := nCnv2Div( ( ::cDbfArt )->pAlq4, cDivEmp(), ::cDivInf )
            ::oDbf:pAlq5      := nCnv2Div( ( ::cDbfArt )->pAlq5, cDivEmp(), ::cDivInf )
            ::oDbf:pAlq6      := nCnv2Div( ( ::cDbfArt )->pAlq6, cDivEmp(), ::cDivInf )
            ::oDbf:pAlqIva1   := nCnv2Div( ( ::cDbfArt )->pAlqIva1, cDivEmp(), ::cDivInf )
            ::oDbf:pAlqIva2   := nCnv2Div( ( ::cDbfArt )->pAlqIva2, cDivEmp(), ::cDivInf )
            ::oDbf:pAlqIva3   := nCnv2Div( ( ::cDbfArt )->pAlqIva3, cDivEmp(), ::cDivInf )
            ::oDbf:pAlqIva4   := nCnv2Div( ( ::cDbfArt )->pAlqIva4, cDivEmp(), ::cDivInf )
            ::oDbf:pAlqIva5   := nCnv2Div( ( ::cDbfArt )->pAlqIva5, cDivEmp(), ::cDivInf )
            ::oDbf:pAlqIva6   := nCnv2Div( ( ::cDbfArt )->pAlqIva6, cDivEmp(), ::cDivInf )

            ::oDbf:nPntVer1   := nCnv2Div( ( ::cDbfArt )->nPntVer1, cDivEmp(), ::cDivInf )
            ::oDbf:nPnvIva1   := nCnv2Div( ( ::cDbfArt )->nPnvIva1, cDivEmp(), ::cDivInf )
            
            ::oDbf:cUnidad    := ( ::cDbfArt )->cUnidad
            ::oDbf:nLngArt    := ( ::cDbfArt )->nLngArt
            ::oDbf:nAltArt    := ( ::cDbfArt )->nAltArt
            ::oDbf:nAncArt    := ( ::cDbfArt )->nAncArt
            ::oDbf:nPesoKG    := ( ::cDbfArt )->nPesoKG
            ::oDbf:nVolumen   := ( ::cDbfArt )->nVolumen


            ::oDbf:Familia    := ( ::cDbfArt )->Familia

            ::oDbf:nIva       := nIva( ::cDbfIva, ( ::cDbfArt )->TipoIva )

            if ( ::cDbfFam )->( dbSeek( ( ::cDbfArt )->Familia ) )
               ::oDbf:Nombref := ( ::cDbfFam )->cNomFam
            else
               ::oDbf:Nombref := ""
            end if

            ::oDbf:Save()

         else
            MsgStop( "Error al agregar registros" )
         end if

      end if

      ( ::cDbfArt )->( dbSkip() )

      ::oMtrInf:AutoInc()

   end do

   ::oMtrInf:AutoInc( ( ::cDbfArt )->( LastRec() ) )

   if ::oDbf:RecCount() > 0

      do case
         case ::oCmbFam:nAt == 1 .and. ::oCmbArt:nAt == 1
            ::oDbf:OrdSetFocus( "FamCod1" )
         case ::oCmbFam:nAt == 2 .and. ::oCmbArt:nAt == 1
            ::oDbf:OrdSetFocus( "FamCod2" )
         case ::oCmbFam:nAt == 1 .and. ::oCmbArt:nAt == 2
            ::oDbf:OrdSetFocus( "FamBar1" )
         case ::oCmbFam:nAt == 2 .and. ::oCmbArt:nAt == 2
            ::oDbf:OrdSetFocus( "FamBar2" )
         case ::oCmbFam:nAt == 1 .and. ::oCmbArt:nAt == 3
            ::oDbf:OrdSetFocus( "FamNom1" )
         case ::oCmbFam:nAt == 2 .and. ::oCmbArt:nAt == 3
            ::oDbf:OrdSetFocus( "FamNom2" )

      end case

   end if

   ::AplyFilter()

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//

METHOD Play( lOnlySelected, dbfArticulo, dbfDiv, dbfKit, dbfIva, dbfFam, oStock, oWndBrw )

   local nRec              := ( dbfArticulo )->( Recno() )
   local nOrd              := ( dbfArticulo )->( OrdSetFocus( 1 ) )

   DEFAULT lOnlySelected   := .f.

   ::cDbfArt               := dbfArticulo
   ::cDbfDiv               := dbfDiv
   ::cDbfKit               := dbfKit
   ::cDbfIva               := dbfIva
   ::cDbfFam               := dbfFam
   ::oStock                := oStock
   ::lOnlySelected         := lOnlySelected

   ::Create()

   if ::lOpenFiles
      if ::lResource()
         ::Activate()
      end if
   end if

   ::End()

   ( dbfArticulo )->( dbGoTo( nRec ) )
   ( dbfArticulo )->( OrdSetFocus( nOrd ) )

   oWndBrw:Refresh()

RETURN ( Self )

//---------------------------------------------------------------------------//