#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Menu.ch"
#include "Report.ch"
#include "MesDbf.ch"

//--------------------------------------------------------------------------//

CLASS TDetComentarios FROM TDet

   METHOD Create( cPath )

   METHOD DefineFiles()

   METHOD OpenFiles( lExclusive )

   METHOD CloseFiles()

   METHOD Resource( nMode, lLiteral )

   METHOD Reindexa()

END CLASS

//--------------------------------------------------------------------------//

METHOD DefineFiles( cPath, cVia, lUniqueName, cFileName )

   local oDbf

   DEFAULT cPath        := ::cPath
   DEFAULT lUniqueName  := .f.
   DEFAULT cFileName    := "ComentariosL"
   DEFAULT cVia         := cDriver()

   if lUniqueName
      cFileName         := cGetNewFileName( cFileName, , , cPath )
   end if

   DEFINE TABLE oDbf FILE ( cFileName ) CLASS ( cFileName ) ALIAS "ComentL" PATH ( cPath ) VIA ( cVia ) COMMENT "Comentarios"

      FIELD NAME  "cCodigo"   TYPE "C" LEN    3 DEC 0 COMMENT  "Código"       COLSIZE  60 OF oDbf
      FIELD NAME  "cDescri"   TYPE "C" LEN  200 DEC 0 COMMENT  "Descripción"  COLSIZE 100 OF oDbf

      INDEX TO ( cFileName ) TAG "cCodigo"   ON "cCodigo"            NODELETED   OF oDbf
      INDEX TO ( cFileName ) TAG "cCodDes"   ON "cCodigo + cDescri"  NODELETED   OF oDbf

   END DATABASE oDbf

RETURN ( oDbf )

//--------------------------------------------------------------------------//

METHOD Create( cPath )

   DEFAULT cPath        := cPatArt()

   ::cPath              := cPath

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD OpenFiles( lExclusive, cPath )

   local lOpen          := .t.
   local oError
   local oBlock         

   DEFAULT lExclusive   := .f.
   DEFAULT cPath        := ::cPath

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      if Empty( ::oDbf )
         ::oDbf         := ::DefineFiles( cPath )
      end if

      ::oDbf:Activate( .f., !lExclusive )

   RECOVER USING oError

      lOpen             := .f.

      ::CloseFiles()

      msgStop( ErrorMessage( oError ), "Imposible abrir las bases de datos de lineas de comentarios" )

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

//--------------------------------------------------------------------------//

METHOD Resource( nMode )

   local oDlg
   local oGetCod
   local oGetCos
   local oSayCos
   local cSayCos
   local lDis              := .f.

   ::oDbfVir:cCodigo       := ::oParent:odbf:cCodigo

   /*
   Caja de dialogo-------------------------------------------------------------
   */

   DEFINE DIALOG oDlg RESOURCE "ComentariosL"

      REDEFINE GET ::oDbfVir:cDescri ;
         ID       110 ;
         WHEN     ( nMode != ZOOM_MODE );
         OF       oDlg

      REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
         WHEN     ( nMode != ZOOM_MODE );
         ACTION   ( oDlg:end( IDOK ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
         CANCEL ;
         ACTION   ( oDlg:end() )

      if nMode != ZOOM_MODE
         oDlg:AddFastKey( VK_F5, {|| oDlg:end( IDOK ) } )
      end if

   ACTIVATE DIALOG oDlg CENTER

RETURN ( oDlg:nResult == IDOK )

//----------------------------------------------------------------------------//

METHOD Reindexa()

   /*
   Definicion del master-------------------------------------------------------
   */

   if Empty( ::oDbf )
      ::oDbf   := ::DefineFiles()
   end if

   ::oDbf:IdxFDel()

   if ::OpenFiles( .t. )
      ::oDbf:Pack()
   end if

   ::CloseFiles()

RETURN ( Self )

//---------------------------------------------------------------------------//