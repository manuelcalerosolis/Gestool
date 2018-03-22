#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TddAgeFac FROM TInfGen

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

   METHOD AppendLine( aTotal, nTotPag )



END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField( "cCodAge", "C",  3, 0, {|| "@!" },        "Cód. age.",        .f., "Cod. agente",         3 )
   ::AddField( "cNomAge", "C", 50, 0, {|| "@!" },        "Agente",           .f., "Nom. agente",        25 )
   ::FldCliente()
   ::AddField( "cNumDoc", "C", 12, 0, {|| "" },          "Doc.",             .t., "Documento",          12 )
   ::AddField( "dFecDoc", "D",  8, 0, {|| "" },          "Fecha",            .t., "Fecha",              12 )
   ::AddField( "nTotNet", "N", 16, 6, {|| ::cPicOut },   "Neto",             .t., "Neto",               12 )
   ::AddField( "nTotIva", "N", 16, 6, {|| ::cPicOut },   cImp(),              .t., cImp(),                12 )
   ::AddField( "nTotReq", "N", 16, 3, {|| ::cPicOut },   "Rec",              .t., "Rec",                12 )
   ::AddField( "nTotPnt", "N", 16, 6, {|| ::cPicPnt },   "Pnt.Ver.",         .f., "Punto verde",        12 )
   ::AddField( "nTotTrn", "N", 16, 6, {|| ::cPicOut },   "Transp.",          .f., "Transporte",         12 )
   ::AddField( "nTotDoc", "N", 16, 6, {|| ::cPicOut },   "Total",            .t., "Total",              12 )
   ::AddField( "nTotCos", "N", 16, 6, {|| ::cPicOut },   "Costo",            .t., "Costo",              12 )
   ::AddField( "nMarGen", "N", 16, 6, {|| ::cPicOut },   "Margen",           .t., "Margen",             12 )
   ::AddField( "nRenTab", "N", 16, 6, {|| ::cPicOut },   "% Ren.",           .t., "% rentabilidad",     12 )
   ::AddField( "nTotPgd", "N", 16, 6, {|| ::cPicOut },   "Pagado",           .t., "Pagado",             12 )
   ::AddField( "nComAge", "N", 13, 6, {|| ::cPicOut },   "Com.Age.",         .t., "Comisión agente",    12 )

   ::AddTmpIndex( "cCodCli", "cCodAge + cCodCli" )
   ::AddTmpIndex( "cCodFec", "cCodAge + DtoS( dFecDoc )" )
   ::AddTmpIndex( "cCodNum", "cCodAge + cNumDoc" )

   ::AddGroup( {|| ::oDbf:cNomAge }, {|| "Agente  : " + Rtrim( ::oDbf:cNomAge ) + "-" + oRetFld( ::oDbf:cNomAge, ::oDbfAge ) }, {||"Total agente..."} )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS TddAgeFac

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE


   ::oFacCliT := TDataCenter():oFacCliT()

   DATABASE NEW ::oFacCliL  PATH ( cPatEmp() ) FILE "FACCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "FACCLIL.CDX"

   DATABASE NEW ::oFacRecT  PATH ( cPatEmp() ) FILE "FACRECT.DBF" VIA ( cDriver() ) SHARED INDEX "FACRECT.CDX"

   DATABASE NEW ::oFacRecL  PATH ( cPatEmp() ) FILE "FACRECL.DBF" VIA ( cDriver() ) SHARED INDEX "FACRECL.CDX"

   ::oFacCliP := TDataCenter():oFacCliP()

   DATABASE NEW ::oAntCliT  PATH ( cPatEmp() ) FILE "ANTCLIT.DBF" VIA ( cDriver() ) SHARED INDEX "ANTCLIT.CDX"

   DATABASE NEW ::oDbfCli   PATH ( cPatCli() ) FILE "CLIENT.DBF"  VIA ( cDriver() ) SHARED INDEX "CLIENT.CDX"

   DATABASE NEW ::oDbfIva  PATH ( cPatDat () ) FILE "TIVA.DBF"    VIA ( cDriver() ) SHARED INDEX "TIVA.CDX"

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos" )
      ::CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TddAgeFac


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
   ::oAntCliT := nil
   ::oDbfCli  := nil
   ::oDbfIva  := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld ) CLASS TddAgeFac

   if !::StdResource( "INF_GEN25" )
      return .f.
   end if

   /*
   Monta los agentes de manera automatica
   */

   if !::oDefAgeInf( 70, 80, 90, 100, 220 )
      return .f.
   end if

   /*
   Damos valor al meter
   */

   ::oMtrInf:SetTotal( ::oFacCliT:Lastrec() )

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

