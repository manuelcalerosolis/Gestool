#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS PInfDiaParte FROM TNewInfGen

   DATA oProduccT    AS OBJECT

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField( "cNumDoc",   "C", 12, 0,  {|| "@!" },        "Documento",      .t., "N�mero de documento"      , 14, .f. )
   ::AddField( "cCodTOpe",  "C",  3, 0,  {|| "@!" },        "Tip. Ope.",      .f., "C�digo del tipo operaci�n",  5, .f. )
   ::AddField( "cNomTOpe",  "C", 35, 0,  {|| "@!" },        "Nom. Ope.",      .f., "Nombre del tipo operaci�n", 20, .f. )
   ::AddField( "cCodOpe",   "C",  3, 0,  {|| "@!" },        "Ope.",           .t., "C�digo de la operaci�n"   ,  5, .f. )
   ::AddField( "cNomOpe",   "C", 35, 0,  {|| "@!" },        "Nom. Ope.",      .f., "Nombre de la operaci�n"   , 20, .f. )
   ::AddField( "cCodSec",   "C",  3, 0,  {|| "@!" },        "Sec.",           .t., "C�digo de la secci�n"     ,  5, .f. )
   ::AddField( "cNomSec",   "C", 35, 0,  {|| "@!" },        "Nom. Sec.",      .f., "Nombre de la secci�n"     , 20, .f. )
   ::AddField( "cCodAlm",   "C",  3, 0,  {|| "@!" },        "Alm.",           .t., "C�digo almac�n"           ,  5, .f. )
   ::AddField( "cNomAlm",   "C", 20, 0,  {|| "@!" },        "Nom. Alm.",      .f., "Nombre almac�n"           , 20, .f. )
   ::AddField( "dFecMov",   "D",  8, 0,  {|| "@!" },        "Fec. inicio",    .f., "Fecha de inicio"          , 12, .f. )
   ::AddField( "dFecFin",   "D",  8, 0,  {|| "@!" },        "Fec. fin",       .f., "Fecha de fin"             , 12, .f. )
   ::AddField( "cHorIni",   "C",  5, 0,  {|| "@R 99:99" },  "Hora inicio",    .f., "Hora de inicio"           , 12, .f. )
   ::AddField( "cHorFin",   "C",  5, 0,  {|| "@R 99:99" },  "Hora fin",       .f., "Hora de fin"              , 12, .f. )
   ::AddField( "nTEmpleado","N", 16, 6,  {|| "@E 9999.99" },"Horas",          .t., "Tiempo empleado"          ,  8, .t. )
   ::AddField( "nTotPro",   "N", 16, 6,  {|| ::cPicImp },   "Tot. producc.",  .t., "Tot. producido"           , 14, .t. )
   ::AddField( "nTotMat",   "N", 16, 6,  {|| ::cPicImp },   "Tot. materias",  .t., "Tot. materias primas"     , 14, .t. )
   ::AddField( "nTotPer",   "N", 16, 6,  {|| ::cPicImp },   "Tot. personal",  .t., "Tot. personal"            , 14, .t. )
   ::AddField( "nTotMaq",   "N", 16, 6,  {|| ::cPicImp },   "Tot. maquinas",  .t., "Tot. maquinaria"          , 14, .t. )
   ::AddField( "nVolumen",  "N", 16, 6,  {|| MasUnd()  },   "Tot. volumen",   .f., "Tot. volumen"             , 12, .t. )
   ::AddField( "nCosLit",   "N", 16, 6,  {|| ::cPicImp },   "Costo/litro",    .f., "Costo/litro"              , 14, .t. )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS PInfDiaParte

   local lOpen       := .t.
   local oBlock      := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

      ::oProduccT    := TProduccion():New( cPatEmp(), cDriver(), oWnd(), "04008" )
      ::oProduccT:OpenFiles()

   RECOVER

      msgStop( 'Imposible abrir todas las bases de datos' )
      
      ::CloseFiles()
      
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS PInfDiaParte

   if !Empty( ::oProduccT )
      ::oProduccT:end()
   end if

   ::oProduccT := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld ) CLASS PInfDiaParte

   ::lNewInforme  := .t.

   if !::NewResource( "INF_GEN_PRODUCCION" )
      return .f.
   end if

   ::oDefHoraInicio()
   ::oDefHoraFin()

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

