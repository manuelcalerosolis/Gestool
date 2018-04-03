#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TFacRecIva FROM TInfGen

   DATA  lResumen    AS LOGIC    INIT .f.
   DATA  lExcCero    AS LOGIC    INIT .f.
   DATA  oEstado     AS OBJECT
   DATA  oFacPrvT    AS OBJECT
   DATA  oFacPrvL    AS OBJECT
   DATA  cIvaDes     AS CHARACTER
   DATA  cIvaHas     AS CHARACTER
   DATA  oDbfIva     AS OBJECT
   DATA  oFacPrvP    AS OBJECT
   DATA  aEstado     AS ARRAY    INIT { "Pendiente", "Liquidada", "Todas" }
   DATA  lAllIva     AS LOGIC    INIT .t.

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

  METHOD Create()

   ::AddField ( "cNumFac", "C", 14, 0, {|| "@!" },        "Factura",                     .t., "Factura",                   14  )
   ::AddField ( "cTipIva", "C",  1, 0, {|| "@!" },        "Tipo",                        .f., "Tipo I.V.A",                 1  )
   ::AddField ( "dFecMov", "D",  8, 0, {|| "@!" },        "Fecha",                       .t., "Fecha",                     14  )
   ::AddField ( "cCodPrv", "C", 12, 0, {|| "@!" },        "Cod. prv.",                   .f., "Cod. proveedor",             8  )
   ::AddField ( "cNomPrv", "C", 50, 0, {|| "@!" },        "Proveedor",                   .f., "Nombre proveedor",          25  )
   ::AddField ( "cNifPrv", "C", 15, 0, {|| "@!" },        "Nif",                         .f., "Nif",                       10  )
   ::AddField ( "cDomPrv", "C", 35, 0, {|| "@!" },        "Domicilio",                   .f., "Domicilio",                 25  )
   ::AddField ( "cPobPrv", "C", 25, 0, {|| "@!" },        "Población",                   .f., "Población",                 25  )
   ::AddField ( "cProPrv", "C", 20, 0, {|| "@!" },        "Provincia",                   .f., "Provincia",                 20  )
   ::AddField ( "cCdpPrv", "C",  7, 0, {|| "@!" },        "CP",                          .f., "Cod. postal",               20  )
   ::AddField ( "cTlfPrv", "C", 12, 0, {|| "@!" },        "Tlf",                         .f., "Teléfono",                   7  )
   ::AddField ( "nBasFac", "N", 16, 3, {|| ::cPicIn },    "Base",                        .t., "Base",                      16  )
   ::AddField ( "nIvaFac", "N", 16, 3, {|| ::cPicIn },    cImp(),                         .t., cImp(),                       16  )
   ::AddField ( "nReqFac", "N", 16, 3, {|| ::cPicIn },    "Rec",                         .t., "Recargo",                   16  )
   ::AddField ( "nTotFac", "N", 16, 6, {|| ::cPicIn },    "Total",                       .t., "Total factura",             16  )
   ::AddField ( "dFecCon", "D",  8, 0, {|| "@!" },        "Contabilización",             .f., "Fecha contabilización",     25  )

   ::AddTmpIndex ( "cTipIva", "cTipIva" )

   ::AddGroup ( {|| ::oDbf:cTipIva }, {|| "tipo " + cImp() + " : " + Rtrim( ::oDbf:cTipIva ) + "-" + oRetFld( ::oDbf:cTipIva, ::oDbfIva ) }, {|| "Total tipo " + cImp() } )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   DATABASE NEW ::oFacPrvT PATH ( cPatEmp() )   FILE "FACPRVT.DBF"   VIA ( cDriver() ) SHARED INDEX "FACPRVT.CDX"

   DATABASE NEW ::oFacPrvL PATH ( cPatEmp() )   FILE "FACPRVL.DBF"   VIA ( cDriver() ) SHARED INDEX "FACPRVL.CDX"

   DATABASE NEW ::oFacPrvP PATH ( cPatEmp() )   FILE "FACPRVP.DBF"   VIA ( cDriver() ) SHARED INDEX "FACPRVP.CDX"

   DATABASE NEW ::oDbfIva  PATH ( cPatDat() )   FILE "TIVA.DBF"      VIA ( cDriver() ) SHARED INDEX "TIVA.CDX"

   DATABASE NEW ::oDbfPrv  PATH ( cPatEmp() )   FILE "PROVEE.DBF"    VIA ( cDriver() ) SHARED INDEX "PROVEE.CDX"

   RECOVER

      msgStop( 'Imposible abrir todas las bases de datos' )
      ::CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles()

   if !Empty( ::oFacPrvT ) .and. ::oFacPrvT:Used()
      ::oFacPrvT:End()
   end if
   if !Empty( ::oFacPrvL ) .and. ::oFacPrvL:Used()
      ::oFacPrvL:End()
   end if
   if !Empty( ::oDbfIva ) .and. ::oDbfIva:Used()
      ::oDbfIva:End()
   end if
   if !Empty( ::oFacPrvP ) .and. ::oFacPrvP:Used()
      ::oFacPrvP:End()
   end if
   if !Empty( ::oDbfPrv ) .and. ::oDbfPrv:Used()
      ::oDbfPrv:End()
   end if

   ::oFacPrvT  := nil
   ::oFacPrvL  := nil
   ::oDbfIva   := nil
   ::oFacPrvP  := nil
   ::oDbfPrv   := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld )

   local cEstado := "Todas"
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

   /*
   Damos valor al meter
   */

   ::oMtrInf:SetTotal( ::oFacPrvT:Lastrec() )

   REDEFINE COMBOBOX ::oEstado ;
      VAR      cEstado ;
      ID       218 ;
      ITEMS    ::aEstado;
      OF       ::oFld:aDialogs[1]

   /*
   Montamos el Desde -- Hasta impuestos----------------------------------------------
   */

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

   ::CreateFilter( aItmFacPrv(), ::oFacPrvT:cAlias )

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   local n
   local cCodIva
   local aTotFac
   local cExpHead := ""

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   /*Monta la cabecera del documento*/

   ::aHeader      := {  {|| "Fecha    : " + Dtoc( Date() ) },;
                        {|| "Periodo  : " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                        {|| "tipo " + cImp() + " : " + if( ::lAllIva, "Todos", AllTrim( ::cIvaDes ) + " > " + AllTrim( ::cIvaHas ) ) },;
                        {|| "Estado   : " + ::aEstado[ ::oEstado:nAt ] } }

   /*Monta los filtros para la tabla de facturas*/

   ::oFacPrvT:OrdSetFocus( "dFecFac" )

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

   ::oFacPrvT:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oFacPrvT:cFile ), ::oFacPrvT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oFacPrvT:GoTop()

   while !::lBreak .and. !::oFacPrvT:Eof()

      if lChkSer( ::oFacPrvT:cSerFac, ::aSer )

         aTotFac           := aTotFacPrv( ::oFacPrvT:CSERFAC + Str( ::oFacPrvT:NNUMFAC ) + ::oFacPrvT:CSUFFAC, ::oFacPrvT:cAlias, ::oFacPrvL:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias, ::oFacPrvP:cAlias, nil, ::cDivInf, .f. )[ 5 ]

         for n := 1 to len( aTotFac )

            if aTotFac[ n, 3 ] != nil

               cCodIva           := cCodigoIva( ::oDbfIva:cAlias, aTotFac[ n, 3 ] )

               if ( ::lAllIva .or. ( cCodIva >= ::cIvaDes .and. cCodIva <= ::cIvaHas ) )

                  ::oDbf:Append()

                  ::oDbf:cNumFac := AllTrim( ::oFacPrvT:cSerFac ) + "/" + Alltrim( Str( ::oFacPrvT:nNumFac ) ) + "/" + AllTrim( ::oFacPrvT:cSufFac )
                  ::oDbf:dFecMov := ::oFacPrvT:dFecFac
                  ::oDbf:dFecCon := ::oFacPrvT:dFecEnt
                  ::oDbf:cTipIva := cCodIva
                  ::oDbf:nBasFac := aTotFac[ n, 2 ]
                  ::oDbf:nIvaFac := ( aTotFac[ n, 2 ] * aTotFac[ n, 3 ] ) / 100
                  if ::oFacPrvT:lRecargo
                     ::oDbf:nReqFac := ( aTotFac[ n, 2 ] * aTotFac[ n, 4 ] ) / 100
                  else
                     ::oDbf:nReqFac := 0
                  end if
                  ::oDbf:nTotFac := ::oDbf:nBasFac + ::oDbf:nIvaFac + ::oDbf:nReqFac

                  ::AddProveedor( ::oFacPrvT:cCodPrv )

                  ::oDbf:Save()

               end if

            end if

         next

      end if

      ::oFacPrvT:Skip()

      ::oMtrInf:AutoInc( ::oFacPrvT:OrdKeyNo() )

   end while

   ::oFacPrvT:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oFacPrvT:cFile ) )

   ::oMtrInf:AutoInc( ::oFacPrvT:Lastrec() )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//