METHOD lGenerate() CLASS TddAgeFac

   local aTotal
   local nTotPag
   local bValid   := {|| .t. }
   local lExcCero := .f.
   local cExpHead := ""

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   ::aHeader      := {  {|| "Fecha   : " + Dtoc( Date() ) },;
                        {|| "Periodo : " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                        {|| "Agentes : " + ::cAgeOrg         + " > " + ::cAgeDes },;
                        {|| "Estado  : " + ::cEstado },;
                        {|| "Ordenado: " + ::cOrdenado } }

   ::oFacCliT:OrdSetFocus( "dFecFac" )

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       := ::oFilter:cExpresionFilter
   else
      cExpHead       := '.t.'
   end if

   ::oFacCliT:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oFacCliT:cFile ), ::oFacCliT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oFacCliT:GoTop()

	/*
   Nos movemos por las cabeceras de los albaranes
   */

   while !::lBreak .and. !::oFacCliT:Eof()

      if ::oFacCliT:dFecFac >= ::dIniInf                                                              .AND.;
         ::oFacCliT:dFecFac <= ::dFinInf                                                              .AND.;
         ( ::lAgeAll .or. ( ::oFacCliT:cCodAge >= ::cAgeOrg .AND. ::oFacCliT:cCodAge <= ::cAgeDes ) ) .AND.;
         lChkSer( ::oFacCliT:cSerie, ::aSer )

         nTotPag           := nPagFacCli( ::oFacCliT:cSerie + Str( ::oFacCliT:NNUMFAC ) + ::oFacCliT:CSUFFAC, ::oFacCliT:cAlias, ::oFacCliP:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias )
         aTotal            := aTotFacCli( ::oFacCliT:cSerie + Str( ::oFacCliT:NNUMFAC ) + ::oFacCliT:CSUFFAC, ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias, ::oFacCliP:cAlias, ::oAntCliT:cAlias )

         do case
            case ::oEstado:nAt == 1
               if abs( aTotal[ 4 ] ) > abs( nTotPag ) .and. abs( aTotal[ 4 ] ) > 0
                  ::AppendLine( ::oFacCliT, aTotal, nTotPag )
               end if
            case ::oEstado:nAt == 2
               if abs( aTotal[ 4 ] ) <= abs( nTotPag )
                  ::AppendLine( ::oFacCliT, aTotal, nTotPag )
               end if
            case ::oEstado:nAt == 3
               ::AppendLine( ::oFacCliT, aTotal, nTotPag )
         end case

      end if

      ::oFacCliT:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oFacCliT:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oFacCliT:cFile ) )
   ::oMtrInf:AutoInc( ::oFacCliT:LastRec() )

   /*
   Comenzamos las rectificativas
   */

   ::oFacRecT:OrdSetFocus( "dFecFac" )

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       := ::oFilter:cExpresionFilter
   else
      cExpHead       := '.t.'
   end if

   ::oFacRecT:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oFacRecT:cFile ), ::oFacRecT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oFacRecT:GoTop()

	/*
   Nos movemos por las cabeceras de los albaranes
   */

   while !::lBreak .and. !::oFacRecT:Eof()

      if ::oFacRecT:dFecFac >= ::dIniInf                                                              .AND.;
         ::oFacRecT:dFecFac <= ::dFinInf                                                              .AND.;
         ( ::lAgeAll .or. ( ::oFacRecT:cCodAge >= ::cAgeOrg .AND. ::oFacRecT:cCodAge <= ::cAgeDes ) ) .AND.;
         lChkSer( ::oFacRecT:cSerie, ::aSer )

         aTotal            := aTotFacRec( ::oFacRecT:cSerie + Str( ::oFacRecT:nNumFac ) + ::oFacRecT:cSufFac, ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias )
         nTotPag           := nPagFacRec( ::oFacRecT:cSerie + Str( ::oFacRecT:NNUMFAC ) + ::oFacRecT:CSUFFAC, ::oFacRecT:cAlias, ::oFacCliP:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias )

         do case
            case ::oEstado:nAt == 1
               if abs( aTotal[ 4 ] ) > abs( nTotPag ) .and. abs( aTotal[ 4 ] ) > 0
                  ::AppendLine( ::oFacRecT, aTotal, nTotPag )
               end if
            case ::oEstado:nAt == 2
               if abs( aTotal[ 4 ] ) <= abs( nTotPag )
                  ::AppendLine( ::oFacRecT, aTotal, nTotPag )
               end if
            case ::oEstado:nAt == 3
               ::AppendLine( ::oFacRecT, aTotal, nTotPag )
         end case

      end if

      ::oFacRecT:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oFacRecT:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oFacRecT:cFile ) )
   ::oMtrInf:AutoInc( ::oFacRecT:LastRec() )

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

METHOD AppendLine( oFacT, aTotal, nTotPag )

   local nMargen     := 0

   ::oDbf:Append()

   ::oDbf:cCodAge    := oFacT:cCodAge

   if ::oDbfAge:Seek( oFacT:cCodAge )
      ::oDbf:cNomAge := Rtrim( ::oDbfAge:cApeAge ) + ", " + ::oDbfAge:cNbrAge
   end if

   ::oDbf:cNomAge    := oFacT:cCodAge
   ::oDbf:CCODCLI    := oFacT:cCodCli
   ::oDbf:CNOMCLI    := oFacT:cNomCli

   ::AddCliente( oFacT:cCodCli, oFacT, .f. )

   ::oDbf:dFecDoc    := oFacT:dFecFac
   ::oDbf:cNumDoc    := oFacT:cSerie + "/" + AllTrim( Str( oFacT:nNumFac ) ) + "/" + oFacT:cSufFac
   ::oDbf:nTotNet    := aTotal[ 1 ] - aTotal[ 5 ] - aTotal[ 6 ]
   ::oDbf:nTotIva    := aTotal[ 2 ]
   ::oDbf:nTotReq    := aTotal[ 3 ]
   ::oDbf:nTotDoc    := aTotal[ 4 ]
   ::oDbf:nTotPnt    := aTotal[ 5 ]   
   ::oDbf:nTotTrn    := aTotal[ 6 ]
   ::oDbf:nComAge    := aTotal[ 7 ]
   ::oDbf:nTotPgd    := nTotPag

   ::oDbf:nTotCos    := aTotal[ 9 ]
   nMargen           := ::oDbf:nTotNet - aTotal[ 7 ] - aTotal[ 9 ]
   ::oDbf:nMarGen    := nMargen
   
   ::oDbf:nRenTab    := nRentabilidad( ::oDbf:nTotNet - aTotal[ 7 ], 0, aTotal[ 9 ] )

   ::oDbf:Save()

RETURN ( Self )

//---------------------------------------------------------------------------//