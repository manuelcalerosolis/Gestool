#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Menu.ch"
#include "Report.ch"
#include "MesDbf.ch"

//--------------------------------------------------------------------------//

CLASS THisFacAutomatica FROM TDet

   METHOD DefineFiles()

   METHOD OpenFiles( lExclusive )

   METHOD OpenService( lExclusive )

   METHOD CloseFiles()

   METHOD CloseService()

END CLASS

//--------------------------------------------------------------------------//

METHOD DefineFiles( cPath, cVia, lUniqueName, cFileName )

   local oDbf

   DEFAULT cPath        := ::cPath
   DEFAULT lUniqueName  := .f.
   DEFAULT cFileName    := "FacAutI"
   DEFAULT cVia         := cDriver()

   if lUniqueName
      cFileName         := cGetNewFileName( cFileName, , , cPath )
   end if

   DEFINE TABLE oDbf FILE ( cFileName ) CLASS ( cFileName ) ALIAS ( cFileName ) PATH ( cPath ) VIA ( cVia ) COMMENT "líneas de plantillas de ventas automáticas"

      FIELD NAME "cCodFac"    TYPE "C" LEN  03 DEC 0 COMMENT "Código"                           OF oDbf
      FIELD NAME "dFecha"     TYPE "D" LEN  08 DEC 0 COMMENT "Fecha de creación"                OF oDbf
      FIELD NAME "cHora"      TYPE "C" LEN  05 DEC 2 COMMENT "Hora de creación"                 OF oDbf
      FIELD NAME "cFichero"   TYPE "C" LEN 255 DEC 0 COMMENT "Fichero con el resultado"         OF oDbf

      INDEX TO ( cFileName ) TAG "cCodFac"   ON "cCodFac"                             NODELETED OF oDbf

   END DATABASE oDbf

RETURN ( oDbf )

//--------------------------------------------------------------------------//

METHOD OpenFiles( lExclusive, cPath )

   local lOpen             := .t.
   local oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   DEFAULT  lExclusive     := .f.

   BEGIN SEQUENCE

      if Empty( ::oDbf )
         ::oDbf            := ::DefineFiles( cPath )
      end if

      ::oDbf:Activate( .f., !lExclusive )

   RECOVER

      lOpen                := .f.
      
      ::CloseFiles()
      
      msgStop( "Imposible abrir todas las bases de datos" )

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//--------------------------------------------------------------------------//

METHOD OpenService( lExclusive, cPath )

   local lOpen          := .t.
   local oError
   local oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   DEFAULT lExclusive   := .f.

   BEGIN SEQUENCE

      if Empty( ::oDbf )
         ::oDbf         := ::DefineFiles( cPath )
      end if

      ::oDbf:Activate( .f., !lExclusive )

   RECOVER USING oError

      lOpen             := .f.

      ::CloseService()

      msgStop( "Imposible abrir todas las bases de datos" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles()

   if ::oDbf != nil .and. ::oDbf:Used()
      ::oDbf:End()
   end if

   ::oDbf         := nil

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD CloseService()

   if ::oDbf != nil .and. ::oDbf:Used()
      ::oDbf:End()
   end if

   ::oDbf   := nil

RETURN ( .t. )

//---------------------------------------------------------------------------//