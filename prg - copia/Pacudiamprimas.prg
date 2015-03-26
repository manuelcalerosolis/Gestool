#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS PAcuDiaMPrimas FROM TNewInfGen

   DATA oProduccT    AS OBJECT

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField( "cCodArt",  "C", 18, 0,  {|| "@!" },       "Código artículo",    .t., "Código artículo"             , 14, .f. )
   ::AddField( "cNomArt",  "C",100, 0,  {|| "@!" },       "Artículo",     .t., "Nombre artículo"             , 35, .f. )
   ::AddField( "cCodTOpe", "C",  3, 0,  {|| "@!" },       "Tip. Ope.",    .f., "Código del tipo operación"   ,  5, .f. )
   ::AddField( "cNomTOpe", "C", 35, 0,  {|| "@!" },       "Nom. Ope.",    .f., "Nombre del tipo operación"   , 20, .f. )
   ::AddField( "cCodOpe",  "C",  3, 0,  {|| "@!" },       "Ope.",         .f., "Código de la operación"      ,  5, .f. )
   ::AddField( "cNomOpe",  "C", 35, 0,  {|| "@!" },       "Nom. Ope.",    .f., "Nombre de la operación"      , 20, .f. )
   ::AddField( "cCodSec",  "C",  3, 0,  {|| "@!" },       "Sec.",         .f., "Código de la sección"        ,  5, .f. )
   ::AddField( "cNomSec",  "C", 35, 0,  {|| "@!" },       "Nom. Sec.",    .f., "Nombre de la sección"        , 20, .f. )
   ::AddField( "cCodAlm",  "C",  3, 0,  {|| "@!" },       "Alm.",         .f., "Código almacén"              ,  5, .f. )
   ::AddField( "cNomAlm",  "C", 20, 0,  {|| "@!" },       "Nom. Alm.",    .f., "Nombre almacén"              , 20, .f. )
   ::AddField( "nCajas",   "N", 16, 6,  {|| MasUnd()},    "Cajas",        .f., "Cajas"                       , 12, .t. )
   ::AddField( "nUniCaj",  "N", 16, 6,  {|| MasUnd()},    "Uni. cajas",   .f., "Uidades por cajas"           , 12, .t. )
   ::AddField( "nUnidades","N", 16, 6,  {|| MasUnd()},    "Unidades",     .t., "Total unidades"              , 12, .t. )
   ::AddField( "nImporte", "N", 16, 6,  {|| ::cPicOut },  "Importe",      .t., "Importe"                     , 12, .t. )
   ::AddField( "nPeso",    "N", 16, 6,  {|| MasUnd() },   "Peso",         .f., "Peso"                        , 12, .t. )
   ::AddField( "nVolumen", "N", 16, 6,  {|| MasUnd() },   "Volumen",      .f., "Volumen"                     , 12, .t. )
   ::AddField( "dFecMov",  "D",  8, 0 , {|| "@!" },       "Fec. inicio",  .f., "Fecha de inicio"             , 12, .f. )

   ::cPrefijoIndice  := "cCodArt"

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS PAcuDiaMPrimas

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

METHOD CloseFiles() CLASS PAcuDiaMPrimas

   if !Empty( ::oProduccT )
      ::oProduccT:end()
   end if

   ::oProduccT := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld ) CLASS PAcuDiaMPrimas

   ::lNewInforme  := .t.

   if !::NewResource( "INF_GEN_PRODUCCION" )
      return .f.
   end if

   ::oDefHoraInicio()
   ::oDefHoraFin()

   if !::lGrupoArticulo()
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

