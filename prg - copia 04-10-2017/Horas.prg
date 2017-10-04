#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//----------------------------------------------------------------------------//

CLASS THoras FROM TMANT

   DATA  cMru     INIT "gc_worker2_clock_16"
   DATA  cBitmap  INIT clrTopProduccion

   METHOD OpenFiles( lExclusive )

   METHOD CloseFiles()

   METHOD DefineFiles()

   METHOD Resource( nMode )

   METHOD lPresave( nMode )

END CLASS

//----------------------------------------------------------------------------//

METHOD OpenFiles( lExclusive, cPath )

   local lOpen          := .t.
   local oError
   local oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   DEFAULT lExclusive   := .f.

   BEGIN SEQUENCE

      if Empty( ::oDbf )
         ::oDbf         := ::DefineFiles( cPath )
      end if

      ::oDbf:Activate( .f., !( lExclusive ) )

   RECOVER USING oError

      lOpen             := .f.

      ::CloseFiles()

      msgStop( ErrorMessage( oError ), "Imposible abrir todas las bases de datos" )

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//----------------------------------------------------------------------------//

METHOD CloseFiles()

   if !Empty( ::oDbf )
      ::oDbf:end()
   end if

   ::oDbf         := nil

RETURN .t.

//----------------------------------------------------------------------------//

METHOD DefineFiles( cPath, cDriver )

   local oDbf

   DEFAULT cPath        := ::cPath
   DEFAULT cDriver      := ::cDriver

   DEFINE TABLE oDbf FILE "Horas.Dbf" CLASS "Horas" ALIAS "Horas" PATH ( cPath ) VIA ( cDriver ) COMMENT "Tipos de horas"

      FIELD NAME "cCodHra"    TYPE "C" LEN  3  DEC 0 COMMENT "Código"   COLSIZE 100 OF oDbf
      FIELD NAME "cDesHra"    TYPE "C" LEN 35  DEC 0 COMMENT "Nombre"   COLSIZE 400 OF oDbf

      INDEX TO "Horas.Cdx" TAG "cCodHra" ON "cCodHra" COMMENT "Código"  NODELETED   OF oDbf
      INDEX TO "Horas.Cdx" TAG "cDesHra" ON "cDesHra" COMMENT "Nombre"  NODELETED   OF oDbf

   END DATABASE oDbf

RETURN ( oDbf )

//----------------------------------------------------------------------------//

METHOD Resource( nMode )

	local oDlg
   local oGet

   DEFINE DIALOG oDlg RESOURCE "Horas" TITLE LblTitle( nMode ) + "tipo de hora"

      REDEFINE GET oGet VAR ::oDbf:cCodHra;
         ID       110 ;
         WHEN     ( nMode == APPD_MODE ) ;
         VALID    NotValid( oGet, ::oDbf:cAlias, .t., "0" ) ;
			PICTURE 	"@!" ;
			OF 		oDlg

      REDEFINE GET ::oDbf:cDesHra;
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

//---------------------------------------------------------------------------//

METHOD lPreSave( nMode )

   if nMode == APPD_MODE .or. nMode == DUPL_MODE

      if ::oDbf:SeekInOrd( ::oDbf:cCodHra, "CCODHRA",  )
         MsgStop( "Código ya existe " + Rtrim( ::oDbf:cCodHra ) )
         return .f.
      end if

   end if

   if Empty( ::oDbf:cDesHra )
      MsgStop( "La descripción del tipo de hora no puede estar vacía." )
      Return .f.
   end if

Return .t.

//---------------------------------------------------------------------------//