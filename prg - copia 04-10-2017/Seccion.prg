#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//----------------------------------------------------------------------------//

CLASS TSeccion FROM TMant

   DATA  cMru     INIT "gc_worker_group_16"
   DATA  cBitmap  INIT clrTopProduccion

   METHOD OpenFiles( lExclusive )

   METHOD DefineFiles()

   METHOD Resource( nMode )

   METHOD lPreSave( nMode )

END CLASS

//----------------------------------------------------------------------------//

METHOD OpenFiles( lExclusive, cPath )

   local lOpen          := .t.
   local oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   DEFAULT lExclusive   := .f.

   BEGIN SEQUENCE

      if Empty( ::oDbf )
         ::oDbf         := ::DefineFiles( cPath )
      end if

      ::oDbf:Activate( .f., !( lExclusive ) )

   RECOVER

      lOpen             := .f.
      
      ::CloseFiles()
      
      msgStop( "Imposible abrir todas las bases de datos" )

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//----------------------------------------------------------------------------//

METHOD DefineFiles( cPath, cDriver )

   local oDbf

   DEFAULT cPath        := ::cPath
   DEFAULT cDriver      := ::cDriver

   DEFINE TABLE oDbf FILE "Seccion.Dbf" CLASS "Seccion" ALIAS "Seccion" PATH ( cPath ) VIA ( cDriver ) COMMENT "Secciones"

      FIELD NAME "cCodSec"    TYPE "C" LEN  3  DEC 0 COMMENT "Código" COLSIZE 100   OF oDbf
      FIELD NAME "cDesSec"    TYPE "C" LEN 35  DEC 0 COMMENT "Nombre" COLSIZE 400   OF oDbf

      INDEX TO "Seccion.Cdx" TAG "cCodSec" ON "cCodSec" COMMENT "Código" NODELETED  OF oDbf
      INDEX TO "Seccion.Cdx" TAG "cDesSec" ON "cDesSec" COMMENT "Nombre" NODELETED  OF oDbf

   END DATABASE oDbf

RETURN ( oDbf )

//----------------------------------------------------------------------------//

METHOD Resource( nMode )

	local oDlg
   local oGet

   DEFINE DIALOG oDlg RESOURCE "Seccion" TITLE LblTitle( nMode ) + "secciones"

      REDEFINE GET oGet VAR ::oDbf:cCodSec;
         ID       110 ;
         WHEN     ( nMode == APPD_MODE ) ;
         VALID    NotValid( oGet, ::oDbf:cAlias, .t., "0" ) ;
			PICTURE 	"@!" ;
			OF 		oDlg

      REDEFINE GET ::oDbf:cDesSec;
         ID       120 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
			OF 		oDlg

      REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( if( ::lPreSave( nMode ), oDlg:end( IDOK ), ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
         CANCEL ;
			ACTION 	( oDlg:end() )

      REDEFINE BUTTON ;
         ID       559 ;
			OF 		oDlg ;
         CANCEL ;
         ACTION   ( MsgInfo( "Ayuda no definida" ) )

   if nMode != ZOOM_MODE
      oDlg:AddFastKey( VK_F5, {|| if( ::lPreSave( nMode ), oDlg:end( IDOK ), ) } )
   end if

   oDlg:bStart    := { || oGet:SetFocus() }

   ACTIVATE DIALOG oDlg CENTER

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

METHOD lPreSave( nMode )

   if nMode == APPD_MODE .or. nMode == DUPL_MODE

      if ::oDbf:SeekInOrd( ::oDbf:cCodSec, "CCODSEC" )
         MsgStop( "Código ya existe " + Rtrim( ::oDbf:cCodSec ) )
         return .f.
      end if

   end if

   if Empty( ::oDbf:cDesSec )
      MsgStop( "La descripción de la sección no puede estar vacía." )
      Return .f.
   end if

Return .t.

//---------------------------------------------------------------------------//