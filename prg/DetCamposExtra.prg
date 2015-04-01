#include "FiveWin.Ch"
#include "Report.ch"
#include "Xbrowse.ch"
#include "MesDbf.ch"
#include "Factu.ch" 
#include "FastRepH.ch"

//---------------------------------------------------------------------------//

CLASS TDetCamposExtra FROM TMant

   DATA oDbf
   DATA lOpenFiles         INIT .f.      

   Method New( cPath, oWndParent, oMenuItem )   CONSTRUCTOR

   Method DefineFiles()

   Method OpenFiles( lExclusive )
   Method CloseFiles()

   Method OpenService( lExclusive )
   Method CloseService()

   Method Reindexa( oMeter )

   Method Resource( nMode )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( cPath, oWndParent, oMenuItem ) CLASS TDetCamposExtra

   DEFAULT cPath           := cPatEmp()
   DEFAULT oWndParent      := oWnd()
   DEFAULT oMenuItem       := "01124"

   ::nLevel                := nLevelUsr( oMenuItem )

   ::cPath                 := cPath
   ::oWndParent            := oWndParent
   ::oDbf                  := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD DefineFiles( cPath, cDriver ) CLASS TDetCamposExtra

   DEFAULT cPath        := ::cPath
   DEFAULT cDriver      := cDriver()

   DEFINE DATABASE ::oDbf FILE "DETCAMPOEXTRA.DBF" CLASS "DETCAMPOEXTRA" ALIAS "DETCAMPOEXTRA" PATH ( cPath ) VIA ( cDriver ) COMMENT "Detalle campos extra"

      
      FIELD NAME "nTipDoc"       TYPE "N" LEN   2  DEC 0 COMMENT "Tipo documento"         HIDE           OF ::oDbf
      FIELD NAME "cCodTipo"      TYPE "C" LEN   3  DEC 0 COMMENT "Código"                 HIDE           OF ::oDbf
      FIELD NAME "cClave"        TYPE "C" LEN  20  DEC 0 COMMENT "Clave principal"        HIDE           OF ::oDbf
      FIELD NAME "cValor"        TYPE "C" LEN 250  DEC 0 COMMENT "Valor del campo"        HIDE           OF ::oDbf

      INDEX TO "DETCAMPOEXTRA.Cdx" TAG "nTipDoc"   ON "nTipDoc"   COMMENT "nTipDoc"        NODELETED OF ::oDbf
      INDEX TO "DETCAMPOEXTRA.Cdx" TAG "cCodTipo"  ON "cCodTipo"  COMMENT "cCodTipo"       NODELETED OF ::oDbf
      INDEX TO "DETCAMPOEXTRA.Cdx" TAG "cClave"    ON "cClave"    COMMENT "cClave"         NODELETED OF ::oDbf

   END DATABASE ::oDbf

RETURN ( ::oDbf )

//---------------------------------------------------------------------------//

METHOD OpenFiles( lExclusive ) CLASS TDetCamposExtra

   local oError
   local oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   DEFAULT lExclusive         := .f.

   BEGIN SEQUENCE

   if !::lOpenFiles

      if Empty( ::oDbf )
         ::DefineFiles()
      end if

      ::oDbf:Activate( .f., !( lExclusive ) )

      ::lLoadDivisa()

      ::lOpenFiles         := .t.

   end if

   RECOVER USING oError

      ::lOpenFiles         := .f.

      msgStop( "Imposible abrir todas las bases de datos" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   if !::lOpenFiles
      ::CloseFiles()
   end if

RETURN ( ::lOpenFiles )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS TDetCamposExtra

   if ::oDbf != nil .and. ::oDbf:Used()
      ::oDbf:End()
   end if

   ::oDbf         := nil

   ::lOpenFiles   := .f.

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD OpenService( lExclusive, cPath ) CLASS TDetCamposExtra

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

      ::oDbf:Activate( .f., !( lExclusive ) )

   RECOVER USING oError

      lOpen             := .f.

      msgStop( ErrorMessage( oError ), "Imposible abrir todas las bases de datos" )

   END SEQUENCE

   ErrorBlock( oBlock )

   ::CloseFiles()

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseService() CLASS TDetCamposExtra

   if !Empty( ::oDbf ) .and. ::oDbf:Used()
      ::oDbf:End()
   end if

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD Reindexa() CLASS TDetCamposExtra

   if Empty( ::oDbf )
      ::oDbf      := ::DefineFiles()
   end if

   ::oDbf:IdxFDel()

   ::oDbf:Activate( .f., .t., .f. )

   ::oDbf:Pack()

   ::oDbf:End()

RETURN ( Self )

//--------------------------------------------------------------------------//

METHOD Resource() CLASS TDetCamposExtra

   MsgInfo( "Entro en el Recurso" )

   DEFINE DIALOG ::oDlg RESOURCE "EXTRA" TITLE "Campos extra"



   ACTIVATE DIALOG ::oDlg CENTER

Return ( ::oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//