#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS PAnuDiaMateriales FROM TNewInfGen

   DATA oProduccT    AS OBJECT

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField( "cCodArt",  "C", 18, 0,  {|| "@!" },        "Código artículo",   .t., "Código artículo"            , 14, .f. )
   ::AddField( "cNomArt",  "C",100, 0,  {|| "@!" },        "Artículo",    .t., "Nombre artículo"            , 35, .f. )
   ::AddField( "cCodTOpe", "C",  3, 0,  {|| "@!" },        "Tip. Ope.",   .f., "Código del tipo operación"  ,  5, .f. )
   ::AddField( "cNomTOpe", "C", 35, 0,  {|| "@!" },        "Nom. Ope.",   .f., "Nombre del tipo operación"  , 20, .f. )
   ::AddField( "cCodOpe",  "C",  3, 0,  {|| "@!" },        "Ope.",        .f., "Código de la operación"     ,  5, .f. )
   ::AddField( "cNomOpe",  "C", 35, 0,  {|| "@!" },        "Nom. Ope.",   .f., "Nombre de la operación"     , 20, .f. )
   ::AddField( "cCodSec",  "C",  3, 0,  {|| "@!" },        "Sec.",        .f., "Código de la sección"       ,  5, .f. )
   ::AddField( "cNomSec",  "C", 35, 0,  {|| "@!" },        "Nom. Sec.",   .f., "Nombre de la sección"       , 20, .f. )
   ::AddField( "cCodAlm",  "C",  3, 0,  {|| "@!" },        "Alm.",        .f., "Código almacén"             ,  5, .f. )
   ::AddField( "cNomAlm",  "C", 20, 0,  {|| "@!" },        "Nom. Alm.",   .f., "Nombre almacén"             , 20, .f. )
   ::AddField( "nImpEne",  "N", 16, 6, {|| ::cPicOut },    "Ene",         .t., "Enero"                      , 12, .t. )
   ::AddField( "nImpFeb",  "N", 16, 6, {|| ::cPicOut },    "Feb",         .t., "Febrero"                    , 12, .t. )
   ::AddField( "nImpMar",  "N", 16, 6, {|| ::cPicOut },    "Mar",         .t., "Marzo"                      , 12, .t. )
   ::AddField( "nImpAbr",  "N", 16, 6, {|| ::cPicOut },    "Abr",         .t., "Abril"                      , 12, .t. )
   ::AddField( "nImpMay",  "N", 16, 6, {|| ::cPicOut },    "May",         .t., "Mayo"                       , 12, .t. )
   ::AddField( "nImpJun",  "N", 16, 6, {|| ::cPicOut },    "Jun",         .t., "Junio"                      , 12, .t. )
   ::AddField( "nImpJul",  "N", 16, 6, {|| ::cPicOut },    "Jul",         .t., "Julio"                      , 12, .t. )
   ::AddField( "nImpAgo",  "N", 16, 6, {|| ::cPicOut },    "Ago",         .t., "Agosto"                     , 12, .t. )
   ::AddField( "nImpSep",  "N", 16, 6, {|| ::cPicOut },    "Sep",         .t., "Septiembre"                 , 12, .t. )
   ::AddField( "nImpOct",  "N", 16, 6, {|| ::cPicOut },    "Oct",         .t., "Octubre"                    , 12, .t. )
   ::AddField( "nImpNov",  "N", 16, 6, {|| ::cPicOut },    "Nov",         .t., "Noviembre"                  , 12, .t. )
   ::AddField( "nImpDic",  "N", 16, 6, {|| ::cPicOut },    "Dic",         .t., "Diciembre"                  , 12, .t. )
   ::AddField( "nImpTot",  "N", 16, 6, {|| ::cPicOut },    "Tot",         .t., "Total"                      , 12, .t. )
   ::AddField( "dFecMov",  "D",  8, 0, {|| "@!" },         "Fec. inicio", .f., "Fecha de inicio"            , 12, .f. )

   /*
   Indice por defecto----------------------------------------------------------
   */

   ::cPrefijoIndice  := "cCodArt"

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS PAnuDiaMateriales

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

