#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

FUNCTION DetAgeTpv()

   local oInf
   local aCol  := {}
   local aIdx  := {}

   aAdd( aCol, { "CCODAGE", "C",  3, 0,  {|| "@!" },         "Cód. age.",                 .f., "Cod. Agente",                 3 } )
   aAdd( aCol, { "CNOMAGE", "C", 50, 0,  {|| "@!" },         "Agente",                    .f., "Nom. Agente",                25 } )
   aAdd( aCol, { "CCODCLI", "C", 12, 0,  {|| "@!" },         "Cód. cli.",                 .t., "Cod. Cliente",                8 } )
   aAdd( aCol, { "CNOMCLI", "C", 50, 0,  {|| "@!" },         "Cliente",                   .t., "Nom. Cliente",               40 } )
   aAdd( aCol, { "CNIFCLI", "C", 15, 0,  {|| "@!" },         "Nif",                       .f., "Nif",                        12 } )
   aAdd( aCol, { "CDOMCLI", "C", 35, 0,  {|| "@!" },         "Domicilio",                 .f., "Domicilio",                  20 } )
   aAdd( aCol, { "CPOBCLI", "C", 35, 0,  {|| "@!" },         "Población",                 .f., "Población",                  25 } )
   aAdd( aCol, { "CPROCLI", "C", 20, 0,  {|| "@!" },         "Provincia",                 .f., "Provincia",                  20 } )
   aAdd( aCol, { "CCDPCLI", "C",  7, 0,  {|| "@!" },         "Cod. Postal",               .f., "Cod. Postal",                 7 } )
   aAdd( aCol, { "CTLFCLI", "C", 12, 0,  {|| "@!" },         "Teléfono",                  .f., "Teléfono",                   12 } )
   aAdd( aCol, { "CNUMDOC", "C", 12, 0, {|| "" },            "Doc.",                      .t., "Documento",                  12 } )
   aAdd( aCol, { "DFECDOC", "D",  8, 0, {|| "" },            "Fecha",                     .t., "Fecha",                      10 } )
   aAdd( aCol, { "NTOTNET", "N", 16, 6, {|| oInf:cPicOut },  "Neto",                      .t., "Neto",                       10 } )
   aAdd( aCol, { "NTOTIVA", "N", 16, 6, {|| oInf:cPicOut },  cImp(),                       .t., cImp(),                        10 } )
   aAdd( aCol, { "NTOTDOC", "N", 16, 6, {|| oInf:cPicOut },  "Total",                     .t., "Total",                      10 } )
   aAdd( aCol, { "NCOMAGE", "N", 13, 6, {|| oInf:cPicOut },  "Com.Age.",                  .f., "Comisión agente",            10 } )

   aAdd( aIdx, { "CCODAGE", "CCODAGE + DTOS( DFECDOC )" } )

   oInf  := TDAgeTpv():New( "Informe detallado de la liquidación de agentes en tikets de clientes", aCol, aIdx, "01047" )

   oInf:AddGroup( {|| oInf:oDbf:cNomAge }, {|| "Agente  : " + Rtrim( oInf:oDbf:cNomAge ) + "-" + oRetFld( oInf:oDbf:cNomAge, oInf:oDbfAge ) }, {||"Total agente..."} )

   oInf:Resource()
   oInf:Activate()

   oInf:End()
   oInf  := nil

RETURN NIL

//---------------------------------------------------------------------------//

CLASS TDAgeTpv FROM TInfGen

   DATA  lResumen    AS LOGIC    INIT .f.
   DATA  lExcCero    AS LOGIC    INIT .f.
   DATA  oEstado     AS OBJECT
   DATA  oTpvCliT    AS OBJECT
   DATA  oTpvCliL    AS OBJECT
   DATA  oTpvCliP    AS OBJECT
   DATA  oIva        AS OBJECT
   DATA  oSay        AS OBJECT
   DATA  lTvta       AS LOGIC    INIT .f.
   DATA  cTipVen     AS CHARACTER
   DATA  cTipVen2    AS CHARACTER
   DATA  cEstado     AS CHARACTER     INIT  "Todas"
   DATA  aEstado     AS ARRAY    INIT  { "Pendientes", "Cobradas", "Todas" }
   DATA  oIndice     AS OBJECT

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD Resource( cFld )

   METHOD lGenerate()

   METHOD Activate()

