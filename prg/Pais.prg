#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//----------------------------------------------------------------------------//

CLASS TPais FROM TMant

   DATA oBan                  AS OBJECT

   DATA cMru                  INIT "gc_globe_16"

   DATA  cBitmap              INIT clrTopArchivos

   METHOD OpenFiles()
   METHOD OpenService()

   METHOD DefineFiles()

   METHOD CloseFiles()

   METHOD Resource( nMode )

   METHOD cNombre( cCod )     INLINE   ( oRetFld( cCod, ::oDbf, "cNomPai" ) )
   METHOD cBmp( cCod )        INLINE   ( ::oBan:hBandera( oRetFld( cCod, ::oDbf, "cResPai" ) ) )

   METHOD GetPais( cCodPai, oSay, oBmp )

   METHOD lPreSave( oCmb, oDlg, nMode )

   METHOD GetIsoPais( cCodPai )

END CLASS

//----------------------------------------------------------------------------//

METHOD OpenFiles( lExclusive, cPath )

   local lOpen          := .t.
   local oError
   local oBlock

   DEFAULT lExclusive   := .f.

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

   if Empty( ::oDbf )
      ::DefineFiles()
   end if

   ::oDbf:Activate( .f., !( lExclusive ) )

   ::oBan               := TBandera():New

   RECOVER USING oError

      lOpen             := .f.

      ::CloseFiles()
      
      msgStop( ErrorMessage( oError ), "Imposible abrir todas las bases de datos de paises" )

   END SEQUENCE

RETURN ( lOpen )

//----------------------------------------------------------------------------//

METHOD OpenService( lExclusive, cPath )

   local lOpen          := .t.
   local oError
   local oBlock

   DEFAULT lExclusive   := .f.

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      if Empty( ::oDbf )
         ::DefineFiles( cPath )
      end if

      ::oDbf:Activate( .f., !( lExclusive ) )

   RECOVER USING oError

      lOpen             := .f.

      ::CloseFiles()
      
      msgStop( ErrorMessage( oError ), "Imposible abrir todas las bases de datos de paises" )

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//----------------------------------------------------------------------------//

METHOD DefineFiles( cPath, cDriver )

   DEFAULT cPath        := ::cPath
   DEFAULT cDriver      := cDriver()

   DEFINE DATABASE ::oDbf FILE "PAIS.DBF" CLASS "Pais" PATH ( cPath ) VIA ( cDriver ) COMMENT "Paises"

      FIELD NAME "cCodPai"    TYPE "C" LEN  4  DEC 0  COMMENT "Código"  DEFAULT Space( 4 )      COLSIZE 80  OF ::oDbf
      FIELD NAME "cNomPai"    TYPE "C" LEN 35  DEC 0  COMMENT "Nombre"  DEFAULT Space( 35)      COLSIZE 200 OF ::oDbf
      FIELD NAME "cCodIso"    TYPE "C" LEN  3  DEC 0  COMMENT "ISO"                             COLSIZE 80  OF ::oDbf
      FIELD NAME "cBndPai"    TYPE "C" LEN  4  DEC 0  COMMENT ""                           HIDE COLSIZE 0   OF ::oDbf
      FIELD NAME "cResPai"    TYPE "C" LEN  8  DEC 0  COMMENT ""                           HIDE COLSIZE 0   OF ::oDbf

      INDEX TO "Pais.CDX" TAG "CCODPAI" ON "CCODPAI" COMMENT "Código" NODELETED OF ::oDbf
      INDEX TO "Pais.CDX" TAG "CNOMPAI" ON "CNOMPAI" COMMENT "Nombre" NODELETED OF ::oDbf

   END DATABASE ::oDbf

RETURN ( ::oDbf )

//----------------------------------------------------------------------------//

METHOD Resource( nMode )

   local oDlg
   local oGet
   local oCmb
   local cCmb     := ::oBan:cBandera( ::oDbf:cResPai )

   DEFINE DIALOG oDlg RESOURCE "PAIS" TITLE LblTitle( nMode ) + "paises"

      REDEFINE GET oGet VAR ::oDbf:CCODPAI UPDATE;
			ID 		100 ;
         WHEN     ( nMode == APPD_MODE ) ;
			PICTURE 	"@!" ;
			OF 		oDlg

      REDEFINE GET ::oDbf:CNOMPAI UPDATE;
			ID 		110 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
			OF 		oDlg

      REDEFINE GET ::oDbf:cCodIso UPDATE;
         ID       130 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      /*
		Bandera_________________________________________________________________
		*/

		REDEFINE COMBOBOX oCmb VAR cCmb;
         ID       120;
			OF 		oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ITEMS    ::oBan:aNomBan ;
         BITMAPS  ::oBan:aResBan

      REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
         WHEN     (  nMode != ZOOM_MODE ) ;
         ACTION   (  ::lPreSave( oGet, oCmb, oDlg, nMode ) )

      REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
         CANCEL ;
			ACTION 	( oDlg:end() )

   if nMode != ZOOM_MODE
      oDlg:AddFastKey( VK_F5, {|| ::lPreSave( oGet, oCmb, oDlg, nMode ) } )
   end if

   oDlg:AddFastKey( VK_F1, {|| GoHelp() } )

   oDlg:bStart    := {|| oGet:SetFocus() }

	ACTIVATE DIALOG oDlg	CENTER

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

METHOD lPreSave( oGet, oCmb, oDlg, nMode )

   local nCmb     := Max( Min( oCmb:nAt, len( ::oBan:aResBan ) ), 1 )

   ::oDbf:cResPai := ::oBan:aResBan[ nCmb ]

   if nMode == APPD_MODE .or. nMode == DUPL_MODE

      oGet:lValid()

      if ::oDbf:SeekInOrd( ::oDbf:cCodPai, "cCodPai" )
         MsgStop( "Código ya existe " + Rtrim( ::oDbf:cCodPai ) )
         return .f.
      end if

   end if

   if Empty( ::oDbf:cNomPai )
      MsgStop( "La descripción del país no puede estar vacía." )
      Return .f.
   end if

Return oDlg:end( IDOK )

//---------------------------------------------------------------------------//

METHOD CloseFiles()

   if !Empty( ::oDbf ) .and. ::oDbf:Used()
      ::oDbf:end()
   end if

   if !Empty( ::oBan )
      ::oBan:end()
   end if

RETURN .t.

//--------------------------------------------------------------------------//

METHOD GetPais( cCodPai, oSay, oBmp )

   if ::oDbf:Seek( cCodPai )

      oSay:cText( ::oDbf:cNomPai )

      oBmp:LoadImage( ::oDbf:cResPai )

      oBmp:Refresh()

   end if

RETURN ( .t. )

//--------------------------------------------------------------------------//

METHOD GetIsoPais( cCodPai )

   local cCodIso     := ""

   if ::oDbf:Seek( cCodPai )

      cCodIso        := ::oDbf:cCodIso

   end if

RETURN ( cCodIso )

//----------------------------------------------------------------------------//