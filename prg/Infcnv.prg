#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS InfCnv FROM TInfGen

   DATA  oDbfCnv  AS OBJECT
   DATA  cCnvOrg  AS CHARACTER
   DATA  cCnvDes  AS CHARACTER
   DATA  lAllCnv  AS LOGIC   INIT .t.

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField( "cCodCnv",   "C",  2, 0, {|| "" },           "Cód. Cnv.",      .t., "Código de la tabla de conversión",    5, .f. )
   ::AddField( "cDetCnv",   "C", 30, 0, {|| "" },           "Descripción",    .t., "Detalle de la tabla de conversión",  30, .f. )
   ::AddField( "cUndStk",   "C",  4, 0, {|| "" },           "U. Stk.",        .t., "Literal para unidades de stocks",    15, .f. )
   ::AddField( "cUndVta",   "C",  4, 0, {|| "" },           "U. Vta.",        .t., "Literal para unidades de venta",     50, .f. )
   ::AddField( "nFacCnv",   "n", 16, 6, {|| "" },           "Factor",         .t., "Factor de conversión",               50, .f. )

   ::AddTmpIndex ( "cCodCnv", "cCodCnv" )

   ::lDefFecInf   := .f.
   ::lDefSerInf   := .f.
   ::lDefDivInf   := .f.

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   DATABASE NEW ::oDbfCnv PATH ( cPatDat() )   FILE "TBLCNV.DBF"   VIA ( cDriver() ) SHARED INDEX "TBLCNV.CDX"

   RECOVER

      msgStop( 'Imposible abrir todas las bases de datos' )
      ::CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles()

   if !Empty( ::oDbfCnv ) .and. ::oDbfCnv:Used()
      ::oDbfCnv:End()
   end if

   ::oDbfCnv  := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld )

   local cSayCnvOrg
   local cSayCnvDes
   local oSayCnvOrg
   local oSayCnvDes
   local oCnvOrg
   local oCnvDes

   if !::StdResource( "INF_CNV01" )
      return .f.
   end if

   /*
   Montamos los tipos de movimientos de almacen
   */

   ::cCnvOrg   := dbFirst( ::oDbfCnv, 1 )
   ::cCnvDes   := dbLast(  ::oDbfCnv, 1 )
   cSayCnvOrg  := dbFirst( ::oDbfCnv, 2 )
   cSayCnvDes  := dbLast(  ::oDbfCnv, 2 )

   REDEFINE CHECKBOX ::lAllCnv ;
      ID       ( 60 ) ;
      OF       ::oFld:aDialogs[1]

   REDEFINE GET oCnvOrg VAR ::cCnvOrg;
      ID       ( 70 );
      WHEN     ( !::lAllCnv );
      BITMAP   "LUPA" ;
		COLOR 	CLR_GET ;
      OF       ::oFld:aDialogs[1]

      oCnvOrg:bValid   := {|| cTblCnv( oCnvOrg, ::oDbfCnv:cAlias, oSayCnvOrg ) }
      oCnvOrg:bHelp    := {|| BrwTblCnv( oCnvOrg, ::oDbfCnv:cAlias, oSayCnvOrg ) }

   REDEFINE GET oSayCnvOrg VAR cSayCnvOrg ;
      ID       ( 80 );
      WHEN     .f.;
      COLOR    CLR_GET ;
      OF       ::oFld:aDialogs[1]

   REDEFINE GET oCnvDes VAR ::cCnvDes;
      ID       ( 90 );
      WHEN     ( !::lAllCnv );
      BITMAP   "LUPA" ;
		COLOR 	CLR_GET ;
      OF       ::oFld:aDialogs[1]

      oCnvDes:bValid   := {|| cTblCnv( oCnvDes, ::oDbfCnv:cAlias, oSayCnvDes ) }
      oCnvDes:bHelp    := {|| BrwTblCnv( oCnvDes, ::oDbfCnv:cAlias, oSayCnvDes ) }

   REDEFINE GET oSayCnvDes VAR cSayCnvDes ;
      WHEN     .f.;
      ID       ( 100 );
      OF       ::oFld:aDialogs[1]

   /*
   Damos valor al meter
   */

   ::oMtrInf:SetTotal( ::oDbfCnv:Lastrec() )

   ::CreateFilter( aItmTbl(), ::oDbfCnv )

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   ::oDlg:Disable()
   ::oDbf:Zap()

   ::aHeader         := {  {|| "Fecha         : " + Dtoc( Date() ) },;
                           {|| "F. conversión : " + if( ::lAllCnv, "Todos", AllTrim( ::cCnvOrg ) + " > " + AllTrim( ::cCnvDes ) ) } }

   ::oDbfCnv:OrdSetFocus( "CCODCNV" )

   ::oDbfCnv:GoTop()
   while !::oDbfCnv:Eof()

      if ( ::lAllCnv .or. ( ::oDbfCnv:cCodCnv >= ::cCnvOrg .AND. ::oDbfCnv:cCodCnv <= ::cCnvDes ) ) .and. ;
         ::EvalFilter()

         ::oDbf:Append()

         ::oDbf:cCodCnv    := ::oDbfCnv:cCodCnv
         ::oDbf:cDetCnv    := ::oDbfCnv:cDetCnv
         ::oDbf:cUndStk    := ::oDbfCnv:cUndStk
         ::oDbf:cUndVta    := ::oDbfCnv:cUndVta
         ::oDbf:nFacCnv    := ::oDbfCnv:nFacCnv

         ::oDbf:Save()

      end if

      ::oDbfCnv:Skip()

      ::oMtrInf:AutoInc( ::oDbfCnv:OrdKeyNo() )

   end while

   ::oMtrInf:AutoInc( ::oDbfCnv:LastRec() )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//