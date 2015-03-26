#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS InfPro FROM TInfGen

   DATA  oDbfPro  AS OBJECT
   DATA  cProOrg  AS CHARACTER
   DATA  cProDes  AS CHARACTER
   DATA  lAllPro  AS LOGIC   INIT .t.

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField( "cCodPro",   "C",  5, 0, {|| "" },           "Cód. prm.",      .t., "Código de la promoción",   5, .f. )
   ::AddField( "cNomPro",   "C", 25, 0, {|| "" },           "Nombre",         .f., "Nombre de la promoción",  20, .f. )
   ::AddField( "cCodArt",   "C", 18, 0, {|| "" },           "Código artículo",      .t., "Código del artículo",     15, .f. )
   ::AddField( "cNomArt",   "C",100, 0, {|| "" },           "Artículo",       .t., "Nombre del artículo",     50, .f. )
   ::AddField( "dIniPro",   "D",  8, 0, {|| "" },           "Inicio",         .t., "Fecha inicio promoción",  10, .f. )
   ::AddField( "dFinPro",   "D",  8, 0, {|| "" },           "Fin",            .t., "Fecha fin promoción",     10, .f. )
   ::AddField( "nDtoPro",   "N",  5, 2, {|| "@E 99.99" },   "% Dto.",         .t., "Porcentaje de descuento",  5, .f. )
   ::AddField( "cCodTar",   "C",  5, 0, {|| "" },           "Tar.",           .f., "Código de la tarifa",      5, .f. )

   ::AddTmpIndex ( "cCodPro", "cCodPro" )

   ::lDefFecInf   := .f.
   ::lDefSerInf   := .f.
   ::lDefDivInf   := .f.

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

      DATABASE NEW ::oDbfPro PATH ( cPatArt() )   FILE "PROMOT.DBF"   VIA ( cDriver() ) SHARED INDEX "PROMOT.CDX"

   RECOVER

      msgStop( 'Imposible abrir todas las bases de datos' )
      ::CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles()

   if !Empty( ::oDbfPro ) .and. ::oDbfPro:Used()
      ::oDbfPro:End()
   end if

   ::oDbfPro  := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld )

   local cSayProOrg
   local cSayProDes
   local oSayProOrg
   local oSayProDes
   local oProOrg
   local oProDes

   if !::StdResource( "INF_PRO01" )
      return .f.
   end if

   /*
   Montamos los tipos de movimientos de almacen
   */

   ::cProOrg   := dbFirst( ::oDbfPro, 1 )
   ::cProDes   := dbLast(  ::oDbfPro, 1 )
   cSayProOrg  := dbFirst( ::oDbfPro, 2 )
   cSayProDes  := dbLast(  ::oDbfPro, 2 )

   REDEFINE CHECKBOX ::lAllPro ;
      ID       ( 60 ) ;
      OF       ::oFld:aDialogs[1]

   REDEFINE GET oProOrg VAR ::cProOrg;
      ID       ( 70 );
      WHEN     ( !::lAllPro );
      BITMAP   "LUPA" ;
		COLOR 	CLR_GET ;
      OF       ::oFld:aDialogs[1]

      oProOrg:bValid   := {|| cPromo( oProOrg, ::oDbfPro:cAlias, oSayProOrg ) }
      oProOrg:bHelp    := {|| BrwPromo( oProOrg, ::oDbfPro:cAlias, oSayProOrg ) }

   REDEFINE GET oSayProOrg VAR cSayProOrg ;
      ID       ( 80 );
      WHEN     .f.;
      COLOR    CLR_GET ;
      OF       ::oFld:aDialogs[1]

   REDEFINE GET oProDes VAR ::cProDes;
      ID       ( 90 );
      WHEN     ( !::lAllPro );
      BITMAP   "LUPA" ;
		COLOR 	CLR_GET ;
      OF       ::oFld:aDialogs[1]

      oProDes:bValid   := {|| cPromo( oProDes, ::oDbfPro:cAlias, oSayProDes ) }
      oProDes:bHelp    := {|| BrwPromo( oProDes, ::oDbfPro:cAlias, oSayProDes ) }

   REDEFINE GET oSayProDes VAR cSayProDes ;
      WHEN     .f.;
      ID       ( 100 );
      OF       ::oFld:aDialogs[1]

   /*
   Damos valor al meter
   */

   ::oMtrInf:SetTotal( ::oDbfPro:Lastrec() )

   ::CreateFilter( aItmPrm(), ::oDbfPro )

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   ::aHeader      := {  {|| "Fecha       : " + Dtoc( Date() ) },;
                        {|| "Promociones : " + if( ::lAllPro, "Todos", AllTrim( ::cProOrg ) + " > " + AllTrim( ::cProDes ) ) } }

   ::oDbfPro:OrdSetFocus( "CCODPRO" )

   ::oDbfPro:GoTop()

   while !::lBreak .and. !::oDbfPro:Eof()

      if ( ::lAllPro .or. ( ::oDbfPro:cCodPro >= ::cProOrg .AND. ::oDbfPro:cCodPro <= ::cProDes ) ) .and. ;
         ::EvalFilter()

         ::oDbf:Append()

         ::oDbf:cCodPro   := ::oDbfPro:cCodPro
         ::oDbf:cNomPro   := ::oDbfPro:cNomPro
         ::oDbf:cCodArt   := ::oDbfPro:cCodArt
         ::oDbf:cNomArt   := retArticulo( ::oDbf:cCodArt )
         ::oDbf:dIniPro   := ::oDbfPro:dIniPro
         ::oDbf:dFinPro   := ::oDbfPro:dFinPro
         ::oDbf:nDtoPro   := ::oDbfPro:nDtoPro
         ::oDbf:cCodTar   := ::oDbfPro:cCodTar

         ::oDbf:Save()

      end if

      ::oDbfPro:Skip()

      ::oMtrInf:AutoInc( ::oDbfPro:OrdKeyNo() )

   end while

   ::oMtrInf:AutoInc( ::oDbfPro:LastRec() )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//