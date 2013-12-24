#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS PInfDiaMateriales FROM TNewInfGen

   DATA oProduccT    AS OBJECT

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField( "cNumDoc",     "C", 12, 0,  {|| "@!" },        "Documento",                  .t., "Número de documento"              , 20, .f. )
   ::AddField( "cCodTOpe",    "C",  3, 0,  {|| "@!" },        "Tip. Ope.",                  .f., "Código del tipo operación"        ,  5, .f. )
   ::AddField( "cNomTOpe",    "C", 35, 0,  {|| "@!" },        "Nom. Ope.",                  .f., "Nombre del tipo operación"        , 20, .f. )
   ::AddField( "cCodOpe",     "C",  3, 0,  {|| "@!" },        "Ope.",                       .t., "Código de la operación"           ,  5, .f. )
   ::AddField( "cNomOpe",     "C", 35, 0,  {|| "@!" },        "Nom. Ope.",                  .f., "Nombre de la operación"           , 20, .f. )
   ::AddField( "cCodSec",     "C",  3, 0,  {|| "@!" },        "Sec.",                       .t., "Código de la sección"             ,  5, .f. )
   ::AddField( "cNomSec",     "C", 35, 0,  {|| "@!" },        "Nom. Sec.",                  .f., "Nombre de la sección"             , 20, .f. )
   ::AddField( "cCodAlm",     "C",  3, 0,  {|| "@!" },        "Alm.",                       .t., "Código almacén"                   ,  5, .f. )
   ::AddField( "cNomAlm",     "C", 20, 0,  {|| "@!" },        "Nom. Alm.",                  .f., "Nombre almacén"                   , 20, .f. )
   ::AddField( "dFecMov",     "D",  8, 0,  {|| "@!" },        "Fec. inicio",                .f., "Fecha de inicio"                  , 12, .f. )
   ::AddField( "dFecFin",     "D",  8, 0,  {|| "@!" },        "Fec. fin",                   .f., "Fecha de fin"                     , 12, .f. )
   ::AddField( "cHorIni",     "C",  5, 0,  {|| "@R 99:99"},   "Hora inicio",                .f., "Hora de inicio"                   , 12, .f. )
   ::AddField( "cHorFin",     "C",  5, 0,  {|| "@R 99:99"},   "Hora fin",                   .f., "Hora de fin"                      , 12, .f. )
   ::AddField( "nTEmpleado",  "N", 16, 6,  {|| "@E 9999.99"}, "Horas",                      .t., "Tiempo empleado"                  , 10, .t. )
   ::AddField( "cCodArt",     "C", 18, 0,  {|| "@!" },        "Código artículo",                  .f., "Código artículo"                  , 14, .f. )
   ::AddField( "cNomArt",     "C",100, 0,  {|| "@!" },        "Artículo",                   .f., "Nombre artículo"                  , 35, .f. )
   ::AddField( "nCajas",      "N", 16, 6,  {|| MasUnd()},     cNombreCajas(),               .f., cNombreCajas()                     , 12, .t. )
   ::AddField( "nUniCaj",     "N", 16, 6,  {|| MasUnd()},     cNombreUnidades(),            .f., cNombreUnidades()                  , 12, .f. )
   ::AddField( "nUnidades",   "N", 16, 6,  {|| MasUnd()},     "Tot. " + cNombreUnidades(),  .t., "Total " + cNombreUnidades()       , 15, .t. )
   ::AddField( "nImporte",    "N", 16, 6,  {|| ::cPicOut },   "Importe",                    .t., "Importe"                          , 12, .t. )
   ::AddField( "nPeso",       "N", 16, 6,  {|| MasUnd() },    "Peso",                       .f., "Peso"                             , 12, .t. )
   ::AddField( "nVolumen",    "N", 16, 6,  {|| MasUnd() },    "Volumen",                    .f., "Volumen"                          , 12, .t. )
   ::AddField( "nVelUnd",     "N", 16, 6,  {|| MasUnd() },    "Vel. Und.",                  .f., "Velocidad de llenado por unidades", 15, .f. )
   ::AddField( "nVelCaj",     "N", 16, 6,  {|| MasUnd() },    "Vel. Caj.",                  .f., "Velocidad de llenado por cajas"   , 15, .f. )
   ::AddField( "nVelVol",     "N", 16, 6,  {|| MasUnd() },    "Vel. Vol.",                  .f., "Velocidad de llenado por volumen" , 15, .f. )
   ::AddField( "nVelPes",     "N", 16, 6,  {|| MasUnd() },    "Vel, Peso",                  .f., "Velocidad de llenado por peso"    , 15, .f. )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS PInfDiaMateriales

   local lOpen       := .t.
   local oBlock      := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

      ::oProduccT    :=  TProduccion():Create( cPatEmp() )
      ::oProduccT:OpenFiles()

   RECOVER

      msgStop( 'Imposible abrir todas las bases de datos' )
      ::CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS PInfDiaMateriales

   if !Empty( ::oProduccT )
      ::oProduccT:end()
   end if

   ::oProduccT := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld ) CLASS PInfDiaMateriales

   ::lNewInforme  := .t.

   if !::NewResource( "INF_GEN_PRODUCCION" )
      return .f.
   end if

   ::oDefHoraInicio()
   ::oDefHoraFin()

   if !::lGrupoArticulo( .t. )
      return .f.
   end if

   if !::lGrupoTOperacion( .f. )
      return .f.
   end if

   if !::lGrupoOperacion( .f. )
      return .f.
   end if

   if !::lGrupoSeccion( .f. )
      return .f.
   end if

   if !::lGrupoAlmacen( .f. )
      return .f.
   end if

   ::lDefCondiciones := .f.

   ::oMtrInf:SetTotal( ::oProduccT:oDbf:Lastrec() )

   ::CreateFilter( , ::oProduccT:oDbf )

