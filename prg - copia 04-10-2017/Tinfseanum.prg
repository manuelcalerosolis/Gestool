#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TInfSeaNum FROM TInfGen

   METHOD Create()

   METHod lResource( cFld )

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD OpenFiles()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD CloseFiles()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField( "cTipDoc",  "C",27, 0, {|| "@!" },     "Tip. Doc.",    .t., "Tipo de documento",     25, .f.  )
   ::AddField( "cNumDoc",  "C",12, 0, {|| "@!" },     "Num. Doc.",    .t., "Número del documento",  15, .f.  )
   ::AddField( "cCodArt",  "C",18, 0, {|| "@!" },     "Código artículo",    .t., "Código del artículo",   18, .f.  )
   ::AddField( "dFecDoc",  "D", 8, 0, {|| "@!" },     "Fecha",        .t., "Fecha del documento",   12, .f.  )
   ::AddField( "cCodCli",  "C",12, 0, {|| "@!" },     "Cod. Cli/Prv", .t., "Código del Cli/Prv",    15, .f.  )
   ::AddField( "cCliPrv",  "C",50, 0, {|| "@!" },     "Nom. Cli/Prv", .t., "Nombre del Cli/Prv",    50, .f.  )
   ::AddField( "cCodObr",  "C",10, 0, {|| "@!" },     "Dirección",         .t., "Dirección",                  10, .f.  )

   ::AddTmpIndex ( "dFecDoc", "dFecDoc" )

   ::lDefSerInf := .f.

RETURN ( Self )

//---------------------------------------------------------------------------//

METHod lResource( cFld )

   if !::StdResource( "INF_TRAZALOTE" )
      return .f.
   end if

   ::oBtnFilter:Disable()

   ::oMtrInf:SetTotal( ::xOthers:Lastrec() )

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   ::oDlg:Disable()
   ::oDbf:Zap()

   ::xOthers:GoTop()

   ::aHeader      := {  {|| "Fecha   : " + Dtoc( Date() ) } }

   while !::xOthers:Eof()

      if ::xOthers:dFecDoc >= ::dIniInf                                                               .AND.;
         ::xOthers:dFecDoc <= ::dFinInf

         ::oDbf:Append()

         ::oDbf:cTipDoc     := AllTrim( ::xOthers:cTipDoc )
         ::oDbf:cNumDoc     := ::xOthers:cNumDoc
         ::oDbf:cCodArt     := ::xOthers:cCodArt
         ::oDbf:dFecDoc     := ::xOthers:dFecDoc
         ::oDbf:cCodCli     := ::xOthers:cCodCli
         ::oDbf:cCliPrv     := ::xOthers:cCliPrv
         ::oDbf:cCodObr     := ::xOthers:cCodObr

         ::oDbf:Save()

      end if

      ::xOthers:Skip()

      ::oMtrInf:AutoInc( ::xOthers:OrdKeyNo() )

   end do

   ::oMtrInf:AutoInc( ::xOthers:LastRec() )

   ::oDlg:Enable()

   ::oBtnFilter:Disable()

   ::xOthers:GoTop()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//