#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TdAgePed FROM TInfGen

   DATA  lResumen    AS LOGIC       INIT .f.
   DATA  lExcCero    AS LOGIC       INIT .f.
   DATA  oEstado     AS OBJECT
   DATA  cEstado     AS CHARACTER   INIT  "Todos"
   DATA  aEstado     AS ARRAY       INIT  { "Pendiente", "Parcilamente", "Entregado", "Todos" }
   DATA  oPedCliT    AS OBJECT
   DATA  oPedCliL    AS OBJECT
   DATA  oDbfIva     AS OBJECT
   DATA  lTvta       AS LOGIC       INIT .f.
   DATA  cTipVen     AS CHARACTER
   DATA  cTipVen2    AS CHARACTER
   DATA  oOrdenado   AS OBJECT
   DATA  cOrdenado   AS CHARACTER   INIT  "Fechas"
   DATA  aOrdenado   AS ARRAY       INIT  { "Clientes", "Fechas", "Documento" }

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

   METHOD AppendLine( aTotal )

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
   ::AddField( "nComAge", "N", 13, 6, {|| ::cPicOut },   "Com.Age.",         .t., "Comisión agente",    12 )

   ::AddTmpIndex( "cCodCli", "cCodAge + cCodCli" )
   ::AddTmpIndex( "cCodFec", "cCodAge + DtoS( dFecDoc )" )
   ::AddTmpIndex( "cCodNum", "cCodAge + cNumDoc" )

   ::AddGroup( {|| ::oDbf:cNomAge }, {|| "Agente  : " + Rtrim( ::oDbf:cNomAge ) + "-" + oRetFld( ::oDbf:cNomAge, ::oDbfAge ) }, {||"Total agente..."} )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS TdAgePed

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   ::oPedCliT := TDataCenter():oPedCliT()

   DATABASE NEW ::oPedCliL  PATH ( cPatEmp() ) FILE "PEDCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "PEDCLIL.CDX"

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

METHOD CloseFiles() CLASS TdAgePed

   if !Empty( ::oPedCliT ) .and. ::oPedCliT:Used()
      ::oPedCliT:End()
   end if
   if !Empty( ::oPedCliL ) .and. ::oPedCliL:Used()
      ::oPedCliL:End()
   end if
   if !Empty( ::oDbfCli ) .and. ::oDbfCli:Used()
      ::oDbfCli:End()
   end if
   if !Empty( ::oDbfIva ) .and. ::oDbfIva:Used()
      ::oDbfIva:End()
   end if

   ::oPedCliT := nil
   ::oPedCliL := nil
   ::oDbfCli  := nil
   ::oDbfIva  := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld ) CLASS TdAgePed

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

   ::oMtrInf:SetTotal( ::oPedCliT:Lastrec() )

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

   ::CreateFilter( aItmPedCli(), ::oPedCliT:cAlias )

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate() CLASS TdAgePed

   local cExpHead := ""
   local bValid   := {|| .t. }
   local lExcCero := .f.
   local aTotal

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   ::aHeader      := {  {|| "Fecha   : " + Dtoc( Date() ) },;
                        {|| "Periodo : " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                        {|| "Agentes : " + ::cAgeOrg         + " > " + ::cAgeDes },;
                        {|| "Facturas: " + ::cEstado },;
                        {|| "Ordenado: " + ::cOrdenado } }

   ::oPedCliT:OrdSetFocus( "dFecPed" )

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       := ::oFilter:cExpresionFilter
   else
      cExpHead       := '.t.'
   end if

   ::oPedCliT:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oPedCliT:cFile ), ::oPedCliT:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oPedCliT:GoTop()

   /*
   Nos movemos por las cabeceras de los albaranes
   */

   while !::lBreak .and. !::oPedCliT:Eof()

      if ::oPedCliT:dFecPed >= ::dIniInf                                                              .AND.;
         ::oPedCliT:dFecPed <= ::dFinInf                                                              .AND.;
         ( ::lAgeAll .or. ( ::oPedCliT:cCodAge >= ::cAgeOrg .AND. ::oPedCliT:cCodAge <= ::cAgeDes ) ) .AND.;
         lChkSer( ::oPedCliT:cSerPed, ::aSer )

         aTotal            := aTotPedCli( ::oPedCliT:cSerPed + Str( ::oPedCliT:nNumPed ) + ::oPedCliT:cSufPed, ::oPedCliT:cAlias, ::oPedCliL:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias )

         do case
            case ::oEstado:nAt == 1
               if bValid   := {|| ::oPedCliT:nEstado == 1 }
                  ::AppendLine( aTotal )
               end if
            case ::oEstado:nAt == 2
               if bValid   := {|| ::oPedCliT:nEstado == 2 }
                  ::AppendLine( aTotal )
               end if
            case ::oEstado:nAt == 3
               if bValid   := {|| ::oPedCliT:nEstado == 3 }
                  ::AppendLine( aTotal )
               end if
            case ::oEstado:nAt == 4
               ::AppendLine( aTotal )
         end case

      end if

      ::oPedCliT:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oPedCliT:IdxDelete( cCurUsr(), GetFileNoExt( ::oPedCliT:cFile ) )

   ::oMtrInf:AutoInc( ::oPedCliT:LastRec() )

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

METHOD AppendLine( aTotal )

   ::oDbf:Append()

   ::oDbf:cCodAge    := ::oPedCliT:cCodAge

   if ::oDbfAge:Seek( ::oPedCliT:cCodAge )
      ::oDbf:cNomAge := Rtrim( ::oDbfAge:cApeAge ) + ", " + ::oDbfAge:cNbrAge
   end if

   ::oDbf:cNomAge    := ::oPedCliT:cCodAge
   ::oDbf:cCodCli    := ::oPedCliT:cCodCli
   ::oDbf:cNomCli    := ::oPedCliT:cNomCli

   ::AddCliente( ::oPedCliT:cCodCli, ::oPedCliT, .f. )

   aTotal            := aTotPedCli( ::oPedCliT:cSerPed + Str( ::oPedCliT:nNumPed ) + ::oPedCliT:cSufPed, ::oPedCliT:cAlias, ::oPedCliL:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias )

   ::oDbf:dFecDoc    := ::oPedCliT:dFecPed
   ::oDbf:cNumDoc    := ::oPedCliT:cSerPed + "/" + AllTrim( Str( ::oPedCliT:nNumPed ) ) + "/" + ::oPedCliT:cSufPed
   ::oDbf:nTotNet    := aTotal[ 1 ] - aTotal[ 5 ] - aTotal[ 6 ]
   ::oDbf:nTotIva    := aTotal[ 2 ]
   ::oDbf:nTotReq    := aTotal[ 3 ]
   ::oDbf:nTotDoc    := aTotal[ 4 ]
   ::oDbf:nTotPnt    := aTotal[ 5 ]
   ::oDbf:nTotTrn    := aTotal[ 6 ]
   ::oDbf:nComAge    := aTotal[ 7 ]

   ::oDbf:nTotCos    := aTotal[ 8 ]
   ::oDbf:nMarGen    := aTotal[ 4 ] - aTotal[ 8 ]
   ::oDbf:nRenTab    := ( ( aTotal[ 4 ] / aTotal[ 8 ] ) - 1 ) * 100

   ::oDbf:Save()

RETURN ( Self )

//---------------------------------------------------------------------------//