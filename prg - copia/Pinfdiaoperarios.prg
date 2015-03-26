#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS PInfDiaOperarios FROM TNewInfGen

   DATA oProduccT    AS OBJECT

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField( "cCodTOpe", "C",  3, 0,  {|| "@!" },       "Tip. Ope.",    .f., "Código del tipo operación"  ,  5, .f. )
   ::AddField( "cNomTOpe", "C", 35, 0,  {|| "@!" },       "Nom. Ope.",    .f., "Nombre del tipo operación"  , 20, .f. )
   ::AddField( "cCodOpe",  "C",  3, 0,  {|| "@!" },       "Ope.",         .f., "Código de la operación"     ,  5, .f. )
   ::AddField( "cNomOpe",  "C", 35, 0,  {|| "@!" },       "Nom. Ope.",    .f., "Nombre de la operación"     , 20, .f. )
   ::AddField( "cCodSec",  "C",  3, 0,  {|| "@!" },       "Sec.",         .f., "Código de la sección"       ,  5, .f. )
   ::AddField( "cNomSec",  "C", 35, 0,  {|| "@!" },       "Nom. Sec.",    .f., "Nombre de la sección"       , 20, .f. )
   ::AddField( "cCodAlm",  "C",  3, 0,  {|| "@!" },       "Alm.",         .f., "Código almacén"             ,  5, .f. )
   ::AddField( "cNomAlm",  "C", 20, 0,  {|| "@!" },       "Nom. Alm.",    .f., "Nombre almacén"             , 20, .f. )
   ::AddField( "cNumDoc",  "C", 12, 0,  {|| "@!" },       "Documento",    .t., "Número de documento"        , 20, .f. )
   ::AddField( "cCodTra",  "C",  5, 0,  {|| "@!" },       "Cod. Oper.",   .t., "Código operario"            , 14, .f. )
   ::AddField( "cNomTra",  "C", 35, 0,  {|| "@!" },       "Operario",     .t., "Nombre operario"            , 35, .f. )
   ::AddField( "dFecMov",  "D",  8, 0,  {|| "@!" },       "Fec. inicio",  .f., "Fecha de inicio"            , 12, .f. )
   ::AddField( "dFecFin",  "D",  8, 0,  {|| "@!" },       "Fec. fin",     .f., "Fecha de Fin"               , 12, .f. )
   ::AddField( "cHorIni",  "C",  5, 0,  {|| "@R 99:99"},  "Hora inicio",  .f., "Hora de inicio"             , 12, .f. )
   ::AddField( "cHorFin",  "C",  5, 0,  {|| "@R 99:99"},  "Hora fin",     .f., "Hora de fin"                , 12, .f. )
   ::AddField( "nHoras",   "N", 16, 6,  {|| MasUnd()},    "Horas",        .t., "Horas"                      , 20, .f. )
   ::AddField( "nImporte", "N", 16, 6,  {|| ::cPicOut },  "Importe",      .t., "Importe"                    , 12, .t. )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS PInfDiaOperarios

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

METHOD CloseFiles() CLASS PInfDiaOperarios

   if !Empty( ::oProduccT )
      ::oProduccT:end()
   end if

   ::oProduccT := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld ) CLASS PInfDiaOperarios

   ::lNewInforme  := .t.

   if !::NewResource( "INF_GEN_PRODUCCION" )
      return .f.
   end if

   ::oDefHoraInicio()
   ::oDefHoraFin()

   if !::lGrupoOperario( .t. )
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

