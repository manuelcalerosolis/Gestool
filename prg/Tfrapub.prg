#include "FiveWin.Ch"
#include "Factu.ch"
#include "MesDbf.ch"

//----------------------------------------------------------------------------//

CLASS TFrasesPublicitarias FROM TMant

   DATA  oDlg

   DATA  oGetCodigo
   DATA  oGetFrase

   DATA  cBitmap                       INIT clrTopArchivos

   METHOD New( cPath, oWndParent, oMenuItem )

   METHOD OpenFiles( lExclusive )
   MESSAGE OpenService( lExclusive )   METHOD OpenFiles( lExclusive )

   METHOD DefineFiles()

   METHOD Resource( nMode )

   METHOD InvSelect( oBrw )            INLINE ( ::oDbf:Load(), ::oDbf:lSelect := !::oDbf:lSelect, ::oDbf:Save(), oBrw:Refresh() )

   Method lSelect( lSel, oBrw )

   METHOD SelectAll( lSel, oBrw )

   METHOD lValid( oGet, oSay )

   METHOD cNombre( cCodArt )

   METHOD lPreSave( oGet, oGet2, oDlg, nMode )


END CLASS

//----------------------------------------------------------------------------//

METHOD New( cPath, oWndParent, oMenuItem )

   DEFAULT cPath        := cPatArt()
   DEFAULT oWndParent   := GetWndFrame()

   if oMenuItem != nil
      ::nLevel          := nLevelUsr( oMenuItem )
   else
      ::nLevel          := nLevelUsr( "01104" )
   end if

   ::cPath              := cPath
   ::oWndParent         := oWndParent
   ::oDbf               := nil
   ::cMru               := "Led_Red_16"

   ::lAutoButtons       := .t.
   ::lCreateShell       := .f.

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD OpenFiles( lExclusive )

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

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Imposible abrir las bases de datos de frases publicitarias" )

      ::CloseFiles()

      lOpen             := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//----------------------------------------------------------------------------//

METHOD DefineFiles( cPath, cDriver )

   DEFAULT cPath        := ::cPath
   DEFAULT cDriver      := cDriver()

   DEFINE DATABASE ::oDbf FILE "FraPub.Dbf" CLASS "FraPub" ALIAS "FraPub" PATH ( cPath ) VIA ( cDriver ) COMMENT "Frases publicitarias"

      FIELD NAME "cCodFra" TYPE "C" LEN  3  DEC 0 COMMENT "Código"               PICTURE "@!"   COLSIZE 60  OF ::oDbf
      FIELD NAME "cTxtFra" TYPE "C" LEN 200 DEC 0 COMMENT "Frase"                               COLSIZE 400 OF ::oDbf
      FIELD NAME "lSelect" TYPE "L" LEN  1  DEC 0 COMMENT ""                     HIDE           COLSIZE 0   OF ::oDbf

      INDEX TO "FraPub.CDX" TAG "cCodFra" ON "cCodFra" COMMENT "Código" NODELETED OF ::oDbf
      INDEX TO "FraPub.CDX" TAG "cTxtFra" ON "cTxtFra" COMMENT "Frase"  NODELETED OF ::oDbf

   END DATABASE ::oDbf

RETURN ( ::oDbf )

//----------------------------------------------------------------------------//

METHOD Resource( nMode )

   DEFINE DIALOG ::oDlg RESOURCE "FraPub" TITLE LblTitle( nMode ) + "frases publicitarias"

      REDEFINE GET ::oGetCodigo VAR ::oDbf:cCodFra UPDATE;
			ID 		100 ;
         WHEN     ( nMode == APPD_MODE ) ;
         PICTURE  "@!" ;
         OF       ::oDlg

      ::oGetCodigo:bValid  := {|| NotValid( ::oGetCodigo, ::oDbf:cAlias, .t., "0" ) }

      REDEFINE GET ::oGetFrase VAR ::oDbf:cTxtFra UPDATE;
			ID 		110 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       ::oDlg

      REDEFINE BUTTON ;
         ID       IDOK ;
         OF       ::oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( ::lPreSave(  nMode ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
         OF       ::oDlg ;
         CANCEL ;
         ACTION   ( ::oDlg:end() )

      REDEFINE BUTTON ;
         ID       9 ;
         OF       ::oDlg ;
         ACTION   ( GoHelp() )

   if nMode != ZOOM_MODE
      ::oDlg:AddFastKey( VK_F5, {|| ::lPreSave( nMode ) } )
   end if

   ::oDlg:bStart  := {|| ::oGetCodigo:SetFocus() }

   ACTIVATE DIALOG ::oDlg CENTER

RETURN ( ::oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

METHOD lPreSave( nMode )

   if nMode == APPD_MODE .or. nMode == DUPL_MODE

      if Empty( ::oDbf:cCodFra )
         MsgStop( "Código de tipo de artículo no puede estar vacío." )
         ::oGetCodigo:SetFocus()
         Return .f.
      end if

      if ::oDbf:SeekInOrd( ::oDbf:cCodFra, "cCodFra" )
         MsgStop( "Código ya existe " + Rtrim( ::oDbf:cCodFra ) )
         return nil
      end if

   end if

   if Empty( ::oDbf:cTxtFra )
      MsgStop( "Frase publicitaria no puede estar vacía." )
      ::oGetFrase:SetFocus()
      Return .f.
   end if

RETURN ( ::oDlg:end( IDOK ) )

//--------------------------------------------------------------------------//

Method lSelect( lSel, oBrw )

   ::oDbf:Load()
   ::oDbf:lSelect    := lSel
   ::oDbf:Save()

   if oBrw != nil
      oBrw:Refresh()
   end if

Return ( Self )

//--------------------------------------------------------------------------//

METHOD SelectAll( lSel, oBrw )

   ::oDbf:GetStatus()

   DEFAULT lSel   := .f.

   ::oDbf:GoTop()
   while !( ::oDbf:eof() )
      ::lSelect( lSel )
      ::oDbf:Skip()
   end while

   ::oDbf:SetStatus()

   if oBrw != nil
      oBrw:Refresh()
   end if

RETURN ( Self )

//--------------------------------------------------------------------------//

METHOD lValid( oGet, oSay )

   local cCodFra

   if Empty( oGet:VarGet() )
      return .t.
   end if

   cCodFra        := RJustObj( oGet, "0" )

   if ::oDbf:Seek( cCodFra )
      oGet:cText( cCodFra )
      if oSay != nil
         oSay:cText( ::oDbf:cTxtFra )
      end if
   else
      msgStop( "Código de frase publicitaria no encontrada" )
      return .f.
   end if

RETURN .t.

//--------------------------------------------------------------------------//

METHOD cNombre( cCodFra )

   local cNombre  := ""

   if ::oDbf:Seek( cCodFra )
      cNombre     := ::oDbf:cTxtFra
   end if

RETURN ( cNombre )

//---------------------------------------------------------------------------//