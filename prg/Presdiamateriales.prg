#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS PResDiaMateriales FROM TInfGen

   DATA oProduccT    AS OBJECT

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField( "cCodArt",   "C", 18, 0,  {|| "@!" },        "Código artículo",                  .t., "Código artículo"                    , 14, .f. )
   ::AddField( "cNomArt",   "C",100, 0,  {|| "@!" },        "Artículo",                   .t., "Nombre artículo"                    , 35, .f. )
   ::AddField( "cCodOpe",   "C",  3, 0,  {|| "@!" },        "Ope.",                       .f., "Código de la operación"             ,  5, .f. )
   ::AddField( "cNomOpe",   "C", 35, 0,  {|| "@!" },        "Nom. Ope.",                  .f., "Nombre de la operación"             , 20, .f. )
   ::AddField( "cCodSec",   "C",  3, 0,  {|| "@!" },        "Sec.",                       .f., "Código de la sección"               ,  5, .f. )
   ::AddField( "cNomSec",   "C", 35, 0,  {|| "@!" },        "Nom. Sec.",                  .f., "Nombre de la sección"               , 20, .f. )
   ::AddField( "cCodAlm",   "C",  3, 0,  {|| "@!" },        "Alm.",                       .f., "Código almacén"                     ,  5, .f. )
   ::AddField( "cNomAlm",   "C", 20, 0,  {|| "@!" },        "Nom. Alm.",                  .f., "Nombre almacén"                     , 20, .f. )
   ::AddField( "nCajas",    "N", 16, 6,  {|| MasUnd()},     cNombreCajas(),               .f., cNombreCajas()                       , 12, .t. )
   ::AddField( "nUniCaj",   "N", 16, 6,  {|| MasUnd()},     cNombreUnidades(),            .f., cNombreUnidades()                    , 12, .t. )
   ::AddField( "nUnidades", "N", 16, 6,  {|| MasUnd()},     "Tot. " + cNombreUnidades(),  .t., "Total " + cNombreUnidades()         , 15, .t. )
   ::AddField( "nImporte",  "N", 16, 6,  {|| ::cPicOut },   "Importe",                    .t., "Importe"                            , 12, .t. )
   ::AddField( "nPeso",     "N", 16, 6,  {|| MasUnd() },    "Peso",                       .f., "Peso"                               , 12, .t. )
   ::AddField( "nVolumen",  "N", 16, 6,  {|| MasUnd() },    "Volumen",                    .f., "Volumen"                            , 12, .t. )
   ::AddField( "nVelUnd",   "N", 16, 6,  {|| MasUnd() },    "Vel. Und.",                  .f., "Velocidad de operacion por unidades", 15, .f. )
   ::AddField( "nVelVol",   "N", 16, 6,  {|| MasUnd() },    "Vel. Vol.",                  .f., "Velocidad de operacion por volumen" , 15, .f. )
   ::AddField( "nVelPes",   "N", 16, 6,  {|| MasUnd() },    "Vel. Peso",                  .f., "Velocidad de operacion por peso"    , 15, .f. )

   /*
   Indice por defecto----------------------------------------------------------
   */

   ::cPrefijoIndice  := "cCodArt"

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS PResDiaMateriales

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

METHOD CloseFiles() CLASS PResDiaMateriales

   if !Empty( ::oProduccT )
      ::oProduccT:end()
   end if

   ::oProduccT := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld ) CLASS PResDiaMateriales

   ::lNewInforme  := .t.

   if !::StdResource( "PROINFMATERIALES" )
      return .f.
   end if

   if !::lDefArtInf( 190, 191, 200, 201, 210 )
      return .f.
   end if

   if !::oDefOpera( 100, 101, 110, 111, 120, .f. )
      return .f.
   end if

   if !::oDefSeccion( 130, 131, 140, 141, 150, .f. )
      return .f.
   end if

   if !::oDefAlmInf( 160, 161, 170, 171, 180, .f. )
      return .f.
   end if

   ::oMtrInf:SetTotal( ::oProduccT:oDbf:Lastrec() )

   ::CreateFilter( , ::oProduccT:oDbf )

RETURN .t.

//---------------------------------------------------------------------------//

