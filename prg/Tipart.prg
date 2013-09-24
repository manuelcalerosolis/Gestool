#include "FiveWin.Ch"
#include "Factu.ch"
#include "MesDbf.ch"

//----------------------------------------------------------------------------//

CLASS TTipArt FROM TMANT

   METHOD Create( cPath ) CONSTRUCTOR

   METHOD New( cPath, oWndParent, oMenuItem ) CONSTRUCTOR

   METHOD OpenFiles( lExclusive )
   MESSAGE OpenService( lExclusive )   METHOD OpenFiles( lExclusive )

   METHOD DefineFiles()

   METHOD Activate()

   METHOD Resource( nMode )

   METHOD lValid( oGet, oSay )

   METHOD cNombre( cCodArt )

   METHOD lPreSave( oGet, oGet2, oDlg, nMode )

   METHOD PublicarWeb( lLoad )

   METHOD Enviar( lLoad )

   METHOD lSelect( lSel, oBrw )

   METHOD SelectAll( lSel, oBrw )

END CLASS

//----------------------------------------------------------------------------//

METHOD Create( cPath )

   DEFAULT cPath     := cPatArt()

   ::cPath           := cPath
   ::oDbf            := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD New( cPath, oWndParent, oMenuItem )

   DEFAULT cPath        := cPatArt()
   DEFAULT oWndParent   := GetWndFrame()

   if oMenuItem != nil
      ::nLevel          := nLevelUsr( oMenuItem )
   else
      ::nLevel          := nLevelUsr( "01013" )
   end if

   ::cPath              := cPath
   ::oWndParent         := oWndParent

   ::oDbf               := nil

   ::cMru               := "Cubes_Blue_16"

   ::cBitmap            := clrTopArchivos

   ::lAutoButtons       := .f.
   ::lCreateShell       := .f.

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD OpenFiles( lExclusive, cPath )

   local lOpen          := .t.
   local oBlock         := ErrorBlock( {| oError | ApoloBreak( oError ) } )

   DEFAULT lExclusive   := .f.

   BEGIN SEQUENCE

   if Empty( ::oDbf )
      ::DefineFiles( cPath )
   end if

   ::oDbf:Activate( .f., !( lExclusive ) )

   RECOVER

      msgStop( "Imposible abrir las bases de datos de tipos de articulos" )
      ::CloseFiles()
      lOpen             := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//----------------------------------------------------------------------------//

METHOD DefineFiles( cPath, cDriver )

   DEFAULT cPath        := ::cPath
   DEFAULT cDriver      := cDriver()

   DEFINE DATABASE ::oDbf FILE "Tipart.Dbf" CLASS "Tipart" ALIAS "Tipart" PATH ( cPath ) VIA ( cDriver ) COMMENT "Tipos de artículos"

      FIELD CALCULATE NAME "bSndDoc"   LEN  14  DEC 0 COMMENT { "Enviar", "Lbl16", 3 }       VAL {|| ::oDbf:FieldGetByName( "lSelect" ) } BITMAPS "Sel16", "Nil16" COLSIZE 20 OF ::oDbf
      FIELD CALCULATE NAME "bPubInt"   LEN  14  DEC 0 COMMENT { "Publicar", "SndInt16", 3 }  VAL {|| ::oDbf:FieldGetByName( "lPubInt" ) } BITMAPS "Sel16", "Nil16" COLSIZE 20 OF ::oDbf
      FIELD NAME "cCodTip" TYPE "C"    LEN   3  DEC 0 COMMENT "Código"         PICTURE "@!"  COLSIZE 60     OF ::oDbf
      FIELD NAME "cNomTip" TYPE "C"    LEN 100  DEC 0 COMMENT "Nombre"                       COLSIZE 200    OF ::oDbf
      FIELD NAME "lSelect" TYPE "L"    LEN   1  DEC 0 COMMENT ""               HIDE          COLSIZE 0      OF ::oDbf
      FIELD NAME "lPubInt" TYPE "L"    LEN   1  DEC 0 COMMENT ""               HIDE          COLSIZE 0      OF ::oDbf
      FIELD NAME "cCodWeb" TYPE "N"    LEN  11  DEC 0 COMMENT "Código Web"     HIDE                         OF ::oDbf
      FIELD NAME "cImgTip" TYPE "C"    LEN 250  DEC 0 COMMENT "Imagen"         HIDE                         OF ::oDbf
      FIELD NAME "nPosInt" TYPE "N"    LEN   3  DEC 0 COMMENT "nPosInt"        HIDE                         OF ::oDbf
      FIELD NAME "cNomInt" TYPE "C"    LEN 100  DEC 0 COMMENT "Nombre comercio electrónico"                 OF ::oDbf

      INDEX TO "TipArt.CDX" TAG "cCodTip" ON "cCodTip"            COMMENT "Código"           NODELETED      OF ::oDbf
      INDEX TO "TipArt.CDX" TAG "cNomTip" ON "Upper( cNomTip )"   COMMENT "Nombre"           NODELETED      OF ::oDbf
      INDEX TO "TipArt.CDX" TAG "cCodWeb" ON "Str( cCodWeb, 11 )" COMMENT "Códigoweb"        NODELETED      OF ::oDbf

   END DATABASE ::oDbf

RETURN ( ::oDbf )

//----------------------------------------------------------------------------//

