#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS PAnuDiaMPrimas FROM TNewInfGen

   DATA oProduccT    AS OBJECT

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField( "cCodArt",  "C", 18, 0,  {|| "@!" },       "C�digo art�culo",    .t., "C�digo art�culo"             , 14, .f. )
   ::AddField( "cNomArt",  "C",100, 0,  {|| "@!" },       "Art�culo",     .t., "Nombre art�culo"             , 35, .f. )
   ::AddField( "cCodTOpe", "C",  3, 0,  {|| "@!" },       "Tip. Ope.",    .f., "C�digo del tipo operaci�n"   ,  5, .f. )
   ::AddField( "cNomTOpe", "C", 35, 0,  {|| "@!" },       "Nom. Ope.",    .f., "Nombre del tipo operaci�n"   , 20, .f. )
   ::AddField( "cCodOpe",  "C",  3, 0,  {|| "@!" },       "Ope.",         .f., "C�digo de la operaci�n"      ,  5, .f. )
   ::AddField( "cNomOpe",  "C", 35, 0,  {|| "@!" },       "Nom. Ope.",    .f., "Nombre de la operaci�n"      , 20, .f. )
   ::AddField( "cCodSec",  "C",  3, 0,  {|| "@!" },       "Sec.",         .f., "C�digo de la secci�n"        ,  5, .f. )
   ::AddField( "cNomSec",  "C", 35, 0,  {|| "@!" },       "Nom. Sec.",    .f., "Nombre de la secci�n"        , 20, .f. )
   ::AddField( "cCodAlm",  "C",  3, 0,  {|| "@!" },       "Alm.",         .f., "C�digo almac�n"              ,  5, .f. )
   ::AddField( "cNomAlm",  "C", 20, 0,  {|| "@!" },       "Nom. Alm.",    .f., "Nombre almac�n"              , 20, .f. )
   ::AddField( "nImpEne",  "N", 16, 6,  {|| ::cPicOut },  "Ene",          .t., "Enero"                       , 12, .t. )
   ::AddField( "nImpFeb",  "N", 16, 6,  {|| ::cPicOut },  "Feb",          .t., "Febrero"                     , 12, .t. )
   ::AddField( "nImpMar",  "N", 16, 6,  {|| ::cPicOut },  "Mar",          .t., "Marzo"                       , 12, .t. )
   ::AddField( "nImpAbr",  "N", 16, 6,  {|| ::cPicOut },  "Abr",          .t., "Abril"                       , 12, .t. )
   ::AddField( "nImpMay",  "N", 16, 6,  {|| ::cPicOut },  "May",          .t., "Mayo"                        , 12, .t. )
   ::AddField( "nImpJun",  "N", 16, 6,  {|| ::cPicOut },  "Jun",          .t., "Junio"                       , 12, .t. )
   ::AddField( "nImpJul",  "N", 16, 6,  {|| ::cPicOut },  "Jul",          .t., "Julio"                       , 12, .t. )
   ::AddField( "nImpAgo",  "N", 16, 6,  {|| ::cPicOut },  "Ago",          .t., "Agosto"                      , 12, .t. )
   ::AddField( "nImpSep",  "N", 16, 6,  {|| ::cPicOut },  "Sep",          .t., "Septiembre"                  , 12, .t. )
   ::AddField( "nImpOct",  "N", 16, 6,  {|| ::cPicOut },  "Oct",          .t., "Octubre"                     , 12, .t. )
   ::AddField( "nImpNov",  "N", 16, 6,  {|| ::cPicOut },  "Nov",          .t., "Noviembre"                   , 12, .t. )
   ::AddField( "nImpDic",  "N", 16, 6,  {|| ::cPicOut },  "Dic",          .t., "Diciembre"                   , 12, .t. )
   ::AddField( "nImpTot",  "N", 16, 6,  {|| ::cPicOut },  "Tot",          .t., "Total"                       , 12, .t. )
   ::AddField( "dFecMov",  "D",  8, 0 , {|| "@!" },       "Fec. inicio",  .f., "Fecha de inicio"             , 12, .f. )

   ::cPrefijoIndice  := "cCodArt"

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS PAnuDiaMPrimas

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

METHOD CloseFiles() CLASS PAnuDiaMPrimas

   if !Empty( ::oProduccT )
      ::oProduccT:end()
   end if

   ::oProduccT := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld ) CLASS PAnuDiaMPrimas

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

METHOD lGenerate() CLASS PAnuDiaMPrimas

   local cExpHead          := ""
   local cExpLine          := ""
   local cCodTipoOperacion := Space( 3 )
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
      aAdd( ::aHeader, {|| Padr( "Art�culo", 13 ) + ": " + AllTrim( ::oGrupoArticulo:Cargo:Desde ) + " > " + AllTrim( ::oGrupoArticulo:Cargo:Hasta ) } )
   end if

   if !::oGrupoTOperacion:Cargo:Todos
      aAdd( ::aHeader, {|| Padr( "Tip. opeaci�n", 13 ) + ": " + AllTrim( ::oGrupoTOperacion:Cargo:Desde ) + " > " + AllTrim( ::oGrupoTOperacion:Cargo:Hasta ) } )
   end if

   if !::oGrupoOperacion:Cargo:Todos
      aAdd( ::aHeader, {|| Padr( "Opeaci�n", 13 ) + ": " + AllTrim( ::oGrupoOperacion:Cargo:Desde ) + " > " + AllTrim( ::oGrupoOperacion:Cargo:Hasta ) } )
   end if

   if !::oGrupoSeccion:Cargo:Todos
      aAdd( ::aHeader, {|| Padr( "Secci�n", 13 ) + ": " + AllTrim( ::oGrupoSeccion:Cargo:Desde ) + " > " + AllTrim( ::oGrupoSeccion:Cargo:Hasta ) } )
   end if

   if !::oGrupoAlmacen:Cargo:Todos
      aAdd( ::aHeader, {|| Padr( "Almac�n", 13 ) + ": " + AllTrim( ::oGrupoAlmacen:Cargo:Desde ) + " > " + AllTrim( ::oGrupoAlmacen:Cargo:Hasta ) } )
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

               ::SetValorGrupo( "Tipo operaci�n",  cCodTipoOperacion )
               ::SetValorGrupo( "Operaci�n", ::oProduccT:oDbf:cCodOpe )
               ::SetValorGrupo( "Secci�n", ::oProduccT:oDbf:cCodSec )
               ::SetValorGrupo( "Almac�n", ::oProduccT:oDetMaterial:oDbf:cAlmOrd )
               ::SetValorGrupo( "Fecha", Dtoc( ::oProduccT:oDbf:dFecOrd ) )

               if !::lSeekInAcumulado( ::oProduccT:oDetMaterial:oDbf:cCodArt )

                  ::oDbf:Blank()

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
                  ::oDbf:dFecMov    := ::oProduccT:oDbf:dFecOrd

                  ::oDbf:Insert()

               end if

               nImporte            := ::oProduccT:oDetMaterial:oDbf:nImpOrd * ::oProduccT:oDetMaterial:oDbf:nUndOrd * NotCaja( ::oProduccT:oDetMaterial:oDbf:nCajOrd )

               ::AddImporte( ::oProduccT:oDbf:dFecOrd, nImporte )

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