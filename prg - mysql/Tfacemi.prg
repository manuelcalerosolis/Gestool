#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"
//---------------------------------------------------------------------------//

CLASS TFacEmiIva FROM TInfGen

   DATA  oFacCliP    AS OBJECT
   DATA  oFacCliT    AS OBJECT
   DATA  oFacCliL    AS OBJECT
   DATA  oFacRecT    AS OBJECT
   DATA  oFacRecL    AS OBJECT
   DATA  oAntCliT    AS OBJECT
   DATA  oDbfIva     AS OBJECT
   DATA  lAllIva     AS LOGIC    INIT .t.
   DATA  cIvaDes     AS CHARACTER
   DATA  cIvaHas     AS CHARACTER
   DATA  oEstado     AS OBJECT
   DATA  aEstado     AS ARRAY    INIT { "Pendiente", "Liquidada", "Todas" }

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//
/*Creamos la temporal, los ordenes y los grupos*/

METHOD Create()

   ::AddField ( "cNumFac", "C", 14, 0, {|| "@!" },         "Factura",                  .t., "Factura"                 , 14, .f. )
   ::AddField ( "dFecMov", "D",  8, 0, {|| "@!" },         "Fecha",                    .t., "Fecha"                   , 12, .f. )
   ::AddField ( "cCodCli", "C", 12, 0, {|| "@!" },         "Cod. cli",                 .t., "Cod. cliente"            ,  8, .f. )
   ::AddField ( "cNomCli", "C", 50, 0, {|| "@!" },         "Nombre",                   .t., "Nombre cliente"          , 25, .f. )
   ::AddField ( "cNifCli", "C", 15, 0, {|| "@!" },         "Nif",                      .f., "Nif"                     ,  8, .f. )
   ::AddField ( "cDomCli", "C", 35, 0, {|| "@!" },         "Domicilio",                .f., "Domicilio"               , 25, .f. )
   ::AddField ( "cPobCli", "C", 25, 0, {|| "@!" },         "Población",                .f., "Población"               , 20, .f. )
   ::AddField ( "cProCli", "C", 20, 0, {|| "@!" },         "Provincia",                .f., "Provincia"               , 20, .f. )
   ::AddField ( "cCdpCli", "C",  7, 0, {|| "@!" },         "CP",                       .f., "Cod. postal"             , 20, .f. )
   ::AddField ( "cTlfCli", "C", 12, 0, {|| "@!" },         "Tlf",                      .f., "Teléfono"                ,  7, .f. )
   ::AddField ( "cTipIva", "C",  1, 0, {|| "@!" },         "Tipo",                     .t., "Tipo I.V.A"              ,  1, .f. )
   ::AddField ( "cNomIva", "C", 30, 0, {|| "@!" },         "Nom. " + cImp(),           .f., "Nombre tipo " + cImp()   , 35, .f. )
   ::AddField ( "nPctIva", "N",  6, 2, {|| "@ 99.99" },    "% " + cImp(),              .f., "Porcentaje de " + cImp() , 12, .f. )
   ::AddField ( "nBasFac", "N", 19, 6, {|| ::cPicOut },    "Base",                     .t., "Base"                    , 12, .t. )
   ::AddField ( "nIvaFac", "N", 19, 6, {|| ::cPicOut },    cImp(),                     .t., cImp()                    , 12, .t. )
   ::AddField ( "nReqFac", "N", 19, 6, {|| ::cPicOut },    "Rec",                      .t., "Recargo"                 , 12, .t. )
   ::AddField ( "nTotFac", "N", 19, 6, {|| ::cPicOut },    "Total",                    .t., "Total Factura"           , 12, .t. )
   ::AddField ( "cTipDoc", "C", 20, 0, {|| "@!" },         "Tipo",                     .f., "Tipo de documento"       , 15, .f. )

   ::AddTmpIndex( "cTipIva", "cTipIva" )

   ::AddGroup( {|| ::oDbf:cTipIva }, {|| "tipo " + cImp() + " : " + Rtrim( ::oDbf:cTipIva ) + "-" + oRetFld( ::oDbf:cTipIva, ::oDbfIva ) }, {||"Total tipo impuestos.."} )

