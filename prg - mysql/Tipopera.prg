#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//----------------------------------------------------------------------------//

CLASS TTipOpera FROM TMant

   DATA   cMru       INIT "gc_folder_open_worker_16"
   DATA   cBitmap    INIT clrTopProduccion

   METHOD OpenFiles( lExclusive )

   METHOD DefineFiles()

   METHOD Resource( nMode )

   METHOD lPreSave( nMode )

END CLASS

//---------------------------------------------------------------------------//

METHOD OpenFiles( lExclusive, cPath )

   local lOpen          := .t.
   local oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   DEFAULT  lExclusive  := .f.

   BEGIN SEQUENCE

      if Empty( ::oDbf )
         ::oDbf         := ::DefineFiles( cPath )
      end if

      ::oDbf:Activate( .f., !( lExclusive ) )

   RECOVER

      lOpen             := .f.
      
      msgStop( "Imposible abrir todas las bases de datos" )
      
      ::CloseFiles()

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD DefineFiles( cPath, cDriver )

   local oDbf

   DEFAULT cPath        := ::cPath
   DEFAULT cDriver      := cDriver()

   DEFINE TABLE oDbf FILE "TipOpera.Dbf" CLASS "TipOpera" ALIAS "TipOpera" PATH ( cPath ) VIA ( cDriver ) COMMENT "Tipos de operaciones"

      FIELD NAME "cCodTip"    TYPE "C" LEN  3  DEC 0 COMMENT "Código"      COLSIZE 100          OF oDbf
      FIELD NAME "cDesTip"    TYPE "C" LEN 35  DEC 0 COMMENT "Nombre"      COLSIZE 400          OF oDbf

      INDEX TO "TipOpera.Cdx" TAG "cCodTip" ON "cCodTip" COMMENT "Código" NODELETED OF oDbf
      INDEX TO "TipOpera.Cdx" TAG "cDesTip" ON "cDesTip" COMMENT "Nombre" NODELETED OF oDbf

   END DATABASE oDbf

RETURN ( oDbf )

//----------------------------------------------------------------------------//

METHOD Resource( nMode )

   local oDlg
   local oGet

   DEFINE DIALOG oDlg RESOURCE "Horas" TITLE LblTitle( nMode ) + "tipo de operación"

      REDEFINE GET oGet VAR ::oDbf:cCodTip;
         ID       110 ;
         WHEN     ( nMode == APPD_MODE ) ;
         VALID    NotValid( oGet, ::oDbf:cAlias, .t., "0" ) ;
			PICTURE 	"@!" ;
			OF 		oDlg

      REDEFINE GET ::oDbf:cDesTip;
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

	ACTIVATE DIALOG oDlg	CENTER

RETURN ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

METHOD lPreSave( nMode )

   if ( nMode == APPD_MODE .or. nMode == DUPL_MODE ) .and. ::oDbf:SeekInOrd( ::oDbf:cCodTip, "cCodTip" )
      MsgStop( "Código ya existe " + Rtrim( ::oDbf:cCodTip ) )
      Return .f.
   end if

   if Empty( ::oDbf:cDesTip )
      MsgStop( "La descripción del tipo de operación no puede estar vacía." )
      Return .f.
   end if

RETURN .t.

//--------------------------------------------------------------------------//