METHOD CloseFiles() CLASS PAnuDiaMateriales

   if !Empty( ::oProduccT )
      ::oProduccT:end()
   end if

   ::oProduccT := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld ) CLASS PAnuDiaMateriales

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

METHOD lGenerate() CLASS PAnuDiaMateriales

   local cExpHead          := ""
   local cExpLine          := ""
   local nTemEmpl          := 0
   local cCodTipoOperacion := Space( 3 )
   local nPct              := 0
   local nImporte          := 0

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
   ::oProduccT:oDetProduccion:oDbf:OrdSetFocus( "cNumOrd" )

   cExpHead       := '( dFecOrd > Ctod( "' + Dtoc( ::dIniInf ) + '" ) .or. ( dFecOrd == Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. Alltrim( cHorIni ) >= Alltrim( "' + ::cHoraInicio + '") ) ) .and. '
   cExpHead       += '( dFecFin < Ctod( "' + Dtoc( ::dFinInf ) + '" ) .or. ( dFecFin <= Ctod( "' + Dtoc( ::dFinInf ) + '" ) .and. Alltrim( cHorFin ) <= Alltrim( "' + ::cHoraFin + '") ) )'

   if !::oGrupoOperacion:Cargo:Todos
      cExpHead    += ' .and. cCodOpe >= "' + Rtrim( ::oGrupoOperacion:Cargo:Desde ) + '" .and. cCodOpe <= "' + Rtrim( ::oGrupoOperacion:Hasta ) + '"'
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

               /*
               Asignamos valores a los grupos----------------------------------
               */

               ::SetValorGrupo( "Tipo operación",  cCodTipoOperacion )
               ::SetValorGrupo( "Operación",       ::oProduccT:oDbf:cCodOpe )
               ::SetValorGrupo( "Sección",         ::oProduccT:oDbf:cCodSec )
               ::SetValorGrupo( "Almacén",         ::oProduccT:oDetProduccion:oDbf:cAlmOrd )
               ::SetValorGrupo( "Fecha", Dtoc( ::oProduccT:oDbf:dFecOrd ) )

               nTemEmpl                := nTiempoEntreFechas( ::oProduccT:oDbf:dFecOrd, ::oProduccT:oDbf:dFecFin, ::oProduccT:oDbf:cHorIni, ::oProduccT:oDbf:cHorFin )

               if !::lSeekInAcumulado( ::oProduccT:oDetProduccion:oDbf:cCodArt )

                  ::oDbf:Blank()

                  ::oDbf:cCodArt       := ::oProduccT:oDetProduccion:oDbf:cCodArt
                  ::oDbf:cNomArt       := ::oProduccT:oDetProduccion:oDbf:cNomArt
                  ::oDbf:cCodOpe       := ::oProduccT:oDbf:cCodOpe
                  ::oDbf:cNomOpe       := oRetFld( ::oDbf:cCodOpe, ::oOperacion:oDbf )
                  ::oDbf:cCodTOpe      := cCodTipoOperacion
                  ::oDbf:cNomTOpe      := oRetFld( cCodTipoOperacion, ::oProduccT:oOperacion:oTipOpera:oDbf, "cDesTip" )
                  ::oDbf:cCodSec       := ::oProduccT:oDbf:cCodSec
                  ::oDbf:cNomSec       := oRetFld( ::oDbf:cCodSec, ::oSeccion:oDbf )
                  ::oDbf:cCodAlm       := ::oProduccT:oDetProduccion:oDbf:cAlmOrd
                  ::oDbf:cNomAlm       := oRetFld( ::oDbf:cCodAlm, ::oDbfAlm )
                  ::oDbf:dFecMov       := ::oProduccT:oDbf:dFecOrd
                  ::oDbf:dFecMov       := ::oProduccT:oDbf:dFecOrd


                  ::oDbf:Insert()

               end if

               nImporte             := ( NotCaja( ::oProduccT:oDetProduccion:oDbf:nCajOrd ) * ::oProduccT:oDetProduccion:oDbf:nUndOrd ) * ::oProduccT:oDetProduccion:oDbf:nImpOrd

               ::AddImporte( ::oProduccT:oDbf:dFecOrd, nImporte )

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