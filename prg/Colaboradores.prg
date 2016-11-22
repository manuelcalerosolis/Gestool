#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//----------------------------------------------------------------------------//

CLASS TColaboradores FROM TMant

   DATA   cMru       INIT "gc_users_relation_16"
   DATA   cBitmap    INIT Rgb( 197, 227, 9 )

   METHOD OpenFiles( lExclusive )

   METHOD DefineFiles()

   METHOD Resource( nMode )

   METHOD lPreSave( nMode )

END CLASS

//---------------------------------------------------------------------------//

METHOD OpenFiles( lExclusive )

   local lOpen          := .t.
   local oError
   local oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   DEFAULT  lExclusive  := .f.

   BEGIN SEQUENCE

      if Empty( ::oDbf )
         ::oDbf         := ::DefineFiles()
      end if

      ::oDbf:Activate( .f., !( lExclusive ) )

   RECOVER USING oError
      
      lOpen          := .f.

      ::CloseFiles()
      
      msgStop( "Imposible abrir todas las bases de datos" + CRLF + ErrorMessage( oError )  )

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//----------------------------------------------------------------------------//

METHOD DefineFiles( cPath, cDriver )

   local oDbf

   DEFAULT cPath        := ::cPath
   DEFAULT cDriver      := cDriver()

   DEFINE TABLE oDbf FILE "Colaboradores.Dbf" CLASS "Colaboraores" ALIAS "Colabora" PATH ( cPath ) VIA ( cDriver ) COMMENT "Colaboradores"

      FIELD NAME "cCodCol"    TYPE "C" LEN  3  DEC 0 COMMENT "Código"      COLSIZE 100    OF oDbf
      FIELD NAME "cDesCol"    TYPE "C" LEN 35  DEC 0 COMMENT "Nombre"      COLSIZE 400    OF oDbf

      INDEX TO "Colaboradores.Cdx" TAG "cCodCol" ON "cCodCol" COMMENT "Código" NODELETED  OF oDbf
      INDEX TO "Colaboradores.Cdx" TAG "cDesCol" ON "cDesCol" COMMENT "Nombre" NODELETED  OF oDbf

   END DATABASE oDbf

RETURN ( oDbf )

//----------------------------------------------------------------------------//

METHOD Resource( nMode )

   local oDlg
   local oGet

   DEFINE DIALOG oDlg RESOURCE "Horas" TITLE LblTitle( nMode ) + "colaboradores"

      REDEFINE GET oGet VAR ::oDbf:cCodCol ;
         ID       110 ;
         WHEN     ( nMode == APPD_MODE ) ;
         VALID    NotValid( oGet, ::oDbf:cAlias, .t., "0" ) ;
			PICTURE 	"@!" ;
			OF 		oDlg

      REDEFINE GET ::oDbf:cDesCol ;
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

      if ::oDbf:SeekInOrd( ::oDbf:cCodCol, "cCodCol" )
         MsgStop( "Código ya existe " + Rtrim( ::oDbf:cCodCol ) )
         Return .f.
      end if

   end if

   if Empty( ::oDbf:cDesCol )
      MsgStop( "La descripción del colaborador no puede estar vacía." )
      Return .f.
   end if

RETURN .t.

//--------------------------------------------------------------------------//