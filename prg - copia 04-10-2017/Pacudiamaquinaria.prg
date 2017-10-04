#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS PAcuDiaMaquinaria FROM TNewInfGen

   DATA oProduccT    AS OBJECT

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create() CLASS PAcuDiaMaquinaria

   ::AddField( "cCodMaq",  "C",  3, 0,  {|| "@!" },       "Cod. Maq.",    .t., "Código maquina"              , 14, .f. )
   ::AddField( "cNomMaq",  "C", 35, 0,  {|| "@!" },       "Maquina",      .t., "Nombre maquina"              , 35, .f. )
   ::AddField( "cCodTOpe", "C",  3, 0,  {|| "@!" },       "Tip. Ope.",    .f., "Código del tipo operación"   ,  5, .f. )
   ::AddField( "cNomTOpe", "C", 35, 0,  {|| "@!" },       "Nom. Ope.",    .f., "Nombre del tipo operación"   , 20, .f. )
   ::AddField( "cCodOpe",  "C",  3, 0,  {|| "@!" },       "Ope.",         .f., "Código de la operación"      ,  5, .f. )
   ::AddField( "cNomOpe",  "C", 35, 0,  {|| "@!" },       "Nom. Ope.",    .f., "Nombre de la operación"      , 20, .f. )
   ::AddField( "cCodSec",  "C",  3, 0,  {|| "@!" },       "Sec.",         .f., "Código de la sección"        ,  5, .f. )
   ::AddField( "cNomSec",  "C", 35, 0,  {|| "@!" },       "Nom. Sec.",    .f., "Nombre de la sección"        , 20, .f. )
   ::AddField( "cCodAlm",  "C",  3, 0,  {|| "@!" },       "Alm.",         .f., "Código almacén"              ,  5, .f. )
   ::AddField( "cNomAlm",  "C", 20, 0,  {|| "@!" },       "Nom. Alm.",    .f., "Nombre almacén"              , 20, .f. )
   ::AddField( "nHoras",   "N", 16, 6,  {|| MasUnd()},    "Horas",        .t., "Horas"                       , 20, .f. )
   ::AddField( "nCosHra",  "N", 16, 6,  {|| ::cPicOut },  "Coste",        .t., "Coste hora"                  , 12, .t. )
   ::AddField( "nImporte", "N", 16, 6,  {|| ::cPicOut },  "Importe",      .t., "Importe"                     , 12, .t. )
   ::AddField( "dFecMov",  "D",  8, 0 , {|| "@!" },       "Fec. inicio",  .f., "Fecha de inicio"             , 12, .f. )

   /*
   Indice por defecto----------------------------------------------------------
   */

   ::cPrefijoIndice  := "cCodMaq"

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS PAcuDiaMaquinaria

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

METHOD CloseFiles() CLASS PAcuDiaMaquinaria

   if !Empty( ::oProduccT )
      ::oProduccT:end()
   end if

   ::oProduccT := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld ) CLASS PAcuDiaMaquinaria

   ::lNewInforme  := .t.

   if !::NewResource( "INF_GEN_PRODUCCION" )
      return .f.
   end if

   ::oDefHoraInicio()
   ::oDefHoraFin()

   if !::lGrupoMaquina()
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

