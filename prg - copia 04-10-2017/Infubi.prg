#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS InfUbi FROM TInfGen

   DATA  oDbfUbiT  AS OBJECT
   DATA  oDbfUbiL  AS OBJECT
   DATA  cUbiOrg   AS CHARACTER
   DATA  cUbiDes   AS CHARACTER
   DATA  lAllUbi   AS LOGIC   INIT .t.

   METHOD Create()

   METHOD OpenFiles()

   METHOD CloseFiles()

   METHOD lResource( cFld )

   METHOD lGenerate()

END CLASS

//---------------------------------------------------------------------------//

METHOD Create()

   ::AddField( "cCodUbi",   "C",  5, 0, {|| "" },     "Cod. ubi.",         .f., "Código de ubicación",               10, .f. )
   ::AddField( "cNomUbi",   "C", 30, 0, {|| "" },     "Nom. ubi.",         .f., "Nombre de ubicación",               10, .f. )
   ::AddField( "cUbiLin",   "C",  5, 0, {|| "" },     "Ubic.",             .t., "Ubicación",                         10, .f. )
   ::AddField( "cNomUbil",  "C", 30, 0, {|| "" },     "Descripción",       .t., "Domicilio de almacen",              30, .f. )

   ::AddTmpIndex( "CCODUBI", "CCODUBI + CUBILIN" )

   ::AddGroup( {|| ::oDbf:cCodUbi }, {|| "Cod. ubicación  : " + Rtrim( ::oDbf:cCodUbi ) + "-" + Rtrim( ::oDbf:cNomUbi ) }, {||"Total ..."} )

   ::lDefFecInf   := .f.
   ::lDefSerInf   := .f.
   ::lDefDivInf   := .f.

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD OpenFiles()

   local lOpen    := .t.
   local oBlock   := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   BEGIN SEQUENCE

   DATABASE NEW ::oDbfUbiT PATH ( cPatAlm() )   FILE "UBICAT.DBF"   VIA ( cDriver() ) SHARED INDEX "UBICAT.CDX"

   DATABASE NEW ::oDbfUbiL PATH ( cPatAlm() )   FILE "UBICAL.DBF"   VIA ( cDriver() ) SHARED INDEX "UBICAL.CDX"

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos" )
      ::CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles()

   if !Empty( ::oDbfUbiT ) .and. ::oDbfUbiT:Used()
      ::oDbfUbiT:End()
   end if
   if !Empty( ::oDbfUbiL ) .and. ::oDbfUbiL:Used()
      ::oDbfUbiL:End()
   end if

   ::oDbfUbiT  := nil
   ::oDbfUbiL  := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lResource( cFld )

   local oUbiOrg
   local oUbiDes
   local cSayUbiOrg
   local cSayUbiDes
   local oSayUbiOrg
   local oSayUbiDes

   if !::StdResource( "INF_UBI01" )
      return .f.
   end if

   ::cUbiOrg   := dbFirst( ::oDbfUbiT, 1 )
   ::cUbiDes   := dbLast(  ::oDbfUbiT, 1 )
   cSayUbiOrg  := dbFirst( ::oDbfUbiT, 2 )
   cSayUbiDes  := dbLast(  ::oDbfUbiT, 2 )

   /*
   Montamos las ubicaciones----------------------------------------------------
   */

   REDEFINE CHECKBOX ::lAllUbi ;
      ID       ( 60 ) ;
      OF       ::oFld:aDialogs[1]

   REDEFINE GET oUbiOrg VAR ::cUbiOrg;
      ID       ( 70 );
      WHEN     ( !::lAllUbi );
      BITMAP   "LUPA" ;
		COLOR 	CLR_GET ;
      OF       ::oFld:aDialogs[1]

      oUbiOrg:bValid   := {|| cUbica( oUbiOrg, ::oDbfUbiT:cAlias, oSayUbiOrg ) }
      oUbiOrg:bHelp    := {|| BrwUbicacion( oUbiOrg, ::oDbfUbiT:cAlias, oSayUbiOrg ) }

   REDEFINE GET oSayUbiOrg VAR cSayUbiOrg ;
      ID       ( 80 );
      WHEN     .f.;
      COLOR    CLR_GET ;
      OF       ::oFld:aDialogs[1]

   REDEFINE GET oUbiDes VAR ::cUbiDes;
      ID       ( 90 );
      WHEN     ( !::lAllUbi );
      BITMAP   "LUPA" ;
		COLOR 	CLR_GET ;
      OF       ::oFld:aDialogs[1]

      oUbiDes:bValid   := {|| cUbica( oUbiDes, ::oDbfUbiT:cAlias, oSayUbiDes ) }
      oUbiDes:bHelp    := {|| BrwUbicacion( oUbiDes, ::oDbfUbiT:cAlias, oSayUbiDes ) }

   REDEFINE GET oSayUbiDes VAR cSayUbiDes ;
      WHEN     .f.;
      ID       ( 100 );
      OF       ::oFld:aDialogs[1]

   /*
   Damos valor al meter
   */

   ::oMtrInf:SetTotal( ::oDbfUbiT:Lastrec() )

   ::CreateFilter( aItmUbi(), ::oDbfUbiT:cAlias )

RETURN .t.

//---------------------------------------------------------------------------//
/*
Esta funcion crea la base de datos para generar posteriormente el informe
*/

METHOD lGenerate()

   ::oDlg:Disable()
   ::oBtnCancel:Enable()
   ::oDbf:Zap()

   ::aHeader      := {  {|| "Fecha     : " + Dtoc( Date() ) },;
                        {|| "Ubicación : " + if( ::lAllUbi, "Todos", AllTrim( ::cUbiOrg ) + " > " + AllTrim( ::cUbiDes ) ) } }

   ::oDbfUbiT:OrdSetFocus( "CCODUBI" )

   ::oDbfUbiT:GoTop()
   while !::lBreak .and. !::oDbfUbiT:Eof()

      if ( ::lAllUbi .or. ( ::oDbfUbiT:cCodUbi >= ::cUbiOrg .AND. ::oDbfUbiT:cCodUbi <= ::cUbiDes ) ) .and.;
         ::oDbfUbiL:Seek( ::oDbfUbiT:cCodUbi )                                                        .and.;
         ::EvalFilter()

         while ::oDbfUbiT:cCodUbi == ::oDbfUbiL:cCodUbi .and. !::oDbfUbiL:Eof

            ::oDbf:Append()

            ::oDbf:cCodUbi     := ::oDbfUbiT:cCodUbi
            ::oDbf:cNomUbi     := oRetFld( ::oDbf:cCodUbi, ::oDbfUbiT )
            ::oDbf:cUbiLin     := ::oDbfUbiL:cUbiLin
            ::oDbf:cNomUbil    := ::oDbfUbiL:cNomUbil

            ::oDbf:Save()

            ::oDbfUbiL:Skip()

         end while

      end if

      ::oDbfUbiT:Skip()

      ::oMtrInf:AutoInc()

   end while

   ::oMtrInf:AutoInc( ::oDbfUbiT:LastRec() )

   ::oDlg:Enable()

RETURN ( ::oDbf:LastRec() > 0 )

//---------------------------------------------------------------------------//