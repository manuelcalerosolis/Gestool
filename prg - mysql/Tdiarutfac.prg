#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TDiaRutFac FROM TInfGen

   DATA  lResumen    AS LOGIC    INIT .f.
   DATA  lExcCero    AS LOGIC    INIT .f.
   DATA  oEstado     AS OBJECT
   DATA  cEstado     AS CHARACTER     INIT  "Todas"
   DATA  aEstado     AS ARRAY    INIT  { "Pendientes", "Cobradas", "Todas" }
   DATA  oFacCliT    AS OBJECT
   DATA  oFacCliL    AS OBJECT
   DATA  oFacRecT    AS OBJECT
   DATA  oFacRecL    AS OBJECT
   DATA  oFacCliP    AS OBJECT
   DATA  oAntCliT    AS OBJECT
   DATA  oDbfIva     AS OBJECT
   DATA  oOrdenado   AS OBJECT
   DATA  cOrdenado   AS CHARACTER     INIT  "Fechas"
   DATA  aOrdenado   AS ARRAY    INIT  { "Clientes", "Fechas", "Documento" }

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

   METHOD AppendLineFacCli( aTotal, nTotPag )

   METHOD AppendLineFacRec( aTotal, nTotPag )

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField( "cCodRut", "C",  4, 0, {|| "@!" },                 "Cod. Rut.",        .f., "Código ruta",         4, .f. )
   ::AddField( "cNomRut", "C", 50, 0, {|| "@!" },                 "Ruta",             .f., "Nombre ruta",        20, .f. )
   ::AddField( "cNumDoc", "C", 12, 0, {|| "@R #/#########/##" },  "Doc.",             .t., "Documento",          20, .f. )
   ::AddField( "dFecDoc", "D",  8, 0, {|| "" },                   "Fecha",            .t., "Fecha",              12, .f. )
   ::FldCliente()
   ::AddField( "nTotNet", "N", 16, 6, {|| ::cPicOut },            "Neto",             .t., "Neto",               12 )
   ::AddField( "nTotIva", "N", 16, 6, {|| ::cPicOut },            cImp(),              .t., cImp(),                12 )
   ::AddField( "nTotReq", "N", 16, 3, {|| ::cPicOut },            "Rec",              .t., "Rec",                12 )
   ::AddField( "nTotPnt", "N", 16, 6, {|| ::cPicPnt },            "Pnt.Ver.",         .f., "Punto verde",        12 )
   ::AddField( "nTotTrn", "N", 16, 6, {|| ::cPicOut },            "Transp.",          .f., "Transporte",         12 )
   ::AddField( "nTotDoc", "N", 16, 6, {|| ::cPicOut },            "Total",            .t., "Total",              12 )
   ::AddField( "nTotPgd", "N", 16, 6, {|| ::cPicOut },            "Pagado",           .t., "Pagado",             12 )
   ::AddField( "nTotAge", "N", 16, 6, {|| ::cPicOut },            "Com. agente",      .t., "Comisión agente",    12 )

   ::AddTmpIndex( "cCodCli", "cCodRut + cCodCli" )
   ::AddTmpIndex( "cCodFec", "cCodRut + DtoS( dFecDoc )" )
   ::AddTmpIndex( "cCodNum", "cCodRut + cNumDoc" )

   ::AddGroup( {|| ::oDbf:cCodRut }, {|| "Ruta  : " + Rtrim( ::oDbf:cCodRut ) + "-" + Rtrim( ::oDbf:cNomRut ) }, {||"Total ruta..."} )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS TDiaRutFac

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

      ::oFacCliT := TDataCenter():oFacCliT()

      DATABASE NEW ::oFacCliL  PATH ( cPatEmp() ) FILE "FACCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "FACCLIL.CDX"

      DATABASE NEW ::oFacRecT  PATH ( cPatEmp() ) FILE "FACRECT.DBF" VIA ( cDriver() ) SHARED INDEX "FACRECT.CDX"

      DATABASE NEW ::oFacRecL  PATH ( cPatEmp() ) FILE "FACCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "FACCLIL.CDX"

      ::oFacCliP := TDataCenter():oFacCliP()

      DATABASE NEW ::oDbfCli   PATH ( cPatCli() ) FILE "CLIENT.DBF"  VIA ( cDriver() ) SHARED INDEX "CLIENT.CDX"

      DATABASE NEW ::oDbfIva  PATH ( cPatDat () ) FILE "TIVA.DBF"    VIA ( cDriver() ) SHARED INDEX "TIVA.CDX"

      DATABASE NEW ::oAntCliT  PATH ( cPatEmp() ) FILE "ANTCLIT.DBF" VIA ( cDriver() ) SHARED INDEX "ANTCLIT.CDX"

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos" )

      ::CloseFiles()

      lOpen       := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TDiaRutFac

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
   if !Empty( ::oDbfCli ) .and. ::oDbfCli:Used()
      ::oDbfCli:End()
   end if
   if !Empty( ::oDbfIva ) .and. ::oDbfIva:Used()
      ::oDbfIva:End()
   end if
   if !Empty( ::oAntCliT ) .and. ::oAntCliT:Used()
      ::oAntCliT:End()
   end if

   ::oFacCliT := nil
   ::oFacCliL := nil
   ::oFacRecT := nil
   ::oFacRecL := nil
   ::oFacCliP := nil
   ::oDbfCli  := nil
   ::oDbfIva  := nil
   ::oAntCliT := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld ) CLASS TDiaRutFac

   if !::StdResource( "DIAFACRUT" )
      return .f.
   end if

   /*
   Monta los agentes de manera automatica
   */

   if !::oDefRutInf( 70, 80, 90, 100, 600 )
      return .f.
   end if

   /*
   Damos valor al meter
   */

   ::oMtrInf:SetTotal( ::oFacCliT:Lastrec() )

   ::oDefResInf()

   REDEFINE COMBOBOX ::oEstado ;
      VAR      ::cEstado ;
      ID       218 ;
      ITEMS    ::aEstado ;
      OF       ::oFld:aDialogs[1]

   REDEFINE COMBOBOX ::oOrdenado ;
      VAR      ::cOrdenado ;
      ID       219 ;
      ITEMS    ::aOrdenado ;
      OF       ::oFld:aDialogs[1]

   ::CreateFilter( aItmFacCli(), ::oFacCliT:cAlias )

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate() CLASS TDiaRutFac

   local aTotal
   local nTotPag
   local cExpHead := ""

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   ::aHeader      := {  {|| "Fecha   : " + Dtoc( Date() ) },;
                        {|| "Periodo : " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                        {|| "Rutas   : " + if( ::lAllRut, "Todas", AllTrim( ::cRutOrg ) + " > " + AllTrim( ::cRutDes ) ) },;
                        {|| "Estado  : " + ::cEstado },;
                        {|| "Ordenado: " + ::cOrdenado } }

   ::oFacCliT:OrdSetFocus( "dFecFac" )

   cExpHead       := 'dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   if !::lAllRut
      cExpHead    += ' .and. cCodRut >= "' + Rtrim( ::cRutOrg ) + '" .and. cCodRut <= "' + Rtrim( ::cRutDes ) + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oFacCliT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oFacCliT:cFile ), ::oFacCliT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oFacCliT:OrdKeyCount() )

	/*
   Nos movemos por las cabeceras de los albaranes
   */

   ::oFacCliT:GoTop()

   while !::lBreak .and. !::oFacCliT:Eof()

      if lChkSer( ::oFacCliT:cSerie, ::aSer )

         nTotPag           := nPagFacCli( ::oFacCliT:cSerie + Str( ::oFacCliT:NNUMFAC ) + ::oFacCliT:CSUFFAC, ::oFacCliT:cAlias, ::oFacCliP:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias )
         aTotal            := aTotFacCli( ::oFacCliT:cSerie + Str( ::oFacCliT:NNUMFAC ) + ::oFacCliT:CSUFFAC, ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias, ::oFacCliP:cAlias, ::oAntCliT:cAlias )

         do case
            case ::oEstado:nAt == 1
               if abs( aTotal[ 4 ] ) > abs( nTotPag ) .and. abs( aTotal[ 4 ] ) > 0
                  ::AppendLineFacCli( aTotal, nTotPag )
               end if
            case ::oEstado:nAt == 2
               if abs( aTotal[ 4 ] ) <= abs( nTotPag )
                  ::AppendLineFacCli( aTotal, nTotPag )
               end if
            case ::oEstado:nAt == 3
               ::AppendLineFacCli( aTotal, nTotPag )
         end case

      end if

      ::oFacCliT:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oFacCliT:IdxDelete( cCurUsr(), GetFileNoExt( ::oFacCliT:cFile ) )

    /*
   comenzamos con las rectificativas
    */

   ::oFacRecT:OrdSetFocus( "dFecFac" )

   cExpHead       := 'dFecFac >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFac <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   if !::lAllRut
      cExpHead    += ' .and. cCodRut >= "' + Rtrim( ::cRutOrg ) + '" .and. cCodRut <= "' + Rtrim( ::cRutDes ) + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead    += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oFacRecT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oFacRecT:cFile ), ::oFacRecT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oFacRecT:OrdKeyCount() )

   ::oFacRecT:GoTop()

   while !::lBreak .and. !::oFacRecT:Eof()

      if lChkSer( ::oFacRecT:cSerie, ::aSer )

         nTotPag           := nPagFacRec( ::oFacRecT:cSerie + Str( ::oFacRecT:NNUMFAC ) + ::oFacRecT:CSUFFAC, ::oFacRecT:cAlias, ::oFacCliP:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias )
         aTotal            := aTotFacRec( ::oFacRecT:cSerie + Str( ::oFacRecT:NNUMFAC ) + ::oFacRecT:CSUFFAC, ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias )

         do case
            case ::oEstado:nAt == 1
               if abs( aTotal[ 4 ] ) > abs( nTotPag ) .and. abs( aTotal[ 4 ] ) > 0
                  ::AppendLineFacRec( aTotal, nTotPag )
               end if
            case ::oEstado:nAt == 2
               if abs( aTotal[ 4 ] ) <= abs( nTotPag )
                  ::AppendLineFacRec( aTotal, nTotPag )
               end if
            case ::oEstado:nAt == 3
               ::AppendLineFacRec( aTotal, nTotPag )
         end case

      end if

      ::oFacRecT:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oFacRecT:IdxDelete( cCurUsr(), GetFileNoExt( ::oFacRecT:cFile ) )


   do case
      case ::oOrdenado:nAt == 1
         ::oDbf:OrdSetFocus( "CCODCLI" )
      case ::oOrdenado:nAt == 2
         ::oDbf:OrdSetFocus( "CCODFEC" )
      case ::oOrdenado:nAt == 3
         ::oDbf:OrdSetFocus( "CCODNUM" )
   end case

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//

