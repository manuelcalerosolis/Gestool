#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS PInfMateriales FROM TInfGen

   DATA oProduccT    AS OBJECT

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField( "cCodOpe",  "C",  3, 0,  {|| "@!" },       "Ope",          .f., "Código de la operación"      ,  5, .f. )
   ::AddField( "cCodSec",  "C",  3, 0,  {|| "@!" },       "Sec",          .f., "Código de la sección"        ,  5, .f. )
   ::AddField( "cCodAlm",  "C",  3, 0,  {|| "@!" },       "Alm",          .f., "Código almacén"              ,  5, .f. )
   ::AddField( "dFecMov",  "D",  8, 0,  {|| "@!" },       "Fec. inicio",  .t., "Fecha de inicio"             , 12, .f. )
   ::AddField( "dFecFin",  "D",  8, 0,  {|| "@!" },       "Fec. fin",     .t., "Fecha de Fin"                , 12, .f. )
   ::AddField( "cHorIni",  "C",  5, 0,  {|| "@R 99:99"},  "Hora inicio",  .t., "Hora de inicio"              , 12, .f. )
   ::AddField( "cHorFin",  "C",  5, 0,  {|| "@R 99:99"},  "Hora fin",     .t., "Hora de fin"                 , 12, .f. )
   ::AddField( "cNumDoc",  "C", 12, 0,  {|| "@!" },       "Documento",    .t., "Número de documento"         , 20, .f. )
   ::AddField( "cCodArt",  "C", 18, 0,  {|| "@!" },       "Código artículo",    .t., "Código artículo"             , 14, .f. )
   ::AddField( "cNomArt",  "C",100, 0,  {|| "@!" },       "Artículo",     .t., "Nombre artículo"             , 35, .f. )
   ::AddField( "nCajas",   "N", 16, 6,  {|| MasUnd()},    "Cajas",        .t., "Cajas"                       , 12, .t. )
   ::AddField( "nUniCaj",  "N", 16, 6,  {|| MasUnd()},    "Uni. cajas",   .t., "Uidades por cajas"           , 12, .t. )
   ::AddField( "nUnidades","N", 16, 6,  {|| MasUnd()},    "Unidades",     .t., "Total unidades"              , 12, .t. )
   ::AddField( "nImporte", "N", 16, 6,  {|| ::cPicOut },  "Importe",      .f., "Importe"                     , 12, .t. )
   ::AddField( "nPeso",    "N", 16, 6,  {|| MasUnd() },   "Peso",         .f., "Peso"                        , 12, .t. )
   ::AddField( "nVolumen", "N", 16, 6,  {|| MasUnd() },   "Volumen",      .f., "Volumen"                     , 12, .t. )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS PInfMateriales

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

METHOD CloseFiles() CLASS PInfMateriales

   if !Empty( ::oProduccT )
      ::oProduccT:end()
   end if

   ::oProduccT := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld ) CLASS PInfMateriales

   ::lNewInforme  := .t.

   if !::StdResource( "PROINFMATERIALES" )
      return .f.
   end if

   if !::oDefOpera( 100, 101, 110, 111, 120, .t. )
      return .f.
   end if

   if !::oDefSeccion( 130, 131, 140, 141, 150, .t. )
      return .f.
   end if

   if !::oDefAlmInf( 160, 161, 170, 171, 180 )
      return .f.
   end if

   ::oMtrInf:SetTotal( ::oProduccT:oDbf:Lastrec() )

   ::CreateFilter( , ::oProduccT:oDbf )

RETURN .t.

//---------------------------------------------------------------------------//

