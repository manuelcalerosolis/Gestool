#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//--------------------------------------------------------------------------//

CLASS TpvOrdenesMenu FROM TDet

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
   DEFAULT cFileName    := "TpvOrdMnu"
   DEFAULT cVia         := cDriver()

   if lUniqueName
      cFileName         := cGetNewFileName( cFileName, , , cPath )
   end if

   DEFINE TABLE oDbf FILE ( cFileName ) CLASS ( cFileName ) ALIAS ( cFileName ) PATH ( cPath ) VIA ( cVia ) COMMENT "ordenes menu"

      FIELD NAME "cCodMnu" TYPE "C" LEN 03  DEC 0 COMMENT "Código menu"                    OF oDbf
      FIELD NAME "cCodOrd" TYPE "C" LEN 02  DEC 0 COMMENT "Código orden"                   OF oDbf

      INDEX TO ( cFileName ) TAG "cCodMnu" ON "cCodMnu + cCodOrd"                NODELETED OF oDbf
      INDEX TO ( cFileName ) TAG "cCodOrd" ON "cCodOrd"                          NODELETED OF oDbf

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

      lOpen             := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//--------------------------------------------------------------------------//

METHOD CloseFiles()

   msgAlert( "CloseFiles")

   if !empty( ::oDbf ) .and. ::oDbf:Used()
      ::oDbf:End()
      ::oDbf            := nil
   end if

RETURN .t.

//--------------------------------------------------------------------------//

METHOD Resource( nMode )

   local oDlg
   local oGetOrd

   // Caja de dialogo-------------------------------------------------------------

   DEFINE DIALOG oDlg RESOURCE "OrdenComanda" 


      REDEFINE GET   oGetOrd ;
         VAR         ::oDbfVir:cCodOrd ;
         BITMAP      "Lupa" ;
         ID          100 ;
         IDTEXT      101 ;
         WHEN        ( nMode != ZOOM_MODE ) ;
         OF          oDlg

      oGetOrd:bValid    := {|| ::oParent:oOrdenComandas:Existe( oGetOrd, oGetOrd:oHelpText ) }
      oGetOrd:bHelp     := {|| ::oParent:oOrdenComandas:Buscar( oGetOrd ) }

      // Botones------------------------------------------------------------------

      REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( ::lPreSave( oDlg ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
			ACTION 	( oDlg:end() )

      if nMode != ZOOM_MODE
         oDlg:AddFastKey( VK_F5, {|| ::lPreSave( oDlg ) } )
      end if

   ACTIVATE DIALOG oDlg CENTER

RETURN ( oDlg:nResult == IDOK )

//----------------------------------------------------------------------------//

METHOD lPreSave( oDlg )

   local lPreSave    := .t.

   if Empty( ::oDbfVir:cCodOrd )
      MsgStop( "Código del orden no puede estar vacio" )
      Return ( .f. )
   end if

   ::oDbfVir:GetStatus()

   if ::oDbfVir:SeekInOrd( ::oDbfVir:cCodOrd, "cCodOrd" )
      MsgStop( "El orden ya esta añadido" )
      lPreSave    := .f.
   end if

   ::oDbfVir:SetStatus()

   if lPreSave
      oDlg:End( IDOK )
   end if 

RETURN ( lPreSave )

//----------------------------------------------------------------------------//

METHOD PreSaveDetails()

   ::oDbfVir:cCodMnu  := ::oParent:oDbf:cCodMnu

RETURN ( Self )

//--------------------------------------------------------------------------//

