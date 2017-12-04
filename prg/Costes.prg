#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//----------------------------------------------------------------------------//

CLASS TCosMaq FROM TMant

   DATA  cMru     INIT "gc_industrial_robot_money_16"
   
   DATA  cBitmap  INIT clrTopProduccion

   METHOD OpenFiles( lExclusive )

   METHOD CloseFiles()

   METHOD DefineFiles()

   METHOD Resource( nMode )

   Method lPreSave( oGet, nMode )

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
   DEFAULT cDriver      := cDriver()

   DEFINE TABLE oDbf FILE "Costes.Dbf" CLASS "Costes" ALIAS "Costes" PATH ( cPath ) VIA ( cDriver ) COMMENT "Costes de maquinaria"

      FIELD NAME "cCodCos"    TYPE "C" LEN 12  DEC 0 COMMENT "Código"   COLSIZE 100   OF oDbf
      FIELD NAME "cDesCos"    TYPE "C" LEN 35  DEC 0 COMMENT "Nombre"   COLSIZE 400   OF oDbf
      FIELD NAME "nImpCos"    TYPE "N" LEN 16  DEC 6 COMMENT "Importe"  COLSIZE 100   PICTURE cPouDiv() ALIGN RIGHT   OF oDbf

      INDEX TO "Costes.Cdx" TAG "cCodCos" ON "cCodCos" COMMENT "Código" NODELETED     OF oDbf
      INDEX TO "Costes.Cdx" TAG "cDesCos" ON "cDesCos" COMMENT "Nombre" NODELETED     OF oDbf

   END DATABASE oDbf

RETURN ( oDbf )

//----------------------------------------------------------------------------//

METHOD Resource( nMode )

	local oDlg
   local oGet

   DEFINE DIALOG oDlg RESOURCE "CostesMaquina" TITLE LblTitle( nMode ) + "costes de maquinaria"

      REDEFINE GET oGet VAR ::oDbf:cCodCos;
         ID       110 ;
         WHEN     ( nMode == APPD_MODE ) ;
         VALID    NotValid( oGet, ::oDbf:cAlias ) ;
			PICTURE 	"@!" ;
			OF 		oDlg

      REDEFINE GET ::oDbf:cDesCos;
         ID       120 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
			OF 		oDlg

      REDEFINE GET ::oDbf:nImpCos;
         ID       130 ;
         PICTURE  ( cPouDiv() ) ;
         WHEN     ( nMode != ZOOM_MODE ) ;
			OF 		oDlg

      REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( if( ::lPreSave( oGet, nMode ), oDlg:end( IDOK ), ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
         CANCEL ;
			ACTION 	( oDlg:end() )

   if nMode != ZOOM_MODE
      oDlg:AddFastKey( VK_F5, {|| if( ::lPreSave( oGet, nMode ), oDlg:end( IDOK ), ) } )
   end if

   oDlg:bStart := { || oGet:SetFocus() }

   ACTIVATE DIALOG oDlg CENTER

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

METHOD lPreSave( oGet, nMode )

   if nMode == APPD_MODE .or. nMode == DUPL_MODE
      if Empty( ::oDbf:cCodCos )
         MsgStop( "Código del coste no puede estar vacío" )
         oGet:SetFocus()
         Return .f.
      end if

      if ::oDbf:SeekInOrd( ::oDbf:cCodCos, "CCODCOS" )
         msgStop( "Código existente" )
         oGet:SetFocus()
         return .f.
      end if
   end if

   if Empty( ::oDbf:cDesCos )
      MsgStop( "La descripción del coste no puede estar vacía." )
      Return .f.
   end if

Return .t.

//---------------------------------------------------------------------------//