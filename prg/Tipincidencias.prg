#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//----------------------------------------------------------------------------//

CLASS TipIncidencia FROM TMANT

   METHOD New( cPath, oWndParent, oMenuItem )

   METHOD OpenFiles( lExclusive )
   MESSAGE OpenService( lExclusive )   METHOD OpenFiles( lExclusive )

   METHOD DefineFiles()

   METHOD Resource( nMode )

   METHOD InvSelect( oBrw )   INLINE ( ::oDbf:Load(), ::oDbf:lSelect := !::oDbf:lSelect, ::oDbf:Save(), oBrw:Refresh() )

   Method lSelect( lSel, oBrw )

   METHOD SelectAll( lSel, oBrw )

   METHOD lValid( oGet, oSay )

   METHOD cNombre( cCodArt )

END CLASS

//----------------------------------------------------------------------------//

METHOD New( cPath, oWndParent, oMenuItem )

   DEFAULT cPath        := cPatEmp()
   DEFAULT oWndParent   := GetWndFrame()

   if oMenuItem != nil
      ::nLevel          := nLevelUsr( oMenuItem )
   else
      ::nLevel          := nLevelUsr( "01089" )
   end if

   ::cPath              := cPath
   ::oWndParent         := oWndParent
   ::oDbf               := nil

   ::lAutoButtons       := .t.
   ::lCreateShell       := .f.

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD OpenFiles( lExclusive )

   DEFAULT lExclusive   := .f.

   if Empty( ::oDbf )
      ::DefineFiles()
   end if

   ::oDbf:Activate( .f., !( lExclusive ) )

RETURN .t.

//----------------------------------------------------------------------------//

METHOD DefineFiles( cPath, cDriver )

   DEFAULT cPath        := ::cPath
   DEFAULT cDriver      := cDriver()

   DEFINE DATABASE ::oDbf FILE "TipInci.Dbf" CLASS "TipInci" ALIAS "TipInci" PATH ( cPath ) VIA ( cDriver ) COMMENT "Tipos de incidencias"

      FIELD NAME "cCodInc" TYPE "C" LEN  3  DEC 0 COMMENT "Código"      PICTURE "@!" COLSIZE  60 OF ::oDbf
      FIELD NAME "cNomInc" TYPE "C" LEN 50  DEC 0 COMMENT "Descripción"              COLSIZE 200 OF ::oDbf

      INDEX TO "TipInci.CDX" TAG "cCodInc" ON "cCodInc" COMMENT "Código" NODELETED OF ::oDbf
      INDEX TO "TipInci.CDX" TAG "cNomInc" ON "cNomInc" COMMENT "Nombre" NODELETED OF ::oDbf

   END DATABASE ::oDbf

RETURN ( ::oDbf )

//----------------------------------------------------------------------------//

METHOD Resource( nMode )

	local oDlg
   local oGet

   DEFINE DIALOG oDlg RESOURCE "TipArt" TITLE LblTitle( nMode ) + "tipo de incidencia"

      REDEFINE GET oGet VAR ::oDbf:cCodInc UPDATE;
			ID 		100 ;
         WHEN     ( nMode == APPD_MODE ) ;
         VALID    NotValid( oGet, ::oDbf:cAlias, .t., "0" ) ;
			PICTURE 	"@!" ;
			OF 		oDlg

      REDEFINE GET ::oDbf:cNomInc UPDATE;
			ID 		110 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
			OF 		oDlg

      REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( oDlg:end( IDOK ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
         CANCEL ;
			ACTION 	( oDlg:end() )

   REDEFINE BUTTON ;
         ID       9 ;
			OF 		oDlg ;
         ACTION   ( ChmHelp( "TipoIncidencia" ) )

   odlg:AddFastKey ( VK_F1, {|| ChmHelp( "TipoIncidencia" ) } )

   ACTIVATE DIALOG oDlg CENTER

RETURN ( oDlg:nResult == IDOK )

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

   local cCodArt

   if Empty( oGet:VarGet() )
      return .t.
   end if

   cCodArt        := RJustObj( oGet, "0" )

   if ::oDbf:Seek( cCodArt )
      oGet:cText( cCodArt )
      if oSay != nil
         oSay:cText( ::oDbf:cNomTip )
      end if
   else
      msgStop( "Código no encontrado" )
      return .f.
   end if

RETURN .t.

//--------------------------------------------------------------------------//

METHOD cNombre( cCodArt )

   local cNombre  := ""

   if ::oDbf:Seek( cCodArt )
      cNombre     := ::oDbf:cNomTip
   end if

RETURN ( cNombre )

//---------------------------------------------------------------------------//