RETURN .t.

//---------------------------------------------------------------------------//

METHOD lGenerate() CLASS PInfDiaMateriales

   local cExpHead          := ""
   local cExpLine          := ""
   local cCodTipoOperacion := Space( 3 )
   local nPct              := 0

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   /*
   Cabeceras del documento-----------------------------------------------------
   */

   ::aHeader   := {  {|| Padr( "Fecha", 13 ) + ": " + Dtoc( Date() ) },;
                     {|| Padr( "Periodo", 13 ) + ": " + Dtoc( ::dIniInf ) + Space( 1 ) + Trans( ::cHoraInicio, "@R 99:99" ) + " > " + Dtoc( ::dFinInf ) + Space( 1 ) + Trans( ::cHoraFin, "@R 99:99" ) } }

   if !::oGrupoArticulo:Cargo:Todos
      aAdd( ::aHeader, {|| Padr( "Artículo", 13 ) + ": " + AllTrim( ::oGrupoArticulo:Cargo:Desde ) + " > " + AllTrim( ::oGrupoArticulo:Cargo:Hasta ) } )
   end if

   if !::oGrupoTOperacion:Cargo:Todos
      aAdd( ::aHeader, {|| Padr( "Tip. opeación", 13 ) + ": " + AllTrim( ::oGrupoTOperacion:Cargo:Desde ) + " > " + AllTrim( ::oGrupoTOperacion:Cargo:Hasta ) } )
   end if

   if !::oGrupoOperacion:Cargo:Todos
      aAdd( ::aHeader, {|| Padr( "Opeación", 13 ) + ": " + AllTrim( ::oGrupoOperacion:Cargo:Desde ) + " > " + AllTrim( ::oGrupoOperacion:Cargo:Hasta ) } )
   end if

   if !::oGrupoSeccion:Cargo:Todos
      aAdd( ::aHeader, {|| Padr( "Sección", 13 ) + ": " + AllTrim( ::oGrupoSeccion:Cargo:Desde ) + " > " + AllTrim( ::oGrupoSeccion:Cargo:Hasta ) } )
   end if

   if !::oGrupoAlmacen:Cargo:Todos
      aAdd( ::aHeader, {|| Padr( "Almacén", 13 ) + ": " + AllTrim( ::oGrupoAlmacen:Cargo:Desde ) + " > " + AllTrim( ::oGrupoAlmacen:Cargo:Hasta ) } )
   end if

   /*
   Filtros de la cabecera------------------------------------------------------
   */

   ::oProduccT:oDbf:OrdSetFocus( "dFecOrd" )

   cExpHead       := '( dFecOrd > Ctod( "' + Dtoc( ::dIniInf ) + '" ) .or. ( dFecOrd == Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. Alltrim( cHorIni ) >= Alltrim( "' + ::cHoraInicio + '") ) ) .and. '
   cExpHead       += '( dFecFin < Ctod( "' + Dtoc( ::dFinInf ) + '" ) .or. ( dFecFin <= Ctod( "' + Dtoc( ::dFinInf ) + '" ) .and. Alltrim( cHorFin ) <= Alltrim( "' + ::cHoraFin + '") ) )'

   ::oProduccT:oDetProduccion:oDbf:OrdSetFocus( "cNumOrd" )

   if !::oGrupoOperacion:Cargo:Todos
      cExpHead    += '.and. cCodOpe >= "' + Rtrim( ::oGrupoOperacion:Cargo:Desde ) + '" .and. cCodOpe <= "' + Rtrim( ::oGrupoOperacion:Cargo:Hasta ) + '"'
   end if

   if !::oGrupoSeccion:Cargo:Todos
      cExpHead    += ' .and. cCodSec >= "' + Rtrim( ::oGrupoSeccion:Cargo:Desde ) + '" .and. cCodSec <= "' + Rtrim( ::oGrupoSeccion:Cargo:Hasta ) + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead    += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oProduccT:oDbf:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oProduccT:oDbf:cFile ), ::oProduccT:oDbf:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oProduccT:oDbf:OrdKeyCount() )

   if !::oGrupoAlmacen:Cargo:Todos
      cExpLine    := 'cAlmOrd >= "' + Rtrim( ::oGrupoAlmacen:Cargo:Desde ) + '" .and. cAlmOrd <= "' + Rtrim( ::oGrupoAlmacen:Cargo:Hasta ) + '"'
   else
      cExpLine    := '.t.'
   end if

   if !::oGrupoArticulo:Cargo:Todos
      cExpLine    += ' .and. cCodArt >= "' + ::oGrupoArticulo:Cargo:Desde + '" .and. cCodArt <= "' + ::oGrupoArticulo:Cargo:Hasta + '"'
   end if

   ::oProduccT:oDetProduccion:oDbf:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oProduccT:oDetProduccion:oDbf:cFile ), ::oProduccT:oDetProduccion:oDbf:OrdKey(), cAllTrimer( cExpLine ), , , , , , , , .t. )

   ::oProduccT:oDbf:GoTop()

   while !::lBreak .and. !::oProduccT:oDbf:Eof()

      cCodTipoOperacion := oRetFld( ::oProduccT:oDbf:cCodOpe, ::oProduccT:oOperacion:oDbf, "cTipOpe" )

      if lChkSer( ::oProduccT:oDbf:cSerOrd, ::aSer ) .and.;
         ( ::oGrupoTOperacion:Cargo:Todos .or.;
         ( cCodTipoOperacion >= ::oGrupoTOperacion:Cargo:Desde .and. cCodTipoOperacion <= ::oGrupoTOperacion:Cargo:Hasta ) )

         if ::oProduccT:oDetProduccion:oDbf:Seek( ::oProduccT:oDbf:cSerOrd + Str( ::oProduccT:oDbf:nNumOrd ) + ::oProduccT:oDbf:cSufOrd )

            while ::oProduccT:oDetProduccion:oDbf:cSerOrd + Str( ::oProduccT:oDetProduccion:oDbf:nNumOrd ) + ::oProduccT:oDetProduccion:oDbf:cSufOrd == ::oProduccT:oDbf:cSerOrd + Str( ::oProduccT:oDbf:nNumOrd ) + ::oProduccT:oDbf:cSufOrd .and. !::oProduccT:oDetProduccion:oDbf:eof()

               ::oDbf:Append()

               ::oDbf:cCodOpe       := ::oProduccT:oDbf:cCodOpe
               ::oDbf:cCodSec       := ::oProduccT:oDbf:cCodSec
               ::oDbf:cCodAlm       := ::oProduccT:oDetProduccion:oDbf:cAlmOrd
               ::oDbf:cNomOpe       := oRetFld( ::oDbf:cCodOpe, ::oOperacion:oDbf )
               ::oDbf:cNomSec       := oRetFld( ::oDbf:cCodSec, ::oSeccion:oDbf )
               ::oDbf:cNomAlm       := oRetFld( ::oDbf:cCodAlm, ::oDbfAlm )
               ::oDbf:cCodTOpe      := cCodTipoOperacion
               ::oDbf:cNomTOpe      := oRetFld( cCodTipoOperacion, ::oProduccT:oOperacion:oTipOpera:oDbf, "cDesTip" )
               ::oDbf:dFecMov       := ::oProduccT:oDbf:dFecOrd
               ::oDbf:dFecFin       := ::oProduccT:oDbf:dFecFin
               ::oDbf:cHorIni       := ::oProduccT:oDbf:cHorIni
               ::oDbf:cHorFin       := ::oProduccT:oDbf:cHorFin
               ::oDbf:nTEmpleado    := nTiempoEntreFechas( ::oProduccT:oDbf:dFecOrd, ::oProduccT:oDbf:dFecFin, ::oProduccT:oDbf:cHorIni, ::oProduccT:oDbf:cHorFin )
               ::oDbf:cNumDoc       := ::oProduccT:oDbf:cSerOrd + "/" + AllTrim( Str( ::oProduccT:oDbf:nNumOrd ) ) + "/" + ::oProduccT:oDbf:cSufOrd
               ::oDbf:cCodArt       := ::oProduccT:oDetProduccion:oDbf:cCodArt
               ::oDbf:cNomArt       := ::oProduccT:oDetProduccion:oDbf:cNomArt
               ::oDbf:nCajas        := ::oProduccT:oDetProduccion:oDbf:nCajOrd
               ::oDbf:nUniCaj       := ::oProduccT:oDetProduccion:oDbf:nUndOrd
               ::oDbf:nUnidades     := NotCaja( ::oProduccT:oDetProduccion:oDbf:nCajOrd ) * ::oProduccT:oDetProduccion:oDbf:nUndOrd
               ::oDbf:nImporte      := ::oProduccT:oDetProduccion:oDbf:nImpOrd * ::oDbf:nUnidades
               ::oDbf:nPeso         := ::oProduccT:oDetProduccion:oDbf:nPeso * ::oDbf:nUnidades
               ::oDbf:nVolumen      := ::oProduccT:oDetProduccion:oDbf:nVolumen  * ::oDbf:nUnidades
               ::oDbf:nVelCaj       := ::oDbf:nCajas / ::oDbf:nTEmpleado
               ::oDbf:nVelUnd       := ::oDbf:nUnidades / ::oDbf:nTEmpleado
               ::oDbf:nVelVol       := ::oDbf:nVolumen / ::oDbf:nTEmpleado
               ::oDbf:nVelPes       := ::oDbf:nPeso / ::oDbf:nTEmpleado

               ::oDbf:Save()

               ::oProduccT:oDetProduccion:oDbf:Skip()

            end while

         end if

      end if

      ::oProduccT:oDbf:Skip()

      ::oMtrInf:AutoInc( ::oProduccT:oDbf:OrdKeyNo() )

   end while

   ::oProduccT:oDbf:IdxDelete( cCurUsr(), GetFileNoExt( ::oProduccT:oDbf:cFile ) )
   ::oProduccT:oDetProduccion:oDbf:IdxDelete( cCurUsr(), GetFileNoExt( ::oProduccT:oDetProduccion:oDbf:cFile ) )

   ::oMtrInf:AutoInc( ::oProduccT:oDbf:Lastrec() )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//