METHOD lGenerate() CLASS PAcuDiaMaquinaria

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

   if !::oGrupoMaquina:Cargo:Todos
      aAdd( ::aHeader, {|| Padr( "Maquinaria", 13 ) + ": " + AllTrim( ::oGrupoMaquina:Cargo:Desde ) + " > " + AllTrim( ::oGrupoMaquina:Cargo:Hasta ) } )
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
   ::oProduccT:oDetMaquina:oDbf:OrdSetFocus( "cNumOrd" )

   if !::oGrupoAlmacen:Cargo:Todos
      cExpHead    := 'cAlmOrd >= "' + Rtrim( ::oGrupoAlmacen:Cargo:Desde ) + '" .and. cAlmOrd <= "' + Rtrim( ::oGrupoAlmacen:Cargo:Hasta ) + '"'
   else
      cExpHead    := '.t.'
   end if

   if !::oGrupoOperacion:Cargo:Todos
      cExpHead    += ' .and. cCodOpe >= "' + Rtrim( ::oGrupoOperacion:Cargo:Desde ) + '" .and. cCodOpe <= "' + Rtrim( ::oGrupoOperacion:Cargo:Hasta ) + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead    += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oProduccT:oDbf:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oProduccT:oDbf:cFile ), ::oProduccT:oDbf:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oProduccT:oDbf:OrdKeyCount() )

   cExpLine       := '( dFecIni > Ctod( "' + Dtoc( ::dIniInf ) + '" ) .or. ( dFecIni == Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. Alltrim( cIniMaq ) >= Alltrim( "' + ::cHoraInicio + '") ) ) .and. '
   cExpLine       += '( dFecFin < Ctod( "' + Dtoc( ::dFinInf ) + '" ) .or. ( dFecFin <= Ctod( "' + Dtoc( ::dFinInf ) + '" ) .and. Alltrim( cIniMaq ) <= Alltrim( "' + ::cHoraFin + '") ) )'

   if !::oGrupoSeccion:Cargo:Todos
      cExpLine    += ' .and. cCodSec >= "' + Rtrim( ::oGrupoSeccion:Cargo:Desde ) + '" .and. cCodSec <= "' + Rtrim( ::oGrupoSeccion:Cargo:Hasta ) + '"'
   end if

   if !::oGrupoMaquina:Cargo:Todos
      cExpLine    += ' .and. cCodMaq >= "' + ::oGrupoMaquina:Cargo:Desde + '" .and. cCodMaq <= "' + ::oGrupoMaquina:Cargo:Hasta + '"'
   end if

   ::oProduccT:oDetMaquina:oDbf:AddTmpIndex( cCurUsr(), GetFileNoExt( ::oProduccT:oDetMaquina:oDbf:cFile ), ::oProduccT:oDetMaquina:oDbf:OrdKey(), cAllTrimer( cExpLine ), , , , , , , , .t. )

   ::oProduccT:oDbf:GoTop()

   while !::lBreak .and. !::oProduccT:oDbf:Eof()

      cCodTipoOperacion := oRetFld( ::oProduccT:oDbf:cCodOpe, ::oProduccT:oOperacion:oDbf, "cTipOpe" )

      if lChkSer( ::oProduccT:oDbf:cSerOrd, ::aSer ) .and.;
         ( ::oGrupoTOperacion:Cargo:Todos .or.;
         ( cCodTipoOperacion >= ::oGrupoTOperacion:Cargo:Desde .and. cCodTipoOperacion <= ::oGrupoTOperacion:Cargo:Hasta ) )

         if ::oProduccT:oDetMaquina:oDbf:Seek( ::oProduccT:oDbf:cSerOrd + Str( ::oProduccT:oDbf:nNumOrd ) + ::oProduccT:oDbf:cSufOrd )

            while ::oProduccT:oDetMaquina:oDbf:cSerOrd + Str( ::oProduccT:oDetMaquina:oDbf:nNumOrd ) + ::oProduccT:oDetMaquina:oDbf:cSufOrd == ::oProduccT:oDbf:cSerOrd + Str( ::oProduccT:oDbf:nNumOrd ) + ::oProduccT:oDbf:cSufOrd .and. !::oProduccT:oDetMaquina:oDbf:eof()

               /*
               Asignamos valores a los grupos----------------------------------
               */

               ::SetValorGrupo( "Tipo operación",  cCodTipoOperacion )
               ::SetValorGrupo( "Operación", ::oProduccT:oDbf:cCodOpe )
               ::SetValorGrupo( "Sección", ::oProduccT:oDetMaquina:oDbf:cCodSec )
               ::SetValorGrupo( "Almacén", ::oProduccT:oDbf:cAlmOrd )
               ::SetValorGrupo( "Fecha", Dtoc( ::oProduccT:oDbf:dFecOrd ) )

               if !::lSeekInAcumulado( ::oProduccT:oDetMaquina:oDbf:cCodMaq )

                  ::oDbf:Append()

                  ::oDbf:cCodMaq    := ::oProduccT:oDetMaquina:oDbf:cCodMaq
                  ::oDbf:cNomMaq    := oRetFld( ::oDbf:cCodMaq, ::oMaquina:oDbf )
                  ::oDbf:cCodOpe    := ::oProduccT:oDbf:cCodOpe
                  ::oDbf:cNomOpe    := oRetFld( ::oDbf:cCodOpe, ::oOperacion:oDbf )
                  ::oDbf:cCodSec    := ::oProduccT:oDetMaquina:oDbf:cCodSec
                  ::oDbf:cNomSec    := oRetFld( ::oDbf:cCodSec, ::oSeccion:oDbf )
                  ::oDbf:cCodAlm    := ::oProduccT:oDbf:cAlmOrd
                  ::oDbf:cNomAlm    := oRetFld( ::oDbf:cCodAlm, ::oDbfAlm )
                  ::oDbf:cCodTOpe   := cCodTipoOperacion
                  ::oDbf:cNomTOpe   := oRetFld( cCodTipoOperacion, ::oProduccT:oOperacion:oTipOpera:oDbf, "cDesTip" )
                  ::oDbf:nHoras     := ::oProduccT:oDetMaquina:oDbf:nTotHra
                  ::oDbf:nCosHra    := ::oProduccT:oDetMaquina:oDbf:nCosHra
                  ::oDbf:nImporte   := ::oProduccT:oDetMaquina:oDbf:nTotHra * ::oProduccT:oDetMaquina:oDbf:nCosHra
                  ::oDbf:dFecMov    := ::oProduccT:oDbf:dFecOrd

                  ::oDbf:Save()

               else

                  ::oDbf:Load()

                  ::oDbf:nHoras     += ::oProduccT:oDetMaquina:oDbf:nTotHra
                  ::oDbf:nCosHra    += ::oProduccT:oDetMaquina:oDbf:nCosHra
                  ::oDbf:nImporte   += ::oProduccT:oDetMaquina:oDbf:nTotHra * ::oProduccT:oDetMaquina:oDbf:nCosHra

                  ::oDbf:Save()

               end if

               ::oProduccT:oDetMaquina:oDbf:Skip()

            end while

         end if

      end if

      ::oProduccT:oDbf:Skip()

      ::oMtrInf:AutoInc( ::oProduccT:oDbf:OrdKeyNo() )

   end while

   ::oProduccT:oDbf:IdxDelete( cCurUsr(), GetFileNoExt( ::oProduccT:oDbf:cFile ) )
   ::oProduccT:oDetMaquina:oDbf:IdxDelete( cCurUsr(), GetFileNoExt( ::oProduccT:oDetMaquina:oDbf:cFile ) )

   ::oMtrInf:AutoInc( ::oProduccT:oDbf:Lastrec() )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//