METHOD lGenerate() CLASS PAcuDiaMPrimas

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
   ::oProduccT:oDetMaterial:oDbf:OrdSetFocus( "cNumOrd" )

   cExpHead       := '( dFecOrd > Ctod( "' + Dtoc( ::dIniInf ) + '" ) .or. ( dFecOrd == Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. Alltrim( cHorIni ) >= Alltrim( "' + ::cHoraInicio + '") ) ) .and. '
   cExpHead       += '( dFecFin < Ctod( "' + Dtoc( ::dFinInf ) + '" ) .or. ( dFecFin <= Ctod( "' + Dtoc( ::dFinInf ) + '" ) .and. Alltrim( cHorFin ) <= Alltrim( "' + ::cHoraFin + '") ) )'

   if !::oGrupoOperacion:Cargo:Todos
      cExpHead    += ' .and. cCodOpe >= "' + Rtrim( ::oGrupoOperacion:Cargo:Desde ) + '" .and. cCodOpe <= "' + Rtrim( ::oGrupoOperacion:Cargo:Hasta ) + '"'
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

   ::oProduccT:oDetMaterial:oDbf:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oProduccT:oDetMaterial:oDbf:cFile ), ::oProduccT:oDetMaterial:oDbf:OrdKey(), cAllTrimer( cExpLine ), , , , , , , , .t. )

   ::oProduccT:oDbf:GoTop()

   while !::lBreak .and. !::oProduccT:oDbf:Eof()

      cCodTipoOperacion := oRetFld( ::oProduccT:oDbf:cCodOpe, ::oProduccT:oOperacion:oDbf, "cTipOpe" )

      if lChkSer( ::oProduccT:oDbf:cSerOrd, ::aSer ) .and.;
         ( ::oGrupoTOperacion:Cargo:Todos .or.;
         ( cCodTipoOperacion >= ::oGrupoTOperacion:Cargo:Desde .and. cCodTipoOperacion <= ::oGrupoTOperacion:Cargo:Hasta ) )

         if ::oProduccT:oDetMaterial:oDbf:Seek( ::oProduccT:oDbf:cSerOrd + Str( ::oProduccT:oDbf:nNumOrd ) + ::oProduccT:oDbf:cSufOrd )

            while ::oProduccT:oDetMaterial:oDbf:cSerOrd + Str( ::oProduccT:oDetMaterial:oDbf:nNumOrd ) + ::oProduccT:oDetMaterial:oDbf:cSufOrd == ::oProduccT:oDbf:cSerOrd + Str( ::oProduccT:oDbf:nNumOrd ) + ::oProduccT:oDbf:cSufOrd .and. !::oProduccT:oDetMaterial:oDbf:eof()

                /*
                Asignamos valores a los grupos----------------------------------
                */

                ::SetValorGrupo( "Tipo operación",  cCodTipoOperacion )
                ::SetValorGrupo( "Operación", ::oProduccT:oDbf:cCodOpe )
                ::SetValorGrupo( "Sección", ::oProduccT:oDbf:cCodSec )
                ::SetValorGrupo( "Almacén", ::oProduccT:oDetMaterial:oDbf:cAlmOrd )
                ::SetValorGrupo( "Fecha", Dtoc( ::oProduccT:oDbf:dFecOrd ) )


                if !::lSeekInAcumulado( ::oProduccT:oDetMaterial:oDbf:cCodArt )

                  ::oDbf:Append()

                  ::oDbf:cCodArt    := ::oProduccT:oDetMaterial:oDbf:cCodArt
                  ::oDbf:cNomArt    := ::oProduccT:oDetMaterial:oDbf:cNomArt
                  ::oDbf:cCodOpe    := ::oProduccT:oDbf:cCodOpe
                  ::oDbf:cCodSec    := ::oProduccT:oDbf:cCodSec
                  ::oDbf:cCodAlm    := ::oProduccT:oDetMaterial:oDbf:cAlmOrd
                  ::oDbf:cNomOpe    := oRetFld( ::oDbf:cCodOpe, ::oOperacion:oDbf )
                  ::oDbf:cNomSec    := oRetFld( ::oDbf:cCodSec, ::oSeccion:oDbf )
                  ::oDbf:cNomAlm    := oRetFld( ::oDbf:cCodAlm, ::oDbfAlm )
                  ::oDbf:cCodTOpe   := cCodTipoOperacion
                  ::oDbf:cNomTOpe   := oRetFld( cCodTipoOperacion, ::oProduccT:oOperacion:oTipOpera:oDbf, "cDesTip" )
                  ::oDbf:nCajas     := ::oProduccT:oDetMaterial:oDbf:nCajOrd
                  ::oDbf:nUniCaj    := ::oProduccT:oDetMaterial:oDbf:nUndOrd
                  ::oDbf:nUnidades  := ::oProduccT:oDetMaterial:oDbf:nCajOrd * ::oProduccT:oDetMaterial:oDbf:nUndOrd
                  ::oDbf:nImporte   := ::oProduccT:oDetMaterial:oDbf:nImpOrd * ::oDbf:nUnidades
                  ::oDbf:nPeso      := ::oProduccT:oDetMaterial:oDbf:nPeso * ::oDbf:nUnidades
                  ::oDbf:nVolumen   := ::oProduccT:oDetMaterial:oDbf:nVolumen * ::oDbf:nUnidades
                  ::oDbf:dFecMov    := ::oProduccT:oDbf:dFecOrd

                  ::oDbf:Save()

               else

                  ::oDbf:Load()

                  ::oDbf:nCajas     += ::oProduccT:oDetMaterial:oDbf:nCajOrd
                  ::oDbf:nUniCaj    += ::oProduccT:oDetMaterial:oDbf:nUndOrd
                  ::oDbf:nUnidades  += ::oProduccT:oDetMaterial:oDbf:nCajOrd * ::oProduccT:oDetMaterial:oDbf:nUndOrd
                  ::oDbf:nImporte   += ::oProduccT:oDetMaterial:oDbf:nImpOrd * ::oProduccT:oDetMaterial:oDbf:nUndOrd * ::oProduccT:oDetMaterial:oDbf:nCajOrd
                  ::oDbf:nPeso      += ::oProduccT:oDetMaterial:oDbf:nPeso * ::oProduccT:oDetMaterial:oDbf:nUndOrd * ::oProduccT:oDetMaterial:oDbf:nCajOrd
                  ::oDbf:nVolumen   += ::oProduccT:oDetMaterial:oDbf:nVolumen * ::oProduccT:oDetMaterial:oDbf:nUndOrd * ::oProduccT:oDetMaterial:oDbf:nCajOrd

                  ::oDbf:Save()

               end if

               ::oProduccT:oDetMaterial:oDbf:Skip()

            end while

         end if

      end if

      ::oProduccT:oDbf:Skip()

      ::oMtrInf:AutoInc( ::oProduccT:oDbf:OrdKeyNo() )

   end while

   ::oProduccT:oDbf:IdxDelete( cCurUsr(), GetFileNoExt( ::oProduccT:oDbf:cFile ) )
   ::oProduccT:oDetMaterial:oDbf:IdxDelete( cCurUsr(), GetFileNoExt( ::oProduccT:oDetMaterial:oDbf:cFile ) )

   ::oMtrInf:AutoInc( ::oProduccT:oDbf:Lastrec() )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//