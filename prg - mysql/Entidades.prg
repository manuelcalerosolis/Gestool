#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//----------------------------------------------------------------------------//

CLASS TEntidades FROM TMant

   DATA   cMru       INIT "gc_office_building2_16"
   DATA   cBitmap    INIT clrTopExpedientes

   METHOD OpenFiles( lExclusive )

   METHOD DefineFiles()

   METHOD Resource( nMode )

   METHOD lPreSave( nMode )

   METHOD getDireccion( id )     INLINE ( oRetFld( id, ::oDbf, "cDireccion" ) )
   METHOD getDescripcion( id )   INLINE ( oRetFld( id, ::oDbf, "cDesEnt"    ) )
   METHOD getNombre( id )        INLINE ( oRetFld( id, ::oDbf, "cNombre"    ) )
   METHOD getGLNFisico( id )     INLINE ( oRetFld( id, ::oDbf, "cGLNFisico" ) )
   METHOD getPntLogico( id )     INLINE ( oRetFld( id, ::oDbf, "cPntLogico" ) )
   METHOD getDireccion( id )     INLINE ( oRetFld( id, ::oDbf, "cDireccion" ) )
   METHOD getCodigoPostal( id )  INLINE ( oRetFld( id, ::oDbf, "cCodPostal" ) )
   METHOD getPoblacion( id )     INLINE ( oRetFld( id, ::oDbf, "cPoblacion" ) )
   METHOD getProvincia( id )     INLINE ( oRetFld( id, ::oDbf, "cProvincia" ) )
   METHOD getPais( id )          INLINE ( oRetFld( id, ::oDbf, "cPais"      ) )
   METHOD getCodigoPais( id )    INLINE ( getPaisCode( oRetFld( id, ::oDbf, "cPais" ) ) )
   METHOD getTelefono( id )      INLINE ( oRetFld( id, ::oDbf, "cTelefono"  ) )
   METHOD getWeb( id )           INLINE ( oRetFld( id, ::oDbf, "cWeb"       ) )
   METHOD getMail( id )          INLINE ( oRetFld( id, ::oDbf, "cMail"      ) )
   METHOD getContacto( id )      INLINE ( oRetFld( id, ::oDbf, "cContacto"  ) )
   METHOD getCodigoINE( id )     INLINE ( oRetFld( id, ::oDbf, "cCodigoINE" ) )
   METHOD getCNOCNAE( id )       INLINE ( oRetFld( id, ::oDbf, "cCNOCNAE"   ) )
   METHOD getOtros( id )         INLINE ( oRetFld( id, ::oDbf, "cOtros"     ) )

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
      FIELD NAME "cGLNFisico"    TYPE "C" LEN 60  DEC 0 COMMENT "GLN físico"                 HIDE           OF oDbf
      FIELD NAME "cPntLogico"    TYPE "C" LEN 60  DEC 0 COMMENT "Punto lógico operacional"   HIDE           OF oDbf
      FIELD NAME "cDireccion"    TYPE "C" LEN 160 DEC 0 COMMENT "Dirección"                  COLSIZE 400    OF oDbf
      FIELD NAME "cCodPostal"    TYPE "C" LEN 15  DEC 0 COMMENT "Código postal"              COLSIZE 100    OF oDbf
      FIELD NAME "cPoblacion"    TYPE "C" LEN 100 DEC 0 COMMENT "Población"                  COLSIZE 200    OF oDbf
      FIELD NAME "cProvincia"    TYPE "C" LEN 100 DEC 0 COMMENT "Provincia"                  COLSIZE 200    OF oDbf
      FIELD NAME "cPais"         TYPE "C" LEN 100 DEC 0 COMMENT "País"                       COLSIZE 200    OF oDbf
      FIELD NAME "cTelefono"     TYPE "C" LEN 20  DEC 0 COMMENT "Teléfono"                   HIDE           OF oDbf
      FIELD NAME "cWeb"          TYPE "C" LEN 200 DEC 0 COMMENT "Web"                        HIDE           OF oDbf
      FIELD NAME "cMail"         TYPE "C" LEN 100 DEC 0 COMMENT "Correo electrónico"         HIDE           OF oDbf
      FIELD NAME "cContacto"     TYPE "C" LEN 200 DEC 0 COMMENT "Contacto"                   HIDE           OF oDbf
      FIELD NAME "cCodigoINE"    TYPE "C" LEN 20  DEC 0 COMMENT "Código INE"                 HIDE           OF oDbf
      FIELD NAME "cCNOCNAE"      TYPE "C" LEN 20  DEC 0 COMMENT "CNO/CNAE"                   HIDE           OF oDbf
      FIELD NAME "cOtros"        TYPE "C" LEN 200 DEC 0 COMMENT "Otros"                      HIDE           OF oDbf

      INDEX TO "Entidades.Cdx" TAG "cCodEnt" ON "cCodEnt" COMMENT "Código"       NODELETED OF oDbf
      INDEX TO "Entidades.Cdx" TAG "cDesEnt" ON "cDesEnt" COMMENT "Descripción"  NODELETED OF oDbf

   END DATABASE oDbf

RETURN ( oDbf )

//----------------------------------------------------------------------------//

METHOD Resource( nMode )

   local oDlg
   local oGet

   DEFINE DIALOG oDlg RESOURCE "Entidades" TITLE LblTitle( nMode ) + "entidades"

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

      REDEFINE GET ::oDbf:cPntLogico ;
         ID       150 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET ::oDbf:cDireccion ;
         ID       160 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET ::oDbf:cCodPostal ;
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

      REDEFINE COMBOBOX ::oDbf:cPais ;
         ITEMS    aPaisesValues();
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

   if nMode != ZOOM_MODE
      oDlg:AddFastKey( VK_F5, {|| if( ::lPreSave( nMode ), oDlg:end( IDOK ), ) } )
   end if

   oDlg:bStart := { || oGet:SetFocus() }

	ACTIVATE DIALOG oDlg	CENTER

RETURN ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

METHOD lPreSave( nMode )

   local cErrors  := ""

   if ( nMode == APPD_MODE .or. nMode == DUPL_MODE )
      if ::oDbf:SeekInOrd( ::oDbf:cCodEnt, "cCodEnt" )
         cErrors  += "Código ya existe " + Rtrim( ::oDbf:cCodEnt ) + CRLF
      end if
   end if

   if Empty( ::oDbf:cDesEnt )
      cErrors  += "La descripción de la entidad no puede estar vacía." + CRLF
   end if

   if Empty( ::oDbf:cDireccion )
      cErrors  += "La dirección de la entidad no puede estar vacía." + CRLF
   end if
   
   if Empty( ::oDbf:cCodPostal )
      cErrors  += "El código postal de la entidad no puede estar vacío." + CRLF
   end if

   if Empty( ::oDbf:cPoblacion )
      cErrors  += "La población de la entidad no puede estar vacío." + CRLF
   end if

   if Empty( ::oDbf:cProvincia )
      cErrors  += "La provincia de la entidad no puede estar vacía." + CRLF
   end if

   if Empty( ::oDbf:cPais )
      cErrors  += "El país de la entidad no puede estar vacío." + CRLF
   end if

   if !empty(cErrors)
      msgStop( cErrors )
      Return .f.
   end if 

Return .t.

//--------------------------------------------------------------------------//