METHOD AppendLineFacCli( aTotal, nTotPag )

   ::oDbf:Append()

   ::oDbf:cCodRut    := ::oFacCliT:cCodRut
   ::oDbf:cNomRut    := oRetFld( ::oDbf:cCodRut, ::oDbfRut )

   ::oDbf:cCodCli    := ::oFacCliT:cCodCli
   ::oDbf:cNomCli    := ::oFacCliT:cNomCli

   ::AddCliente( ::oFacCliT:cCodCli, ::oFacCliT, .f. )

   ::oDbf:dFecDoc    := ::oFacCliT:dFecFac
   ::oDbf:cNumDoc    := ::oFacCliT:cSerie + Str( ::oFacCliT:nNumFac ) + ::oFacCliT:cSufFac
   ::oDbf:nTotNet    := aTotal[ 1 ] - aTotal[ 5 ] - aTotal[ 6 ]
   ::oDbf:nTotIva    := aTotal[ 2 ]
   ::oDbf:nTotReq    := aTotal[ 3 ]
   ::oDbf:nTotDoc    := aTotal[ 4 ]
   ::oDbf:nTotPnt    := aTotal[ 5 ]
   ::oDbf:nTotTrn    := aTotal[ 6 ]
   ::oDbf:nTotAge    := aTotal[ 7 ]
   ::oDbf:nTotPgd    := nTotPag

   ::oDbf:Save()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD AppendLineFacRec( aTotal, nTotPag )

   ::oDbf:Append()

   ::oDbf:cCodRut    := ::oFacRecT:cCodRut
   ::oDbf:cNomRut    := oRetFld( ::oDbf:cCodRut, ::oDbfRut )

   ::oDbf:cCodCli    := ::oFacRecT:cCodCli
   ::oDbf:cNomCli    := ::oFacRecT:cNomCli

   ::AddCliente( ::oFacRecT:cCodCli, ::oFacRecT, .f. )

   ::oDbf:dFecDoc    := ::oFacRecT:dFecFac
   ::oDbf:cNumDoc    := ::oFacRecT:cSerie + Str( ::oFacRecT:nNumFac ) + ::oFacRecT:cSufFac
   ::oDbf:nTotNet    := aTotal[ 1 ] - aTotal[ 5 ] - aTotal[ 6 ]
   ::oDbf:nTotIva    := aTotal[ 2 ]
   ::oDbf:nTotReq    := aTotal[ 3 ]
   ::oDbf:nTotDoc    := aTotal[ 4 ]
   ::oDbf:nTotPnt    := aTotal[ 5 ]
   ::oDbf:nTotTrn    := aTotal[ 6 ]
   ::oDbf:nTotAge    := aTotal[ 7 ]
   ::oDbf:nTotPgd    := nTotPag

   ::oDbf:Save()

RETURN ( Self )

//---------------------------------------------------------------------------//