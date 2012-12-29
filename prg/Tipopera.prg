#include "FiveWin.Ch"
#include "Factu.ch"
#include "MesDbf.ch"

//----------------------------------------------------------------------------//

CLASS TTipOpera FROM TMant

   DATA   cMru       INIT "Worker_Folder_Blue_16"
   DATA   cBitmap    INIT clrTopProduccion

   METHOD OpenFiles( lExclusive )

   METHOD OpenService( lExclusive )

   METHOD DefineFiles()

   METHOD Resource( nMode )

   METHOD lPreSave( nMode )

END CLASS

//---------------------------------------------------------------------------//

METHOD OpenService( lExclusive )

   local lOpen          := .t.
   local oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   DEFAULT  lExclusive  := .f.

   BEGIN SEQUENCE

      if Empty( ::oDbf )
         ::DefineFiles()
      end if

      ::oDbf:Activate( .f., !( lExclusive ) )

   RECOVER

      msgStop( "Imposible abrir todas las bases de datos" )
      ::CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD OpenFiles( lExclusive )

   local lOpen          := .t.
   local oError
   local oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   DEFAULT  lExclusive  := .f.

   BEGIN SEQUENCE

   if Empty( ::oDbf )
      ::DefineFiles()
   end if

   ::oDbf:Activate( .f., !( lExclusive ) )

   RECOVER USING oError

      msgStop( "Imposible abrir todas las bases de datos" + CRLF + ErrorMessage( oError )  )
      ::CloseFiles()
      lOpen          := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//----------------------------------------------------------------------------//

METHOD DefineFiles( cPath, cDriver )

   DEFAULT cPath        := ::cPath
   DEFAULT cDriver      := cDriver()

   DEFINE TABLE ::oDbf FILE "TipOpera.Dbf" CLASS "TipOpera" ALIAS "TipOpera" PATH ( cPath ) VIA ( cDriver )COMMENT "Tipos de operaciones"

      FIELD NAME "cCodTip"    TYPE "C" LEN  3  DEC 0 COMMENT "Código"      COLSIZE 100          OF ::oDbf
      FIELD NAME "cDesTip"    TYPE "C" LEN 35  DEC 0 COMMENT "Nombre"      COLSIZE 400          OF ::oDbf

      INDEX TO "TipOpera.Cdx" TAG "cCodTip" ON "cCodTip" COMMENT "Código" NODELETED OF ::oDbf
      INDEX TO "TipOpera.Cdx" TAG "cDesTip" ON "cDesTip" COMMENT "Nombre" NODELETED OF ::oDbf

   END DATABASE ::oDbf

RETURN ( ::oDbf )

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

   oDlg:bStart := { || oGet:SetFocus() }

	ACTIVATE DIALOG oDlg	CENTER

RETURN ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

METHOD lPreSave( nMode )

   if nMode == APPD_MODE .or. nMode == DUPL_MODE

      if ::oDbf:SeekInOrd( ::oDbf:cCodTip, "CCODTIP" )
         MsgStop( "Código ya existe " + Rtrim( ::oDbf:cCodTip ) )
         return .f.
      end if

   end if

   if Empty( ::oDbf:cDesTip )
      MsgStop( "La descripción del tipo de operación no puede estar vacía." )
      Return .f.
   end if

RETURN .t.

//--------------------------------------------------------------------------//