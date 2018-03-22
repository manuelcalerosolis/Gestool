#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS EInfDiaExpediente FROM TNewInfGen

   DATA oExpediente        AS OBJECT
   DATA oSubTipoExpediente AS OBJECT

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField( "cNumDoc",  "C", 14, 0,  {|| "" }         ,  "Documento"          , .t., "Número documento"           , 14, .f. )
   ::AddField( "lExpEnd",  "L", 01, 0,  {|| "" }         ,  "Finalizado"         , .t., "Expediente finalizado"      ,  4, .f. )
   ::AddField( "dFecOrd",  "D", 08, 0,  {|| "" }         ,  "Inicio"             , .f., "Fecha inicio"               , 12, .f. )
   ::AddField( "cHorOrd",  "C", 05, 0,  {|| "@R 99:99" } ,  "H.Ini."             , .t., "Hora de inicio"             ,  6, .f. )
   ::AddField( "dFecVto",  "D", 08, 0,  {|| "" }         ,  "Vencimiento"        , .f., "Fecha vencimiento"          , 12, .f. )
   ::AddField( "cHorVto",  "C", 05, 0,  {|| "@R 99:99" } ,  "H.Vto."             , .t., "Hora de vencimiento"        ,  6, .f. )
   ::AddField( "cCodCli",  "C", 12, 0,  {|| "" }         ,  "Cliente"            , .t., "Cliente"                    , 14, .f. )
   ::AddField( "cNomCli",  "C", 80, 0,  {|| "" }         ,  "Nombre cliente"     , .f., "Nombre cliente"             , 30, .f. )
   ::AddField( "cCodTip",  "C", 03, 0,  {|| "" }         ,  "Tipo"               , .f., "Código tipo expediente"     ,  8, .f. )
   ::AddField( "cNomTip",  "C", 35, 0,  {|| "" }         ,  "Nombre tipo"        , .f., "Nombre tipo expediente"     , 20, .f. )
   ::AddField( "cCodSub",  "C", 03, 0,  {|| "" }         ,  "Subtipo"            , .f., "Código subtipo expediente"  ,  8, .f. )
   ::AddField( "cNomSub",  "C", 35, 0,  {|| "" }         ,  "Nombre subtipo"     , .f., "Nombre subtipo expediente"  , 20, .f. )
   ::AddField( "cCodCol",  "C", 03, 0,  {|| "" }         ,  "Colaborador"        , .f., "Colaborador"                ,  8, .f. )
   ::AddField( "cNomCol",  "C", 35, 0,  {|| "" }         ,  "Nombre colaborador" , .f., "Nombre colaborador"         , 20, .f. )
   ::AddField( "cCodTra",  "C", 05, 0,  {|| "" }         ,  "Operario"           , .f., "Operario"                   ,  8, .f. )
   ::AddField( "cNomTra",  "C", 35, 0,  {|| "" }         ,  "Nombre operario"    , .f., "Nombre operario"            , 20, .f. )
   ::AddField( "cCodEnt",  "C", 03, 0,  {|| "" }         ,  "Entidad"            , .f., "Entidad"                    ,  8, .f. )
   ::AddField( "cNomEnt",  "C", 35, 0,  {|| "" }         ,  "Nombre entidad"     , .f., "Nombre entidad"             , 20, .f. )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   local lOpen       := .t.
   local oBlock      := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

      ::oExpediente        :=  TExpediente():Create( cPatEmp() )
      ::oExpediente:OpenFiles()

      ::oSubTipoExpediente := TDetTipoExpediente():Create( cPatEmp() )
      ::oSubTipoExpediente:OpenFiles()

   RECOVER

      msgStop( 'Imposible abrir todas las bases de datos' )
      ::CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles()

   if !Empty( ::oExpediente )
      ::oExpediente:end()
   end if

   if !Empty( ::oSubTipoExpediente )
      ::oSubTipoExpediente:end()
   end if

   ::oExpediente        := nil
   ::oSubTipoExpediente := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld )

   ::lNewInforme  := .t.

   if !::NewResource()
      return .f.
   end if

   if !::lGrupoCliente( .f. )
      return .f.
   end if

   if !::lGrupoTipoExpediente( .f. )
      return .f.
   end if

   if !::lGrupoEntidad( .f. )
      return .f.
   end if

   if !::lGrupoColaborador( .f. )
      return .f.
   end if

   if !::lGrupoOperario( .f. )
      return .f.
   end if

   ::lDefCondiciones := .f.

   ::oMtrInf:SetTotal( ::oExpediente:oDbf:Lastrec() )

   ::CreateFilter( , ::oExpediente:oDbf )

RETURN .t.

//---------------------------------------------------------------------------//

