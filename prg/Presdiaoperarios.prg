#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS PResDiaOperarios FROM TInfGen

   DATA oProduccT    AS OBJECT

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField( "cCodOpe",  "C",  3, 0,  {|| "@!" },       "Ope.",         .f., "Código de la operación"      ,  5, .f. )
   ::AddField( "cNomOpe",  "C", 35, 0,  {|| "@!" },       "Nom. Ope.",    .f., "Nombre de la operación"      , 20, .f. )
   ::AddField( "cCodSec",  "C",  3, 0,  {|| "@!" },       "Sec.",         .f., "Código de la sección"        ,  5, .f. )
   ::AddField( "cNomSec",  "C", 35, 0,  {|| "@!" },       "Nom. Sec.",    .f., "Nombre de la sección"        , 20, .f. )
   ::AddField( "cCodAlm",  "C",  3, 0,  {|| "@!" },       "Alm.",         .f., "Código almacén"              ,  5, .f. )
   ::AddField( "cNomAlm",  "C", 20, 0,  {|| "@!" },       "Nom. Alm.",    .f., "Nombre almacén"              , 20, .f. )
   ::AddField( "cNumDoc",  "C", 12, 0,  {|| "@!" },       "Documento",    .t., "Número de documento"         , 20, .f. )
   ::AddField( "cCodTra",  "C",  5, 0,  {|| "@!" },       "Cod. Oper.",   .t., "Código operario"             , 14, .f. )
   ::AddField( "cNomTra",  "C", 35, 0,  {|| "@!" },       "Operario",     .t., "Nombre operario"             , 35, .f. )
   ::AddField( "dFecMov",  "D",  8, 0,  {|| "@!" },       "Fec. inicio",  .f., "Fecha de inicio"             , 12, .f. )
   ::AddField( "dFecFin",  "D",  8, 0,  {|| "@!" },       "Fec. fin",     .f., "Fecha de Fin"                , 12, .f. )
   ::AddField( "cHorIni",  "C",  5, 0,  {|| "@R 99:99"},  "Hora inicio",  .f., "Hora de inicio"              , 12, .f. )
   ::AddField( "cHorFin",  "C",  5, 0,  {|| "@R 99:99"},  "Hora fin",     .f., "Hora de fin"                 , 12, .f. )
   ::AddField( "nHoras",   "N", 16, 6,  {|| MasUnd()},    "Horas",        .t., "Horas"                       , 20, .f. )
   ::AddField( "nImporte", "N", 16, 6,  {|| ::cPicOut },  "Importe",      .t., "Importe"                     , 12, .t. )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS PResDiaOperarios

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

METHOD CloseFiles() CLASS PResDiaOperarios

   if !Empty( ::oProduccT )
      ::oProduccT:end()
   end if

   ::oProduccT := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld ) CLASS PResDiaOperarios

   ::lNewInforme  := .t.

   if !::StdResource( "PROINFOPERARIOS" )
      return .f.
   end if

   if !::oDefOperario( 190, 191, 200, 201, 210, .t. )
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

METHOD lGenerate() CLASS PResDiaOperarios

   local cExpHead := ""
   local cExpLine := ""

   ::oDlg:Disable()

   ::oBtnCancel:Enable()

   ::oDbf:Zap()

   ::oProduccT:oDbf:OrdSetFocus( "dFecOrd" )
   ::oProduccT:oDetPersonal:oDbf:OrdSetFocus( "cNumOrd" )

   if !::lAllAlm
      cExpHead    := 'cAlmOrd >= "' + Rtrim( ::cAlmOrg ) + '" .and. cAlmOrd <= "' + Rtrim( ::cAlmDes ) + '"'
   else
      cExpHead    := '.t.'
   end if

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead    += ' .and. ' + ::oFilter:cExpresionFilter
   end if

   ::oProduccT:oDbf:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oProduccT:oDbf:cFile ), ::oProduccT:oDbf:OrdKey(), ( cExpHead ), , , , , , , , .t. )

   ::oMtrInf:SetTotal( ::oProduccT:oDbf:OrdKeyCount() )

   cExpLine       := 'dFecIni >= Ctod( "' + Dtoc( ::dIniInf ) + '" ) .and. dFecFin <= Ctod( "' + Dtoc( ::dFinInf ) + '" )'

   if !::lOperaAll
      cExpLine    += ' .and. cCodOpe >= "' + Rtrim( ::cOperaOrg ) + '" .and. cCodOpe <= "' + Rtrim( ::cOperaDes ) + '"'
   end if

   if !::lSeccionAll
      cExpLine    += ' .and. cCodSec >= "' + Rtrim( ::cSeccionOrg ) + '" .and. cCodSec <= "' + Rtrim( ::cSeccionDes ) + '"'
   end if

   if !::lOperarioAll
      cExpLine    += ' .and. cCodTra >= "' + ::cOperarioOrg + '" .and. cCodTra <= "' + ::cOperarioDes + '"'
   end if

   ::oProduccT:oDetPersonal:oDbf:AddTmpIndex( Auth():Codigo(), GetFileNoExt( ::oProduccT:oDetPersonal:oDbf:cFile ), ::oProduccT:oDetPersonal:oDbf:OrdKey(), cAllTrimer( cExpLine ), , , , , , , , .t. )

   ::oProduccT:oDbf:GoTop()

   while !::lBreak .and. !::oProduccT:oDbf:Eof()

      if lChkSer( ::oProduccT:oDbf:cSerOrd, ::aSer )

         if ::oProduccT:oDetPersonal:oDbf:Seek( ::oProduccT:oDbf:cSerOrd + Str( ::oProduccT:oDbf:nNumOrd ) + ::oProduccT:oDbf:cSufOrd )

            while ::oProduccT:oDetPersonal:oDbf:cSerOrd + Str( ::oProduccT:oDetPersonal:oDbf:nNumOrd ) + ::oProduccT:oDetPersonal:oDbf:cSufOrd == ::oProduccT:oDbf:cSerOrd + Str( ::oProduccT:oDbf:nNumOrd ) + ::oProduccT:oDbf:cSufOrd .and. !::oProduccT:oDetPersonal:oDbf:eof()

               ::oDbf:Append()

               ::oDbf:cCodOpe    := ::oProduccT:oDetPersonal:oDbf:cCodOpe
               ::oDbf:cCodSec    := ::oProduccT:oDetPersonal:oDbf:cCodSec
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
               //::oDbf:nImporte   :=

               ::oDbf:Save()

               ::oProduccT:oDetPersonal:oDbf:Skip()

            end while

         end if

      end if

      ::oProduccT:oDbf:Skip()

      ::oMtrInf:AutoInc( ::oProduccT:oDbf:OrdKeyNo() )

   end while

   ::oProduccT:oDbf:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oProduccT:oDbf:cFile ) )
   ::oProduccT:oDetPersonal:oDbf:IdxDelete( Auth():Codigo(), GetFileNoExt( ::oProduccT:oDetPersonal:oDbf:cFile ) )

   ::oMtrInf:AutoInc( ::oProduccT:oDbf:Lastrec() )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//