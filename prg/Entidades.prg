#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//----------------------------------------------------------------------------//

CLASS TEntidades FROM TMant

   DATA   cMru       INIT "School_16"
   DATA   cBitmap    INIT clrTopExpedientes

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

   DEFINE TABLE oDbf FILE "Entidades.Dbf" CLASS "Entidades" ALIAS "Entidades" PATH ( cPath ) VIA ( cDriver ) COMMENT "Entidades"

      FIELD NAME "cCodEnt"       TYPE "C" LEN 14  DEC 0 COMMENT "Código"                     COLSIZE 100    OF oDbf
      FIELD NAME "cDesEnt"       TYPE "C" LEN 60  DEC 0 COMMENT "Descripción"                COLSIZE 400    OF oDbf
      FIELD NAME "cNombre"       TYPE "C" LEN 60  DEC 0 COMMENT "Nombre"                     COLSIZE 400    OF oDbf
      FIELD NAME "cGLNFisico"    TYPE "C" LEN 60  DEC 0 COMMENT "GLN físico"                 COLSIZE 400    OF oDbf
      FIELD NAME "cPuntoLogico"  TYPE "C" LEN 60  DEC 0 COMMENT "Punto lógico operacional"   COLSIZE 400    OF oDbf
      FIELD NAME "cDireccion"    TYPE "C" LEN 160 DEC 0 COMMENT "Dirección"                  COLSIZE 400    OF oDbf
      FIELD NAME "cCodigoPostal" TYPE "C" LEN 15  DEC 0 COMMENT "Código postal"              COLSIZE 400    OF oDbf
      FIELD NAME "cPoblacion"    TYPE "C" LEN 100 DEC 0 COMMENT "Población"                  COLSIZE 400    OF oDbf
      FIELD NAME "cProvincia"    TYPE "C" LEN 100 DEC 0 COMMENT "Provincia"                  COLSIZE 400    OF oDbf
      FIELD NAME "cPais"         TYPE "C" LEN 100 DEC 0 COMMENT "País"                       COLSIZE 400    OF oDbf
      FIELD NAME "cTelefono"     TYPE "C" LEN 20  DEC 0 COMMENT "Teléfono"                   COLSIZE 400    OF oDbf
      FIELD NAME "cWeb"          TYPE "C" LEN 200 DEC 0 COMMENT "Web"                        COLSIZE 400    OF oDbf
      FIELD NAME "cMail"         TYPE "C" LEN 100 DEC 0 COMMENT "Correo electrónico"         COLSIZE 400    OF oDbf
      FIELD NAME "cContacto"     TYPE "C" LEN 200 DEC 0 COMMENT "Contacto"                   COLSIZE 400    OF oDbf
      FIELD NAME "cCodigoINE"    TYPE "C" LEN 20  DEC 0 COMMENT "Código INE"                 COLSIZE 400    OF oDbf
      FIELD NAME "cCNOCNAE"      TYPE "C" LEN 20  DEC 0 COMMENT "CNO/CNAE"                   COLSIZE 400    OF oDbf
      FIELD NAME "cOtros"        TYPE "C" LEN 200 DEC 0 COMMENT "Otros"                      COLSIZE 400    OF oDbf

      INDEX TO "Entidades.Cdx" TAG "cCodEnt" ON "cCodEnt" COMMENT "Código" NODELETED OF oDbf
      INDEX TO "Entidades.Cdx" TAG "cDesEnt" ON "cDesEnt" COMMENT "Nombre" NODELETED OF oDbf

   END DATABASE oDbf

RETURN ( oDbf )

//----------------------------------------------------------------------------//

METHOD Resource( nMode )

   local oDlg
   local oGet

   DEFINE DIALOG oDlg RESOURCE "Horas" TITLE LblTitle( nMode ) + "entidades"

      REDEFINE GET oGet VAR ::oDbf:cCodEnt ;
         ID       110 ;
         WHEN     ( nMode == APPD_MODE ) ;
         VALID    NotValid( oGet, ::oDbf:cAlias ) ;
			PICTURE 	"@!" ;
			OF 		oDlg

      REDEFINE GET ::oDbf:cDesEnt ;
         ID       120 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
			OF 		oDlg

      REDEFINE GET ::oDbf:cNombre ;
         ID       130 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET ::oDbf:cGLNFisico ;
         ID       140 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET ::oDbf:cPuntoLogico ;
         ID       150 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET ::oDbf:cDireccion ;
         ID       160 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET ::oDbf:cCodigoPostal ;
         ID       170 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET ::oDbf:cPoblacion ;
         ID       180 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET ::oDbf:cProvincia ;
         ID       190 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET ::oDbf:cPais ;
         ID       200 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET ::oDbf:cTelefono ;
         ID       210 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET ::oDbf:cWeb ;
         ID       220 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET ::oDbf:cMail ;
         ID       230 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET ::oDbf:cContacto ;
         ID       240 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET ::oDbf:cCodigoINE ;
         ID       250 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET ::oDbf:cCNOCNAE ;
         ID       260 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET ::oDbf:cOtros ;
         ID       270 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

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

      if ::oDbf:SeekInOrd( ::oDbf:cCodEnt, "cCodEnt" )
         MsgStop( "Código ya existe " + Rtrim( ::oDbf:cCodEnt ) )
         Return .f.
      end if

   end if

   if Empty( ::oDbf:cDesEnt )
      MsgStop( "La descripción de la entidad no puede estar vacía." )
      Return .f.
   end if

RETURN .t.

//--------------------------------------------------------------------------//