METHOD lGenerate() CLASS PInfDiaParte

   local cExpHead          := ""
   local cCodTipoOperacion := Space( 3 )

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   /*
   Cabeceras del documento-----------------------------------------------------
   */

   ::aHeader   := {  {|| Padr( "Fecha", 13 ) + ": " + Dtoc( Date() ) },;
                     {|| Padr( "Periodo", 13 ) + ": " + Dtoc( ::dIniInf ) + Space( 1 ) + Trans( ::cHoraInicio, "@R 99:99" ) + " > " + Dtoc( ::dFinInf ) + Space( 1 ) + Trans( ::cHoraFin, "@R 99:99" ) } }

   if !::oGrupoTOperacion:Cargo:Todos
      aAdd( ::aHeader, {|| Padr( "Tip. operaci�n", 13 ) + ": " + AllTrim( ::oGrupoTOperacion:Cargo:Desde ) + " > " + AllTrim( ::oGrupoTOperacion:Cargo:Hasta ) } )
   end if

   if !::oGrupoOperacion:Cargo:Todos
      aAdd( ::aHeader, {|| Padr( "Operaci�n", 13 ) + ": " + AllTrim( ::oGrupoOperacion:Cargo:Desde ) + " > " + AllTrim( ::oGrupoOperacion:Cargo:Hasta ) } )
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

   cExpHead       := '( dFecOrd > Ctod( "' + Dtoc( ::dIniInf ) + '" ) .or. ( dFecOrd == Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. Alltrim( cHorIni ) >= Alltrim( "' + ::cHoraInicio + '") ) ) .and. '
   cExpHead       += '( dFecFin < Ctod( "' + Dtoc( ::dFinInf ) + '" ) .or. ( dFecFin <= Ctod( "' + Dtoc( ::dFinInf ) + '" ) .and. Alltrim( cHorFin ) <= Alltrim( "' + ::cHoraFin + '") ) )'

   if !::oGrupoOperacion:Cargo:Todos
      cExpHead    += ' .and. cCodOpe >= "' + Rtrim( ::oGrupoOperacion:Cargo:Desde ) + '" .and. cCodOpe <= "' + Rtrim( ::oGrupoOperacion:Cargo:Hasta ) + '"'
   end if

   if !::oGrupoSeccion:Cargo:Todos
      cExpHead    += ' .and. cCodSec >= "' + Rtrim( ::oGrupoSeccion:Cargo:Desde ) + '" .and. cCodSec <= "' + Rtrim( ::oGrupoSeccion:Cargo:Hasta ) + '"'
   end if

   if !::oGrupoAlmacen:Cargo:Todos
      cExpHead    += ' .and. cAlmOrd >= "' + Rtrim( ::oGrupoAlmacen:Cargo:Desde ) + '" .and. cAlmOrd <= "' + Rtrim( ::oGrupoAlmacen:Cargo:Hasta ) + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead    += ' .and. ' + ::oFilter:cExpresionFilter
   end if


   ::oProduccT:oDbf:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oProduccT:oDbf:cFile ), ::oProduccT:oDbf:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oProduccT:oDbf:OrdKeyCount() )

   ::oProduccT:oDbf:GoTop()

   while !::lBreak .and. !::oProduccT:oDbf:Eof()

      cCodTipoOperacion := oRetFld( ::oProduccT:oDbf:cCodOpe, ::oProduccT:oOperacion:oDbf, "cTipOpe" )

      if lChkSer( ::oProduccT:oDbf:cSerOrd, ::aSer ) .and.;
         ( ::oGrupoTOperacion:Cargo:Todos .or.;
         ( cCodTipoOperacion >= ::oGrupoTOperacion:Cargo:Desde .and. cCodTipoOperacion <= ::oGrupoTOperacion:Cargo:Hasta ) )

         ::oDbf:Append()

         ::oDbf:cNumDoc    := ::oProduccT:oDbf:cSerOrd + "/" + AllTrim( Str( ::oProduccT:oDbf:nNumOrd ) ) + "/" + ::oProduccT:oDbf:cSufOrd
         ::oDbf:cCodOpe    := ::oProduccT:oDbf:cCodOpe
         ::oDbf:cCodSec    := ::oProduccT:oDbf:cCodSec
         ::oDbf:cCodAlm    := ::oProduccT:oDbf:cAlmOrd
         ::oDbf:cCodTOpe   := cCodTipoOperacion
         ::oDbf:cNomTOpe   := oRetFld( cCodTipoOperacion, ::oProduccT:oOperacion:oTipOpera:oDbf, "cDesTip" )
         ::oDbf:cNomOpe    := oRetFld( ::oDbf:cCodOpe, ::oOperacion:oDbf )
         ::oDbf:cNomSec    := oRetFld( ::oDbf:cCodSec, ::oSeccion:oDbf )
         ::oDbf:cNomAlm    := oRetFld( ::oDbf:cCodAlm, ::oDbfAlm )
         ::oDbf:dFecMov    := ::oProduccT:oDbf:dFecOrd
         ::oDbf:dFecFin    := ::oProduccT:oDbf:dFecFin
         ::oDbf:cHorIni    := ::oProduccT:oDbf:cHorIni
         ::oDbf:cHorFin    := ::oProduccT:oDbf:cHorFin
         ::oDbf:nTEmpleado := nTiempoEntreFechas( ::oProduccT:oDbf:dFecOrd, ::oProduccT:oDbf:dFecFin, ::oProduccT:oDbf:cHorIni, ::oProduccT:oDbf:cHorFin )
         ::oDbf:nTotPro    := ::oProduccT:nTotalProducido( ::oProduccT:oDbf:cSerOrd + Str( ::oProduccT:oDbf:nNumOrd ) + ::oProduccT:oDbf:cSufOrd )
         ::oDbf:nTotMat    := ::oProduccT:nTotalMaterial( ::oProduccT:oDbf:cSerOrd + Str( ::oProduccT:oDbf:nNumOrd ) + ::oProduccT:oDbf:cSufOrd )
         ::oDbf:nTotPer    := ::oProduccT:nTotalPersonal( ::oProduccT:oDbf:cSerOrd + Str( ::oProduccT:oDbf:nNumOrd ) + ::oProduccT:oDbf:cSufOrd )
         ::oDbf:nTotMaq    := ::oProduccT:nTotalMaquina( ::oProduccT:oDbf:cSerOrd + Str( ::oProduccT:oDbf:nNumOrd ) + ::oProduccT:oDbf:cSufOrd )
         ::oDbf:nVolumen   := ::oProduccT:nTotalVolumen( ::oProduccT:oDbf:cSerOrd + Str( ::oProduccT:oDbf:nNumOrd ) + ::oProduccT:oDbf:cSufOrd )
         ::oDbf:nCosLit    := ( ::oDbf:nTotMat + ::oDbf:nTotPer + ::oDbf:nTotMaq ) / ::oDbf:nVolumen

         ::oDbf:Save()

      end if

      ::oProduccT:oDbf:Skip()

      ::oMtrInf:AutoInc( ::oProduccT:oDbf:OrdKeyNo() )

   end while

   ::oProduccT:oDbf:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oProduccT:oDbf:cFile ) )

   ::oMtrInf:AutoInc( ::oProduccT:oDbf:Lastrec() )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//