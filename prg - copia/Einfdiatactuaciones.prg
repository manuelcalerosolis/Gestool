#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS EInfDiaActuaciones FROM TInfGen

   DATA oExpediente     AS OBJECT
   DATA oActuacion      AS OBJECT
   DATA oTipoActuacion  AS OBJECT
   DATA lPendientes     AS LOGIC   INIT .t.
   DATA lAllAct         AS LOGIC   INIT .t.
   DATA oIniAct         AS OBJECT
   DATA oFinAct         AS OBJECT
   DATA dIniAct         INIT CtoD( "01/01/" + Str( Year( Date() ) ) )
   DATA dFinAct         INIT Date()

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField( "cTipAct",  "C",  3, 0,  {|| "" }         ,  "Tip. Act."          , .f., "Tipo actuación"             , 10, .f. )
   ::AddField( "cNomAct",  "C", 35, 0,  {|| "" }         ,  "Actuación"          , .f., "Nombre actuación"           , 10, .f. )
   ::AddField( "cNumDoc",  "C", 14, 0,  {|| "" }         ,  "Documento"          , .t., "Número documento"           , 14, .f. )
   ::AddField( "dFecIni",  "D",  8, 0,  {|| "" }         ,  "Inicio"             , .t., "Fecha inicio"               , 10, .f. )
   ::AddField( "cHorIni",  "C",  5, 0,  {|| "" }         ,  "Hora inicio"        , .f., "Hora inicio"                , 10, .f. )
   ::AddField( "dFecFin",  "D",  8, 0,  {|| "" }         ,  "Límite"             , .t., "Fecha límite"               , 10, .f. )
   ::AddField( "cHorFin",  "C",  5, 0,  {|| "" }         ,  "Hora fin"           , .f., "Hora fin"                   , 10, .f. )
   ::AddField( "mMemAct",  "M", 10, 0,  {|| "" }         ,  "Descripción"        , .f., "Descripción"                , 50, .f. )
   ::AddField( "cCodCli",  "C", 12, 0,  {|| "" }         ,  "Cliente"            , .t., "Cliente"                    , 14, .f. )
   ::AddField( "cNomCli",  "C", 80, 0,  {|| "" }         ,  "Nombre cliente"     , .t., "Nombre cliente"             , 50, .f. )
   ::AddField( "cPerCto",  "C", 30, 0,  {|| "" }         ,  "Contacto"           , .t., "Persona de contacto"        , 30, .f. )
   ::AddField( "cTlfCto",  "C", 20, 0,  {|| "" }         ,  "Teléfono"           , .t., "Teléfono"                   , 25, .f. )
   ::AddField( "cMvlCto",  "C", 20, 0,  {|| "" }         ,  "Movil"              , .f., "Movil"                      , 25, .f. )
   ::AddField( "cFaxCto",  "C", 20, 0,  {|| "" }         ,  "Fax"                , .f., "Fax"                        , 25, .f. )

   ::AddTmpIndex( "cNumDoc", "cTipAct + cNumDoc" )

   ::AddGroup( {|| ::oDbf:cTipAct }, {|| "Tipo actuación  : " + Rtrim( ::oDbf:cTipAct ) + "-" + Rtrim( ::oDbf:cNomAct ) }, {||"Total tipo actuación..."} )

   ::lDefDivInf      := .f.
   ::lDefFecInf      := .f.

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   local lOpen       := .t.
   local oError
   local oBlock      := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

      DATABASE NEW ::oExpediente    PATH ( cPatEmp() )  FILE "EXPCAB.DBF"      ALIAS "ExpCab" VIA ( cDriver() ) SHARED INDEX "EXPCAB.CDX"

      DATABASE NEW ::oActuacion     PATH ( cPatEmp() )  FILE "EXPDET.DBF"      ALIAS "ExpDet" VIA ( cDriver() ) SHARED INDEX "EXPDET.CDX"

      DATABASE NEW ::oTipoActuacion PATH ( cPatEmp() )  FILE "ACTUACIONES.DBF" ALIAS "Actuac" VIA ( cDriver() ) SHARED INDEX "ACTUACIONES.CDX"

   RECOVER USING oError


      msgStop( ErrorMessage( oError ), 'Imposible abrir todas las bases de datos' )
      ::CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles()

   if !Empty( ::oExpediente ) .and. ::oExpediente:Used()
      ::oExpediente:end()
   end if

   if !Empty( ::oActuacion ) .and. ::oActuacion:Used()
      ::oActuacion:end()
   end if

   if !Empty( ::oTipoActuacion ) .and. ::oTipoActuacion:Used()
      ::oTipoActuacion:End()
   end if

   ::oExpediente     := nil
   ::oActuacion      := nil
   ::oTipoActuacion  := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld )

   if !::StdResource( "INFTACTUACIONES" )
      return .f.
   end if

   if !::oDefCliInf( 110, 111, 120, 121, , 130 )
      return .f.
   end if

   if !::oDefTipActInf( 150, 151, 160, 161, 140 )
      return .f.
   end if

   REDEFINE CHECKBOX ::lAllAct ;
      ID          170 ;
      OF          ::oFld:aDialogs[1]

   REDEFINE GET   ::oIniAct ;
      VAR         ::dIniAct ;
      WHEN        !::lAllAct ;
      SPINNER ;
      ID          180 ;
      OF          ::oFld:aDialogs[1]

   REDEFINE GET   ::oFinAct ;
      VAR         ::dFinAct ;
      WHEN        !::lAllAct ;
		SPINNER ;
      ID          190 ;
      OF          ::oFld:aDialogs[1]

   REDEFINE CHECKBOX ::lPendientes ;
      ID       200 ;
      OF       ::oFld:aDialogs[1]

   ::CreateFilter( aItmActua(), ::oActuacion:cAlias )

   ::oMtrInf:SetTotal( ::oActuacion:Lastrec() )

