#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TInfCliGrp FROM TInfGen

   DATA  lOnlySelected  AS LOGIC    INIT .f.

   DATA  oEstado        AS OBJECT
   DATA  cTipCli        AS OBJECT
   DATA  oTipCli        AS OBJECT

   DATA  oGrupo         AS OBJECT

   DATA  aStrClients    AS ARRAY    INIT { "Todos", "Clientes", "Clientes potenciales" }
   DATA  aResClients    AS ARRAY    INIT { "Cli", "Cli", "CliPot" }

   Method Create()

   Method OpenFiles()

   Method CloseFiles()

   Method lResource( cFld )

   Method lGenerate()

   Method NewGroup( lNoGroup )

   Method QuiGroup( lNoGroup )

END CLASS

//---------------------------------------------------------------------------//

METHOD Create( lOnlySelected )

   DEFAULT lOnlySelected   := .f.

   ::lOnlySelected         := lOnlySelected

   ::AddField( "Cod",       "C", 12, 0, {|| "" },     "Código",                  .t., "Código",                10, .f. )
   ::AddField( "Titulo",    "C", 50, 0, {|| "" },     "Nombre",                  .t., "Nombre",                30, .f. )
   ::AddField( "Nif",       "C", 15, 0, {|| "" },     "N.I.F.",                  .f., "N.I.F.",                12, .f. )
   ::AddField( "Domicilio", "C",100, 0, {|| "" },     "Domicilio",               .t., "Domicilio",             30, .f. )
   ::AddField( "Poblacion", "C", 35, 0, {|| "" },     "Población",               .t., "Población",             30, .f. )
   ::AddField( "Provincia", "C", 20, 0, {|| "" },     "Provincia" ,              .t., "Provincia" ,            15, .f. )
   ::AddField( "CodPostal", "C",  7, 0, {|| "" },     "Cod. pos.",               .t., "Código postal",          7, .f. )
   ::AddField( "Telefono",  "C", 20, 0, {|| "" },     "Teléfono",                .t., "Teléfono",              10, .f. )
   ::AddField( "Fax",       "C", 20, 0, {|| "" },     "Fax" ,                    .f., "Fax" ,                  10, .f. )
   ::AddField( "Movil",     "C", 20, 0, {|| "" },     "Movil" ,                  .f., "Movil" ,                10, .f. )
   ::AddField( "NbrEst",    "C", 35, 0, {|| "" },     "Establecimiento" ,        .f., "Establecimiento" ,      20, .f. )
   ::AddField( "Direst",    "C", 35, 0, {|| "" },     "Dir. establecimiento",    .f., "Dir. establecimiento",  20, .f. )
   ::AddField( "Banco",     "C", 50, 0, {|| "" },     "Banco" ,                  .f., "Banco" ,                30, .f. )
   ::AddField( "DirBanco",  "C", 35, 0, {|| "" },     "Domicilio banco" ,        .f., "Domicilio banco" ,      25, .f. )
   ::AddField( "PobBanco",  "C", 25, 0, {|| "" },     "Población banco" ,        .f., "Población banco" ,      30, .f. )
   ::AddField( "cProBanco", "C", 20, 0, {|| "" },     "Provincia" ,              .f., "Provincia banco" ,      15, .f. )
   ::AddField( "Cuenta",    "C", 20, 0, {|| "" },     "Cuenta" ,                 .f., "Cuenta banco" ,         10, .f. )
   ::AddField( "CodPago",   "C",  2, 0, {|| "" },     "Pg",                      .f., "Código forma de pago",  10, .f. )
   ::AddField( "NomPago",   "C",100, 0, {|| "" },     "Forma pago",              .f., "Nombre forma de pago",  60, .f. )
   ::AddField( "cCodGrp",   "C",  4, 0, {|| "" },     "Grp.",                    .f., "Código de grupo" ,       4, .f. )
   ::AddField( "cAgente",   "C",  3, 0, {|| "" },     "Agn",                     .f., "Código agente comercial",3, .f. )
   ::AddField( "cMeiInt",   "C", 65, 0, {|| "" },     "Mail",                    .f., "dirección correo electrónico", 30, .f. )
   ::AddField( "cWebInt",   "C", 65, 0, {|| "" },     "Web",                     .f., "Página web",            30, .f. )
   ::AddField( "nRiesgo",   "N", 16, 6, {|| PicOut()},"Riesgo máximo",           .f., "Riesgo máximo",         20, .f. )
   ::AddField( "nRieReal",  "N", 16, 6, {|| PicOut()},"Riesgo real",             .f., "Riesgo real",           20, .f. )
   ::AddField( "cPerCto",   "C", 30, 0, {|| "@!" },   "Contacto",                .f., "Persona de contacto",   20, .f. )

   ::AddTmpIndex ( "cCodCod", "cCodGrp + Cod" )
   ::AddTmpIndex ( "cCodTit", "cCodGrp + Titulo" )
   ::AddTmpIndex ( "cCodPob", "cCodGrp + Poblacion" )
   ::AddTmpIndex ( "cCodPrv", "cCodGrp + Provincia" )
   ::AddTmpIndex ( "cCodCdp", "cCodGrp + CodPostal" )
   ::AddTmpIndex ( "cCodTlf", "cCodGrp + Telefono" )
   ::AddTmpIndex ( "cCodCli", "Cod" )
   ::AddTmpIndex ( "cCliTit", "Titulo" )
   ::AddTmpIndex ( "cCliPob", "Poblacion" )
   ::AddTmpIndex ( "cCliPrv", "Provincia" )
   ::AddTmpIndex ( "cCliCdp", "CodPostal" )
   ::AddTmpIndex ( "cCliTlf", "Telefono" )

   ::lDefFecInf   := .f.
   ::lDefSerInf   := .f.
   ::lDefDivInf   := .f.

