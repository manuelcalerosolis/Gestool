#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//----------------------------------------------------------------------------//

CLASS TSerDoc FROM TMANT

   METHOD New( cPath, oWndParent, oMenuItem ) CONSTRUCTOR

   METHOD Create( cPath ) CONSTRUCTOR

   METHOD OpenFiles( lExclusive )

   METHOD Resource( nMode )

   METHOD Activate()

END CLASS

//----------------------------------------------------------------------------//

METHOD New( cPath, oWndParent, oMenuItem ) CLASS TSerDoc

   DEFAULT cPath        := cPatEmp()
   DEFAULT oWndParent   := GetWndFrame()

   if oMenuItem != nil
      ::nLevel          := Auth():Level( oMenuItem )
   else
      ::nLevel          := 0
   end if

   /*
   Cerramos todas las ventanas
   */

   if oWndParent != nil
      oWndParent:CloseAll()
   end if

   ::cPath              := cPath
   ::oWndParent         := oWndParent
   ::oDbf               := nil

   ::lCreateShell       := .f.
   ::cHtmlHelp          := "Series de docuementos"

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Create( cPath ) CLASS TSerDoc

   DEFAULT cPath        := cPatEmp()

   ::cPath              := cPath
   ::oDbf               := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD OpenFiles( lExclusive ) CLASS TSerDoc

   DEFAULT lExclusive   := .f.

   DEFINE DATABASE ::oDbf FILE "SERDOC.DBF" CLASS "SERDOC" ALIAS "SERDOC" PATH ( ::cPath ) VIA ( cDriver() ) COMMENT "Series de documentos"

      FIELD NAME "nCntPedPrv"    TYPE "N" LEN  9  DEC 0  COMMENT "Código"                             COLSIZE 80  OF ::oDbf
      FIELD NAME "cNomGrp"       TYPE "C" LEN 30  DEC 0  COMMENT "Nombre"                PICTURE "@!" COLSIZE 200 OF ::oDbf
      FIELD NAME "lPubInt"       TYPE "L" LEN  1  DEC 0  COMMENT ""         HIDE                                  OF ::oDbf

      INDEX TO "GRPFAM.CDX" TAG "CCODGRP" ON "CCODGRP"            COMMENT "Código" NODELETED OF ::oDbf
      INDEX TO "GRPFAM.CDX" TAG "CNOMGRP" ON "UPPER( CNOMGRP )"   COMMENT "Nombre" NODELETED OF ::oDbf

   END DATABASE ::oDbf

   ::oDbf:Activate( .f., !( lExclusive ) )

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD Resource( nMode )

	local oDlg
   local oGet

   DEFINE DIALOG oDlg RESOURCE "GrpFam" TITLE LblTitle( nMode ) + "grupos de familias"

      REDEFINE GET oGet VAR ::oDbf:cCodGrp UPDATE;
			ID 		100 ;
         WHEN     ( nMode == APPD_MODE ) ;
         VALID    NotValid( oGet, ::oDbf:cAlias, .t., "0" ) ;
			PICTURE 	"@!" ;
			OF 		oDlg

      REDEFINE GET ::oDbf:cNomGrp UPDATE;
			ID 		110 ;
         PICTURE  ::oDbf:cNomGrp:cPicture ;
         WHEN     ( nMode != ZOOM_MODE ) ;
			OF 		oDlg

      REDEFINE CHECKBOX ::oDbf:lPubInt ;
         ID       120 ;
			WHEN 		( nMode != ZOOM_MODE ) ;
			OF 		oDlg

      REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( oDlg:end( IDOK ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
         CANCEL ;
			ACTION 	( oDlg:end() )

   REDEFINE BUTTON ;
         ID       9 ;
			OF 		oDlg ;
         ACTION   ( ChmHelp( "Grupos_de_familias" ) )

	ACTIVATE DIALOG oDlg	CENTER

RETURN ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

METHOD Activate()

   ::CreateShell( ::nLevel )

   ::oWndBrw:GralButtons( Self )

   DEFINE BTNSHELL RESOURCE "SEL" OF ::oWndBrw ;
      NOBORDER ;
      ACTION   ( ::Publicar() ) ;
      TOOLTIP  "(P)ublicar" ;
      HOTKEY   "P";
      LEVEL    4

   ::oWndBrw:EndButtons( Self )

   ::oWndBrw:cHtmlHelp  := "Grupos de familias"

   ::oWndBrw:Activate(  nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil,;
                        nil, nil, nil, nil, {|| ::CloseFiles() }, nil, nil )

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD Publicar()

   ::oDbf:Load()
   ::oDbf:lPubInt := !::oDbf:lPubInt
   ::oDbf:Save()

   ::oWndBrw:Refresh()

RETURN ( Self )

//----------------------------------------------------------------------------//

FUNCTION GrpFam( oMenuItem, oWnd )

   local oGrpFam

   DEFAULT  oMenuItem   := "01011"
   DEFAULT  oWnd        := oWnd()

   oGrpFam  := TSerDoc():New( cPatEmp(), oWnd, oMenuItem )
   oGrpFam:Activate()

RETURN NIL

//--------------------------------------------------------------------------//