RETURN ( self )

//---------------------------------------------------------------------------//
/*Abrimos las tablas necesarias*/

METHOD OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE


   ::oFacCliT := TDataCenter():oFacCliT()

   DATABASE NEW ::oFacCliL PATH ( cPatEmp() ) FILE "FACCLIL.DBF"  VIA ( cDriver() ) SHARED INDEX "FACCLIL.CDX"

   DATABASE NEW ::oFacRecT PATH ( cPatEmp() ) FILE "FACRECT.DBF"  VIA ( cDriver() ) SHARED INDEX "FACRECT.CDX"

   DATABASE NEW ::oFacRecL PATH ( cPatEmp() ) FILE "FACRECL.DBF"  VIA ( cDriver() ) SHARED INDEX "FACRECL.CDX"

   ::oFacCliP := TDataCenter():oFacCliP()

   DATABASE NEW ::oAntCliT PATH ( cPatEmp() ) FILE "ANTCLIT.DBF"  VIA ( cDriver() ) SHARED INDEX "ANTCLIT.CDX"

   DATABASE NEW ::oDbfIva  PATH ( cPatDat() ) FILE "TIVA.DBF"     VIA ( cDriver() ) SHARED INDEX "TIVA.CDX"

   RECOVER

      msgStop( 'Imposible abrir todas las bases de datos' )
      ::CloseFiles()
      lOpen       := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//
/*Cerramos las tablas abiertas anteriormente*/

METHOD CloseFiles()

   if !Empty( ::oFacCliT ) .and. ::oFacCliT:Used()
      ::oFacCliT:End()
   end if
   if !Empty( ::oFacCliL ) .and. ::oFacCliL:Used()
      ::oFacCliL:End()
   end if
   if !Empty( ::oFacRecT ) .and. ::oFacRecT:Used()
      ::oFacRecT:End()
   end if
   if !Empty( ::oFacRecL ) .and. ::oFacRecL:Used()
      ::oFacRecL:End()
   end if
   if !Empty( ::oFacCliP ) .and. ::oFacCliP:Used()
      ::oFacCliP:End()
   end if
   if !Empty( ::oDbfIva ) .and. ::oDbfIva:Used()
      ::oDbfIva:End()
   end if
   if !Empty( ::oAntCliT ) .and. ::oAntCliT:Used()
      ::oAntCliT:End()
   end if

   ::oFacCliP := nil
   ::oAntCliT := nil
   ::oDbfIva  := nil
   ::oFacCliT := nil
   ::oFacCliL := nil
   ::oFacRecT := nil
   ::oFacRecL := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld )

   local cEstado     := "Todas"
   local oIvaDes
   local oIvaHas
   local oIvaDesTxt
   local oIvaHasTxt
   local cIvaDesTxt
   local cIvaHasTxt
   local oThis := ::oDbfIva

   if !::StdResource( "INF_GEN19" )
      return .f.
   end if

   /*Se montan los desde - hasta ( en este caso se monta aquí pq no está en el tinfgen )*/

   ::cIvaDes   := dbFirst( ::oDbfIva, 1 )
   ::cIvaHas   := dbLast(  ::oDbfIva, 1 )
   cIvaDesTxt  := dbFirst( ::oDbfIva, 2 )
   cIvaHasTxt  := dbLast(  ::oDbfIva, 2 )

   REDEFINE CHECKBOX ::lAllIva ;
      ID       500 ;
      OF       ::oFld:aDialogs[1]

   REDEFINE GET oIvaDes VAR ::cIvaDes ;
      ID       130 ;
      WHEN     ( !::lAllIva );
      VALID    ( cTiva( oIvaDes, oThis:cAlias, oIvaDesTxt ) );
      BITMAP   "LUPA" ;
      ON HELP  ( BrwIva( oIvaDes, oThis:cAlias, oIvaDesTxt ) ) ;
      OF       ::oFld:aDialogs[1]

   REDEFINE GET oIvaDesTxt VAR cIvaDesTxt ;
      WHEN     .f. ;
      ID       131 ;
      OF       ::oFld:aDialogs[1]

   REDEFINE GET oIvaHas VAR ::cIvaHas ;
      ID       140 ;
      WHEN     ( !::lAllIva );
      VALID    ( cTiva( oIvaHas, oThis:cAlias, oIvaHasTxt ) );
      BITMAP   "LUPA" ;
      ON HELP  ( BrwIva( oIvaHas, oThis:cAlias, oIvaHasTxt ) ) ;
      OF       ::oFld:aDialogs[1]

   REDEFINE GET oIvaHasTxt VAR cIvaHasTxt ;
      WHEN     .f. ;
      ID       141 ;
      OF       ::oFld:aDialogs[1]

   /*Definimos el combo con los tipos de facturas*/

   REDEFINE COMBOBOX ::oEstado ;
      VAR      cEstado ;
      ID       218 ;
      ITEMS    ::aEstado;
      OF       ::oFld:aDialogs[1]

   /*Damos valor al meter*/

   ::oMtrInf:SetTotal( ::oFacCliT:Lastrec() )

   ::CreateFilter( aItmFacCli(), ::oFacCliT:cAlias )