RETURN ( Self )

//---------------------------------------------------------------------------//

Method OpenFiles()

   local lOpen       := .t.
   local oBlock      := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

      DATABASE NEW ::oDbfFpg PATH ( cPatEmp() ) FILE "FPago.Dbf" VIA ( cDriver() ) SHARED INDEX "FPago.Cdx"

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos" )
      if !Empty ( ::oDbfFpg )
         ::oDbfFpg:End()
      end if
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( lOpen )

//---------------------------------------------------------------------------//

Method CloseFiles()

   if ::oDbfFpg != nil .and. ::oDbfFpg:Used()
      ::oDbfFpg:End()
   end if

Return ( Self )

//---------------------------------------------------------------------------//

Method lResource( cFld )

   local cEstado  := "Código"
   local cTipCli  := "Todos"
   local cGrupo   := "No agrupar"

   if !::StdResource( "INF_CLI01" )
      return .f.
   end if

   /*
   Montamos los grupos de clientes
   */

   ::oDefGrpCli( 70, 80, 90, 100, 60 )

   /*
   Monta los articulos de manera automatica
   */

   ::oDefCliInf( 110, 120, 130, 140, , 600 )

   REDEFINE COMBOBOX ::oGrupo ;
      VAR      cGrupo ;
      ID       300 ;
      ITEMS    { "No agrupar", "Por grupo cliente", "Por nombre" } ;
      OF       ::oFld:aDialogs[1]

   REDEFINE CHECKBOX ::lSalto ;
      ID       200 ;
      OF       ::oFld:aDialogs[1]

   ::CreateFilter( aItmCli(), ::oDbfCli )

   /*
   Damos valor al meter
   */

   ::oMtrInf:SetTotal( ::oDbfCli:Lastrec() )

   /*
   Ordenado por
   */

   REDEFINE COMBOBOX ::oEstado ;
      VAR      cEstado ;
      ID       218 ;
      ITEMS    { "Código", "Nombre", "Población", "Provincia", "Código postal", "Teléfono" } ;
      OF       ::oFld:aDialogs[1]

   REDEFINE COMBOBOX ::oTipCli ;
      VAR      cTipCli ;
      ID       105 ;
      ITEMS    ::aStrClients ;
      BITMAPS  ::aResClients ;
      OF       ::oFld:aDialogs[1]

   ::bPreGenerate    := {|| ::NewGroup( ::lNoGroup ) }
   ::bPostGenerate   := {|| ::QuiGroup( ::lNoGroup ) }

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   local bValid   := {|| .t. }

   ::oDlg:Disable()
   ::oDbf:Zap()

   ::aHeader      := {  {|| "Fecha        : " + Dtoc( Date() ) },;
                        {|| "Grp. clientes: " + if( ::lAllCli, "Todos", AllTrim( ::cCliOrg ) + " > " + AllTrim( ::cCliDes ) ) },;
                        {|| "Clientes     : " + if( ::lGrpAll, "Todos", AllTrim( ::cGrpOrg ) + " > " + AllTrim( ::cGrpDes ) ) } }

   do case
      case ::oTipCli:nAt == 1
         bValid   := {|| .t. }
      case ::oTipCli:nAt == 2
         bValid   := {|| ::oDbfCli:nTipCli == 1 }
      case ::oTipCli:nAt == 3
         bValid   := {|| ::oDbfCli:nTipCli == 2 }
   end case

   if !::lNoGroup .and. !Empty( ::aoGroup )
      ::aoGroup[ 1 ]:lEject   := ::lSalto
   end if

   ::oDbfCli:GoTop()
   while !::oDbfCli:Eof()

      if Eval( bValid )                                                                               .and.;
         ( ::lGrpAll .or. ( ::oDbfCli:cCodGrp >= ::cGrpOrg .and. ::oDbfCli:cCodGrp <= ::cGrpDes ) )   .and.;
         ( ::lAllCli .or. ( ::oDbfCli:Cod >= ::cCliOrg .and. ::oDbfCli:Cod <= ::cCliDes ) )           .and.;
         ( if( ::lOnlySelected, ::oDbfCli:lLabel, .t. ) )                                             .and.;
         ::EvalFilter( ::oDbfCli )

         ::oDbf:Append()

         ::oDbf:Cod        := ::oDbfCli:Cod
         ::oDbf:Titulo     := ::oDbfCli:Titulo
         ::oDbf:Nif        := ::oDbfCli:Nif
         ::oDbf:Domicilio  := ::oDbfCli:Domicilio
         ::oDbf:Poblacion  := ::oDbfCli:Poblacion
         ::oDbf:Provincia  := ::oDbfCli:Provincia
         ::oDbf:CodPostal  := ::oDbfCli:CodPostal
         ::oDbf:Telefono   := ::oDbfCli:Telefono
         ::oDbf:Fax        := ::oDbfCli:Fax
         ::oDbf:Movil      := ::oDbfCli:Movil
         ::oDbf:NbrEst     := ::oDbfCli:NbrEst
         ::oDbf:Direst     := ::oDbfCli:Direst
         ::oDbf:Banco      := ::oDbfCli:Banco
         ::oDbf:DirBanco   := ::oDbfCli:DirBanco
         ::oDbf:PobBanco   := ::oDbfCli:PobBanco
         ::oDbf:cProBanco  := ::oDbfCli:cProBanco
         ::oDbf:Cuenta     := ::oDbfCli:Cuenta
         ::oDbf:CodPago    := ::oDbfCli:CodPago
         ::oDbf:cAgente    := ::oDbfCli:cAgente
         ::oDbf:NomPago    := oRetFld( ::oDbfCli:CodPago, ::oDbfFpg )
         ::oDbf:cCodGrp    := ::oDbfCli:cCodGrp
         ::oDbf:nRiesgo    := ::oDbfCli:Riesgo
         ::oDbf:nRieReal   := ::oDbfCli:nImpRie
         ::oDbf:cPerCto    := ::oDbfCli:cPerCto
         ::oDbf:cMeiInt    := ::oDbfCli:cMeiInt
         ::oDbf:cWebInt    := ::oDbfCli:cWebInt

         ::oDbf:Save()

      end if

      ::oDbfCli:Skip()

      ::oMtrInf:AutoInc( ::oDbfCli:OrdKeyNo() )

   end do

   ::oMtrInf:AutoInc( ::oDbfCli:LastRec() )

   ::oDlg:Enable()

   if ::oGrupo:nAt == 2
      ::oDbf:OrdSetFocus( ::oEstado:nAt )
   else
      ::oDbf:OrdSetFocus( ::oEstado:nAt + 6 )
   end if

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//

METHOD NewGroup( lNoGroup )

   do case
      case ::oGrupo:nAt == 2
         ::AddGroup( {|| ::oDbf:cCodGrp }, {|| "Grupo : " + Rtrim( ::oDbf:cCodGrp ) + "-" + oRetFld( ::oDbf:cCodGrp, ::oGrpCli:oDbf ) }, {||""} )
      case ::oGrupo:nAt == 3
         ::AddGroup( {|| Left( ::oDbf:Titulo, 1 ) }, {|| "Nombre : " + Left( ::oDbf:Titulo, 1 ) }, {||""} )
   end case

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD QuiGroup( lNoGroup )

   if ::oGrupo:nAt > 1
      ::DelGroup()
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//