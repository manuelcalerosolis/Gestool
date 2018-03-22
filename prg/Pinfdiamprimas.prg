#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS PInfDiaMPrimas FROM TNewInfGen

   DATA oProduccT    AS OBJECT

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField( "cNumDoc",  "C", 12, 0,  {|| "@!" },       "Documento",                 .t., "Número de documento"         , 20, .f. )
   ::AddField( "cCodTOpe", "C",  3, 0,  {|| "@!" },       "Tip. Ope.",                 .f., "Código del tipo operación"   ,  5, .f. )
   ::AddField( "cNomTOpe", "C", 35, 0,  {|| "@!" },       "Nom. Ope.",                 .f., "Nombre del tipo operación"   , 20, .f. )
   ::AddField( "cCodOpe",  "C",  3, 0,  {|| "@!" },       "Ope.",                      .t., "Código de la operación"      ,  5, .f. )
   ::AddField( "cNomOpe",  "C", 35, 0,  {|| "@!" },       "Nom. Ope.",                 .f., "Nombre de la operación"      , 20, .f. )
   ::AddField( "cCodSec",  "C",  3, 0,  {|| "@!" },       "Sec.",                      .t., "Código de la sección"        ,  5, .f. )
   ::AddField( "cNomSec",  "C", 35, 0,  {|| "@!" },       "Nom. Sec.",                 .f., "Nombre de la sección"        , 20, .f. )
   ::AddField( "cCodAlm",  "C",  3, 0,  {|| "@!" },       "Alm.",                      .t., "Código almacén"              ,  5, .f. )
   ::AddField( "cNomAlm",  "C", 20, 0,  {|| "@!" },       "Nom. Alm.",                 .f., "Nombre almacén"              , 20, .f. )
   ::AddField( "cCodArt",  "C", 18, 0,  {|| "@!" },       "Código artículo",                 .f., "Código artículo"             , 14, .f. )
   ::AddField( "cNomArt",  "C",100, 0,  {|| "@!" },       "Artículo",                  .f., "Nombre artículo"             , 35, .f. )
   ::AddField( "dFecMov",  "D",  8, 0,  {|| "@!" },       "Fec. inicio",               .f., "Fecha de inicio"             , 12, .f. )
   ::AddField( "dFecFin",  "D",  8, 0,  {|| "@!" },       "Fec. fin",                  .f., "Fecha de fin"                , 12, .f. )
   ::AddField( "cHorIni",  "C",  5, 0,  {|| "@R 99:99"},  "Hora inicio",               .f., "Hora de inicio"              , 12, .f. )
   ::AddField( "cHorFin",  "C",  5, 0,  {|| "@R 99:99"},  "Hora fin",                  .f., "Hora de fin"                 , 12, .f. )
   ::AddField( "nCajas",   "N", 16, 6,  {|| MasUnd()},    cNombreCajas(),              .t., cNombreCajas()                , 12, .t. )
   ::AddField( "nUniCaj",  "N", 16, 6,  {|| MasUnd()},    cNombreUnidades(),           .t., cNombreUnidades()             , 12, .t. )
   ::AddField( "nUnidades","N", 16, 6,  {|| MasUnd()},    "Tot. " + cNombreUnidades(), .t., "Total " + cNombreUnidades()  , 15, .t. )
   ::AddField( "nImporte", "N", 16, 6,  {|| ::cPicOut },  "Importe",                   .t., "Importe"                     , 12, .t. )
   ::AddField( "nPeso",    "N", 16, 6,  {|| MasUnd() },   "Peso",                      .f., "Peso"                        , 12, .t. )
   ::AddField( "nVolumen", "N", 16, 6,  {|| MasUnd() },   "Volumen",                   .f., "Volumen"                     , 12, .t. )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS PInfDiaMPrimas

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

METHOD CloseFiles() CLASS PInfDiaMPrimas

   if !Empty( ::oProduccT )
      ::oProduccT:end()
   end if

   ::oProduccT := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld ) CLASS PInfDiaMPrimas

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