RETURN .t.

//---------------------------------------------------------------------------//
/*Generamos el informe*/

METHOD lGenerate()

   local n
   local cCodIva
   local aTotFac
   local cExpHead := ""

   /*Desabilita el diálogo y vacía la dbf temporal*/

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   /*Monta la cabecera del documento*/

   ::aHeader      := {  {|| "Fecha    : " + Dtoc( Date() ) },;
                        {|| "Periodo  : " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                        {|| "tipo " + cImp() + " : " + if( ::lAllIva, "Todos",  AllTrim( ::cIvaDes ) + " > " + AllTrim( ::cIvaHas ) ) },;
                        {|| "Estado   : " + ::aEstado[ ::oEstado:nAt ] } }

   /*Monta los filtros para la tabla de facturas*/

   ::oFacCliT:OrdSetFocus( "dFecFac" )

   do case
      case ::oEstado:nAt == 1
         cExpHead    := '!lLiquidada .and. dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
      case ::oEstado:nAt == 2
         cExpHead    := 'lLiquidada .and. dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
      case ::oEstado:nAt == 3
         cExpHead    := 'dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
   end case

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oFacCliT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oFacCliT:cFile ), ::oFacCliT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oFacCliT:OrdKeyCount() )

   /*Recorremos las cabeceras y lineas de las facturas*/

   ::oFacCliT:GoTop()

   while !::lBreak .and. !::oFacCliT:Eof()

      if lChkSer( ::oFacCliT:cSerie, ::aSer )

         aTotFac  := aTotFacCli( ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac, ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias, ::oFacCliP:cAlias, ::oAntCliT:cAlias )[ 8 ]

         for n := 1 to len( aTotFac )

            if aTotFac[ n, 3 ] != nil

               cCodIva           := cCodigoIva( ::oDbfIva:cAlias, aTotFac[ n, 3 ] )

               if ( ::lAllIva .or. ( cCodIva >= ::cIvaDes .and. cCodIva <= ::cIvaHas ) )

                  ::oDbf:Append()

                  ::AddCliente( ::oFacCliT:cCodCli, ::oFacCliT, .f. )

                  ::oDbf:dFecMov := ::oFacCliT:dFecFac
                  ::oDbf:cNumFac := lTrim( ::oFacCliT:cSerie ) + "/" + lTrim( Str( ::oFacCliT:nNumFac ) ) + "/" + lTrim( ::oFacCliT:cSufFac )
                  ::oDbf:cTipIva := cCodIva
                  ::oDbf:cNomIva := oRetFld( cCodIva, ::oDbfIva )
                  ::oDbf:nPctIva := aTotFac[ n, 3 ]
                  ::oDbf:nBasFac := aTotFac[ n, 2 ]
                  ::oDbf:nIvaFac := aTotFac[ n, 8 ]
                  ::oDbf:nReqFac := aTotFac[ n, 9 ]
                  ::oDbf:nTotFac := ::oDbf:nBasFac + ::oDbf:nIvaFac + ::oDbf:nReqFac
                  ::oDbf:cTipDoc := "Factura"

                  ::oDbf:Save()

               end if

            end if

         next

      end if

      ::oFacCliT:Skip()

      ::oMtrInf:AutoInc()

   end while

   /*Destruimos los filtros creados anteriormente*/

   ::oFacCliT:IdxDelete( cCurUsr(), GetFileNoExt( ::oFacCliT:cFile ) )

   /*Monta los filtros para la tabla de facturas rectificativas*/

   ::oFacRecT:OrdSetFocus( "dFecFac" )

   do case
      case ::oEstado:nAt == 1
         cExpHead    := '!lLiquidada .and. dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
      case ::oEstado:nAt == 2
         cExpHead    := 'lLiquidada .and. dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
      case ::oEstado:nAt == 3
         cExpHead    := 'dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'
   end case

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oFacRecT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oFacRecT:cFile ), ::oFacRecT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oFacRecT:OrdKeyCount() )

   /*Recorremos las cabeceras y lineas de las facturas*/

   ::oFacRecT:GoTop()

   while !::lBreak .and. !::oFacRecT:Eof()

      if lChkSer( ::oFacRecT:cSerie, ::aSer )

         aTotFac  := aTotFacRec( ::oFacRecT:cSerie + Str( ::oFacRecT:nNumFac ) + ::oFacRecT:cSufFac, ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias )[ 8 ]

         for n := 1 to len( aTotFac )

            if aTotFac[ n, 3 ] != nil

               cCodIva           := cCodigoIva( ::oDbfIva:cAlias, aTotFac[ n, 3 ] )

               if ( ::lAllIva .or. ( cCodIva >= ::cIvaDes .and. cCodIva <= ::cIvaHas ) )

                  ::oDbf:Append()

                  ::AddCliente( ::oFacRecT:cCodCli, ::oFacRecT, .f. )

                  ::oDbf:dFecMov := ::oFacRecT:dFecFac
                  ::oDbf:cNumFac := lTrim( ::oFacRecT:cSerie ) + "/" + lTrim( Str( ::oFacRecT:nNumFac ) ) + "/" + lTrim( ::oFacRecT:cSufFac )
                  ::oDbf:cTipIva := cCodIva
                  ::oDbf:cNomIva := oRetFld( cCodIva, ::oDbfIva )
                  ::oDbf:nPctIva := aTotFac[ n, 3 ]
                  ::oDbf:nBasFac := aTotFac[ n, 2 ]
                  ::oDbf:nIvaFac := aTotFac[ n, 8 ]
                  ::oDbf:nReqFac := aTotFac[ n, 9 ]
                  ::oDbf:nTotFac := ::oDbf:nBasFac + ::oDbf:nIvaFac + ::oDbf:nReqFac
                  ::oDbf:cTipDoc := "Rectificativa"

                  ::oDbf:Save()

               end if

            end if

         next

      end if

      ::oFacRecT:Skip()

      ::oMtrInf:AutoInc()

   end while

   /*Destruimos los filtros creados anteriormente*/

   ::oFacRecT:IdxDelete( cCurUsr(), GetFileNoExt( ::oFacRecT:cFile ) )

   ::oMtrInf:AutoInc( ::oFacRecT:Lastrec() )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//