END CLASS

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS TDAgeTpv

  local oBlock
  local oError
  local lOpen := .t.

    /*
   Ficheros necesarios
   */

   oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   DATABASE NEW ::oTpvCliT  PATH ( cPatEmp() ) FILE "TIKET.DBF" VIA ( cDriver() ) SHARED INDEX "TIKET.CDX"

   DATABASE NEW ::oTpvCliL  PATH ( cPatEmp() ) FILE "TIKEL.DBF" VIA ( cDriver() ) SHARED INDEX "TIKEL.CDX"

   DATABASE NEW ::oDbfCli   PATH ( cPatCli() ) FILE "CLIENT.DBF" VIA ( cDriver() ) SHARED INDEX "CLIENT.CDX"

   DATABASE NEW ::oIva      PATH ( cPatDat() ) FILE "TIVA.DBF"   VIA ( cDriver() ) SHARED INDEX "TIVA.CDX"

   RECOVER USING oError

      lOpen := .f.

      msgStop( "Imposible abrir todas las bases de datos" )
      ::CloseFiles()

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TDAgeTpv

   if !Empty( ::oTpvCliT ) .and. ::oTpvCliT:Used()
      ::oTpvCliT:End()
   end if

   if !Empty( ::oTpvCliL ) .and. ::oTpvCliL:Used()
      ::oTpvCliL:End()
   end if

   if !Empty( ::oDbfCli ) .and. ::oDbfCli:Used()
      ::oDbfCli:End()
   end if

   if !Empty( ::oIva ) .and. ::oIva:Used()
      ::oIva:End()
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Resource( cFld ) CLASS TDAgeTpv

   local oTipVen
   local oTipVen2
   local This        := Self

   if !::StdResource( "INF_GEN25" )
      return .f.
   end if

   /*
   Monta los agentes de manera automatica
   */

   ::oDefAgeInf( 70, 80, 90, 100 )

   /*
   Damos valor al meter
   */

   ::oMtrInf:SetTotal( ::oTpvCliT:Lastrec() )

   ::oDefResInf()

   REDEFINE SAY ::oSay ;
      ID       217 ;
      OF       ::oFld:aDialogs[1]

   REDEFINE COMBOBOX ::oEstado ;
      VAR      ::cEstado ;
      ID       218 ;
      ITEMS    ::aEstado ;
      OF       ::oFld:aDialogs[1]

RETURN ( Self )

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate() CLASS TDAgeTpv

   local aTotal
   local bValid   := {|| .t. }
   local lExcCero := .f.

   ::oDlg:Disable()

   ::oDbf:Zap()
   ::oTpvCliT:GoTop()

   do case
      case ::oEstado:nAt == 1
         bValid   := {|| !::oTpvCliT:lLiquidada }
      case ::oEstado:nAt == 2
         bValid   := {|| ::oTpvCliT:lLiquidada }
      case ::oEstado:nAt == 3
         bValid   := {|| .t. }
   end case

   ::aHeader      := {  {|| "Fecha   : " + Dtoc( Date() ) },;
                        {|| "Periodo : " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                        {|| "Agentes : " + ::cAgeOrg         + " > " + ::cAgeDes } }

	/*
   Nos movemos por las cabeceras de los albaranes
   */

   WHILE ! ::oTpvCliT:Eof()

      IF Eval( bValid )                                                                     .AND.;
         ::oTpvCliT:dFecTik >= ::dIniInf                                                    .AND.;
         ::oTpvCliT:dFecTik <= ::dFinInf                                                    .AND.;
         ::oTpvCliT:cCodAge >= ::cAgeOrg                                                    .AND.;
         ::oTpvCliT:cCodAge <= ::cAgeDes                                                    .AND.;
         ::oTpvCliT:cTipTik == "1"                                                          .AND.;
         lChkSer( ::oTpvCliT:cSerTik, ::aSer )

         ::oDbf:Append()

         ::oDbf:cCodAge    := ::oTpvCliT:cCodAge

         if ::oDbfAge:Seek( ::oTpvCliT:cCodAge )
            ::oDbf:cNomAge := Rtrim( ::oDbfAge:cApeAge ) + ", " + ::oDbfAge:cNbrAge
         end if

         ::oDbf:cNomAge    := ::oTpvCliT:cCodAge
         ::oDbf:CCODCLI    := ::oTpvCliT:cCliTik
         ::oDbf:CNOMCLI    := ::oTpvCliT:cNomTik

         ::AddCliente( ::oTpvCliT:cCliTik, ::oTpvCliT, .t. )

         aTotal            := aTotTik( ::oTpvCliT:cSerTik + ::oTpvCliT:cNumTik + ::oTpvCliT:cSufTik, ::oTpvCliT:cAlias, ::oTpvCliL:cAlias, ::oDbfDiv:cAlias )

         ::oDbf:DFECDOC    := ::oTpvCliT:dFecTik
         ::oDbf:CNUMDOC    := ::oTpvCliT:cSerTik + ::oTpvCliT:cNumTik + ::oTpvCliT:cSufTik
         ::oDbf:NTOTNET    := aTotal[ 1 ]
         ::oDbf:NTOTIVA    := aTotal[ 2 ]
         ::oDbf:NTOTDOC    := aTotal[ 3 ]

         ::oDbf:Save()

      end if

      ::oTpvCliT:Skip()

      ::oMtrInf:AutoInc( ::oTpvCliT:OrdKeyNo() )

   end while

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//

METHOD Activate() CLASS TDAgeTpv

   local oThis := Self

   ACTIVATE DIALOG ::oDlg CENTER ON INIT ( oThis:oEstado:Hide(), oThis:oSay:Hide(), oThis:oBtnData:Hide() )

RETURN ( ::oDlg:nResult == IDOK )

//----------------------------------------------------------------------------//