METHOD lGenerate() CLASS PInfDiaMPrimas

   local cExpHead          := ""
   local cExpLine          := ""
   local cCodTipoOperacion := Space( 3 )

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

   ::oProduccT:oDetMaterial:oDbf:OrdSetFocus( "cNumOrd" )

   if !::oGrupoOperacion:Cargo:Todos
      cExpHead    += ' .and. cCodOpe >= "' + Rtrim( ::oGrupoOperacion:Cargo:Desde ) + '" .and. cCodOpe <= "' + Rtrim( ::oGrupoOperacion:Cargo:Hasta ) + '"'
   end if

   if !::oGrupoSeccion:Cargo:Todos
      cExpHead    += ' .and. cCodSec >= "' + Rtrim( ::oGrupoSeccion:Cargo:Desde ) + '" .and. cCodSec <= "' + Rtrim( ::oGrupoSeccion:Cargo:Hasta ) + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead    += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oProduccT:oDbf:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oProduccT:oDbf:cFile ), ::oProduccT:oDbf:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oProduccT:oDbf:OrdKeyCount() )

   if !::oGrupoAlmacen:Cargo:Todos
      cExpLine    := 'cAlmOrd >= "' + Rtrim( ::oGrupoAlmacen:Cargo:Desde ) + '" .and. cAlmOrd <= "' + Rtrim( ::oGrupoAlmacen:Cargo:Hasta ) + '"'
   else
      cExpLine    := '.t.'
   end if

   if !::oGrupoArticulo:Cargo:Todos
      cExpLine    += ' .and. cCodArt >= "' + ::oGrupoArticulo:Cargo:Desde + '" .and. cCodArt <= "' + ::oGrupoArticulo:Cargo:Hasta + '"'
   end if

   ::oProduccT:oDetMaterial:oDbf:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oProduccT:oDetMaterial:oDbf:cFile ), ::oProduccT:oDetMaterial:oDbf:OrdKey(), cAllTrimer( cExpLine ), , , , , , , , .t. )

   ::oProduccT:oDbf:GoTop()

   while !::lBreak .and. !::oProduccT:oDbf:Eof()

      cCodTipoOperacion := oRetFld( ::oProduccT:oDbf:cCodOpe, ::oProduccT:oOperacion:oDbf, "cTipOpe" )


      if lChkSer( ::oProduccT:oDbf:cSerOrd, ::aSer ) .and.;
         ( ::oGrupoTOperacion:Cargo:Todos .or. ( cCodTipoOperacion >= ::oGrupoTOperacion:Cargo:Desde .and. cCodTipoOperacion <= ::oGrupoTOperacion:Cargo:Hasta ) )

         if ::oProduccT:oDetMaterial:oDbf:Seek( ::oProduccT:oDbf:cSerOrd + Str( ::oProduccT:oDbf:nNumOrd ) + ::oProduccT:oDbf:cSufOrd )

            while ::oProduccT:oDetMaterial:oDbf:cSerOrd + Str( ::oProduccT:oDetMaterial:oDbf:nNumOrd ) + ::oProduccT:oDetMaterial:oDbf:cSufOrd == ::oProduccT:oDbf:cSerOrd + Str( ::oProduccT:oDbf:nNumOrd ) + ::oProduccT:oDbf:cSufOrd .and. !::oProduccT:oDetMaterial:oDbf:eof()

               ::oDbf:Append()

               ::oDbf:cCodOpe    := ::oProduccT:oDbf:cCodOpe
               ::oDbf:cCodSec    := ::oProduccT:oDbf:cCodSec
               ::oDbf:cCodAlm    := ::oProduccT:oDetMaterial:oDbf:cAlmOrd
               ::oDbf:cNomOpe    := oRetFld( ::oDbf:cCodOpe, ::oOperacion:oDbf )
               ::oDbf:cNomSec    := oRetFld( ::oDbf:cCodSec, ::oSeccion:oDbf )
               ::oDbf:cNomAlm    := oRetFld( ::oDbf:cCodAlm, ::oDbfAlm )
               ::oDbf:cCodTOpe   := cCodTipoOperacion
               ::oDbf:cNomTOpe   := oRetFld( cCodTipoOperacion, ::oProduccT:oOperacion:oTipOpera:oDbf, "cDesTip" )
               ::oDbf:cNumDoc    := ::oProduccT:oDbf:cSerOrd + "/" + AllTrim( Str( ::oProduccT:oDbf:nNumOrd ) ) + "/" + ::oProduccT:oDbf:cSufOrd
               ::oDbf:cCodArt    := ::oProduccT:oDetMaterial:oDbf:cCodArt
               ::oDbf:cNomArt    := ::oProduccT:oDetMaterial:oDbf:cNomArt
               ::oDbf:dFecMov    := ::oProduccT:oDbf:dFecOrd
               ::oDbf:dFecFin    := ::oProduccT:oDbf:dFecFin
               ::oDbf:cHorIni    := ::oProduccT:oDbf:cHorIni
               ::oDbf:cHorFin    := ::oProduccT:oDbf:cHorFin
               ::oDbf:nCajas     := ::oProduccT:oDetMaterial:oDbf:nCajOrd
               ::oDbf:nUniCaj    := ::oProduccT:oDetMaterial:oDbf:nUndOrd
               ::oDbf:nUnidades  := ::oProduccT:oDetMaterial:oDbf:nCajOrd * ::oProduccT:oDetMaterial:oDbf:nUndOrd
               ::oDbf:nImporte   := ::oProduccT:oDetMaterial:oDbf:nImpOrd * ::oDbf:nUnidades
               ::oDbf:nPeso      := ::oProduccT:oDetMaterial:oDbf:nPeso * ::oDbf:nUnidades
               ::oDbf:nVolumen   := ::oProduccT:oDetMaterial:oDbf:nVolumen * ::oDbf:nUnidades

               ::oDbf:Save()

               ::oProduccT:oDetMaterial:oDbf:Skip()

            end while

         end if

      end if

      ::oProduccT:oDbf:Skip()

      ::oMtrInf:AutoInc( ::oProduccT:oDbf:OrdKeyNo() )

   end while

   ::oProduccT:oDbf:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oProduccT:oDbf:cFile ) )
   ::oProduccT:oDetMaterial:oDbf:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oProduccT:oDetMaterial:oDbf:cFile ) )

   ::oMtrInf:AutoInc( ::oProduccT:oDbf:Lastrec() )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//