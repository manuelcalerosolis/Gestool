#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TdAgeAlb FROM TInfGen

   DATA  lResumen    AS LOGIC          INIT .f.
   DATA  lExcCero    AS LOGIC          INIT .f.
   DATA  oEstado     AS OBJECT
   DATA  cEstado     AS CHARACTER      INIT  "Todos"
   DATA  aEstado     AS ARRAY          INIT { "No facturados", "Facturados", "Todos" }
   DATA  oAlbCliT    AS OBJECT
   DATA  oAlbCliL    AS OBJECT
   DATA  oDbfIva     AS OBJECT
   DATA  lTvta       AS LOGIC          INIT .f.
   DATA  oOrdenado   AS OBJECT
   DATA  cOrdenado   AS CHARACTER      INIT  "Fechas"
   DATA  aOrdenado   AS ARRAY          INIT  { "Clientes", "Fechas", "Documento" }

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD Resource( cFld )

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
   ::AddField( "nTotPnt", "N", 16, 6, {|| ::cPicPnt },   "Pnt.Ver.",         .t., "Punto verde",        12 )
   ::AddField( "nTotTrn", "N", 16, 6, {|| ::cPicOut },   "Transp.",          .t., "Transporte",         12 )
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

METHOD OpenFiles() CLASS TdAgeAlb

  local oBlock
  local oError
  local lOpen := .t.

   /*
   Ficheros necesarios
   */

   oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   ::oAlbCliT := TDataCenter():oAlbCliT()

   DATABASE NEW ::oAlbCliL  PATH ( cPatEmp() ) FILE "ALBCLIL.DBF" VIA ( cDriver() ) SHARED INDEX "ALBCLIL.CDX"

   DATABASE NEW ::oDbfCli   PATH ( cPatCli() ) FILE "CLIENT.DBF"  VIA ( cDriver() ) SHARED INDEX "CLIENT.CDX"

   DATABASE NEW ::oDbfIva  PATH ( cPatDat () ) FILE "TIVA.DBF"    VIA ( cDriver() ) SHARED INDEX "TIVA.CDX"

   RECOVER USING oError

      lOpen := .f.

      msgStop( "Imposible abrir todas las bases de datos" )
      ::CloseFiles()

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TdAgeAlb

   if !Empty( ::oAlbCliT ) .and. ::oAlbCliT:Used()
      ::oAlbCliT:End()
   end if

   if !Empty( ::oAlbCliL ) .and. ::oAlbCliL:Used()
      ::oAlbCliL:End()
   end if

  if !Empty( ::oDbfCli ) .and. ::oDbfCli:Used()
      ::oDbfCli:End()
   end if

  if !Empty( ::oDbfIva ) .and. ::oDbfIva:Used()
      ::oDbfIva:End()
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Resource( cFld ) CLASS TdAgeAlb

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

   ::oMtrInf:SetTotal( ::oAlbCliT:Lastrec() )

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

RETURN ( Self )

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate() CLASS TdAgeAlb

   local bValid   := {|| .t. }
   local aTotal

   ::oDlg:Disable()

   ::oDbf:Zap()
   ::oAlbCliT:GoTop()

   ::aHeader      := {  {|| "Fecha   : " + Dtoc( Date() ) },;
                        {|| "Periodo : " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                        {|| "Agentes : " + ::cAgeOrg         + " > " + ::cAgeDes },;
                        {|| "Estado  : " + ::cEstado },;
                        {|| "Ordenado: " + ::cOrdenado } }

	/*
   Nos movemos por las cabeceras de los albaranes
   */

   while ! ::oAlbCliT:Eof()

      if ::oAlbCliT:dFecAlb >= ::dIniInf                                                    .AND.;
         ::oAlbCliT:dFecAlb <= ::dFinInf                                                    .AND.;
         ::oAlbCliT:cCodAge >= ::cAgeOrg                                                    .AND.;
         ::oAlbCliT:cCodAge <= ::cAgeDes                                                    .AND.;
         lChkSer( ::oAlbCliT:cSerAlb, ::aSer )

         aTotal            := aTotAlbCli( ::oAlbCliT:cSerAlb + Str( ::oAlbCliT:nNumAlb ) + ::oAlbCliT:cSufAlb, ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias )

         do case
            case ::oEstado:nAt == 1
               if bValid   := {|| !lFacturado( ::oAlbCliT ) }
                  ::AppendLine( aTotal )
               end if
            case ::oEstado:nAt == 2
               if bValid   := {|| lFacturado( ::oAlbCliT ) }
                  ::AppendLine( aTotal )
               end if
            case ::oEstado:nAt == 3
               ::AppendLine( aTotal )
         end case

      end if

      ::oAlbCliT:Skip()

      ::oMtrInf:AutoInc()

   end while

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

   ::oDbf:cCodAge    := ::oAlbCliT:cCodAge

   if ::oDbfAge:Seek( ::oAlbCliT:cCodAge )
      ::oDbf:cNomAge := Rtrim( ::oDbfAge:cApeAge ) + ", " + ::oDbfAge:cNbrAge
   end if

   ::oDbf:cNomAge    := ::oAlbCliT:cCodAge
   ::oDbf:cCodCli    := ::oAlbCliT:cCodCli
   ::oDbf:cNomCli    := ::oAlbCliT:cNomCli

   ::AddCliente( ::oAlbCliT:cCodCli, ::oAlbCliT, .f. )

   aTotal            := aTotAlbCli( ::oAlbCliT:cSerAlb + Str( ::oAlbCliT:nNumAlb ) + ::oAlbCliT:cSufAlb, ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::oDbfIva:cAlias, ::oDbfDiv:cAlias )

   ::oDbf:dFecDoc    := ::oAlbCliT:dFecAlb
   ::oDbf:cNumDoc    := ::oAlbCliT:cSerAlb + "/" + AllTrim( Str( ::oAlbCliT:nNumAlb ) ) + "/" + ::oAlbCliT:cSufAlb
   ::oDbf:nTotNet    := aTotal[ 1 ] - aTotal[ 5 ] - aTotal[ 6 ]
   ::oDbf:nTotIva    := aTotal[ 2 ]
   ::oDbf:nTotReq    := aTotal[ 3 ]
   ::oDbf:nTotDoc    := aTotal[ 4 ]
   ::oDbf:nTotPnt    := aTotal[ 5 ]
   ::oDbf:nTotTrn    := aTotal[ 6 ]
   ::oDbf:nComAge    := aTotal[ 7 ]

   ::oDbf:nTotCos    := aTotal[ 9 ]
   ::oDbf:nMarGen    := aTotal[ 4 ] - aTotal[ 9 ]
   ::oDbf:nRenTab    := ( ( aTotal[ 4 ] / aTotal[ 9 ] ) - 1 ) * 100

   ::oDbf:Save()

RETURN ( Self )

//---------------------------------------------------------------------------//