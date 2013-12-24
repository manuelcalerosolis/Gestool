#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS InfCaj FROM TInfGen

   DATA  oDbfCaj   AS OBJECT
   DATA  cCajOrg   AS CHARACTER
   DATA  cCajDes   AS CHARACTER
   DATA  lAllCaj   AS LOGIC   INIT .t.

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField( "CCODCAJ",      "C",  3, 0, {|| "" },   "Cod. Caj.",      .t., "Código de caja",          10, .f. )
   ::AddField( "CNOMCAJ",      "C", 30, 0, {|| "" },   "Nom. Caj.",      .t., "Nombre de la caja",       30, .f. )
   ::AddField( "CCAPCAJ",      "C",  3, 0, {|| "" },   "Captura",        .f., "Código de captura",       10, .f. )

   ::AddTmpIndex ( "CCODCAJ", "CCODCAJ" )

   ::lDefFecInf   := .f.
   ::lDefSerInf   := .f.
   ::lDefDivInf   := .f.

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

      DATABASE NEW ::oDbfCaj PATH ( cPatDat() ) FILE "CAJAS.DBF" VIA ( cDriver() ) SHARED INDEX "CAJAS.CDX"

   RECOVER

      msgStop( 'Imposible abrir todas las bases de datos' )
      ::CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles()

   if !Empty( ::oDbfCaj ) .and. ::oDbfCaj:Used()
      ::oDbfCaj:End()
   end if

   ::oDbfCaj  := nil


RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld )

   local cSayCajOrg
   local cSayCajDes
   local oSayCajOrg
   local oSayCajDes
   local oCajOrg
   local oCajDes

   if !::StdResource( "INF_CAJ01" )
      return .f.
   end if

   /*
   Montamos los tipos de movimientos de almacen
   */

   ::cCajOrg   := dbFirst( ::oDbfCaj, 1 )
   ::cCajDes   := dbLast(  ::oDbfCaj, 1 )
   cSayCajOrg  := dbFirst( ::oDbfCaj, 2 )
   cSayCajDes  := dbLast(  ::oDbfCaj, 2 )

   REDEFINE CHECKBOX ::lAllCaj ;
      ID       ( 60 ) ;
      OF       ::oFld:aDialogs[1]

   REDEFINE GET oCajOrg VAR ::cCajOrg;
      ID       ( 70 );
      WHEN     ( !::lAllCaj );
      BITMAP   "LUPA" ;
		COLOR 	CLR_GET ;
      OF       ::oFld:aDialogs[1]

      oCajOrg:bValid   := {|| cCajas( oCajOrg, ::oDbfCaj:cAlias, oSayCajOrg ) }
      oCajOrg:bHelp    := {|| BrwCaj( oCajOrg, ::oDbfCaj:cAlias, oSayCajOrg ) }

   REDEFINE GET oSayCajOrg VAR cSayCajOrg ;
      ID       ( 80 );
      WHEN     .f.;
      COLOR    CLR_GET ;
      OF       ::oFld:aDialogs[1]

   REDEFINE GET oCajDes VAR ::cCajDes;
      ID       ( 90 );
      WHEN     ( !::lAllCaj );
      BITMAP   "LUPA" ;
		COLOR 	CLR_GET ;
      OF       ::oFld:aDialogs[1]

      oCajDes:bValid   := {|| cCajas( oCajDes, ::oDbfCaj:cAlias, oSayCajOrg ) }
      oCajDes:bHelp    := {|| BrwCaj( oCajDes, ::oDbfCaj:cAlias, oSayCajOrg ) }

   REDEFINE GET oSayCajDes VAR cSayCajDes ;
      WHEN     .f.;
      ID       ( 100 );
      OF       ::oFld:aDialogs[1]

   /*
   Damos valor al meter
   */

   ::oMtrInf:SetTotal( ::oDbfCaj:Lastrec() )

   ::CreateFilter( aItmCaja(), ::oDbfCaj:cAlias )

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   ::aHeader      := {  {|| "Fecha : " + Dtoc( Date() ) },;
                        {|| "Cajas : " + if( ::lAllCaj, "Todos", AllTrim( ::cCajOrg ) + " > " + AllTrim( ::cCajDes ) ) } }

   ::oDbfCaj:OrdSetFocus( "CCODCAJ" )

   ::oDbfCaj:GoTop()
   while !::lBreak .and. !::oDbfCaj:Eof()

      if ( ::lAllCaj .or. ( ::oDbfCaj:cCodCaj >= ::cCajOrg .AND. ::oDbfCaj:cCodCaj <= ::cCajDes ) )

         ::oDbf:Append()

         ::oDbf:cCodCaj   := ::oDbfCaj:cCodCaj
         ::oDbf:cNomCaj   := ::oDbfCaj:cNomCaj
         ::oDbf:cCapCaj   := ::oDbfCaj:cCapCaj

         ::oDbf:Save()

      end if

      ::oDbfCaj:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oMtrInf:AutoInc( ::oDbfCaj:LastRec() )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//