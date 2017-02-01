#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//----------------------------------------------------------------------------//

CLASS TDetFideliza FROM TDet

   DATA  cMru                       INIT "gc_industrial_robot_money_16"
   DATA  cBitmap                    INIT Rgb( 197, 227, 9 )

   METHOD OpenFiles( lExclusive )
   METHOD CloseFiles()

   METHOD DefineFiles()

   METHOD Resource( nMode )

   Method lPreSave( oGet, nMode )

END CLASS

//----------------------------------------------------------------------------//

METHOD OpenFiles( lExclusive, cPath )

   local lOpen             := .t.
   local oBlock            

   DEFAULT lExclusive      := .f.
   DEFAULT cPath           := ::cPath

   oBlock                  := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      if Empty( ::oDbf )
         ::oDbf            := ::DefineFiles( cPath )
      end if

      ::oDbf:Activate( .f., !( lExclusive ) )

   RECOVER

      msgStop( "Imposible abrir las bases de datos detalle de fidelización." )

      ::CloseFiles()

      lOpen                := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//----------------------------------------------------------------------------//

METHOD CloseFiles()

   if !Empty( ::oDbf )
      ::oDbf:end()
   end if

   ::oDbf               := nil

RETURN .t.

//----------------------------------------------------------------------------//

METHOD DefineFiles( cPath, cVia, lUniqueName, cFileName )

   local oDbf

   DEFAULT cPath        := ::cPath
   DEFAULT lUniqueName  := .f.
   DEFAULT cFileName    := "DetFideliza"
   DEFAULT cVia         := cDriver()

   if lUniqueName
      cFileName         := cGetNewFileName( cFileName, , , cPath )
   end if

   DEFINE TABLE oDbf FILE ( cFileName ) CLASS ( cFileName ) ALIAS "DetFidel" PATH ( cPath ) VIA ( cVia ) COMMENT "lineas de programa de fidelización"

      FIELD NAME "cCodigo"    TYPE "C" LEN 03  DEC 0 COMMENT "Código"               HIDE  OF oDbf
      FIELD NAME "nLinea"     TYPE "N" LEN 01  DEC 0 COMMENT "Línea"                HIDE  OF oDbf
      FIELD NAME "nImpUni"    TYPE "N" LEN 01  DEC 0 COMMENT "Importe o unidades"   HIDE  OF oDbf
      FIELD NAME "nImporte"   TYPE "N" LEN 16  DEC 6 COMMENT "Importe"                    OF oDbf
      FIELD NAME "nUnidades"  TYPE "N" LEN 16  DEC 6 COMMENT "Unidades"                   OF oDbf
      FIELD NAME "nPctLin"    TYPE "N" LEN 01  DEC 0 COMMENT "Porcentual o lineal"        OF oDbf
      FIELD NAME "nPorcen"    TYPE "N" LEN 06  DEC 2 COMMENT "Porcentaje"                 OF oDbf
      FIELD NAME "nLineal"    TYPE "N" LEN 16  DEC 6 COMMENT "Lineal"                     OF oDbf
      FIELD NAME "mFamilia"   TYPE "M" LEN 10  DEC 0 COMMENT "Familias"                   OF oDbf

      INDEX TO ( cFileName )  TAG "cCodigo"  ON "cCodigo"                  NODELETED      OF oDbf
      INDEX TO ( cFileName )  TAG "nLinea"   ON "cCodigo + Str( nLinea )"  NODELETED      OF oDbf

   END DATABASE oDbf

RETURN ( oDbf )

//----------------------------------------------------------------------------//

METHOD Resource( nMode )

	local oDlg

   if nMode == APPD_MODE
      ::oDbfVir:nImpUni := 1
      ::oDbfVir:nPctLin := 1
   end if

   DEFINE DIALOG oDlg RESOURCE "DetFidelizacion" TITLE LblTitle( nMode ) + "lineas de fidelización"

      REDEFINE RADIO ::oDbfVir:nImpUni ;
         ID       100, 101 ;
         OF       oDlg

      REDEFINE GET ::oDbfVir:nImporte ;
         ID       110 ;
         WHEN     ( ::oDbfVir:nImpUni == 1 ) ;
         SPINNER ;
         PICTURE  ( cPouDiv() ) ;
         OF       oDlg

      REDEFINE GET ::oDbfVir:nUnidades ;
         ID       120 ;
         SPINNER ;
         WHEN     ( ::oDbfVir:nImpUni == 2 ) ;
         PICTURE  ( MasUnd() ) ;
         OF       oDlg

      REDEFINE GET ::oDbfVir:nPorcen ;
         ID       140 ;
         SPINNER ;
         PICTURE  "@E 999.99" ;
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

   ACTIVATE DIALOG oDlg CENTER

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

METHOD lPreSave( nMode )

   if ( ::oDbfVir:nImpUni == 1 ) .and. ( ::oDbf:nLineal < 0 )
      MsgStop( "Importe de la oferta no puede ser menor que cero." )
      return .f.
   end if

   if ( ::oDbfVir:nImpUni == 2 ) .and. ( ::oDbf:nUnidades < 0 )
      MsgStop( "Unidades de la oferta no puede ser menor que cero." )
      return .f.
   end if

   ::oDbfVir:cCodigo := ::oParent:oDbf:cCodigo

Return .t.

//---------------------------------------------------------------------------//