METHOD lGenerate()

   local cExpHead          := ""
   local cCodTipoOperacion := Space( 3 )

   ::oDlg:Disable()
   ::oBtnCancel:Enable()

   ::oDbf:Zap()

   /*
   Cabeceras del documento-----------------------------------------------------
   */

   ::aHeader   := {  {|| Padr( "Fecha", 13 ) + ": " + Dtoc( Date() ) },;
                     {|| Padr( "Periodo", 13 ) + ": " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) } }

   if !::oGrupoCliente:Cargo:Todos
      aAdd( ::aHeader, {|| Padr( "Cliente", 13 ) + ": " + AllTrim( ::oGrupoCliente:Cargo:Desde ) + " > " + AllTrim( ::oGrupoCliente:Cargo:Hasta ) } )
   end if

   if !::oGrupoTipoExpediente:Cargo:Todos
      aAdd( ::aHeader, {|| Padr( "Tipo", 13 ) + ": " + AllTrim( ::oGrupoTipoExpediente:Cargo:Desde ) + " > " + AllTrim( ::oGrupoTipoExpediente:Cargo:Hasta ) } )
   end if

   if !::oGrupoEntidad:Cargo:Todos
      aAdd( ::aHeader, {|| Padr( "Entidad", 13 ) + ": " + AllTrim( ::oGrupoEntidad:Cargo:Desde ) + " > " + AllTrim( ::oGrupoEntidad:Cargo:Hasta ) } )
   end if

   if !::oGrupoOperario:Cargo:Todos
      aAdd( ::aHeader, {|| Padr( "Operario", 13 ) + ": " + AllTrim( ::oGrupoOperario:Cargo:Desde ) + " > " + AllTrim( ::oGrupoOperario:Cargo:Hasta ) } )
   end if

   if !::oGrupoColaborador:Cargo:Todos
      aAdd( ::aHeader, {|| Padr( "Colaborador", 13 ) + ": " + AllTrim( ::oGrupoColaborador:Cargo:Desde ) + " > " + AllTrim( ::oGrupoColaborador:Cargo:Hasta ) } )
   end if

   /*
   Filtros de la cabecera------------------------------------------------------
   */

   ::oExpediente:oDbf:OrdSetFocus( "dFecOrd" )

   cExpHead       := 'dFecOrd >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecOrd <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   if !::oGrupoCliente:Cargo:Todos
      cExpHead    += '.and. cCodCli >= "' + Rtrim( ::oGrupoCliente:Cargo:Desde ) + '" .and. cCodCli <= "' + Rtrim( ::oGrupoCliente:Cargo:Hasta ) + '"'
   end if

   if !::oGrupoTipoExpediente:Cargo:Todos
      cExpHead    += '.and. cCodTip >= "' + Rtrim( ::oGrupoTipoExpediente:Cargo:Desde ) + '" .and. cCodTip <= "' + Rtrim( ::oGrupoTipoExpediente:Cargo:Hasta ) + '"'
   end if

   if !::oGrupoEntidad:Cargo:Todos
      cExpHead    += '.and. cCodEnt >= "' + Rtrim( ::oGrupoEntidad:Cargo:Desde ) + '" .and. cCodEnt <= "' + Rtrim( ::oGrupoEntidad:Cargo:Hasta ) + '"'
   end if

   if !::oGrupoOperario:Cargo:Todos
      cExpHead    += '.and. cCodTra >= "' + Rtrim( ::oGrupoOperario:Cargo:Desde ) + '" .and. cCodTra <= "' + Rtrim( ::oGrupoOperario:Cargo:Hasta ) + '"'
   end if

   if !::oGrupoColaborador:Cargo:Todos
      cExpHead    += '.and. cCodCol >= "' + Rtrim( ::oGrupoColaborador:Cargo:Desde ) + '" .and. cCodCol <= "' + Rtrim( ::oGrupoColaborador:Cargo:Hasta ) + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead    += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oExpediente:oDbf:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oExpediente:oDbf:cFile ), ::oExpediente:oDbf:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oExpediente:oDbf:OrdKeyCount() )

   ::oExpediente:oDbf:GoTop()
   while !::lBreak .and. !::oExpediente:oDbf:Eof()

      if lChkSer( ::oExpediente:oDbf:cSerExp, ::aSer )

         ::oDbf:Append()

         ::oDbf:cNumDoc    := ::oExpediente:oDbf:cSerExp + "/" + AllTrim( Str( ::oExpediente:oDbf:nNumExp ) ) + "/" + ::oExpediente:oDbf:cSufExp
         ::oDbf:cCodCli    := ::oExpediente:oDbf:cCodCli
         ::oDbf:cNomCli    := ::oExpediente:oDbf:cNomCli
         ::oDbf:dFecOrd    := ::oExpediente:oDbf:dFecOrd
         ::oDbf:cHorOrd    := ::oExpediente:oDbf:cHorOrd
         ::oDbf:dFecVto    := ::oExpediente:oDbf:dFecVto
         ::oDbf:cHorVto    := ::oExpediente:oDbf:cHorVto
         ::oDbf:cCodTip    := ::oExpediente:oDbf:cCodTip
         ::oDbf:cNomTip    := oRetFld( ::oExpediente:oDbf:cCodTip, ::oTipoExpediente:oDbf, "cNomTip", "cCodTip" )
         ::oDbf:cCodSub    := ::oExpediente:oDbf:cCodSub
         ::oDbf:cNomSub    := oRetFld( ::oExpediente:oDbf:cCodTip + ::oExpediente:oDbf:cCodSub, ::oSubTipoExpediente:oDbf, "cNomSub", "cCodSub" )
         ::oDbf:cCodCol    := ::oExpediente:oDbf:cCodCol
         ::oDbf:cNomCol    := oRetFld( ::oExpediente:oDbf:cCodCol, ::oColaborador:oDbf, "cDesCol", "cCodCol" )
         ::oDbf:cCodTra    := ::oExpediente:oDbf:cCodTra
         ::oDbf:cNomTra    := oRetFld( ::oExpediente:oDbf:cCodTra, ::oOperario:oDbf, "cNomTra", "cCodTra" )
         ::oDbf:cCodEnt    := ::oExpediente:oDbf:cCodEnt
         ::oDbf:cNomEnt    := oRetFld( ::oExpediente:oDbf:cCodEnt, ::oEntidad:oDbf, "cDesEnt", "cCodEnt" )

         ::oDbf:Save()

      end if

      ::oExpediente:oDbf:Skip()

      ::oMtrInf:AutoInc( ::oExpediente:oDbf:OrdKeyNo() )

   end while

   ::oExpediente:oDbf:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oExpediente:oDbf:cFile ) )

   ::oMtrInf:AutoInc( ::oExpediente:oDbf:Lastrec() )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//