METHOD lGenerate() CLASS PResDiaMateriales

   local cExpHead := ""
   local cExpLine := ""
   local nTemEmpl := 0

   ::oDlg:Disable()

   ::oBtnCancel:Enable()

   ::oDbf:Zap()

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

   ::oProduccT:oDetProduccion:oDbf:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oProduccT:oDetProduccion:oDbf:cFile ), ::oProduccT:oDetProduccion:oDbf:OrdKey(), cAllTrimer( cExpLine ), , , , , , , , .t. )

   ::oProduccT:oDbf:GoTop()

   while !::lBreak .and. !::oProduccT:oDbf:Eof()

      if lChkSer( ::oProduccT:oDbf:cSerOrd, ::aSer )

         if ::oProduccT:oDetProduccion:oDbf:Seek( ::oProduccT:oDbf:cSerOrd + Str( ::oProduccT:oDbf:nNumOrd ) + ::oProduccT:oDbf:cSufOrd )

            while ::oProduccT:oDetProduccion:oDbf:cSerOrd + Str( ::oProduccT:oDetProduccion:oDbf:nNumOrd ) + ::oProduccT:oDetProduccion:oDbf:cSufOrd == ::oProduccT:oDbf:cSerOrd + Str( ::oProduccT:oDbf:nNumOrd ) + ::oProduccT:oDbf:cSufOrd .and. !::oProduccT:oDetProduccion:oDbf:eof()

               /*
               Asignamos valores a los grupos----------------------------------
               */

               ::SetValorGrupo( "Operación", ::oProduccT:oDbf:cCodOpe )
               ::SetValorGrupo( "Sección",   ::oProduccT:oDbf:cCodSec )
               ::SetValorGrupo( "Almacén",   ::oProduccT:oDetProduccion:oDbf:cAlmOrd )

               nTemEmpl             := nTiempoEntreFechas( ::oProduccT:oDbf:dFecOrd, ::oProduccT:oDbf:dFecFin, ::oProduccT:oDbf:cHorIni, ::oProduccT:oDbf:cHorFin )

               if !::lSeekInAcumulado( ::oProduccT:oDetProduccion:oDbf:cCodArt )

                  ::oDbf:Append()

                  ::oDbf:cCodArt    := ::oProduccT:oDetProduccion:oDbf:cCodArt
                  ::oDbf:cNomArt    := ::oProduccT:oDetProduccion:oDbf:cNomArt
                  ::oDbf:cCodOpe    := ::oProduccT:oDbf:cCodOpe
                  ::oDbf:cNomOpe    := oRetFld( ::oDbf:cCodOpe, ::oOperacion:oDbf )
                  ::oDbf:cCodSec    := ::oProduccT:oDbf:cCodSec
                  ::oDbf:cNomSec    := oRetFld( ::oDbf:cCodSec, ::oSeccion:oDbf )
                  ::oDbf:cCodAlm    := ::oProduccT:oDetProduccion:oDbf:cAlmOrd
                  ::oDbf:cNomAlm    := oRetFld( ::oDbf:cCodAlm, ::oDbfAlm )
                  ::oDbf:nCajas     := ::oProduccT:oDetProduccion:oDbf:nCajOrd
                  ::oDbf:nUniCaj    := ::oProduccT:oDetProduccion:oDbf:nUndOrd
                  ::oDbf:nUnidades  := NotCaja( ::oProduccT:oDetProduccion:oDbf:nCajOrd ) * ::oProduccT:oDetProduccion:oDbf:nUndOrd
                  ::oDbf:nImporte   := ::oProduccT:oDetProduccion:oDbf:nImpOrd   * ::oDbf:nUnidades
                  ::oDbf:nPeso      := ::oProduccT:oDetProduccion:oDbf:nPeso     * ::oDbf:nUnidades
                  ::oDbf:nVolumen   := ::oProduccT:oDetProduccion:oDbf:nVolumen  * ::oDbf:nUnidades
                  ::oDbf:nVelUnd    := ::oDbf:nUnidades  / nTemEmpl
                  ::oDbf:nVelVol    := ::oDbf:nVolumen   / nTemEmpl
                  ::oDbf:nVelPes    := ::oDbf:nPeso      / nTemEmpl

                  ::oDbf:Save()

               else

                  ::oDbf:Load()

                  ::oDbf:nCajas     += ::oProduccT:oDetProduccion:oDbf:nCajOrd
                  ::oDbf:nUniCaj    += ::oProduccT:oDetProduccion:oDbf:nUndOrd
                  ::oDbf:nUnidades  += NotCaja( ::oProduccT:oDetProduccion:oDbf:nCajOrd ) * ::oProduccT:oDetProduccion:oDbf:nUndOrd
                  ::oDbf:nImporte   += NotCaja( ::oProduccT:oDetProduccion:oDbf:nCajOrd ) * ::oProduccT:oDetProduccion:oDbf:nImpOrd  * ::oProduccT:oDetProduccion:oDbf:nUndOrd
                  ::oDbf:nPeso      += NotCaja( ::oProduccT:oDetProduccion:oDbf:nCajOrd ) * ::oProduccT:oDetProduccion:oDbf:nPeso    * ::oProduccT:oDetProduccion:oDbf:nUndOrd
                  ::oDbf:nVolumen   += NotCaja( ::oProduccT:oDetProduccion:oDbf:nCajOrd ) * ::oProduccT:oDetProduccion:oDbf:nVolumen * ::oProduccT:oDetProduccion:oDbf:nUndOrd
                  ::oDbf:nVelUnd    := ::oDbf:nUnidades  / nTemEmpl
                  ::oDbf:nVelVol    := ::oDbf:nVolumen   / nTemEmpl
                  ::oDbf:nVelPes    := ::oDbf:nPeso      / nTemEmpl

                  ::oDbf:Save()

               end if

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