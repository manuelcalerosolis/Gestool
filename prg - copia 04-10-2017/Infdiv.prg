#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS InfDiv FROM TInfGen

   DATA  oDbfDiv   AS OBJECT
   DATA  cDivOrg   AS CHARACTER
   DATA  cDivDes   AS CHARACTER
   DATA  lAllDiv   AS LOGIC         INIT .t.
   DATA  oBandera  AS OBJECT

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField( "CCODDIV",      "C",  3, 0, {|| "" },                    "Código",         .t., "Código de la divisa",                                  8, .f. )
   ::AddField( "CNOMDIV",      "C", 20, 0, {|| "" },                    "Nombre",         .t., "Nombre de la divisa",                                 20, .f. )
   ::AddField( "DACTDIV",      "D",  8, 0, {|| "" },                    "Ult. camb.",     .t., "Fecha ultimo cambio de la divisa",                    12, .f. )
   ::AddField( "NPTSDIV",      "N", 16, 0, {|| "@E 999,999.999999" },   "Ptas.",          .t., "Valor en pesetas de la divisa",                       16, .f. )
   ::AddField( "NEURDIV",      "N", 16, 0, {|| "@E 999,999.999999" },   "Euros",          .t., "Valor en euros de la divisa",                         16, .f. )
   ::AddField( "NNINDIV",      "N",  2, 0, {|| "" },                    "Und. Com.",      .f., "Unidades de compra de la divisa",                      5, .f. )
   ::AddField( "NDINDIV",      "N",  1, 0, {|| "" },                    "Dec. Com.",      .f., "Decimales de compra de la divisa",                     5, .f. )
   ::AddField( "NRINDIV",      "N",  1, 0, {|| "" },                    "Red. Com.",      .f., "Decimales de redondeo de la divisa",                   5, .f. )
   ::AddField( "NNOUDIV",      "N",  2, 0, {|| "" },                    "Und. Vta.",      .f., "Unidades de venta de la divisa",                       5, .f. )
   ::AddField( "NDOUDIV",      "N",  1, 0, {|| "" },                    "Dec. Vta.",      .f., "Decimales de venta de la divisa",                      5, .f. )
   ::AddField( "NROUDIV",      "N",  1, 0, {|| "" },                    "Red. Vta.",      .f., "Decimales de redondeo de la divisa",                   5, .f. )
   ::AddField( "NNPVDIV",      "N",  2, 0, {|| "" },                    "Und. P. Ver",    .f., "Unidades de punto verde de la divisa",                 5, .f. )
   ::AddField( "NDPVDIV",      "N",  1, 0, {|| "" },                    "Dec. P. Ver",    .f., "Decimales de punto verde de la divisa",                5, .f. )
   ::AddField( "NRPVDIV",      "N",  1, 0, {|| "" },                    "Red. P. Ver",    .f., "Decimales de redondeo de punto verde  de la divisa",   5, .f. )

   ::AddTmpIndex ( "CCODDIV", "CCODDIV" )

   ::lDefFecInf   := .f.
   ::lDefSerInf   := .f.
   ::lDefDivInf   := .f.

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

      DATABASE NEW ::oDbfDiv PATH ( cPatDat() ) FILE "DIVISAS.DBF" VIA ( cDriver() ) SHARED INDEX "DIVISAS.CDX"

      ::oBandera     := TBandera():New()

   RECOVER

      msgStop( 'Imposible abrir todas las bases de datos' )
      ::CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles()

   if !Empty( ::oDbfDiv ) .and. ::oDbfDiv:Used()
      ::oDbfDiv:End()
   end if

   ::oDbfDiv  := nil
   ::oBandera := nil


RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld )

   local cSayDivOrg
   local cSayDivDes
   local oSayDivOrg
   local oSayDivDes
   local oDivOrg
   local oDivDes

   if !::StdResource( "INF_DIV01" )
      return .f.
   end if

   /*
   Montamos los tipos de movimientos de almacen
   */

   ::cDivOrg   := dbFirst( ::oDbfDiv, 1 )
   ::cDivDes   := dbLast(  ::oDbfDiv, 1 )
   cSayDivOrg  := dbFirst( ::oDbfDiv, 2 )
   cSayDivDes  := dbLast(  ::oDbfDiv, 2 )

   REDEFINE CHECKBOX ::lAllDiv ;
      ID       ( 60 ) ;
      OF       ::oFld:aDialogs[1]

   REDEFINE GET oDivOrg VAR ::cDivOrg;
      ID       ( 70 );
      WHEN     ( !::lAllDiv );
      BITMAP   "LUPA" ;
		COLOR 	CLR_GET ;
      OF       ::oFld:aDialogs[1]

      oDivOrg:bValid   := {|| cNbrDiv( oDivOrg, oSayDivOrg, ::oDbfDiv:cAlias ) }
      oDivOrg:bHelp    := {|| BrwNbrDiv( oDivOrg, oSayDivOrg, ::oDbfDiv:cAlias, ::oBandera ) }

   REDEFINE GET oSayDivOrg VAR cSayDivOrg ;
      ID       ( 80 );
      WHEN     .f.;
      COLOR    CLR_GET ;
      OF       ::oFld:aDialogs[1]

   REDEFINE GET oDivDes VAR ::cDivDes;
      ID       ( 90 );
      WHEN     ( !::lAllDiv );
      BITMAP   "LUPA" ;
		COLOR 	CLR_GET ;
      OF       ::oFld:aDialogs[1]

      oDivDes:bValid   := {|| cNbrDiv( oDivDes, oSayDivDes, ::oDbfDiv:cAlias ) }
      oDivDes:bHelp    := {|| BrwNbrDiv( oDivDes, oSayDivDes, ::oDbfDiv:cAlias, ::oBandera ) }

   REDEFINE GET oSayDivDes VAR cSayDivDes ;
      WHEN     .f.;
      ID       ( 100 );
      OF       ::oFld:aDialogs[1]

   /*
   Damos valor al meter
   */

   ::oMtrInf:SetTotal( ::oDbfDiv:Lastrec() )

   ::CreateFilter( aItmDiv(), ::oDbfDiv:cAlias )

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   local cExpHead := ""

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   ::aHeader      := {  {|| "Fecha  : " + Dtoc( Date() ) },;
                        {|| "Divisa : " + if( ::lAllDiv, "Todos", AllTrim( ::cDivOrg ) + " > " + AllTrim( ::cDivDes ) ) } }

   ::oDbfDiv:OrdSetFocus( "CCODDIV" )

   if !Empty( ::oFilter:cExpresionFilter )
      cExpHead       := ::oFilter:cExpresionFilter
   else
      cExpHead       := '.t.'
   end if

   ::oDbfDiv:GoTop()

   while !::lBreak .and. !::oDbfDiv:Eof()

      if ( ::lAllDiv .or. ( ::oDbfDiv:cCodDiv >= ::cDivOrg .AND. ::oDbfDiv:cCodDiv <= ::cDivDes ) )

         ::oDbf:Append()

         ::oDbf:cCodDiv   := ::oDbfDiv:cCodDiv
         ::oDbf:cNomDiv   := ::oDbfDiv:cNomDiv
         ::oDbf:dActDiv   := ::oDbfDiv:dActDiv
         ::oDbf:nPtsDiv   := ::oDbfDiv:nPtsDiv
         ::oDbf:nEurDiv   := ::oDbfDiv:nEurDiv
         ::oDbf:nNinDiv   := ::oDbfDiv:nNinDiv
         ::oDbf:nDinDiv   := ::oDbfDiv:nDinDiv
         ::oDbf:nRinDiv   := ::oDbfDiv:nRinDiv
         ::oDbf:nNouDiv   := ::oDbfDiv:nNouDiv
         ::oDbf:nDouDiv   := ::oDbfDiv:nDouDiv
         ::oDbf:nRouDiv   := ::oDbfDiv:nRouDiv
         ::oDbf:nNpvDiv   := ::oDbfDiv:nNpvDiv
         ::oDbf:nDpvDiv   := ::oDbfDiv:nDpvDiv
         ::oDbf:nRpvDiv   := ::oDbfDiv:nRpvDiv

         ::oDbf:Save()

      end if

      ::oDbfDiv:Skip()

      ::oMtrInf:AutoInc( ::oDbfDiv:OrdKeyNo() )

   end while

   ::oMtrInf:AutoInc( ::oDbfDiv:LastRec() )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//