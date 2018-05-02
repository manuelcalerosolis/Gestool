#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//----------------------------------------------------------------------------//

CLASS TProyecto FROM TMant

   CLASSDATA oInstance

   DATA  cMru                                   INIT "Led_Red_16"

   DATA  oGetCodigo
   DATA  oGetNombre

   METHOD New( cPath, oWndParent, oMenuItem )   CONSTRUCTOR
   METHOD Create( cPath )                       CONSTRUCTOR

   METHOD DefineFiles()

   METHOD Resource( nMode )
   METHOD   StartResource()                     VIRTUAL
   METHOD   lSaveResource()

END CLASS

//----------------------------------------------------------------------------//

METHOD New( cPath, oWndParent, nLevel )

   DEFAULT oWndParent   := GetWndFrame()
   DEFAULT nLevel       := "01104"

   ::Create( cPath )

   if Empty( ::nLevel )
      ::nLevel          := Auth():Level( nLevel )
   end if

   /*
   Cerramos todas las ventanas-------------------------------------------------
   */

   if oWndParent != nil
      oWndParent:CloseAll()
   end if

   ::cPath              := cPath
   ::oWndParent         := oWndParent

   ::lAutoButtons       := .t.
   ::lCreateShell       := .f.

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Create( cPath )

   DEFAULT cPath        := cPatEmp()

   ::cPath              := cPath
   ::oDbf               := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD DefineFiles( cPath, cDriver )

   DEFAULT cPath        := ::cPath
   DEFAULT cDriver      := cDriver()

   DEFINE DATABASE ::oDbf FILE "Proyecto.Dbf" CLASS "Proyecto" ALIAS "Proyecto" PATH ( cPath ) VIA ( cDriver ) COMMENT getConfigTraslation( "Proyectos" )

      FIELD NAME "cCodPry"  TYPE "C" LEN  4  DEC 0  COMMENT "Código"                               COLSIZE 80  OF ::oDbf
      FIELD NAME "cNomPry"  TYPE "C" LEN 30  DEC 0  COMMENT "Nombre"                               COLSIZE 200 OF ::oDbf
      FIELD NAME "cCodPdr"  TYPE "C" LEN  4  DEC 0  COMMENT "Grupo padre"                          HIDE        OF ::oDbf
      FIELD NAME "cSerPry"  TYPE "C" LEN 30  DEC 0  COMMENT "Número serie"                         COLSIZE 200 OF ::oDbf
      FIELD NAME "cSitPry"  TYPE "C" LEN 30  DEC 0  COMMENT "Situación"                            COLSIZE 200 OF ::oDbf
      FIELD NAME "dFecPry"  TYPE "D" LEN  8  DEC 0  COMMENT "Fecha compra"                         COLSIZE 80  OF ::oDbf
      FIELD NAME "nComPry"  TYPE "N" LEN 16  DEC 6  COMMENT "Precio compra"   PICTURE cPorDiv()    HIDE        OF ::oDbf
      FIELD NAME "nCosPry"  TYPE "N" LEN 16  DEC 6  COMMENT "Costo dia"       PICTURE cPorDiv()    HIDE        OF ::oDbf

      INDEX TO "Proyecto.Cdx" TAG "cCodPry" ON "cCodPry"   COMMENT "Código"        NODELETED                   OF ::oDbf
      INDEX TO "Proyecto.Cdx" TAG "cNomPry" ON "cNomPry"   COMMENT "Nombre"        NODELETED                   OF ::oDbf
      INDEX TO "Proyecto.Cdx" TAG "cCodPdr" ON "cCodPdr"   COMMENT "Grupo padre"   NODELETED                   OF ::oDbf

   END DATABASE ::oDbf

RETURN ( ::oDbf )

//----------------------------------------------------------------------------//

METHOD Resource( nMode )

	local oDlg

   DEFINE DIALOG oDlg RESOURCE "Proyecto" TITLE LblTitle( nMode ) + getConfigTraslation( "Proyecto" )

      REDEFINE GET ::oGetCodigo ;
         VAR      ::oDbf:cCodPry ;
			ID 		100 ;
         WHEN     ( nMode == APPD_MODE .or. nMode == DUPL_MODE ) ;
         VALID    NotValid( ::oGetCodigo, ::oDbf:cAlias, .t., "0" ) ;
			PICTURE 	"@!" ;
			OF 		oDlg

      REDEFINE GET ::oGetNombre ;
         VAR      ::oDbf:cNomPry ;
			ID 		110 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
			OF 		oDlg

      REDEFINE GET ::oDbf:cSerPry ;
         ID       120 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE COMBOBOX ::oDbf:cSitPry ;
         ID       130 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ITEMS    ( SQLSituacionesModel():getArrayNombres() ) ;
         OF       oDlg

      REDEFINE GET ::oDbf:dFecPry ;
         SPINNER ;
         ID       140 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET ::oDbf:nComPry ;
         ID       150 ;
         PICTURE  ( cPorDiv() ) ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET ::oDbf:nCosPry ;
         ID       160 ;
         PICTURE  ( cPorDiv() ) ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      /*
      Creamos los botones------------------------------------------------------
      */

      REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( ::lSaveResource( nMode, oDlg ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
         CANCEL ;
			ACTION 	( oDlg:end() )

   oDlg:AddFastKey( VK_F5, {|| ::lSaveResource( nMode, oDlg ) } )

   oDlg:bStart          := {|| ::StartResource() }

	ACTIVATE DIALOG oDlg	CENTER

RETURN ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

Method lSaveResource( nMode, oDlg )

   local aGrp

   ::oDbf:cCodPdr    := Space( 4 )

   if ( nMode == APPD_MODE .or. nMode == DUPL_MODE )

      if Empty( ::oDbf:cCodPry )
         MsgStop( "Código de " + getConfigTraslation( "Proyecto" ) + " no puede estar vacío" )
         ::oGetCodigo:SetFocus()
         Return nil
      end if

      if ::oDbf:SeekInOrd( ::oDbf:cCodPry, "cCodPry" )
         msgStop( "Código existente" )
         ::oGetCodigo:SetFocus()
         Return nil
      end if

   end if

   if Empty( ::oDbf:cNomPry )
      MsgStop( "Nombre de "+ getConfigTraslation( "Proyecto" ) + " no puede estar vacío" )
      ::oGetNombre:SetFocus()
      Return nil
   end if

Return oDlg:end( IDOK )

//---------------------------------------------------------------------------//

