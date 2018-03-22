#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS PResDiaMPrimas FROM TInfGen

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
   ::AddField( "cCodOpe",  "C",  3, 0,  {|| "@!" },       "Ope.",                      .t., "Código de la operación"      ,  5, .f. )
   ::AddField( "cNomOpe",  "C", 35, 0,  {|| "@!" },       "Nom. Ope.",                 .f., "Nombre de la operación"      , 20, .f. )
   ::AddField( "cCodSec",  "C",  3, 0,  {|| "@!" },       "Sec.",                      .t., "Código de la sección"        ,  5, .f. )
   ::AddField( "cNomSec",  "C", 35, 0,  {|| "@!" },       "Nom. Sec.",                 .f., "Nombre de la sección"        , 20, .f. )
   ::AddField( "cCodAlm",  "C",  3, 0,  {|| "@!" },       "Alm.",                      .t., "Código almacén"              ,  5, .f. )
   ::AddField( "cNomAlm",  "C", 20, 0,  {|| "@!" },       "Nom. Alm.",                 .f., "Nombre almacén"              , 20, .f. )
   ::AddField( "cCodArt",  "C", 18, 0,  {|| "@!" },       "Código artículo",                 .f., "Código artículo"             , 14, .f. )
   ::AddField( "cNomArt",  "C",100, 0,  {|| "@!" },       "Artículo",                  .f., "Nombre artículo"             , 35, .f. )
   ::AddField( "nCajas",   "N", 16, 6,  {|| MasUnd()},    cNombreCajas(),              .t., cNombreCajas()                , 12, .t. )
   ::AddField( "nUniCaj",  "N", 16, 6,  {|| MasUnd()},    cNombreUnidades(),           .t., cNombreUnidades()             , 12, .t. )
   ::AddField( "nUnidades","N", 16, 6,  {|| MasUnd()},    "Tot. " + cNombreUnidades(), .t., "Total " + cNombreUnidades()  , 15, .t. )
   ::AddField( "nImporte", "N", 16, 6,  {|| ::cPicOut },  "Importe",                   .t., "Importe"                     , 12, .t. )
   ::AddField( "nPeso",    "N", 16, 6,  {|| MasUnd() },   "Peso",                      .f., "Peso"                        , 12, .t. )
   ::AddField( "nVolumen", "N", 16, 6,  {|| MasUnd() },   "Volumen",                   .f., "Volumen"                     , 12, .t. )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS PInfResMPrimas

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

METHOD CloseFiles() CLASS PResDiaMPrimas

   if !Empty( ::oProduccT )
      ::oProduccT:end()
   end if

   ::oProduccT := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld ) CLASS PResDiaMPrimas

   ::lNewInforme  := .t.

   if !::StdResource( "PROINFMATERIALES" )
      return .f.
   end if

   if !::lDefArtInf( 190, 191, 200, 201, 210, .t. )
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

METHOD lGenerate() CLASS PResDiaMPrimas

   local cExpHead := ""
   local cExpLine := ""

   ::oDlg:Disable()

   ::oBtnCancel:Enable()

   ::oDbf:Zap()

   ::oProduccT:oDbf:OrdSetFocus( "dFecOrd" )
   ::oProduccT:oDetMaterial:oDbf:OrdSetFocus( "cNumOrd" )

   cExpHead       := 'dFecOrd >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFin <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   if !::lOperaAll
      cExpHead    += ' .and. cCodOpe >= "' + Rtrim( ::cOperaOrg ) + '" .and. cCodOpe <= "' + Rtrim( ::cOperaDes ) + '"'
   end if

   if !::lSeccionAll
      cExpHead    += ' .and. cCodSec >= "' + Rtrim( ::cSeccionOrg ) + '" .and. cCodSec <= "' + Rtrim( ::cSeccionDes ) + '"'
   end if

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead    += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oProduccT:oDbf:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oProduccT:oDbf:cFile ), ::oProduccT:oDbf:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oProduccT:oDbf:OrdKeyCount() )

   if !::lAllAlm
      cExpLine    := 'cAlmOrd >= "' + Rtrim( ::cAlmOrg ) + '" .and. cAlmOrd <= "' + Rtrim( ::cAlmDes ) + '"'
   else
      cExpLine    := '.t.'
   end if

   if !::lAllArt
      cExpLine    += ' .and. cCodArt >= "' + ::cArtOrg + '" .and. cCodArt <= "' + ::cArtDes + '"'
   end if

   ::oProduccT:oDetMaterial:oDbf:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oProduccT:oDetMaterial:oDbf:cFile ), ::oProduccT:oDetMaterial:oDbf:OrdKey(), cAllTrimer( cExpLine ), , , , , , , , .t. )

   ::oProduccT:oDbf:GoTop()

   while !::lBreak .and. !::oProduccT:oDbf:Eof()

      if lChkSer( ::oProduccT:oDbf:cSerOrd, ::aSer )

         if ::oProduccT:oDetMaterial:oDbf:Seek( ::oProduccT:oDbf:cSerOrd + Str( ::oProduccT:oDbf:nNumOrd ) + ::oProduccT:oDbf:cSufOrd )

            while ::oProduccT:oDetMaterial:oDbf:cSerOrd + Str( ::oProduccT:oDetMaterial:oDbf:nNumOrd ) + ::oProduccT:oDetMaterial:oDbf:cSufOrd == ::oProduccT:oDbf:cSerOrd + Str( ::oProduccT:oDbf:nNumOrd ) + ::oProduccT:oDbf:cSufOrd .and. !::oProduccT:oDetMaterial:oDbf:eof()

               ::oDbf:Append()

               ::oDbf:cCodOpe    := ::oProduccT:oDbf:cCodOpe
               ::oDbf:cCodSec    := ::oProduccT:oDbf:cCodSec
               ::oDbf:cCodAlm    := ::oProduccT:oDetMaterial:oDbf:cAlmOrd
               ::oDbf:cNomOpe    := oRetFld( ::oDbf:cCodOpe, ::oOperacion:oDbf )
               ::oDbf:cNomSec    := oRetFld( ::oDbf:cCodSec, ::oSeccion:oDbf )
               ::oDbf:cNomAlm    := oRetFld( ::oDbf:cCodAlm, ::oDbfAlm )
               ::oDbf:cNumDoc    := ::oProduccT:oDbf:cSerOrd + "/" + AllTrim( Str( ::oProduccT:oDbf:nNumOrd ) ) + "/" + ::oProduccT:oDbf:cSufOrd
               ::oDbf:cCodArt    := ::oProduccT:oDetMaterial:oDbf:cCodArt
               ::oDbf:cNomArt    := ::oProduccT:oDetMaterial:oDbf:cNomArt
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