METHOD lGenerate() CLASS PInfDiaOperarios

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

   if !::oGrupoOperario:Cargo:Todos
      aAdd( ::aHeader, {|| Padr( "Operario", 13 ) + ": " + AllTrim( ::oGrupoOperario:Cargo:Desde ) + " > " + AllTrim( ::oGrupoOperario:Cargo:Hasta ) } )
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

   ::oProduccT:oDetPersonal:oDbf:OrdSetFocus( "cNumOrd" )

   if !::oGrupoAlmacen:Cargo:Todos
      cExpHead    := 'cAlmOrd >= "' + Rtrim( ::oGrupoAlmacen:Cargo:Desde ) + '" .and. cAlmOrd <= "' + Rtrim( ::oGrupoAlmacen:Cargo:Hasta ) + '"'
   else
      cExpHead    := '.t.'
   end if

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead    += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oProduccT:oDbf:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oProduccT:oDbf:cFile ), ::oProduccT:oDbf:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oProduccT:oDbf:OrdKeyCount() )

   cExpLine       := '( dFecIni > Ctod( "' + Dtoc( ::dIniInf ) + '" ) .or. ( dFecIni == Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. Alltrim( cHorIni ) >= Alltrim( "' + ::cHoraInicio + '") ) ) .and. '
   cExpLine       += '( dFecFin < Ctod( "' + Dtoc( ::dFinInf ) + '" ) .or. ( dFecFin <= Ctod( "' + Dtoc( ::dFinInf ) + '" ) .and. Alltrim( cHorFin ) <= Alltrim( "' + ::cHoraFin + '") ) )'


   if !::oGrupoOperacion:Cargo:Todos
      cExpLine    += ' .and. cCodOpe >= "' + Rtrim( ::oGrupoOperacion:Cargo:Desde ) + '" .and. cCodOpe <= "' + Rtrim( ::oGrupoOperacion:Cargo:Hasta ) + '"'
   end if

   if !::oGrupoSeccion:Cargo:Todos
      cExpLine    += ' .and. cCodSec >= "' + Rtrim( ::oGrupoSeccion:Cargo:Desde ) + '" .and. cCodSec <= "' + Rtrim( ::oGrupoSeccion:Cargo:Hasta ) + '"'
   end if

   if !::oGrupoOperario:Cargo:Todos
      cExpLine    += ' .and. cCodTra >= "' + ::oGrupoOperario:Cargo:Desde + '" .and. cCodTra <= "' + ::oGrupoOperario:Cargo:Hasta + '"'
   end if

   ::oProduccT:oDetPersonal:oDbf:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oProduccT:oDetPersonal:oDbf:cFile ), ::oProduccT:oDetPersonal:oDbf:OrdKey(), cAllTrimer( cExpLine ), , , , , , , , .t. )

   ::oProduccT:oDbf:GoTop()

   while !::lBreak .and. !::oProduccT:oDbf:Eof()

      if lChkSer( ::oProduccT:oDbf:cSerOrd, ::aSer )

         if ::oProduccT:oDetPersonal:oDbf:Seek( ::oProduccT:oDbf:cSerOrd + Str( ::oProduccT:oDbf:nNumOrd ) + ::oProduccT:oDbf:cSufOrd )

            while ::oProduccT:oDetPersonal:oDbf:cSerOrd + Str( ::oProduccT:oDetPersonal:oDbf:nNumOrd ) + ::oProduccT:oDetPersonal:oDbf:cSufOrd == ::oProduccT:oDbf:cSerOrd + Str( ::oProduccT:oDbf:nNumOrd ) + ::oProduccT:oDbf:cSufOrd .and. !::oProduccT:oDetPersonal:oDbf:eof()

               cCodTipoOperacion := oRetFld( ::oProduccT:oDetPersonal:oDbf:cCodOpe, ::oProduccT:oOperacion:oDbf, "cTipOpe" )

               if ( ::oGrupoTOperacion:Cargo:Todos .or.;
                  ( cCodTipoOperacion >= ::oGrupoTOperacion:Cargo:Desde .and. cCodTipoOperacion <= ::oGrupoTOperacion:Cargo:Hasta ) )

                  ::oDbf:Append()

                  ::oDbf:cCodOpe    := ::oProduccT:oDetPersonal:oDbf:cCodOpe
                  ::oDbf:cCodSec    := ::oProduccT:oDetPersonal:oDbf:cCodSec
                  ::oDbf:cCodTOpe   := cCodTipoOperacion
                  ::oDbf:cNomTOpe   := oRetFld( cCodTipoOperacion, ::oProduccT:oOperacion:oTipOpera:oDbf, "cDesTip" )
                  ::oDbf:cCodAlm    := ::oProduccT:oDbf:cAlmOrd
                  ::oDbf:cNomOpe    := oRetFld( ::oDbf:cCodOpe, ::oOperacion:oDbf )
                  ::oDbf:cNomSec    := oRetFld( ::oDbf:cCodSec, ::oSeccion:oDbf )
                  ::oDbf:cNomAlm    := oRetFld( ::oDbf:cCodAlm, ::oDbfAlm )
                  ::oDbf:dFecMov    := ::oProduccT:oDetPersonal:oDbf:dFecIni
                  ::oDbf:dFecFin    := ::oProduccT:oDetPersonal:oDbf:dFecFin
                  ::oDbf:cHorIni    := ::oProduccT:oDetPersonal:oDbf:cHorIni
                  ::oDbf:cHorFin    := ::oProduccT:oDetPersonal:oDbf:cHorFin
                  ::oDbf:cNumDoc    := ::oProduccT:oDbf:cSerOrd + "/" + AllTrim( Str( ::oProduccT:oDbf:nNumOrd ) ) + "/" + ::oProduccT:oDbf:cSufOrd
                  ::oDbf:cCodTra    := ::oProduccT:oDetPersonal:oDbf:cCodTra
                  ::oDbf:cNomTra    := oRetFld( ::oDbf:cCodTra, ::oOperario:oDbf )
                  ::oDbf:nHoras     := nTiempoEntreFechas( ::oProduccT:oDetPersonal:oDbf:dFecIni, ::oProduccT:oDetPersonal:oDbf:dFecFin, ::oProduccT:oDetPersonal:oDbf:cHorIni, ::oProduccT:oDetPersonal:oDbf:cHorFin )
                  ::oDbf:nImporte   := ::oProduccT:nTotalOperario( ::oProduccT:oDbf:cSerOrd + Str( ::oProduccT:oDbf:nNumOrd ) + ::oProduccT:oDbf:cSufOrd + ::oProduccT:oDetPersonal:oDbf:cCodTra )

                  ::oDbf:Save()

               end if

               ::oProduccT:oDetPersonal:oDbf:Skip()

            end while

         end if

      end if

      ::oProduccT:oDbf:Skip()

      ::oMtrInf:AutoInc( ::oProduccT:oDbf:OrdKeyNo() )

   end while

   ::oProduccT:oDbf:IdxDelete( cCurUsr(), GetFileNoExt( ::oProduccT:oDbf:cFile ) )
   ::oProduccT:oDetPersonal:oDbf:IdxDelete( cCurUsr(), GetFileNoExt( ::oProduccT:oDetPersonal:oDbf:cFile ) )

   ::oMtrInf:AutoInc( ::oProduccT:oDbf:Lastrec() )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//