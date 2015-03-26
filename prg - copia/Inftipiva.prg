#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS InfTipIva FROM TInfGen

   DATA  oDbfTIva   AS OBJECT
   DATA  cTIvaOrg   AS CHARACTER
   DATA  cTIvaDes   AS CHARACTER
   DATA  lAllTIva   AS LOGIC   INIT .t.

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField( "Tipo",      "C",  1, 0, {|| "" },   "Cod. impuestos.",      .t., "Tipo de " + cImp(),                    8, .f. )
   ::AddField( "DescIva",   "C", 30, 0, {|| "" },   "Des. impuestos.",      .t., "Descripción del tipo de " + cImp(),   30, .f. )
   ::AddField( "TPIva",     "N",  6, 2, {|| "" },   "% impuestos.",         .t., "Tipo de " + cImp(),                    8, .f. )
   ::AddField( "nRecEq",    "N",  6, 2, {|| "" },   "R.E.",           .t., "Recargo de equivalencia",        8, .f. )
   ::AddField( "GrpAsc",    "C",  9, 0, {|| "" },   "Grp. Ven.",      .f., "Grupo de venta asociado",       10, .f. )
   ::AddField( "CodTer",    "C",  1, 0, {|| "" },   "Terminal",       .f., "Código para terminales",         1, .f. )

   ::AddTmpIndex ( "Tipo", "Tipo" )

   ::lDefFecInf   := .f.
   ::lDefSerInf   := .f.
   ::lDefDivInf   := .f.

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   DATABASE NEW ::oDbfTIva PATH ( cPatDat() )   FILE "TIVA.DBF"   VIA ( cDriver() ) SHARED INDEX "TIVA.CDX"

   RECOVER

      msgStop( 'Imposible abrir todas las bases de datos' )
      ::CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles()

   if !Empty( ::oDbfTIva ) .and. ::oDbfTIva:Used()
      ::oDbfTIva:End()
   end if

   ::oDbfTIva  := nil


RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld )

   local cSayTIvaOrg
   local cSayTIvaDes
   local oSayTIvaOrg
   local oSayTIvaDes
   local oTIvaOrg
   local oTIvaDes

   if !::StdResource( "INF_TIVA01" )
      return .f.
   end if

   /*
   Montamos los tipos de movimientos de almacen
   */

   ::cTIvaOrg   := dbFirst( ::oDbfTIva, 1 )
   ::cTIvaDes   := dbLast(  ::oDbfTIva, 1 )
   cSayTIvaOrg  := dbFirst( ::oDbfTIva, 2 )
   cSayTIvaDes  := dbLast(  ::oDbfTIva, 2 )

   REDEFINE CHECKBOX ::lAllTIva ;
      ID       ( 60 ) ;
      OF       ::oFld:aDialogs[1]

   REDEFINE GET oTIvaOrg VAR ::cTIvaOrg;
      ID       ( 70 );
      WHEN     ( !::lAllTIva );
      BITMAP   "LUPA" ;
		COLOR 	CLR_GET ;
      OF       ::oFld:aDialogs[1]

      oTIvaOrg:bValid   := {|| cTiva( oTIvaOrg, ::oDbfTIva:cAlias, oSayTIvaOrg ) }
      oTIvaOrg:bHelp    := {|| BrwIva( oTIvaOrg, ::oDbfTIva:cAlias, oSayTIvaOrg ) }

   REDEFINE GET oSayTIvaOrg VAR cSayTIvaOrg ;
      ID       ( 80 );
      WHEN     .f.;
      COLOR    CLR_GET ;
      OF       ::oFld:aDialogs[1]

   REDEFINE GET oTIvaDes VAR ::cTIvaDes;
      ID       ( 90 );
      WHEN     ( !::lAllTIva );
      BITMAP   "LUPA" ;
		COLOR 	CLR_GET ;
      OF       ::oFld:aDialogs[1]

      oTIvaDes:bValid   := {|| cTiva( oTIvaDes, ::oDbfTIva:cAlias, oSayTIvaDes ) }
      oTIvaDes:bHelp    := {|| BrwIva( oTIvaDes, ::oDbfTIva:cAlias, oSayTIvaDes ) }

   REDEFINE GET oSayTIvaDes VAR cSayTIvaDes ;
      WHEN     .f.;
      ID       ( 100 );
      OF       ::oFld:aDialogs[1]

   /*
   Damos valor al meter
   */

   ::oMtrInf:SetTotal( ::oDbfTIva:Lastrec() )

   ::CreateFilter( aItmTIva(), ::oDbfTIva:cAlias )

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   ::aHeader      := {  {|| "Fecha    : " + Dtoc( Date() ) },;
                        {|| "tipo " + cImp() + " : " + if( ::lAllTIva, "Todos", AllTrim( ::cTIvaOrg ) + " > " + AllTrim( ::cTIvaDes ) ) } }

   ::oDbfTIva:OrdSetFocus( "Tipo" )

   ::oDbfTIva:GoTop()
   while !::lBreak .and. !::oDbfTIva:Eof()

      if ( ::lAllTIva .or. ( ::oDbfTIva:Tipo >= ::cTIvaOrg .AND. ::oDbfTIva:Tipo <= ::cTIvaDes ) )

         ::oDbf:Append()

         ::oDbf:Tipo       := ::oDbfTIva:Tipo
         ::oDbf:DescIva    := ::oDbfTIva:DescIva
         ::oDbf:TPIva      := ::oDbfTIva:TPIva
         ::oDbf:nRecEq     := ::oDbfTIva:nRecEq
         ::oDbf:GrpAsc     := ::oDbfTIva:GrpAsc
         ::oDbf:CodTer     := ::oDbfTIva:CodTer

         ::oDbf:Save()

      end if

      ::oDbfTIva:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oMtrInf:AutoInc( ::oDbfTIva:LastRec() )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//