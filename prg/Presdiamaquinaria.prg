#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS PResDiaMaquinaria FROM TInfGen

   DATA oProduccT    AS OBJECT

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create() CLASS PResDiaMaquinaria

   ::AddField( "cCodOpe",  "C",  3, 0,  {|| "@!" },       "Ope.",         .f., "Código de la operación"      ,  5, .f. )
   ::AddField( "cNomOpe",  "C", 35, 0,  {|| "@!" },       "Nom. Ope.",    .f., "Nombre de la operación"      , 20, .f. )
   ::AddField( "cCodSec",  "C",  3, 0,  {|| "@!" },       "Sec.",         .f., "Código de la sección"        ,  5, .f. )
   ::AddField( "cNomSec",  "C", 35, 0,  {|| "@!" },       "Nom. Sec.",    .f., "Nombre de la sección"        , 20, .f. )
   ::AddField( "cCodAlm",  "C",  3, 0,  {|| "@!" },       "Alm.",         .f., "Código almacén"              ,  5, .f. )
   ::AddField( "cNomAlm",  "C", 20, 0,  {|| "@!" },       "Nom. Alm.",    .f., "Nombre almacén"              , 20, .f. )
   ::AddField( "cNumDoc",  "C", 12, 0,  {|| "@!" },       "Documento",    .t., "Número de documento"         , 20, .f. )
   ::AddField( "cCodMaq",  "C",  5, 0,  {|| "@!" },       "Cod. Maq.",    .t., "Código maquina"              , 14, .f. )
   ::AddField( "cNomMaq",  "C", 35, 0,  {|| "@!" },       "Maquina",      .t., "Nombre maquina"              , 35, .f. )
   ::AddField( "dFecMov",  "D",  8, 0,  {|| "@!" },       "Fec. inicio",  .f., "Fecha de inicio"             , 12, .f. )
   ::AddField( "dFecFin",  "D",  8, 0,  {|| "@!" },       "Fec. fin",     .f., "Fecha de Fin"                , 12, .f. )
   ::AddField( "cHorIni",  "C",  5, 0,  {|| "@R 99:99"},  "Hora inicio",  .f., "Hora de inicio"              , 12, .f. )
   ::AddField( "cHorFin",  "C",  5, 0,  {|| "@R 99:99"},  "Hora fin",     .f., "Hora de fin"                 , 12, .f. )
   ::AddField( "nHoras",   "N", 16, 6,  {|| MasUnd()},    "Horas",        .t., "Horas"                       , 20, .f. )
   ::AddField( "nCosHra",  "N", 16, 6,  {|| ::cPicOut },  "Coste",        .t., "Coste hora"                  , 12, .t. )
   ::AddField( "nImporte", "N", 16, 6,  {|| ::cPicOut },  "Importe",      .t., "Importe"                     , 12, .t. )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS PResDiaMaquinaria

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

METHOD CloseFiles() CLASS PResDiaMaquinaria

   if !Empty( ::oProduccT )
      ::oProduccT:end()
   end if

   ::oProduccT := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld ) CLASS PResDiaMaquinaria

   ::lNewInforme  := .t.

   if !::StdResource( "PROINFMAQUINARIA" )
      return .f.
   end if

   if !::oDefMaquina( 190, 191, 200, 201, 210, .t. )
      return .f.
   end if

   if !::oDefOpera( 100, 101, 110, 111, 120 )
      return .f.
   end if

   if !::oDefSeccion( 130, 131, 140, 141, 150 )
      return .f.
   end if

   if !::oDefAlmInf( 160, 161, 170, 171, 180 )
      return .f.
   end if

   ::oMtrInf:SetTotal( ::oProduccT:oDbf:Lastrec() )

   ::CreateFilter( , ::oProduccT:oDbf )

RETURN .t.

//---------------------------------------------------------------------------//