METHOD lGenerate() CLASS PInfMateriales

   local cExpHead := ""
   local cExpLine := ""

   ::oDlg:Disable()

   ::oBtnCancel:Enable()

   ::oDbf:Zap()

   ::aHeader      := {  {|| "Fecha     : " + Dtoc( Date() ) },;
                        {|| "Periodo   : " + Dtoc( ::dIniInf ) + " > " + Dtoc( ::dFinInf ) },;
                        {|| "Operación : " + if( ::lOperaAll, "Todos", AllTrim( ::cOperaOrg ) + " > " + AllTrim( ::cOperaDes ) ) },;
                        {|| "Sección   : " + if( ::lSeccionAll, "Todas", AllTrim( ::cSeccionOrg ) + " > " + AllTrim( ::cSeccionDes ) ) },;
                        {|| "Almacén   : " + if( ::lAllAlm, "Todos", AllTrim( ::cAlmOrg ) + " > " + AllTrim( ::cAlmDes ) ) } }

   ::oProduccT:oDbf:OrdSetFocus( "dFecOrd" )
   ::oProduccT:oDetProduccion:oDbf:OrdSetFocus( "cNumOrd" )

   cExpHead       := 'dFecOrd >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFin <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   if !::lOperaAll
      cExpHead    += ' .and. cCodOpe >= "' + Rtrim( ::cOperaOrg ) + '" .and. cCodOpe <= "' + Rtrim( ::cOperaDes ) + '"'
   end if

   if !::lSeccionAll
      cExpHead    += ' .and. cCodSec >= "' + Rtrim( ::cSeccionOrg ) + '" .and. cCodSec <= "' + Rtrim( ::cSeccionDes ) + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oProduccT:oDbf:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oProduccT:oDbf:cFile ), ::oProduccT:oDbf:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oProduccT:oDbf:OrdKeyCount() )

   if !::lAllAlm
      cExpLine    += ' .and. cAlmOrd >= "' + Rtrim( ::cAlmOrg ) + '" .and. cAlmOrd <= "' + Rtrim( ::cAlmDes ) + '"'
   end if

   ::oProduccT:oDetProduccion:oDbf:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oProduccT:oDetProduccion:oDbf:cFile ), ::oProduccT:oDetProduccion:oDbf:OrdKey(), cAllTrimer( cExpLine ), , , , , , , , .t. )

   ::oProduccT:oDbf:GoTop()

   while !::lBreak .and. !::oProduccT:oDbf:Eof()

      if lChkSer( ::oProduccT:oDbf:cSerOrd, ::aSer )

         if ::oProduccT:oDetProduccion:oDbf:Seek( ::oProduccT:oDbf:cSerOrd + Str( ::oProduccT:oDbf:nNumOrd ) + ::oProduccT:oDbf:cSufOrd )

            while ::oProduccT:oDetProduccion:oDbf:cSerOrd + Str( ::oProduccT:oDetProduccion:oDbf:nNumOrd ) + ::oProduccT:oDetProduccion:oDbf:cSufOrd == ::oProduccT:oDbf:cSerOrd + Str( ::oProduccT:oDbf:nNumOrd ) + ::oProduccT:oDbf:cSufOrd .and. !::oProduccT:oDetProduccion:oDbf:eof()

               ::oDbf:Append()

               ::oDbf:cCodOpe    := ::oProduccT:oDbf:cCodOpe
               ::oDbf:cCodSec    := ::oProduccT:oDbf:cCodSec
               ::oDbf:cCodAlm    := ::oProduccT:oDetProduccion:oDbf:cAlmOrd
               ::oDbf:dFecMov    := ::oProduccT:oDbf:dFecOrd
               ::oDbf:dFecFin    := ::oProduccT:oDbf:dFecFin
               ::oDbf:cHorIni    := ::oProduccT:oDbf:cHorIni
               ::oDbf:cHorFin    := ::oProduccT:oDbf:cHorFin
               ::oDbf:cNumDoc    := ::oProduccT:oDbf:cSerOrd + "/" + AllTrim( Str( ::oProduccT:oDbf:nNumOrd ) ) + "/" + ::oProduccT:oDbf:cSufOrd
               ::oDbf:cCodArt    := ::oProduccT:oDetProduccion:oDbf:cCodArt
               ::oDbf:cNomArt    := ::oProduccT:oDetProduccion:oDbf:cNomArt
               ::oDbf:nCajas     := ::oProduccT:oDetProduccion:oDbf:nCajOrd
               ::oDbf:nUniCaj    := ::oProduccT:oDetProduccion:oDbf:nUndOrd
               ::oDbf:nUnidades  := NotCaja( ::oProduccT:oDetProduccion:oDbf:nCajOrd ) * ::oProduccT:oDetPRoduccion:oDbf:nUndOrd
               ::oDbf:nImporte   := ::oProduccT:oDetProduccion:oDbf:nImpOrd   * ::oDbf:nUnidades
               ::oDbf:nPeso      := ::oProduccT:oDetProduccion:oDbf:nPeso     * ::oDbf:nUnidades
               ::oDbf:nVolumen   := ::oProduccT:oDetProduccion:oDbf:nVolumen  * ::oDbf:nUnidades

               ::oDbf:Save()

               ::oProduccT:oDetProduccion:oDbf:Skip()

            end while

         end if

      end if

      ::oProduccT:oDbf:Skip()

      ::oMtrInf:AutoInc( ::oProduccT:oDbf:OrdKeyNo() )

   end while

   ::oProduccT:oDbf:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oProduccT:oDbf:cFile ) )
   ::oProduccT:oDetProduccion:oDbf:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oProduccT:oDetProduccion:oDbf:cFile ) )

   ::oMtrInf:AutoInc( ::oProduccT:oDbf:Lastrec() )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//