METHOD Activate()

   if nAnd( ::nLevel, 1 ) != 0
      msgStop( "Acceso no permitido." )
      Return ( Self )
   end if

   /*
   Cerramos todas las ventanas
   */

   if ::oWndParent != nil
      ::oWndParent:CloseAll()
   end if

   if Empty( ::oDbf ) .or. !::oDbf:Used()
      ::lOpenFiles      := ::OpenFiles()
   end if

   /*
   Creamos el Shell
   */

   if ::lOpenFiles

      if !::lCreateShell
         ::CreateShell( ::nLevel )
      end if

      ::oWndBrw:GralButtons( Self )

      DEFINE BTNSHELL RESOURCE "Lbl" OF ::oWndBrw ;
         NOBORDER ;
         ACTION   ( ::Enviar( .t. ) ) ;
         TOOLTIP  "En(v)iar" ;
         HOTKEY   "V";
         LEVEL    ACC_EDIT

      DEFINE BTNSHELL RESOURCE "SNDINT" OF ::oWndBrw ;
         NOBORDER ;
         ACTION   ( ::PublicarWeb( .t. ) ) ;
         TOOLTIP  "(P)ublicar" ;
         HOTKEY   "P";
         LEVEL    ACC_EDIT

      ::oWndBrw:EndButtons( Self )

      if ::cHtmlHelp != nil
         ::oWndBrw:cHtmlHelp  := ::cHtmlHelp
      end if

      ::oWndBrw:Activate( nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, {|| ::CloseFiles() }, nil, nil )

   end if

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD Resource( nMode )

	local oDlg
   local oGet
   local oGetNombre
   local oGetNombreInt
   local oGetImagen
   local oBmpImagen

   if nMode == APPD_MODE
      ::oDbf:nPosInt := 1
   end if

   DEFINE DIALOG oDlg RESOURCE "TipArt" TITLE LblTitle( nMode ) + "tipos de artículos"

      REDEFINE GET oGet VAR ::oDbf:cCodTip UPDATE;
			ID 		100 ;
         WHEN     ( nMode == APPD_MODE ) ;
			PICTURE 	"@!" ;
			OF 		oDlg

      REDEFINE GET oGetNombre VAR ::oDbf:cNomTip UPDATE;
			ID 		110 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET oGetNombreInt VAR ::oDbf:cNomInt UPDATE;
         ID       150 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE CHECKBOX ::oDbf:lPubInt ;
         ID       130 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET ::oDbf:nPosInt ;
         ID       180 ;
         SPINNER ;
         MIN      1 ;
         MAX      999 ;
         VALID    ( ::oDbf:nPosInt >= 1 .and. ::oDbf:nPosInt <= 999 ) ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         OF       oDlg

      REDEFINE GET oGetImagen VAR ::oDbf:cImgTip UPDATE;
         BITMAP   "Folder" ;
         ON HELP  ( GetBmp( oGetImagen, oBmpImagen ) ) ;
         ON CHANGE( ChgBmp( oGetImagen, oBmpImagen ) ) ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ID       120 ;
         OF       oDlg

      REDEFINE IMAGE oBmpImagen ;
         ID       600 ;
         OF       oDlg ;
         FILE     cFileBmpName( ::oDbf:cImgTip )

      oBmpImagen:SetColor( , GetSysColor( 15 ) )
      oBmpImagen:bLClicked  := {|| ShowImage( oBmpImagen ) }
      oBmpImagen:bRClicked  := {|| ShowImage( oBmpImagen ) }

      REDEFINE GET ::oDbf:cCodWeb UPDATE;
         ID       140 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         PICTURE  "99999" ;
			OF 		oDlg

      REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
         WHEN     ( nMode != ZOOM_MODE ) ;
         ACTION   ( ::lPreSave( oGet, oGetNombre, oDlg, nMode ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
         CANCEL ;
			ACTION 	( oDlg:end() )

   REDEFINE BUTTON ;
         ID       9 ;
			OF 		oDlg ;
         ACTION   ( ChmHelp( "Tipos_de_artículos" ) )

   if nMode != ZOOM_MODE
      oDlg:AddFastKey( VK_F5, {|| ::lPreSave( oGet, oGetNombre, oDlg, nMode ) } )
   end if

   oDlg:AddFastKey( VK_F1, {|| ChmHelp( "Tipos_de_artículos" ) } )

   oDlg:bStart    := {|| oGet:SetFocus() }

   ACTIVATE DIALOG oDlg CENTER

RETURN ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

METHOD lPreSave( oGet, oGetNombre, oDlg, nMode )

   if ( nMode == APPD_MODE .or. nMode == DUPL_MODE )

      if Empty( ::oDbf:cCodTip )
         MsgStop( "Código de tipo de artículo no puede estar vacío." )
         oGet:SetFocus()
         Return .f.
      end if

      ::oDbf:cCodTip := RJust( ::oDbf:cCodTip, "0" )

      if ::oDbf:SeekInOrd( ::oDbf:cCodTip, "cCodTip" )
         MsgStop( "Código ya existe " + Rtrim( ::oDbf:cCodTip ) )
         return .f.
      end if

   end if

   if Empty( ::oDbf:cNomTip )
      MsgStop( "Nombre de tipo de artículo no puede estar vacío." )
      oGetNombre:SetFocus()
      Return .f.
   end if

   ::oDbf:lSelect    := .t.
   ::oDbf:cCodWeb    := 0

RETURN ( oDlg:end( IDOK ) )

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

METHOD PublicarWeb()

   local lPublicar   := !::oDbf:lPubInt

   ::oDbf:Load()
   ::oDbf:lPubInt    := lPublicar
   ::oDbf:lSelect    := lPublicar
   ::oDbf:cCodWeb    := 0
   ::oDbf:Save()

   ::oWndBrw:Refresh()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Enviar( lLoad )

   DEFAULT lLoad     := .f.

   if lLoad
      ::oDbf:Load()
      ::oDbf:lSelect := !::oDbf:lSelect
   end if

      ::oDbf:cCodWeb := 0

   if lLoad
      ::oDbf:Save()
      ::oWndBrw:Refresh()
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//