METHOD lGenerate() CLASS PResDiaMaquinaria

   local cExpHead := ""
   local cExpLine := ""

   ::oDlg:Disable()

   ::oBtnCancel:Enable()

   ::oDbf:Zap()

   ::oProduccT:oDbf:OrdSetFocus( "dFecOrd" )
   ::oProduccT:oDetMaquina:oDbf:OrdSetFocus( "cNumOrd" )

   if !::lAllAlm
      cExpHead    := 'cAlmOrd >= "' + Rtrim( ::cAlmOrg ) + '" .and. cAlmOrd <= "' + Rtrim( ::cAlmDes ) + '"'
   else
      cExpHead    := '.t.'
   end if

   if !::lOperaAll
      cExpHead    += ' .and. cCodOpe >= "' + Rtrim( ::cOperaOrg ) + '" .and. cCodOpe <= "' + Rtrim( ::cOperaDes ) + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead    += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oProduccT:oDbf:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oProduccT:oDbf:cFile ), ::oProduccT:oDbf:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oProduccT:oDbf:OrdKeyCount() )

   cExpLine       := 'dFecIni >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFin <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   if !::lSeccionAll
      cExpLine    += ' .and. cCodSec >= "' + Rtrim( ::cSeccionOrg ) + '" .and. cCodSec <= "' + Rtrim( ::cSeccionDes ) + '"'
   end if

   if !::lMaquinaAll
      cExpLine    += ' .and. cCodMaq >= "' + ::cMaquinaOrg + '" .and. cCodMaq <= "' + ::cMaquinaDes + '"'
   end if

   ::oProduccT:oDetMaquina:oDbf:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oProduccT:oDetMaquina:oDbf:cFile ), ::oProduccT:oDetMaquina:oDbf:OrdKey(), cAllTrimer( cExpLine ), , , , , , , , .t. )

   ::oProduccT:oDbf:GoTop()

   while !::lBreak .and. !::oProduccT:oDbf:Eof()

      if lChkSer( ::oProduccT:oDbf:cSerOrd, ::aSer )

         if ::oProduccT:oDetMaquina:oDbf:Seek( ::oProduccT:oDbf:cSerOrd + Str( ::oProduccT:oDbf:nNumOrd ) + ::oProduccT:oDbf:cSufOrd )

            while ::oProduccT:oDetMaquina:oDbf:cSerOrd + Str( ::oProduccT:oDetMaquina:oDbf:nNumOrd ) + ::oProduccT:oDetMaquina:oDbf:cSufOrd == ::oProduccT:oDbf:cSerOrd + Str( ::oProduccT:oDbf:nNumOrd ) + ::oProduccT:oDbf:cSufOrd .and. !::oProduccT:oDetMaquina:oDbf:eof()

               ::oDbf:Append()

               ::oDbf:cCodOpe    := ::oProduccT:oDbf:cCodOpe
               ::oDbf:cCodSec    := ::oProduccT:oDetMaquina:oDbf:cCodSec
               ::oDbf:cCodAlm    := ::oProduccT:oDbf:cAlmOrd
               ::oDbf:cNomOpe    := oRetFld( ::oDbf:cCodOpe, ::oOperacion:oDbf )
               ::oDbf:cNomSec    := oRetFld( ::oDbf:cCodSec, ::oSeccion:oDbf )
               ::oDbf:cNomAlm    := oRetFld( ::oDbf:cCodAlm, ::oDbfAlm )
               ::oDbf:dFecMov    := ::oProduccT:oDetMaquina:oDbf:dFecIni
               ::oDbf:dFecFin    := ::oProduccT:oDetMaquina:oDbf:dFecFin
               ::oDbf:cHorIni    := ::oProduccT:oDetMaquina:oDbf:cIniMaq
               ::oDbf:cHorFin    := ::oProduccT:oDetMaquina:oDbf:cFinMaq
               ::oDbf:cNumDoc    := ::oProduccT:oDbf:cSerOrd + "/" + AllTrim( Str( ::oProduccT:oDbf:nNumOrd ) ) + "/" + ::oProduccT:oDbf:cSufOrd
               ::oDbf:cCodMaq    := ::oProduccT:oDetMaquina:oDbf:cCodMaq
               ::oDbf:cNomMaq    := oRetFld( ::oDbf:cCodMaq, ::oMaquina:oDbf )
               ::oDbf:nHoras     := ::oProduccT:oDetMaquina:oDbf:nTotHra
               ::oDbf:nCosHra    := ::oProduccT:oDetMaquina:oDbf:nCosHra
               ::oDbf:nImporte   := ::oProduccT:oDetMaquina:oDbf:nTotHra * ::oProduccT:oDetMaquina:oDbf:nCosHra

               ::oDbf:Save()

               ::oProduccT:oDetMaquina:oDbf:Skip()

            end while

         end if

      end if

      ::oProduccT:oDbf:Skip()

      ::oMtrInf:AutoInc( ::oProduccT:oDbf:OrdKeyNo() )

   end while

   ::oProduccT:oDbf:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oProduccT:oDbf:cFile ) )
   ::oProduccT:oDetMaquina:oDbf:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oProduccT:oDetMaquina:oDbf:cFile ) )

   ::oMtrInf:AutoInc( ::oProduccT:oDbf:Lastrec() )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//