RETURN .t.

//---------------------------------------------------------------------------//

METHOD lGenerate()

   local cExpHead    := ".t."

   ::oDlg:Disable()
   ::oBtnCancel:Enable()

   ::oDbf:Zap()

   ::aHeader         := {  {|| "Fecha     : " + Dtoc( Date() ) },;
                           {|| "Periodo   : " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                           {|| "Clientes  : " + if( ::lAllCli, "Todos", AllTrim( ::cCliOrg ) + " > " + AllTrim( ::cCliDes ) ) },;
                           {|| "Actuación : " + if( ::lAllTipAct, "Todos", AllTrim( ::cTipActOrg ) + " > " + AllTrim( ::cTipActDes ) ) } }

   if ::lPendientes
      cExpHead       += ' .and. !lActEnd'
   end if

   if !::lAllAct
      cExpHead       += ' .and. dFecFin >= Ctod( "' + Dtoc( ::dIniAct ) + '" ) .and. dFecFin <= Ctod( "' + Dtoc( ::dFinAct ) + '" )'
   end if

   if !::lAllTipAct
      cExpHead       += ' .and. cCodAct >= "' + Rtrim( ::cTipActOrg ) + '" .and. cCodAct <= "' + Rtrim( ::cTipActDes ) + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oActuacion:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oActuacion:cFile ), ::oActuacion:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oActuacion:OrdKeyCount() )

   /*
   Nos movemos por las cabeceras de los presupuestos a proveedores
   */

   ::oActuacion:GoTop()

   while !::lBreak .and. !::oActuacion:Eof()

      if lChkSer( ::oActuacion:cSerExp, ::aSer )

         if ::oExpediente:Seek( ::oActuacion:cSerExp + Str( ::oActuacion:nNumExp ) + ::oActuacion:cSufExp )  .and.;
            ( ::lAllCli .or. ( ::oExpediente:cCodCli >= Rtrim( ::cCliOrg ) .and. ::oExpediente:cCodCli <= Rtrim( ::cCliDes ) ) )

            ::oDbf:Append()

            ::oDbf:cTipAct    := ::oActuacion:cCodAct
            ::oDbf:cNomAct    := oRetFld( ::oActuacion:cCodAct, ::oTipoActuacion, "cDesAct" )
            ::oDbf:cNumDoc    := ::oActuacion:cSerExp + "/" + AllTrim( Str( ::oActuacion:nNumExp ) ) + "/" + ::oActuacion:cSufExp
            ::oDbf:cCodCli    := ::oExpediente:cCodCli
            ::oDbf:cNomCli    := oRetFld( ::oExpediente:cCodCli, ::oDbfCli, "Titulo" )
            ::oDbf:cPerCto    := oRetFld( ::oExpediente:cCodCli, ::oDbfCli, "cPerCto" )
            ::oDbf:cTlfCto    := oRetFld( ::oExpediente:cCodCli, ::oDbfCli, "Telefono" )
            ::oDbf:cMvlCto    := oRetFld( ::oExpediente:cCodCli, ::oDbfCli, "Movil" )
            ::oDbf:cFaxCto    := oRetFld( ::oExpediente:cCodCli, ::oDbfCli, "Fax" )
            ::oDbf:dFecIni    := ::oActuacion:dFecIni
            ::oDbf:cHorIni    := ::oActuacion:cHorIni
            ::oDbf:dFecFin    := ::oActuacion:dFecFin
            ::oDbf:cHorFin    := ::oActuacion:cHorFin
            ::oDbf:mMemAct    := ::oActuacion:mMemAct

            ::oDbf:Save()

         end if

      end if

      ::oActuacion:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oActuacion:IdxDelete( cCurUsr(), GetFileNoExt( ::oActuacion:cFile ) )

   ::oMtrInf:AutoInc( ::oActuacion:Lastrec() )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//