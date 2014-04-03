#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//--------------------------------------------------------------------------//

CLASS TpvMenuArticulo FROM TDet

   METHOD DefineFiles()

   METHOD OpenFiles( lExclusive )

   METHOD CloseFiles()

   METHOD Resource( nMode, lLiteral )

   METHOD lPreSave()

   METHOD PreSaveDetails()

END CLASS

//--------------------------------------------------------------------------//

METHOD DefineFiles( cPath, cVia, lUniqueName, cFileName )

   local oDbf

   DEFAULT cPath        := ::cPath
   DEFAULT lUniqueName  := .f.
   DEFAULT cFileName    := "TpvMnuArt"
   DEFAULT cVia         := cDriver()

   if lUniqueName
      cFileName         := cGetNewFileName( cFileName, , , cPath )
   end if

   DEFINE TABLE oDbf FILE ( cFileName ) CLASS ( cFileName ) ALIAS ( cFileName ) PATH ( cPath ) VIA ( cVia ) COMMENT "ordenes menu"

      FIELD NAME "cCodMnu" TYPE "C" LEN 03  DEC 0 COMMENT "Código menu"                    OF oDbf
      FIELD NAME "cCodOrd" TYPE "C" LEN 02  DEC 0 COMMENT "Código orden"                   OF oDbf
      FIELD NAME "cCodArt" TYPE "C" LEN 18  DEC 0 COMMENT "Código artículo"                OF oDbf

      INDEX TO ( cFileName ) TAG "cCodMnu" ON "cCodMnu"                          NODELETED OF oDbf
      INDEX TO ( cFileName ) TAG "cCodOrd" ON "cCodOrd"                          NODELETED OF oDbf
      INDEX TO ( cFileName ) TAG "cCodArt" ON "cCodArt"                          NODELETED OF oDbf
      INDEX TO ( cFileName ) TAG "cMnuOrd" ON "cCodMnu + cCodOrd + cCodArt"      NODELETED OF oDbf

   END DATABASE oDbf

RETURN ( oDbf )

//--------------------------------------------------------------------------//

METHOD OpenFiles( lExclusive )

   local lOpen             := .t.
   local oError
   local oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   DEFAULT  lExclusive     := .f.

   BEGIN SEQUENCE

      if Empty( ::oDbf )
         ::oDbf            := ::DefineFiles()
      end if

      ::oDbf:Activate( .f., !lExclusive )

      ::bOnPreSaveDetail   := {|| ::PreSaveDetails() }

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Imposible abrir todas las bases de datos" )

      ::CloseFiles()

      lOpen                := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//--------------------------------------------------------------------------//

METHOD CloseFiles()

   if !empty( ::oDbf ) .and. ::oDbf:Used()
      ::oDbf:End()
      ::oDbf            := nil
   end if

RETURN .t.

//--------------------------------------------------------------------------//

METHOD Resource( nMode )

   local oDlg
   local oGetCodigoArticulo

   msgAlert( ::oParent:oDetOrdenesMenu:oDbfVir:cCodOrd, "Resource de TpvMenuArticulo")

   if ::nMode == APPD_MODE
      ::oDbfVir:cCodOrd := ::oParent:oDetOrdenesMenu:cScopeValue
   end if

   // Caja de dialogo-------------------------------------------------------------

   DEFINE DIALOG oDlg RESOURCE "TpvMenuArticulo" 

      REDEFINE GET   oGetCodigoArticulo ;
         VAR         ::oDbfVir:cCodArt ;
         BITMAP      "Lupa" ;
         ID          100 ;
         IDTEXT      101 ;
         WHEN        ( nMode != ZOOM_MODE ) ;
         OF          oDlg

      oGetCodigoArticulo:bValid  := {|| cArticulo( oGetCodigoArticulo, ::oParent:oDbfArticulo:cAlias, oGetCodigoArticulo:oHelpText ) }
      oGetCodigoArticulo:bHelp   := {|| BrwArticulo( oGetCodigoArticulo, oGetCodigoArticulo:oHelpText ) }

      // Botones------------------------------------------------------------------

      REDEFINE BUTTON ;
         ID          IDOK ;
			OF          oDlg ;
         WHEN        ( nMode != ZOOM_MODE ) ;
         ACTION      ( ::lPreSave( oDlg ) )

		REDEFINE BUTTON ;
         ID          IDCANCEL ;
			OF          oDlg ;
			ACTION      ( oDlg:end() )

      if nMode != ZOOM_MODE
         oDlg:AddFastKey( VK_F5, {|| ::lPreSave( oDlg ) } )
      end if

   ACTIVATE DIALOG oDlg CENTER

RETURN ( oDlg:nResult == IDOK )

//----------------------------------------------------------------------------//

METHOD lPreSave( oDlg )

   if Empty( ::oDbfVir:cCodArt )
      MsgStop( "Código del artículo no puede estar vacio" )
      Return ( .f. )
   end if

   if ::oDbfVir:SeekInOrd( ::oDbfVir:cCodArt, "cCodArt" )
      MsgStop( "El artículo ya esta añadido" )
      Return ( .f. )
   end if

RETURN ( oDlg:End( IDOK ) )

//----------------------------------------------------------------------------//

METHOD PreSaveDetails()

    msgAlert( ::oParent:oDbf:cCodMnu, "PreSaveDetails TpvMenuArticulo" )

   ::oDbfVir:cCodMnu                               := ::oParent:oDbf:cCodMnu

   // ::oDbfVir:cCodMnu    := ::oDbf:cCodMnu
   // ::oDbfVir:cCodOrd    := ::oParent:oDetOrdenesMenu:oDbfVir:cCodOrd

RETURN ( Self )

//--------------------------------------------------------------------------//

