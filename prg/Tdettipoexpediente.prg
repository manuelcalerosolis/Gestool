#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Menu.ch"
#include "Report.ch"
#include "MesDbf.ch"

//--------------------------------------------------------------------------//

CLASS TDetTipoExpediente FROM TDet

   DATA  cMessageNotFound                             INIT "Subtipo de expediente no encontrado"

   METHOD DefineFiles()

   METHOD OpenFiles( lExclusive )

   METHOD Resource( nMode, lLiteral )

   METHOD SaveLines()

   METHOD lPreSave()

END CLASS

//--------------------------------------------------------------------------//

METHOD DefineFiles( cPath, cVia, lUniqueName, cFileName )

   local oDbf

   DEFAULT cPath        := ::cPath
   DEFAULT cVia         := cDriver()
   DEFAULT lUniqueName  := .f.
   DEFAULT cFileName    := "TipExpL"

   if lUniqueName
      cFileName         := cGetNewFileName( cFileName, , , cPatTmp() )
   end if

   DEFINE TABLE oDbf FILE ( cFileName ) CLASS ( cFileName ) ALIAS ( cFileName ) PATH ( cPath ) VIA ( cVia ) COMMENT "Subtipo de expedientes"

      FIELD NAME "cCodTip" TYPE "C" LEN  3  DEC 0 COMMENT "Tipo expediente"            OF oDbf
      FIELD NAME "cCodSub" TYPE "C" LEN  3  DEC 0 COMMENT "Código subtipo"             OF oDbf
      FIELD NAME "cNomSub" TYPE "C" LEN 50  DEC 0 COMMENT "Nombre subtipo"             OF oDbf

      INDEX TO ( cFileName ) TAG "cCodTip" ON "cCodTip"                    NODELETED   OF oDbf
      INDEX TO ( cFileName ) TAG "cCodSub" ON "cCodTip + cCodSub"          NODELETED   OF oDbf
      INDEX TO ( cFileName ) TAG "cNomSub" ON "cCodTip + Upper( cNomSub )" NODELETED   OF oDbf

   END DATABASE oDbf

RETURN ( oDbf )

//--------------------------------------------------------------------------//

METHOD OpenFiles( lExclusive )

   local lOpen             := .t.
   local oError
   local oBlock

   DEFAULT lExclusive      := .f.

   oBlock                  := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      if Empty( ::oDbf )
         ::oDbf            := ::DefineFiles()
      end if

      ::oDbf:Activate( .f., !lExclusive )

      ::bOnPreSaveDetail   := {|| ::SaveLines() }

   RECOVER USING oError

      lOpen                := .f.

      ::CloseFiles()
      
      msgStop( ErrorMessage( oError ), "Imposible abrir todas las bases de datos" )

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//--------------------------------------------------------------------------//

METHOD Resource( nMode )

   local oDlg
   local oGetSub
   local oGetNom

   /*
   Etiquetas-------------------------------------------------------------------
   */

   DEFINE DIALOG oDlg RESOURCE "LSubTipoExpediente" TITLE LblTitle( nMode ) + "subtipo de expedientes"

      /*
      Código de subtipo--------------------------------------------------------
      */

      REDEFINE GET oGetSub VAR ::oDbfVir:cCodSub ;
         ID       100 ;
         WHEN     ( nMode == APPD_MODE ) ;
         BITMAP   "LUPA" ;
         OF       oDlg

      /*
      Código deL nombre--------------------------------------------------------
      */

      REDEFINE GET oGetNom VAR ::oDbfVir:cNomSub ;
         ID       110 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      /*
      Código deL nombre--------------------------------------------------------
      */

      REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( if( ::lPresave( oGetSub, oGetNom, nMode ), oDlg:end( IDOK ), ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
			ACTION 	( oDlg:end() )

      REDEFINE BUTTON ;
         ID       9 ;
			OF 		oDlg ;
         CANCEL ;
         ACTION   ( MsgInfo( "Ayuda no definida" ) )

      if nMode != ZOOM_MODE
         oDlg:AddFastKey( VK_F5, {|| if( ::lPresave( oGetSub, oGetNom, nMode ), oDlg:end( IDOK ), ) } )
      end if

   ACTIVATE DIALOG oDlg CENTER

RETURN ( oDlg:nResult == IDOK )

//----------------------------------------------------------------------------//

METHOD SaveLines()

   ::oDbfVir:cCodTip  := ::oParent:oDbf:cCodTip

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD lPresave( oGetCod, oGetNom, nMode )

   local lPreSave := .t.
   local nOrdAnt  := ::oDbfVir:OrdSetFocus( "cCodSub" )

   if nMode == APPD_MODE

      if ::oDbfVir:Seek( ::oDbfVir:cCodTip + ::oDbfVir:cCodSub )

         msgStop( "Código existente" )
         oGetCod:SetFocus()

         lPreSave := .f.

      end if

   end if

   ::oDbfVir:OrdSetFocus( nOrdAnt )

   if Empty( oGetNom:VarGet() )
      MsgStop( "El nombre del subtipo no puede estar vacio." )
      lPreSave    := .f.
   end if

RETURN ( lPreSave )

//---------------------------------------------------------------------------//