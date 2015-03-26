#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS IGrpVen FROM TInfGen

   DATA  oGrpVen   AS OBJECT
   DATA  cVenOrg   AS CHARACTER
   DATA  cVenDes   AS CHARACTER
   DATA  lAllVen   AS LOGIC   INIT .t.

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField( "cGrpConta",   "C",  9, 0, {|| "" },           "Cód. Grp.",      .t., "Grupo de contabilidad",   20, .f. )
   ::AddField( "cGrpNom",     "C", 25, 0, {|| "" },           "Grp. ventas",    .t., "Nombre del grupo",        40, .f. )

   ::AddTmpIndex ( "cGrpConta", "cGrpConta" )

   ::lDefFecInf   := .f.
   ::lDefSerInf   := .f.
   ::lDefDivInf   := .f.

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

      DATABASE NEW ::oGrpVen PATH ( cPatEmp() ) FILE "GRPVENT.DBF" VIA ( cDriver() ) SHARED INDEX "GRPVENT.CDX"

   RECOVER

      msgStop( 'Imposible abrir todas las bases de datos' )
      ::CloseFiles()
      lOpen       := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles()

   if !Empty( ::oGrpVen ) .and. ::oGrpVen:Used()
      ::oGrpVen:End()
   end if

   ::oGrpVen  := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld )

   local cSayVenOrg
   local cSayVenDes
   local oSayVenOrg
   local oSayVenDes
   local oVenOrg
   local oVenDes

   if !::StdResource( "INF_GVEN01" )
      return .f.
   end if

   /*
   Montamos los tipos de movimientos de almacen
   */

   ::cVenOrg   := dbFirst( ::oGrpVen, 1 )
   ::cVenDes   := dbLast(  ::oGrpVen, 1 )
   cSayVenOrg  := dbFirst( ::oGrpVen, 2 )
   cSayVenDes  := dbLast(  ::oGrpVen, 2 )

   REDEFINE CHECKBOX ::lAllVen ;
      ID       ( 60 ) ;
      OF       ::oFld:aDialogs[1]

   REDEFINE GET oVenOrg VAR ::cVenOrg;
      ID       ( 70 );
      WHEN     ( !::lAllVen );
      BITMAP   "LUPA" ;
		COLOR 	CLR_GET ;
      OF       ::oFld:aDialogs[1]

      oVenOrg:bValid   := {|| cGrpVenta( oVenOrg, ::oGrpVen:cAlias, oSayVenOrg ) }
      oVenOrg:bHelp    := {|| BrwGrpVenta( oVenOrg, ::oGrpVen:cAlias, oSayVenOrg ) }

   REDEFINE GET oSayVenOrg VAR cSayVenOrg ;
      ID       ( 80 );
      WHEN     .f.;
      COLOR    CLR_GET ;
      OF       ::oFld:aDialogs[1]

   REDEFINE GET oVenDes VAR ::cVenDes;
      ID       ( 90 );
      WHEN     ( !::lAllVen );
      BITMAP   "LUPA" ;
		COLOR 	CLR_GET ;
      OF       ::oFld:aDialogs[1]

      oVenDes:bValid   := {|| cGrpVenta( oVenDes, ::oGrpVen:cAlias, oSayVenDes ) }
      oVenDes:bHelp    := {|| BrwGrpVenta( oVenDes, ::oGrpVen:cAlias, oSayVenDes ) }

   REDEFINE GET oSayVenDes VAR cSayVenDes ;
      WHEN     .f.;
      ID       ( 100 );
      OF       ::oFld:aDialogs[1]

   /*
   Damos valor al meter
   */

   ::oMtrInf:SetTotal( ::oGrpVen:Lastrec() )

   ::CreateFilter( aItmGrpVta(), ::oGrpVen )

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   ::oDlg:Disable()
   ::oDbf:Zap()

   ::aHeader      := {  {|| "Fecha       : " + Dtoc( Date() ) },;
                        {|| "Grp. ventas : " + if( ::lAllVen, "Todos", AllTrim( ::cVenOrg ) + " > " + AllTrim( ::cVenDes ) ) } }

   ::oGrpVen:GoTop()
   while !::oGrpVen:Eof()

      if ( ::lAllVen .or. ( ::oGrpVen:cGrpConta >= ::cVenOrg .AND. ::oGrpVen:cGrpConta <= ::cVenDes ) ) .and. ;
         ::EvalFilter()

         ::oDbf:Append()

         ::oDbf:cGrpConta   := ::oGrpVen:cGrpConta
         ::oDbf:cGrpNom     := ::oGrpVen:cGrpNom

         ::oDbf:Save()

      end if

      ::oGrpVen:Skip()

      ::oMtrInf:AutoInc( ::oGrpVen:OrdKeyNo() )

   end while

   ::oMtrInf:AutoInc( ::oGrpVen:LastRec() )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//