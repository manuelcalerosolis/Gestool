#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TInfAtp FROM TInfGen

   DATA cArtOrg      AS OBJECT
   DATA cArtDes      AS OBJECT
   DATA oDbfArt      AS OBJECT
   DATA oDbfArtKit   AS OBJECT
   DATA oDbfCli      AS OBJECT
   DATA lAllArt      AS LOGIC    INIT .t.

   METHOD Create()

   METHOD lResource( cFld )

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lGenerate()

   METHOD cArt( aGet, aGet2 )

   METHOD BrwAtipica( aGet, aGet2 )

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField( "cCodArt",     "C", 18, 0, {|| "@!" },          "Código artículo",       .f., "Código del artículo",         12, .f. )
   ::AddField( "cNomArt",     "C",100, 0, {|| "@!" },          "Nom. Art.",       .t., "Nombre del artículo",         40, .f. )
   ::AddField( "nCosto",      "N", 16, 6, {|| ::cPicCom },     "Coste" ,          .t., "Precio de costo",             12, .f. )
   ::AddField( "dFecIni",     "D",  8, 0, {|| "" },            "Inicio" ,         .t., "Fecha inicio",                 8, .f. )
   ::AddField( "dFecFin",     "D",  8, 0, {|| "" },            "Fin" ,            .t., "Fecha fin",                    8, .f. )
   ::AddField( "nTarifa1",    "N", 16, 6, {|| ::cPicImp },     "Tarifa 1" ,       .t., "Tarifa cliente 1" ,           12, .f. )
   ::AddField( "nTarifa2",    "N", 16, 6, {|| ::cPicImp },     "Tarifa 2" ,       .f., "Tarifa cliente 2" ,           12, .f. )
   ::AddField( "nTarifa3",    "N", 16, 6, {|| ::cPicImp },     "Tarifa 3" ,       .f., "Tarifa cliente 3" ,           12, .f. )
   ::AddField( "nTarifa4",    "N", 16, 6, {|| ::cPicImp },     "Tarifa 4" ,       .f., "Tarifa cliente 4" ,           12, .f. )
   ::AddField( "nTarifa5",    "N", 16, 6, {|| ::cPicImp },     "Tarifa 5" ,       .f., "Tarifa cliente 5" ,           12, .f. )
   ::AddField( "nTarifa6",    "N", 16, 6, {|| ::cPicImp },     "Tarifa 6" ,       .f., "Tarifa cliente 6" ,           12, .f. )
   ::AddField( "nProXY",      "C", 10, 0, {|| "@!" },          "Pro. X*Y" ,       .t., "Promoción X*Y" ,              10, .f. )
   ::AddField( "nDtoArt",     "N",  6, 2, {|| "@E 999.99" },   "Dto. art. %" ,    .t., "Descuento artículo" ,         12, .f. )
   ::AddField( "nDtoLin",     "N", 16, 6, {|| ::cPicImp },     "Dto. lineal" ,    .f., "Descuento lineal" ,           12, .f. )
   ::AddField( "nDtoProm",    "N",  6, 2, {|| "@E 999.99" },   "Dto. promo. %" ,  .f., "Descuento promoción" ,        12, .f. )
   ::AddField( "nComAge",     "N",  6, 2, {|| "@E 999.99" },   "Com. agente %" ,  .f., "Comisión de agente" ,         15, .f. )
   ::AddField( "nDtoGen",     "N",  6, 2, {|| "@E 999.99" },   "Dto. def1 %" ,    .f., "Descuento definido 1" ,       12, .f. )
   ::AddField( "nDtoPP",      "N",  6, 2, {|| "@E 999.99" },   "Dto. def2 %" ,    .f., "Descuento definido 2" ,       12, .f. )
   ::AddField( "nDtoDef1",    "N",  6, 2, {|| "@E 999.99" },   "Dto. def3 %" ,    .f., "Descuento definido 3" ,       12, .f. )
   ::AddField( "nDtoDef2",    "N",  6, 2, {|| "@E 999.99" },   "Dto. def4 %" ,    .f., "Descuento definido 4" ,       12, .f. )
   ::AddField( "nDtoAtp",     "N",  6, 2, {|| "@E 999.99" },   "Dto. atp. %" ,    .f., "Descuento atipico" ,          12, .f. )
   ::AddField( "nNeto1",      "N", 16, 6, {|| ::cPicImp },     "Tar. neta 1" ,    .t., "Tarifa neta 1" ,              15, .f. )
   ::AddField( "nNeto2",      "N", 16, 6, {|| ::cPicImp },     "Tar. neta 2" ,    .f., "Tarifa neta 2" ,              15, .f. )
   ::AddField( "nNeto3",      "N", 16, 6, {|| ::cPicImp },     "Tar. neta 3" ,    .f., "Tarifa neta 3" ,              15, .f. )
   ::AddField( "nNeto4",      "N", 16, 6, {|| ::cPicImp },     "Tar. neta 4" ,    .f., "Tarifa neta 4" ,              15, .f. )
   ::AddField( "nNeto5",      "N", 16, 6, {|| ::cPicImp },     "Tar. neta 5" ,    .f., "Tarifa neta 5" ,              15, .f. )
   ::AddField( "nNeto6",      "N", 16, 6, {|| ::cPicImp },     "Tar. neta 6" ,    .f., "Tarifa neta 6" ,              15, .f. )
   ::AddField( "nPntVer",     "N", 16, 6, {|| ::cPicPnt },     "Punto verde" ,    .f., "Punto verde",                 12, .f. )
   ::AddField( "nNetVer1",    "N", 16, 6, {|| ::cPicImp },     "Neto Ver. 1" ,    .f., "Neto 1 con punto verde" ,     15, .f. )
   ::AddField( "nNetVer2",    "N", 16, 6, {|| ::cPicImp },     "Neto Ver. 2" ,    .f., "Neto 2 con punto verde" ,     15, .f. )
   ::AddField( "nNetVer3",    "N", 16, 6, {|| ::cPicImp },     "Neto Ver. 3" ,    .f., "Neto 3 con punto verde" ,     15, .f. )
   ::AddField( "nNetVer4",    "N", 16, 6, {|| ::cPicImp },     "Neto Ver. 4" ,    .f., "Neto 4 con punto verde" ,     15, .f. )
   ::AddField( "nNetVer5",    "N", 16, 6, {|| ::cPicImp },     "Neto Ver. 5" ,    .f., "Neto 5 con punto verde" ,     15, .f. )
   ::AddField( "nNetVer6",    "N", 16, 6, {|| ::cPicImp },     "Neto Ver. 6" ,    .f., "Neto 6 con punto verde" ,     15, .f. )
   ::AddField( "nMarUnd1",    "N", 16, 6, {|| ::cPicImp },     "Mar. und. 1" ,    .t., "Margen unidad 1" ,            12, .f. )
   ::AddField( "nMarUnd2",    "N", 16, 6, {|| ::cPicImp },     "Mar. und. 2" ,    .f., "Margen unidad 2" ,            12, .f. )
   ::AddField( "nMarUnd3",    "N", 16, 6, {|| ::cPicImp },     "Mar. und. 3" ,    .f., "Margen unidad 3" ,            12, .f. )
   ::AddField( "nMarUnd4",    "N", 16, 6, {|| ::cPicImp },     "Mar. und. 4" ,    .f., "Margen unidad 4" ,            12, .f. )
   ::AddField( "nMarUnd5",    "N", 16, 6, {|| ::cPicImp },     "Mar. und. 5" ,    .f., "Margen unidad 5" ,            12, .f. )
   ::AddField( "nMarUnd6",    "N", 16, 6, {|| ::cPicImp },     "Mar. und. 6" ,    .f., "Margen unidad 6" ,            12, .f. )
   ::AddField( "nMarCaj1",    "N", 16, 6, {|| ::cPicImp },     "Mar. caj. 1" ,    .t., "Margen caja 1" ,              12, .f. )
   ::AddField( "nMarCaj2",    "N", 16, 6, {|| ::cPicImp },     "Mar. caj. 2" ,    .f., "Margen caja 2" ,              12, .f. )
   ::AddField( "nMarCaj3",    "N", 16, 6, {|| ::cPicImp },     "Mar. caj. 3" ,    .f., "Margen caja 3" ,              12, .f. )
   ::AddField( "nMarCaj4",    "N", 16, 6, {|| ::cPicImp },     "Mar. caj. 4" ,    .f., "Margen caja 4" ,              12, .f. )
   ::AddField( "nMarCaj5",    "N", 16, 6, {|| ::cPicImp },     "Mar. caj. 5" ,    .f., "Margen caja 5" ,              12, .f. )
   ::AddField( "nMarCaj6",    "N", 16, 6, {|| ::cPicImp },     "Mar. caj. 6" ,    .f., "Margen caja 6" ,              12, .f. )
   ::AddField( "nRenCos1",    "N", 16, 6, {|| "@E 999.99" },   "Ren. costo 1 %" , .t., "Rentabilidad sobre costo 1" , 15, .f. )
   ::AddField( "nRenCos2",    "N", 16, 6, {|| "@E 999.99" },   "Ren. costo 2 %" , .f., "Rentabilidad sobre costo 2" , 15, .f. )
   ::AddField( "nRenCos3",    "N", 16, 6, {|| "@E 999.99" },   "Ren. costo 3 %" , .f., "Rentabilidad sobre costo 3" , 15, .f. )
   ::AddField( "nRenCos4",    "N", 16, 6, {|| "@E 999.99" },   "Ren. costo 4 %" , .f., "Rentabilidad sobre costo 4" , 15, .f. )
   ::AddField( "nRenCos5",    "N", 16, 6, {|| "@E 999.99" },   "Ren. costo 5 %" , .f., "Rentabilidad sobre costo 5" , 15, .f. )
   ::AddField( "nRenCos6",    "N", 16, 6, {|| "@E 999.99" },   "Ren. costo 6 %" , .f., "Rentabilidad sobre costo 6" , 15, .f. )
   ::AddField( "nRenVta1",    "N", 16, 6, {|| "@E 999.99" },   "Ren. venta 1 %" , .t., "Rentabilidad sobre venta 1" , 15, .f. )
   ::AddField( "nRenVta2",    "N", 16, 6, {|| "@E 999.99" },   "Ren. venta 2 %" , .f., "Rentabilidad sobre venta 2" , 15, .f. )
   ::AddField( "nRenVta3",    "N", 16, 6, {|| "@E 999.99" },   "Ren. venta 3 %" , .f., "Rentabilidad sobre venta 3" , 15, .f. )
   ::AddField( "nRenVta4",    "N", 16, 6, {|| "@E 999.99" },   "Ren. venta 4 %" , .f., "Rentabilidad sobre venta 4" , 15, .f. )
   ::AddField( "nRenVta5",    "N", 16, 6, {|| "@E 999.99" },   "Ren. venta 5 %" , .f., "Rentabilidad sobre venta 5" , 15, .f. )
   ::AddField( "nRenVta6",    "N", 16, 6, {|| "@E 999.99" },   "Ren. venta 6 %" , .f., "Rentabilidad sobre venta 6" , 15, .f. )

   ::AddTmpIndex ( "cCodArt", "cCodArt" )

   ::lDefFecInf := .f.
   ::lDefSerInf := .f.

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   DATABASE NEW ::oDbfArt     PATH ( cPatEmp() ) FILE "ARTICULO.DBF" VIA ( cDriver() ) SHARED INDEX "ARTICULO.CDX"

   DATABASE NEW ::oDbfArtKit  PATH ( cPatEmp() ) FILE "ARTKIT.DBF"   VIA ( cDriver() ) SHARED INDEX "ARTKIT.CDX"

   DATABASE NEW ::oDbfCli     PATH ( cPatEmp() ) FILE "CLIENT.DBF"   VIA ( cDriver() ) SHARED INDEX "CLIENT.CDX"

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos" )
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
   if !Empty( ::oDbfArtKit ) .and. ::oDbfArtKit:Used()
      ::oDbfArtKit:End()
   end if
   if !Empty( ::oDbfCli ) .and. ::oDbfCli:Used()
      ::oDbfCli:End()
   end if

   ::oDbfArt      := nil
   ::oDbfArtKit   := nil
   ::oDbfCli      := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld )

   local oArtOrg
   local oArtDes
   local cSayArtOrg
   local oSayArtOrg
   local cSayArtDes
   local oSayArtDes
   local dbfTmpAtp   := ::xOthers[1]

   if !::StdResource( "INF_ATIPICA" )
      return .f.
   end if

   ::oBtnFilter:Disable()

   /*Monta los articulos*/

   ::cArtOrg   := dbFirst( dbfTmpAtp, 2 )
   ::cArtDes   := dbLast(  dbfTmpAtp, 2 )
   cSayArtOrg  := oRetFld( ::cArtOrg, ::oDbfArt )
   cSayArtDes  := oRetFld( ::cArtDes, ::oDbfArt )

   REDEFINE CHECKBOX ::lAllArt ;
      ID       240 ;
      OF       ::oFld:aDialogs[1]

   REDEFINE GET oArtOrg VAR ::cArtOrg;
      ID       ( 200 ) ;
      WHEN     ( !::lAllArt );
      VALID    ( ::cArt( oArtOrg, oSayArtOrg ) ) ;
      BITMAP   "LUPA" ;
      OF       ::oFld:aDialogs[1]

      oArtOrg:bHelp  :={|| ::BrwAtipica( oArtOrg, oSayArtOrg ) }

   REDEFINE GET oSayArtOrg VAR cSayArtOrg ;
		WHEN 		.F.;
      ID       ( 210 ) ;
      OF       ::oFld:aDialogs[1]

   REDEFINE GET oArtDes VAR ::cArtDes;
      ID       ( 220 ) ;
      WHEN     ( !::lAllArt );
      VALID    ( ::cArt( oArtDes, oSayArtDes ) );
      BITMAP   "LUPA" ;
      OF       ::oFld:aDialogs[1]

      oArtDes:bHelp  :={|| ::BrwAtipica( oArtDes, oSayArtDes ) }

   REDEFINE GET oSayArtDes VAR cSayArtDes ;
		WHEN 		.F.;
      ID       ( 230 ) ;
      OF       ::oFld:aDialogs[1]

   /*Damos valor al meter*/

   ::oMtrInf:SetTotal( ( dbfTmpAtp )->( Lastrec() ) )

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   local dbfTmpAtp   := ::xOthers[1]
   local aGetCli     := ::xOthers[2]
   local aTmpCli     := ::xOthers[3]
   local nUniCaja    := 0
   local nDtoAtipico := 0
   local nSbrAtp     := aGetCli[ ::oDbfCli:fieldpos( "nSbrAtp" ) ]:nAt

   ::oDlg:Disable()
   ::oDbf:Zap()

   /*Montamos la cabecera*/

   ::aHeader         := {}

   aAdd( ::aHeader, {|| "Cliente           : " + AllTrim( aTmpCli[ ::oDbfCli:fieldpos( "Cod" ) ] ) + " - " + AllTrim( aTmpCli[ ::oDbfCli:fieldpos( "Titulo" ) ] ) } )
   aAdd( ::aHeader, {|| "Fecha             : " + Dtoc( Date() ) } )
   aAdd( ::aHeader, {|| "Artículos         : " + if( ::lAllArt, "Todos", AllTrim( ::cArtOrg ) + " > " + AllTrim( ::cArtDes ) ) } )

   if aTmpCli[ ::oDbfCli:fieldpos( "nDtoEsp" ) ] != 0
      aAdd( ::aHeader, {|| Left( aTmpCli[ ::oDbfCli:fieldpos( "cDtoEsp" ) ], 17 ) + " : " + AllTrim( Str( aTmpCli[ ::oDbfCli:fieldpos( "nDtoEsp" ) ] ) ) + " %" } )
   end if

   if aTmpCli[ ::oDbfCli:fieldpos( "nDpp"    ) ] != 0
      aAdd( ::aHeader, {|| Left( aTmpCli[ ::oDbfCli:fieldpos( "cDpp" )    ], 17 ) + " : " + AllTrim( Str( aTmpCli[ ::oDbfCli:fieldpos( "nDpp"    ) ] ) ) + " %" } )
   end if

   if aTmpCli[ ::oDbfCli:fieldpos( "nDtoCnt" ) ] != 0
      aAdd( ::aHeader, {|| Left( aTmpCli[ ::oDbfCli:fieldpos( "cDtoUno" ) ], 17 ) + " : " + AllTrim( Str( aTmpCli[ ::oDbfCli:fieldpos( "nDtoCnt" ) ] ) ) + " %" } )
   end if

   if aTmpCli[ ::oDbfCli:fieldpos( "nDtoRap" ) ] != 0
      aAdd( ::aHeader, {|| Left( aTmpCli[ ::oDbfCli:fieldpos( "cDtoDos" ) ], 17 ) + " : " + AllTrim( Str( aTmpCli[ ::oDbfCli:fieldpos( "nDtoRap" ) ] ) ) + " %" } )
   end if

   if aTmpCli[ ::oDbfCli:fieldpos( "nDtoAtp" ) ] != 0
      aAdd( ::aHeader, {|| Left( aTmpCli[ ::oDbfCli:fieldpos( "cDtoAtp" ) ], 17 ) + " : " + AllTrim( Str( aTmpCli[ ::oDbfCli:fieldpos( "nDtoAtp" ) ] ) ) + " %" } )
   end if

   ( dbfTmpAtp )->( dbGoTop() )

   while !( dbfTmpAtp )->( Eof() )

      if ( ::lAllArt .or. ( ( dbfTmpAtp )->cCodArt >= ::cArtOrg .AND. ( dbfTmpAtp )->cCodArt <= ::cArtDes ) )

         if ::oDbfArt:Seek( ( dbfTmpAtp )->cCodArt )

         ::oDbf:Append()

         /*Metemos los datos del articulo*/

         ::oDbf:cCodArt     := ::oDbfArt:Codigo
         ::oDbf:cNomArt     := ::oDbfArt:Nombre

         ::oDbf:dFecIni     := ( dbfTmpAtp )->dFecIni
         ::oDbf:dFecFin     := ( dbfTmpAtp )->dFecFin

         /*
         Tarifas y costo
         */

         if ::cDivInf == cDivChg()

            if ( dbfTmpAtp )->lPrcCom
               ::oDbf:nCosto   := nCnv2Div( ( dbfTmpAtp )->nPrcCom, cDivEmp(), cDivChg() )
            else
               ::oDbf:nCosto   := nCnv2Div( nCosto( nil, ::oDbfArt:cAlias, ::oDbfArtKit:cAlias ), cDivEmp(), cDivChg() )
            end if

            ::oDbf:nTarifa1    := nCnv2Div( ( dbfTmpAtp )->nPrcArt,  cDivEmp(), cDivChg() )
            ::oDbf:nTarifa2    := nCnv2Div( ( dbfTmpAtp )->nPrcArt2, cDivEmp(), cDivChg() )
            ::oDbf:nTarifa3    := nCnv2Div( ( dbfTmpAtp )->nPrcArt3, cDivEmp(), cDivChg() )
            ::oDbf:nTarifa4    := nCnv2Div( ( dbfTmpAtp )->nPrcArt4, cDivEmp(), cDivChg() )
            ::oDbf:nTarifa5    := nCnv2Div( ( dbfTmpAtp )->nPrcArt5, cDivEmp(), cDivChg() )
            ::oDbf:nTarifa6    := nCnv2Div( ( dbfTmpAtp )->nPrcArt6, cDivEmp(), cDivChg() )

            ::oDbf:nDtoLin     := nCnv2Div( ( dbfTmpAtp )->nDtoDiv, cDivEmp(), cDivChg() )

         end if

         if ::cDivInf == cDivEmp()

            if ( dbfTmpAtp )->lPrcCom
               ::oDbf:nCosto   := ( dbfTmpAtp )->nPrcCom
            else
               ::oDbf:nCosto   := nCosto( nil, ::oDbfArt:cAlias, ::oDbfArtKit:cAlias )
            end if

            ::oDbf:nTarifa1    := ( dbfTmpAtp )->nPrcArt
            ::oDbf:nTarifa2    := ( dbfTmpAtp )->nPrcArt2
            ::oDbf:nTarifa3    := ( dbfTmpAtp )->nPrcArt3
            ::oDbf:nTarifa4    := ( dbfTmpAtp )->nPrcArt4
            ::oDbf:nTarifa5    := ( dbfTmpAtp )->nPrcArt5
            ::oDbf:nTarifa6    := ( dbfTmpAtp )->nPrcArt6

            ::oDbf:nDtoLin     := ( dbfTmpAtp )->nDtoDiv

         end if

         /*Descuentos tanto de atipicas como de cliente*/


         do case
            case ( dbfTmpAtp )->nUncOfe == 0 .or. ( dbfTmpAtp )->nUnvOfe == 0
               ::oDbf:nProXY   := ""
            case ( dbfTmpAtp )->nUncOfe == 1 .or. ( dbfTmpAtp )->nUnvOfe == 1
               ::oDbf:nProXY   := "1 + 0"
            case ( dbfTmpAtp )->nUncOfe != 1 .or. ( dbfTmpAtp )->nUnvOfe != 1
               ::oDbf:nProXY   := AllTrim( Str( ( dbfTmpAtp )->nUncOfe ) ) +  " + " + AllTrim( Str( ( dbfTmpAtp )->nUnvOfe - ( dbfTmpAtp )->nUncOfe ) )
         end case

         ::oDbf:nDtoArt        := ( dbfTmpAtp )->nDtoArt
         ::oDbf:nDtoProm       := ( dbfTmpAtp )->nDprArt
         ::oDbf:nComAge        := ( dbfTmpAtp )->nComAge
         ::oDbf:nDtoGen        := aTmpCli[ ::oDbfCli:fieldpos( "nDtoEsp" ) ]
         ::oDbf:nDtoPP         := aTmpCli[ ::oDbfCli:fieldpos( "nDpp"    ) ]
         ::oDbf:nDtoDef1       := aTmpCli[ ::oDbfCli:fieldpos( "nDtoCnt" ) ]
         ::oDbf:nDtoDef2       := aTmpCli[ ::oDbfCli:fieldpos( "nDtoRap" ) ]
         ::oDbf:nDtoAtp        := aTmpCli[ ::oDbfCli:fieldpos( "nDtoAtp" ) ]

         /*Calculamos los netos bases según los descuentos a aplicar*/

         /*Neto base 1*/

         ::oDbf:nNeto1         :=  ( dbfTmpAtp )->nPrcArt

         if ( dbfTmpAtp )->nUncOfe != 0 .and. ( dbfTmpAtp )->nUnvOfe != 0
            if ( dbfTmpAtp )->nUncOfe != 1 .or. ( dbfTmpAtp )->nUnvOfe != 1
               ::oDbf:nNeto1   := ( ( ::oDbf:nNeto1 * ( dbfTmpAtp )->nUncOfe ) / ( dbfTmpAtp )->nUnvOfe )
            end if
         end if

         if ( dbfTmpAtp )->nDtoArt  != 0
            ::oDbf:nNeto1      -= ( ( ::oDbf:nNeto1 * ( dbfTmpAtp )->nDtoArt ) / 100 )
         end if

         if ( dbfTmpAtp )->nDtoDiv != 0
            ::oDbf:nNeto1      -= ( dbfTmpAtp )->nDtoDiv
         end if

         if ( dbfTmpAtp )->nDprArt != 0
            ::oDbf:nNeto1      -= ( ( ::oDbf:nNeto1 * ( dbfTmpAtp )->nDprArt ) / 100 )
         end if

         if ( dbfTmpAtp )->lComAge .and. ( dbfTmpAtp )->nComAge != 0
            ::oDbf:nNeto1      -= ( ( ::oDbf:nNeto1 * ( dbfTmpAtp )->nComAge ) / 100 )
         end if

         /*Atipico con la posición 1*/

         if nSbrAtp == 1 .and. aTmpCli[ ::oDbfCli:fieldpos( "nDtoAtp" ) ] != 0
            nDtoAtipico        := ( ( ::oDbf:nNeto1 * aTmpCli[ ::oDbfCli:fieldpos( "nDtoAtp" ) ] ) / 100 )
         end if

         if aTmpCli[ ::oDbfCli:fieldpos( "nDtoEsp" ) ] != 0
            ::oDbf:nNeto1      -= ( ( ::oDbf:nNeto1 * aTmpCli[ ::oDbfCli:fieldpos( "nDtoEsp" ) ] ) / 100 )
         end if

         /*Atipico con la posición 2*/

         if nSbrAtp == 2 .and. aTmpCli[ ::oDbfCli:fieldpos( "nDtoAtp" ) ] != 0
            nDtoAtipico        := ( ( ::oDbf:nNeto1 * aTmpCli[ ::oDbfCli:fieldpos( "nDtoAtp" ) ] ) / 100 )
         end if

         if aTmpCli[ ::oDbfCli:fieldpos( "nDpp" ) ] != 0
            ::oDbf:nNeto1      -= ( ( ::oDbf:nNeto1 * aTmpCli[ ::oDbfCli:fieldpos( "nDpp" ) ] ) / 100 )
         end if

         /*Atipico con la posición 3*/

         if nSbrAtp == 3 .and. aTmpCli[ ::oDbfCli:fieldpos( "nDtoAtp" ) ] != 0
            nDtoAtipico        := ( ( ::oDbf:nNeto1 * aTmpCli[ ::oDbfCli:fieldpos( "nDtoAtp" ) ] ) / 100 )
         end if

         if aTmpCli[ ::oDbfCli:fieldpos( "nDtoCnt" ) ] != 0
            ::oDbf:nNeto1      -= ( ( ::oDbf:nNeto1 * aTmpCli[ ::oDbfCli:fieldpos( "nDtoCnt" ) ] ) / 100 )
         end if

         /*Atipico con la posición 4*/

         if nSbrAtp == 4 .and. aTmpCli[ ::oDbfCli:fieldpos( "nDtoAtp" ) ] != 0
            nDtoAtipico        := ( ( ::oDbf:nNeto1 * aTmpCli[ ::oDbfCli:fieldpos( "nDtoAtp" ) ] ) / 100 )
         end if

         if aTmpCli[ ::oDbfCli:fieldpos( "nDtoRap" ) ] != 0
            ::oDbf:nNeto1      -= ( ( ::oDbf:nNeto1 * aTmpCli[ ::oDbfCli:fieldpos( "nDtoRap" ) ] ) / 100 )
         end if

         /*Atipico con la posición 5*/

         if nSbrAtp == 5 .and. aTmpCli[ ::oDbfCli:fieldpos( "nDtoAtp" ) ] != 0
            nDtoAtipico        := ( ( ::oDbf:nNeto1 * aTmpCli[ ::oDbfCli:fieldpos( "nDtoAtp" ) ] ) / 100 )
         end if

         ::oDbf:nNeto1          -= nDtoAtipico

         if ::cDivInf == cDivChg()
            ::oDbf:nNeto1      := nCnv2Div( ::oDbf:nNeto1, cDivEmp(), cDivChg() )
         end if

         /*Neto base 2*/

         ::oDbf:nNeto2         :=  ( dbfTmpAtp )->nPrcArt2

         if ( dbfTmpAtp )->nUncOfe != 0 .and. ( dbfTmpAtp )->nUnvOfe != 0
            if ( dbfTmpAtp )->nUncOfe != 1 .or. ( dbfTmpAtp )->nUnvOfe != 1
               ::oDbf:nNeto2   := ( ( ::oDbf:nNeto2 * ( dbfTmpAtp )->nUncOfe ) / ( dbfTmpAtp )->nUnvOfe )
            end if
         end if

         if ( dbfTmpAtp )->nDtoArt  != 0
            ::oDbf:nNeto2      -= ( ( ::oDbf:nNeto2 * ( dbfTmpAtp )->nDtoArt ) / 100 )
         end if

         if ( dbfTmpAtp )->nDtoDiv != 0
            ::oDbf:nNeto2      -= ( dbfTmpAtp )->nDtoDiv
         end if

         if ( dbfTmpAtp )->nDprArt != 0
            ::oDbf:nNeto2      -= ( ( ::oDbf:nNeto2 * ( dbfTmpAtp )->nDprArt ) / 100 )
         end if

         if ( dbfTmpAtp )->lComAge .and. ( dbfTmpAtp )->nComAge != 0
            ::oDbf:nNeto2      -= ( ( ::oDbf:nNeto2 * ( dbfTmpAtp )->nComAge ) / 100 )
         end if

         /*Atipico con la posición 1*/

         if nSbrAtp == 1 .and. aTmpCli[ ::oDbfCli:fieldpos( "nDtoAtp" ) ] != 0
            nDtoAtipico        := ( ( ::oDbf:nNeto2 * aTmpCli[ ::oDbfCli:fieldpos( "nDtoAtp" ) ] ) / 100 )
         end if

         if aTmpCli[ ::oDbfCli:fieldpos( "nDtoEsp" ) ] != 0
            ::oDbf:nNeto2      -= ( ( ::oDbf:nNeto2 * aTmpCli[ ::oDbfCli:fieldpos( "nDtoEsp" ) ] ) / 100 )
         end if

         /*Atipico con la posición 2*/

         if nSbrAtp == 2 .and. aTmpCli[ ::oDbfCli:fieldpos( "nDtoAtp" ) ] != 0
            nDtoAtipico        := ( ( ::oDbf:nNeto2 * aTmpCli[ ::oDbfCli:fieldpos( "nDtoAtp" ) ] ) / 100 )
         end if

         if aTmpCli[ ::oDbfCli:fieldpos( "nDpp" ) ] != 0
            ::oDbf:nNeto2      -= ( ( ::oDbf:nNeto2 * aTmpCli[ ::oDbfCli:fieldpos( "nDpp" ) ] ) / 100 )
         end if

         /*Atipico con la posición 3*/

         if nSbrAtp == 3 .and. aTmpCli[ ::oDbfCli:fieldpos( "nDtoAtp" ) ] != 0
            nDtoAtipico        := ( ( ::oDbf:nNeto2 * aTmpCli[ ::oDbfCli:fieldpos( "nDtoAtp" ) ] ) / 100 )
         end if

         if aTmpCli[ ::oDbfCli:fieldpos( "nDtoCnt" ) ] != 0
            ::oDbf:nNeto2      -= ( ( ::oDbf:nNeto2 * aTmpCli[ ::oDbfCli:fieldpos( "nDtoCnt" ) ] ) / 100 )
         end if

         /*Atipico con la posición 4*/

         if nSbrAtp == 4 .and. aTmpCli[ ::oDbfCli:fieldpos( "nDtoAtp" ) ] != 0
            nDtoAtipico        := ( ( ::oDbf:nNeto2 * aTmpCli[ ::oDbfCli:fieldpos( "nDtoAtp" ) ] ) / 100 )
         end if

         if aTmpCli[ ::oDbfCli:fieldpos( "nDtoRap" ) ] != 0
            ::oDbf:nNeto2      -= ( ( ::oDbf:nNeto2 * aTmpCli[ ::oDbfCli:fieldpos( "nDtoRap" ) ] ) / 100 )
         end if

         /*Atipico con la posición 5*/

         if nSbrAtp == 5 .and. aTmpCli[ ::oDbfCli:fieldpos( "nDtoAtp" ) ] != 0
            nDtoAtipico        := ( ( ::oDbf:nNeto2 * aTmpCli[ ::oDbfCli:fieldpos( "nDtoAtp" ) ] ) / 100 )
         end if

         ::oDbf:nNeto2         -= nDtoAtipico

         if ::cDivInf == cDivChg()
            ::oDbf:nNeto2      := nCnv2Div( ::oDbf:nNeto2, cDivEmp(), cDivChg() )
         end if

         /*Neto base 3*/

         ::oDbf:nNeto3         :=  ( dbfTmpAtp )->nPrcArt3

         if ( dbfTmpAtp )->nUncOfe != 0 .and. ( dbfTmpAtp )->nUnvOfe != 0
            if ( dbfTmpAtp )->nUncOfe != 1 .or. ( dbfTmpAtp )->nUnvOfe != 1
               ::oDbf:nNeto3   := ( ( ::oDbf:nNeto3 * ( dbfTmpAtp )->nUncOfe ) / ( dbfTmpAtp )->nUnvOfe )
            end if
         end if

         if ( dbfTmpAtp )->nDtoArt  != 0
            ::oDbf:nNeto3      -= ( ( ::oDbf:nNeto3 * ( dbfTmpAtp )->nDtoArt ) / 100 )
         end if

         if ( dbfTmpAtp )->nDtoDiv != 0
            ::oDbf:nNeto3      -= ( dbfTmpAtp )->nDtoDiv
         end if

         if ( dbfTmpAtp )->nDprArt != 0
            ::oDbf:nNeto3      -= ( ( ::oDbf:nNeto3 * ( dbfTmpAtp )->nDprArt ) / 100 )
         end if

         if ( dbfTmpAtp )->lComAge .and. ( dbfTmpAtp )->nComAge != 0
            ::oDbf:nNeto3      -= ( ( ::oDbf:nNeto3 * ( dbfTmpAtp )->nComAge ) / 100 )
         end if

         /*Atipico con la posición 1*/

         if nSbrAtp == 1 .and. aTmpCli[ ::oDbfCli:fieldpos( "nDtoAtp" ) ] != 0
            nDtoAtipico        := ( ( ::oDbf:nNeto3 * aTmpCli[ ::oDbfCli:fieldpos( "nDtoAtp" ) ] ) / 100 )
         end if

         if aTmpCli[ ::oDbfCli:fieldpos( "nDtoEsp" ) ] != 0
            ::oDbf:nNeto3      -= ( ( ::oDbf:nNeto3 * aTmpCli[ ::oDbfCli:fieldpos( "nDtoEsp" ) ] ) / 100 )
         end if

         /*Atipico con la posición 2*/

         if nSbrAtp == 2 .and. aTmpCli[ ::oDbfCli:fieldpos( "nDtoAtp" ) ] != 0
            nDtoAtipico        := ( ( ::oDbf:nNeto3 * aTmpCli[ ::oDbfCli:fieldpos( "nDtoAtp" ) ] ) / 100 )
         end if

         if aTmpCli[ ::oDbfCli:fieldpos( "nDpp" ) ] != 0
            ::oDbf:nNeto3      -= ( ( ::oDbf:nNeto3 * aTmpCli[ ::oDbfCli:fieldpos( "nDpp" ) ] ) / 100 )
         end if

         /*Atipico con la posición 3*/

         if nSbrAtp == 3 .and. aTmpCli[ ::oDbfCli:fieldpos( "nDtoAtp" ) ] != 0
            nDtoAtipico        := ( ( ::oDbf:nNeto3 * aTmpCli[ ::oDbfCli:fieldpos( "nDtoAtp" ) ] ) / 100 )
         end if

         if aTmpCli[ ::oDbfCli:fieldpos( "nDtoCnt" ) ] != 0
            ::oDbf:nNeto3      -= ( ( ::oDbf:nNeto3 * aTmpCli[ ::oDbfCli:fieldpos( "nDtoCnt" ) ] ) / 100 )
         end if

         /*Atipico con la posición 4*/

         if nSbrAtp == 4 .and. aTmpCli[ ::oDbfCli:fieldpos( "nDtoAtp" ) ] != 0
            nDtoAtipico        := ( ( ::oDbf:nNeto3 * aTmpCli[ ::oDbfCli:fieldpos( "nDtoAtp" ) ] ) / 100 )
         end if

         if aTmpCli[ ::oDbfCli:fieldpos( "nDtoRap" ) ] != 0
            ::oDbf:nNeto3      -= ( ( ::oDbf:nNeto3 * aTmpCli[ ::oDbfCli:fieldpos( "nDtoRap" ) ] ) / 100 )
         end if

         /*Atipico con la posición 5*/

         if nSbrAtp == 5 .and. aTmpCli[ ::oDbfCli:fieldpos( "nDtoAtp" ) ] != 0
            nDtoAtipico        := ( ( ::oDbf:nNeto3 * aTmpCli[ ::oDbfCli:fieldpos( "nDtoAtp" ) ] ) / 100 )
         end if

         ::oDbf:nNeto3         -= nDtoAtipico

         if ::cDivInf == cDivChg()
            ::oDbf:nNeto3      := nCnv2Div( ::oDbf:nNeto3, cDivEmp(), cDivChg() )
         end if

         /*Neto base 4*/

         ::oDbf:nNeto4         :=  ( dbfTmpAtp )->nPrcArt4

         if ( dbfTmpAtp )->nUncOfe != 0 .and. ( dbfTmpAtp )->nUnvOfe != 0
            if ( dbfTmpAtp )->nUncOfe != 1 .or. ( dbfTmpAtp )->nUnvOfe != 1
               ::oDbf:nNeto4   := ( ( ::oDbf:nNeto4 * ( dbfTmpAtp )->nUncOfe ) / ( dbfTmpAtp )->nUnvOfe )
            end if
         end if

         if ( dbfTmpAtp )->nDtoArt  != 0
            ::oDbf:nNeto4      -= ( ( ::oDbf:nNeto4 * ( dbfTmpAtp )->nDtoArt ) / 100 )
         end if

         if ( dbfTmpAtp )->nDtoDiv != 0
            ::oDbf:nNeto4      -= ( dbfTmpAtp )->nDtoDiv
         end if

         if ( dbfTmpAtp )->nDprArt != 0
            ::oDbf:nNeto4      -= ( ( ::oDbf:nNeto4 * ( dbfTmpAtp )->nDprArt ) / 100 )
         end if

         if ( dbfTmpAtp )->lComAge .and. ( dbfTmpAtp )->nComAge != 0
            ::oDbf:nNeto4     -= ( ( ::oDbf:nNeto4 * ( dbfTmpAtp )->nComAge ) / 100 )
         end if

         /*Atipico con la posición 1*/

         if nSbrAtp == 1 .and. aTmpCli[ ::oDbfCli:fieldpos( "nDtoAtp" ) ] != 0
            nDtoAtipico        := ( ( ::oDbf:nNeto4 * aTmpCli[ ::oDbfCli:fieldpos( "nDtoAtp" ) ] ) / 100 )
         end if

         if aTmpCli[ ::oDbfCli:fieldpos( "nDtoEsp" ) ] != 0
            ::oDbf:nNeto4      -= ( ( ::oDbf:nNeto4 * aTmpCli[ ::oDbfCli:fieldpos( "nDtoEsp" ) ] ) / 100 )
         end if

         /*Atipico con la posición 2*/

         if nSbrAtp == 2 .and. aTmpCli[ ::oDbfCli:fieldpos( "nDtoAtp" ) ] != 0
            nDtoAtipico        := ( ( ::oDbf:nNeto4 * aTmpCli[ ::oDbfCli:fieldpos( "nDtoAtp" ) ] ) / 100 )
         end if

         if aTmpCli[ ::oDbfCli:fieldpos( "nDpp" ) ] != 0
            ::oDbf:nNeto4      -= ( ( ::oDbf:nNeto4 * aTmpCli[ ::oDbfCli:fieldpos( "nDpp" ) ] ) / 100 )
         end if

         /*Atipico con la posición 3*/

         if nSbrAtp == 3 .and. aTmpCli[ ::oDbfCli:fieldpos( "nDtoAtp" ) ] != 0
            nDtoAtipico        := ( ( ::oDbf:nNeto4 * aTmpCli[ ::oDbfCli:fieldpos( "nDtoAtp" ) ] ) / 100 )
         end if

         if aTmpCli[ ::oDbfCli:fieldpos( "nDtoCnt" ) ] != 0
            ::oDbf:nNeto4      -= ( ( ::oDbf:nNeto4 * aTmpCli[ ::oDbfCli:fieldpos( "nDtoCnt" ) ] ) / 100 )
         end if

         /*Atipico con la posición 4*/

         if nSbrAtp == 4 .and. aTmpCli[ ::oDbfCli:fieldpos( "nDtoAtp" ) ] != 0
            nDtoAtipico        := ( ( ::oDbf:nNeto4 * aTmpCli[ ::oDbfCli:fieldpos( "nDtoAtp" ) ] ) / 100 )
         end if

         if aTmpCli[ ::oDbfCli:fieldpos( "nDtoRap" ) ] != 0
            ::oDbf:nNeto4      -= ( ( ::oDbf:nNeto4 * aTmpCli[ ::oDbfCli:fieldpos( "nDtoRap" ) ] ) / 100 )
         end if

         /*Atipico con la posición 5*/

         if nSbrAtp == 5 .and. aTmpCli[ ::oDbfCli:fieldpos( "nDtoAtp" ) ] != 0
            nDtoAtipico        := ( ( ::oDbf:nNeto4 * aTmpCli[ ::oDbfCli:fieldpos( "nDtoAtp" ) ] ) / 100 )
         end if

         ::oDbf:nNeto4         -= nDtoAtipico

         if ::cDivInf == cDivChg()
            ::oDbf:nNeto4      := nCnv2Div( ::oDbf:nNeto4, cDivEmp(), cDivChg() )
         end if

         /*Neto base 5*/

         ::oDbf:nNeto5         :=  ( dbfTmpAtp )->nPrcArt5

         if ( dbfTmpAtp )->nUncOfe != 0 .and. ( dbfTmpAtp )->nUnvOfe != 0
            if ( dbfTmpAtp )->nUncOfe != 1 .or. ( dbfTmpAtp )->nUnvOfe != 1
               ::oDbf:nNeto5   := ( ( ::oDbf:nNeto5 * ( dbfTmpAtp )->nUncOfe ) / ( dbfTmpAtp )->nUnvOfe )
            end if
         end if

         if ( dbfTmpAtp )->nDtoArt  != 0
            ::oDbf:nNeto5      -= ( ( ::oDbf:nNeto5 * ( dbfTmpAtp )->nDtoArt ) / 100 )
         end if

         if ( dbfTmpAtp )->nDtoDiv != 0
            ::oDbf:nNeto5      -= ( dbfTmpAtp )->nDtoDiv
         end if

         if ( dbfTmpAtp )->nDprArt != 0
            ::oDbf:nNeto5      -= ( ( ::oDbf:nNeto5 * ( dbfTmpAtp )->nDprArt ) / 100 )
         end if

         if ( dbfTmpAtp )->lComAge .and. ( dbfTmpAtp )->nComAge != 0
            ::oDbf:nNeto5      -= ( ( ::oDbf:nNeto5 * ( dbfTmpAtp )->nComAge ) / 100 )
         end if

         /*Atipico con la posición 1*/

         if nSbrAtp == 1 .and. aTmpCli[ ::oDbfCli:fieldpos( "nDtoAtp" ) ] != 0
            nDtoAtipico        := ( ( ::oDbf:nNeto5 * aTmpCli[ ::oDbfCli:fieldpos( "nDtoAtp" ) ] ) / 100 )
         end if

         if aTmpCli[ ::oDbfCli:fieldpos( "nDtoEsp" ) ] != 0
            ::oDbf:nNeto5      -= ( ( ::oDbf:nNeto5 * aTmpCli[ ::oDbfCli:fieldpos( "nDtoEsp" ) ] ) / 100 )
         end if

         /*Atipico con la posición 2*/

         if nSbrAtp == 2 .and. aTmpCli[ ::oDbfCli:fieldpos( "nDtoAtp" ) ] != 0
            nDtoAtipico        := ( ( ::oDbf:nNeto5 * aTmpCli[ ::oDbfCli:fieldpos( "nDtoAtp" ) ] ) / 100 )
         end if

         if aTmpCli[ ::oDbfCli:fieldpos( "nDpp" ) ] != 0
            ::oDbf:nNeto5      -= ( ( ::oDbf:nNeto5 * aTmpCli[ ::oDbfCli:fieldpos( "nDpp" ) ] ) / 100 )
         end if

         /*Atipico con la posición 3*/

         if nSbrAtp == 3 .and. aTmpCli[ ::oDbfCli:fieldpos( "nDtoAtp" ) ] != 0
            nDtoAtipico        := ( ( ::oDbf:nNeto5 * aTmpCli[ ::oDbfCli:fieldpos( "nDtoAtp" ) ] ) / 100 )
         end if

         if aTmpCli[ ::oDbfCli:fieldpos( "nDtoCnt" ) ] != 0
            ::oDbf:nNeto5      -= ( ( ::oDbf:nNeto5 * aTmpCli[ ::oDbfCli:fieldpos( "nDtoCnt" ) ] ) / 100 )
         end if

         /*Atipico con la posición 4*/

         if nSbrAtp == 4 .and. aTmpCli[ ::oDbfCli:fieldpos( "nDtoAtp" ) ] != 0
            nDtoAtipico        := ( ( ::oDbf:nNeto5 * aTmpCli[ ::oDbfCli:fieldpos( "nDtoAtp" ) ] ) / 100 )
         end if

         if aTmpCli[ ::oDbfCli:fieldpos( "nDtoRap" ) ] != 0
            ::oDbf:nNeto5      -= ( ( ::oDbf:nNeto5 * aTmpCli[ ::oDbfCli:fieldpos( "nDtoRap" ) ] ) / 100 )
         end if

         /*Atipico con la posición 5*/

         if nSbrAtp == 5 .and. aTmpCli[ ::oDbfCli:fieldpos( "nDtoAtp" ) ] != 0
            nDtoAtipico        := ( ( ::oDbf:nNeto5 * aTmpCli[ ::oDbfCli:fieldpos( "nDtoAtp" ) ] ) / 100 )
         end if

         ::oDbf:nNeto5         -= nDtoAtipico

         if ::cDivInf == cDivChg()
            ::oDbf:nNeto5      := nCnv2Div( ::oDbf:nNeto5, cDivEmp(), cDivChg() )
         end if

         /*Neto base 6*/

         ::oDbf:nNeto6         :=  ( dbfTmpAtp )->nPrcArt6

         if ( dbfTmpAtp )->nUncOfe != 0 .and. ( dbfTmpAtp )->nUnvOfe != 0
            if ( dbfTmpAtp )->nUncOfe != 1 .or. ( dbfTmpAtp )->nUnvOfe != 1
               ::oDbf:nNeto6   := ( ( ::oDbf:nNeto6 * ( dbfTmpAtp )->nUncOfe ) / ( dbfTmpAtp )->nUnvOfe )
            end if
         end if

         if ( dbfTmpAtp )->nDtoArt  != 0
            ::oDbf:nNeto6      -= ( ( ::oDbf:nNeto6 * ( dbfTmpAtp )->nDtoArt ) / 100 )
         end if

         if ( dbfTmpAtp )->nDtoDiv != 0
            ::oDbf:nNeto6      -= ( dbfTmpAtp )->nDtoDiv
         end if

         if ( dbfTmpAtp )->nDprArt != 0
            ::oDbf:nNeto6      -= ( ( ::oDbf:nNeto6 * ( dbfTmpAtp )->nDprArt ) / 100 )
         end if

         if ( dbfTmpAtp )->lComAge .and. ( dbfTmpAtp )->nComAge != 0
            ::oDbf:nNeto6      -= ( ( ::oDbf:nNeto6 * ( dbfTmpAtp )->nComAge ) / 100 )
         end if

         /*Atipico con la posición 1*/

         if nSbrAtp == 1 .and. aTmpCli[ ::oDbfCli:fieldpos( "nDtoAtp" ) ] != 0
            nDtoAtipico        := ( ( ::oDbf:nNeto6 * aTmpCli[ ::oDbfCli:fieldpos( "nDtoAtp" ) ] ) / 100 )
         end if

         if aTmpCli[ ::oDbfCli:fieldpos( "nDtoEsp" ) ] != 0
            ::oDbf:nNeto6      -= ( ( ::oDbf:nNeto6 * aTmpCli[ ::oDbfCli:fieldpos( "nDtoEsp" ) ] ) / 100 )
         end if

         /*Atipico con la posición 2*/

         if nSbrAtp == 2 .and. aTmpCli[ ::oDbfCli:fieldpos( "nDtoAtp" ) ] != 0
            nDtoAtipico        := ( ( ::oDbf:nNeto6 * aTmpCli[ ::oDbfCli:fieldpos( "nDtoAtp" ) ] ) / 100 )
         end if

         if aTmpCli[ ::oDbfCli:fieldpos( "nDpp" ) ] != 0
            ::oDbf:nNeto6      -= ( ( ::oDbf:nNeto6 * aTmpCli[ ::oDbfCli:fieldpos( "nDpp" ) ] ) / 100 )
         end if

         /*Atipico con la posición 3*/

         if nSbrAtp == 3 .and. aTmpCli[ ::oDbfCli:fieldpos( "nDtoAtp" ) ] != 0
            nDtoAtipico        := ( ( ::oDbf:nNeto6 * aTmpCli[ ::oDbfCli:fieldpos( "nDtoAtp" ) ] ) / 100 )
         end if

         if aTmpCli[ ::oDbfCli:fieldpos( "nDtoCnt" ) ] != 0
            ::oDbf:nNeto6      -= ( ( ::oDbf:nNeto6 * aTmpCli[ ::oDbfCli:fieldpos( "nDtoCnt" ) ] ) / 100 )
         end if

         /*Atipico con la posición 4*/

         if nSbrAtp == 4 .and. aTmpCli[ ::oDbfCli:fieldpos( "nDtoAtp" ) ] != 0
            nDtoAtipico        := ( ( ::oDbf:nNeto6 * aTmpCli[ ::oDbfCli:fieldpos( "nDtoAtp" ) ] ) / 100 )
         end if

         if aTmpCli[ ::oDbfCli:fieldpos( "nDtoRap" ) ] != 0
            ::oDbf:nNeto6      -= ( ( ::oDbf:nNeto6 * aTmpCli[ ::oDbfCli:fieldpos( "nDtoRap" ) ] ) / 100 )
         end if

         /*Atipico con la posición 5*/

         if nSbrAtp == 5 .and. aTmpCli[ ::oDbfCli:fieldpos( "nDtoAtp" ) ] != 0
            nDtoAtipico        := ( ( ::oDbf:nNeto6 * aTmpCli[ ::oDbfCli:fieldpos( "nDtoAtp" ) ] ) / 100 )
         end if

         ::oDbf:nNeto6         -= nDtoAtipico

         if ::cDivInf == cDivChg()
            ::oDbf:nNeto6      := nCnv2Div( ::oDbf:nNeto6, cDivEmp(), cDivChg() )
         end if

         /*Punto verde*/

         ::oDbf:nPntVer        := ::oDbfArt:nPntVer1

         if ::cDivInf == cDivChg()
            ::oDbf:nPntVer     := nCnv2Div( ::oDbf:nPntVer, cDivEmp(), cDivChg() )
         end if

         ::oDbf:nNetVer1       := ::oDbf:nNeto1 + ::oDbf:nPntVer
         ::oDbf:nNetVer2       := ::oDbf:nNeto2 + ::oDbf:nPntVer
         ::oDbf:nNetVer3       := ::oDbf:nNeto3 + ::oDbf:nPntVer
         ::oDbf:nNetVer4       := ::oDbf:nNeto4 + ::oDbf:nPntVer
         ::oDbf:nNetVer5       := ::oDbf:nNeto5 + ::oDbf:nPntVer
         ::oDbf:nNetVer6       := ::oDbf:nNeto6 + ::oDbf:nPntVer

         /*Calculamos los margenes sobre unidad*/

         ::oDbf:nMarUnd1     := ::oDbf:nNeto1 - ::oDbf:nCosto
         ::oDbf:nMarUnd2     := ::oDbf:nNeto2 - ::oDbf:nCosto
         ::oDbf:nMarUnd3     := ::oDbf:nNeto3 - ::oDbf:nCosto
         ::oDbf:nMarUnd4     := ::oDbf:nNeto4 - ::oDbf:nCosto
         ::oDbf:nMarUnd5     := ::oDbf:nNeto5 - ::oDbf:nCosto
         ::oDbf:nMarUnd6     := ::oDbf:nNeto6 - ::oDbf:nCosto

         /*Calculamos los margenes sobre caja*/

         if ::oDbfArt:Seek ( ( dbfTmpAtp )->cCodArt )
            nUnicaja         := ::oDbfArt:nUniCaja
         end if

         ::oDbf:nMarCaj1     := ( ::oDbf:nNeto1 - ::oDbf:nCosto ) * nUniCaja
         ::oDbf:nMarCaj2     := ( ::oDbf:nNeto2 - ::oDbf:nCosto ) * nUniCaja
         ::oDbf:nMarCaj3     := ( ::oDbf:nNeto3 - ::oDbf:nCosto ) * nUniCaja
         ::oDbf:nMarCaj4     := ( ::oDbf:nNeto4 - ::oDbf:nCosto ) * nUniCaja
         ::oDbf:nMarCaj5     := ( ::oDbf:nNeto5 - ::oDbf:nCosto ) * nUniCaja
         ::oDbf:nMarCaj6     := ( ::oDbf:nNeto6 - ::oDbf:nCosto ) * nUniCaja

         /*Calculamos la rentabilidad sobre costo*/

         ::oDbf:nRenCos1     := ( ( ::oDbf:nNeto1 / ::oDbf:nCosto ) -1 ) * 100
         ::oDbf:nRenCos2     := ( ( ::oDbf:nNeto2 / ::oDbf:nCosto ) -1 ) * 100
         ::oDbf:nRenCos3     := ( ( ::oDbf:nNeto3 / ::oDbf:nCosto ) -1 ) * 100
         ::oDbf:nRenCos4     := ( ( ::oDbf:nNeto4 / ::oDbf:nCosto ) -1 ) * 100
         ::oDbf:nRenCos5     := ( ( ::oDbf:nNeto5 / ::oDbf:nCosto ) -1 ) * 100
         ::oDbf:nRenCos6     := ( ( ::oDbf:nNeto6 / ::oDbf:nCosto ) -1 ) * 100

         /*Calculamos la rentabilidad sobre venta*/

         ::oDbf:nRenVta1     := ( ( ::oDbf:nNeto1 - ::oDbf:nCosto ) / ::oDbf:nNeto1 ) * 100
         ::oDbf:nRenVta2     := ( ( ::oDbf:nNeto2 - ::oDbf:nCosto ) / ::oDbf:nNeto2 ) * 100
         ::oDbf:nRenVta3     := ( ( ::oDbf:nNeto3 - ::oDbf:nCosto ) / ::oDbf:nNeto3 ) * 100
         ::oDbf:nRenVta4     := ( ( ::oDbf:nNeto4 - ::oDbf:nCosto ) / ::oDbf:nNeto4 ) * 100
         ::oDbf:nRenVta5     := ( ( ::oDbf:nNeto5 - ::oDbf:nCosto ) / ::oDbf:nNeto5 ) * 100
         ::oDbf:nRenVta6     := ( ( ::oDbf:nNeto6 - ::oDbf:nCosto ) / ::oDbf:nNeto6 ) * 100

         ::oDbf:Save()

         end if

      end if

      ( dbfTmpAtp )->( dbSkip() )

      ::oMtrInf:AutoInc( ( dbfTmpAtp )->( OrdKeyNo() ) )

   end do

   ::oMtrInf:AutoInc( ( dbfTmpAtp )->( LastRec() ) )

   ::oDlg:Enable()

   ::oBtnFilter:Disable()

   ( dbfTmpAtp )->( dbGoTop() )

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//

/*Metodo que comprueba si metemos un artículo que existe*/

METHOD cArt( aGet, aGet2 )

   local nOrdArt
   local nOrdAtp
   local lValid      := .f.
	local cCodArt		:= aGet:varGet()
   local dbfTmpAtp   := ::xOthers[1]

   if Empty( cCodArt )
      return .t.
   end if

   nOrdArt  := ::oDbfArt:OrdSetFocus( "CODIGO" )
   nOrdAtp  := ( dbfTmpAtp )->( ordSetFocus( "CCODART" ) )

   if ( dbfTmpAtp )->( dbSeek( cCodArt ) ) .and. ::oDbfArt:Seek( cCodArt )

      aGet:cText( ::oDbfArt:Codigo )

      if aGet2 != NIL
         aGet2:cText( ::oDbfArt:Nombre )
      end if

      lValid   := .t.

   else

      msgStop( "Artículo no encontrado" )

   end if

   ::oDbfArt:OrdSetFocus( nOrdAtp )
   ( dbfTmpAtp )->( ordSetFocus( nOrdArt ) )

RETURN lValid

//---------------------------------------------------------------------------//

/*Browse que muestra los articulos que están en la base de datos temporal*/

METHOD BrwAtipica( aGet, aGet2 )

	local oDlg
	local oBrw
   local aGet1
   local cGet1
   local nOrdAnt
	local oCbxOrd
   local aCbxOrd     := { "Código" }
   local cCbxOrd     := "Código"
   local dbfTmpAtp   := ::xOthers[1]

   nOrdAnt           := ( dbfTmpAtp )->( OrdSetFocus( "CCODART" ) )

   ( dbfTmpAtp )->( dbGoTop() )

      DEFINE DIALOG oDlg RESOURCE "HELPENTRY" TITLE "Seleccionar artículos"

      REDEFINE GET aGet1 VAR cGet1;
			ID 		104 ;
         ON CHANGE( AutoSeek( nKey, nFlags, Self, oBrw, dbfTmpAtp ) );
         VALID    ( OrdClearScope( oBrw, dbfTmpAtp ) );
         BITMAP   "FIND" ;
         OF       oDlg

		REDEFINE COMBOBOX oCbxOrd ;
			VAR 		cCbxOrd ;
			ID 		102 ;
         ITEMS    aCbxOrd ;
         ON CHANGE( ( dbfTmpAtp )->( OrdSetFocus( "CCODART" ) ), oBrw:refresh(), aGet1:SetFocus() ) ;
         OF       oDlg

      oBrw                 := IXBrowse():New( oDlg )

      oBrw:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrw:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      oBrw:cAlias          := dbfTmpAtp
      oBrw:nMarqueeStyle   := 5

      oBrw:bLDblClick      := {|| oDlg:end( IDOK ) }

      oBrw:CreateFromResource( 105 )

      with object ( oBrw:AddCol() )
         :cHeader          := "Código"
         :bEditValue       := {|| ( dbfTmpAtp )->cCodArt }
         :nWidth           := 80
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Nombre"
         :bEditValue       := {|| oRetFld( ( dbfTmpAtp )->cCodArt, ::oDbfArt ) }
         :nWidth           := 400
      end with

		REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
         ACTION   ( oDlg:end(IDOK) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
			ACTION 	( oDlg:end() )

		REDEFINE BUTTON ;
			ID 		500 ;
			OF 		oDlg ;
         WHEN     .f. ;
         ACTION   ( nil )

		REDEFINE BUTTON ;
			ID 		501 ;
			OF 		oDlg ;
         WHEN     .f. ;
         ACTION   ( nil )

   oDlg:AddFastKey( VK_RETURN, {|| oDlg:end(IDOK) } )
   oDlg:AddFastKey( VK_F5, {|| oDlg:end(IDOK) } )

   ACTIVATE DIALOG oDlg CENTER

   if oDlg:nResult == IDOK

      aGet:cText( ( dbfTmpAtp )->cCodArt )
      aGet2:cText( oRetFld( ( dbfTmpAtp )->cCodArt, ::oDbfArt ) )

   end if

   ( dbfTmpAtp )->( OrdSetFocus( nOrdAnt ) )

   aGet:setFocus()

RETURN ( .t. )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//