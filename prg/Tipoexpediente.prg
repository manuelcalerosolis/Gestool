#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"
#include "Xbrowse.ch"

//---------------------------------------------------------------------------//

Function StartTTipoExpediente()

   local oExpediente

   oExpediente    := TTipoExpediente():New( cPatEmp(), cDriver(), oWnd(), "tipo_expediente" )

   if !Empty( oExpediente )
      oExpediente:Activate()
   end if

Return nil

//----------------------------------------------------------------------------//

CLASS TTipoExpediente FROM TMasDet

   DATA  cMru     INIT "gc_folders_16"
   DATA  cBitmap  INIT Rgb( 197, 227, 9 )

   DATA  oSubTipoExpediente

   METHOD New( cPath, oWndParent, oMenuItem )
   METHOD CreateInit( cPath )
   METHOD Create( cPath )

   METHOD OpenFiles( lExclusive )
   METHOD CloseFiles()

   METHOD DefineFiles()

   METHOD Resource( nMode )

   METHOD lPreSave( oGet, nMode )

   Method BuscarEspecial()

END CLASS

//----------------------------------------------------------------------------//

METHOD New( cPath, cDriver, oWndParent, oMenuItem )

   DEFAULT cPath        := cPatEmp()
   DEFAULT cDriver      := cDriver()
   DEFAULT oWndParent   := oWnd()

   ::cPath              := cPath
   ::cDriver            := cDriver
   ::oWndParent         := oWndParent

   if oMenuItem != nil .and. ::nLevel == nil
      ::nLevel          := Auth():Level( oMenuItem )
   else
      ::nLevel          := 1
   end if

   if nAnd( ::nLevel, 1 ) == 0
      msgStop( "Acceso no permitido." )
      return nil
   end if

   ::cPath              := cPath
   ::oWndParent         := oWndParent
   ::cMessageNotFound   := "Tipo de expediente no encontrado"

   ::bFirstKey          := {|| ::oDbf:cCodTip }

   ::oSubTipoExpediente := TDetTipoExpediente():New( cPath, ::cDriver, Self )
   ::AddDetail( ::oSubTipoExpediente )

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD CreateInit( cPath )

   DEFAULT cPath        := cPatEmp()

   ::cPath              := cPath

   ::bFirstKey          := {|| ::oDbf:cCodTip }

   ::oSubTipoExpediente := TDetTipoExpediente():New( cPath, cDriver(), Self )

   ::AddDetail( ::oSubTipoExpediente )

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD Create( cPath )

   DEFAULT cPath        := cPatEmp()

   ::cPath              := cPath
   ::oDbf               := nil

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
         ::oDbf         := ::DefineFiles()
      end if

      ::oDbf:Activate( .f., !( lExclusive ) )

      ::OpenDetails()

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Imposible abrir todas las bases de datos" )

      ::CloseFiles()

      lOpen             := .f.

   END SEQUENCE

   ErrorBlock( oBlock )

RETURN ( lOpen )

//---------------------------------------------------------------------------//

METHOD CloseFiles()

   if ::oDbf != nil .and. ::oDbf:Used()
      ::oDbf:End()
      ::oDbf            := nil
   end if

   ::CloseDetails()

RETURN .t.

//---------------------------------------------------------------------------//

METHOD DefineFiles( cPath, cDriver )
   
   local oDbf

   DEFAULT cPath        := ::cPath
   DEFAULT cDriver      := cDriver()

   DEFINE TABLE oDbf FILE "TipExpT.Dbf" CLASS "TipExpT" ALIAS "TipExpT" PATH ( cPath ) VIA ( cDriver ) COMMENT "Tipos de expedientes"

      FIELD NAME "cCodTip"   TYPE "C" LEN  3  DEC 0 COMMENT "Código" COLSIZE 100                OF oDbf
      FIELD NAME "cNomTip"   TYPE "C" LEN 35  DEC 0 COMMENT "Nombre" COLSIZE 400                OF oDbf

      INDEX TO "TipExpT.Cdx" TAG "cCodTip" ON "cCodTip"           COMMENT "Código"   NODELETED  OF oDbf
      INDEX TO "TipExpT.Cdx" TAG "cNomTip" ON "Upper( cNomTip )"  COMMENT "Nombre"   NODELETED  OF oDbf

   END DATABASE oDbf

RETURN ( oDbf )

//---------------------------------------------------------------------------//

METHOD Resource( nMode )

	local oDlg
   local oGet
   local oBrw

   DEFINE DIALOG oDlg RESOURCE "TipoExpediente" TITLE LblTitle( nMode ) + "tipo de expediente"

      REDEFINE GET oGet VAR ::oDbf:cCodTip ;
         ID       110 ;
         WHEN     ( nMode == APPD_MODE ) ;
         VALID    ( NotValid( oGet, ::oDbf:cAlias, .t., "0" ) ) ;
			PICTURE 	"@!" ;
			OF 		oDlg

      REDEFINE GET ::oDbf:cNomTip ;
         ID       120 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
			OF 		oDlg

      /*
      Subtipos de Expedientes--------------------------------------------------
      */

		REDEFINE BUTTON ;
			ID 		500 ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( ::oSubTipoExpediente:Append( oBrw ) )

		REDEFINE BUTTON ;
			ID 		501 ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( ::oSubTipoExpediente:Edit( oBrw ) )

		REDEFINE BUTTON ;
			ID 		502 ;
			OF 		oDlg ;
         ACTION   ( ::oSubTipoExpediente:Zoom() )

      REDEFINE BUTTON ;
         ID       503 ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( ::oSubTipoExpediente:Del( oBrw ) )

      oBrw                 := IXBrowse():New( oDlg )

      oBrw:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
      oBrw:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

      ::oSubTipoExpediente:oDbfVir:SetBrowse( oBrw ) 

      oBrw:nMarqueeStyle   := 5
      oBrw:cName           := "Lineas subtipos de expedientes"

      with object ( oBrw:AddCol() )
         :cHeader          := "Código"
         :bStrData         := {|| ::oSubTipoExpediente:oDbfVir:FieldGetByName( "cCodSub" ) }
         :nWidth           := 80
      end with

      with object ( oBrw:AddCol() )
         :cHeader          := "Nombre"
         :bStrData         := {|| ::oSubTipoExpediente:oDbfVir:FieldGetByName( "cNomSub" ) }
         :nWidth           := 280
      end with

      if ( nMode != ZOOM_MODE )
         oBrw:bLDblClick   := {|| ::oSubTipoExpediente:Edit( oBrw ) }
      end if

      oBrw:CreateFromResource( 200 )

      REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( ::lPreSave( nMode, oGet, oDlg ) )

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
         oDlg:AddFastKey( VK_F2, {|| ::oSubTipoExpediente:Append( oBrw ) } )
         oDlg:AddFastKey( VK_F3, {|| ::oSubTipoExpediente:Edit( oBrw ) } )
         oDlg:AddFastKey( VK_F4, {|| ::oSubTipoExpediente:Del( oBrw ) } )
         oDlg:AddFastKey( VK_F5, {|| ::lPreSave( nMode, oGet, oDlg ) } )
      end if

      oDlg:bStart := {|| oBrw:Load() }

	ACTIVATE DIALOG oDlg	CENTER

RETURN ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

Method lPreSave( nMode, oGet, oDlg )

   if nMode == APPD_MODE .or. nMode == DUPL_MODE

      if Empty( ::oDbf:cCodTip )
         MsgStop( "Código del tipo de expediente no puede estar vacío" )
         oGet:SetFocus()
         return .f.
      end if

      if ::oDbf:SeekInOrd( ::oDbf:cCodTip, "cCodTip" )
         msgStop( "Código existente" )
         oGet:SetFocus()
         return .f.
      end if

   end if

   if Empty( ::oDbf:cNomTip )
      MsgStop( "La descripción del tipo no puede estar vacía." )
      Return .f.
   end if

   oDlg:end( IDOK )

Return .t.

//---------------------------------------------------------------------------//

METHOD BuscarEspecial( oGetTip, oGetSub, cField )

   local oDlg
   local nOrd
   local oField
   local oBrwTipo
   local oBrwSubTipo
   local cDlgName
   local cCbxIndex
   local oCbxIndex
   local aCbxIndex
   local oGetSearch
   local cGetSearch

   /*
   Apertura de ficheros si no lo estan-----------------------------------------
   */

   if Empty( ::oDbf ) .or. !::oDbf:Used()
      if !::OpenFiles()
         Return .f.
      end if
   end if

   /*
   Instanciamos la variables---------------------------------------------------
   */

   cGetSearch     := Space( 100 )

   cDlgName       := "Buscando " + Rtrim( Lower( ::oDbf:cComment ) )
   aCbxIndex      := ::oDbf:aCommentIndex()

   nOrd           := 2
   nOrd           := Min( Max( nOrd, 1 ), len( aCbxIndex ) )
   cCbxIndex      := aCbxIndex[ nOrd ]

   /*
   Estado de la base de datos--------------------------------------------------
   */

   ::oDbf:OrdSetFocus( nOrd )
   ::oDbf:GoTop()

   ::oSubTipoExpediente:oDbf:OrdSetFocus( "cCodTip" )

   /*
   Creamos el dialogo----------------------------------------------------------
   */

   oDlg                 := TDialog():New( , , , , cDlgName, "HelpTipo" )

   oGetSearch           := TGet():ReDefine( 106, { | u | if( PCount() == 0, cGetSearch, cGetSearch := u ) }, oDlg, , "@!",,,,,,, .f.,,, .f., .f. )
   oGetSearch:bChange   := {|nKey, nFlags| AutoSeek( nKey, nFlags, oGetSearch, oBrwTipo, ::oDbf ) }

   oCbxIndex            := TComboBox():ReDefine( 107, { | u | if( PCount() == 0, cCbxIndex, cCbxIndex := u ) }, aCbxIndex, oDlg )
   oCbxIndex:bChange    := {|| ::oDbf:OrdSetFocus( oCbxIndex:nAt ), oBrwTipo:Refresh(), oGetSearch:SetFocus() }

   /*
   Browse de tipos--------------------------------------------------------------------
   */

   oBrwTipo                := IXBrowse():New( oDlg )

   oBrwTipo:bClrSel        := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
   oBrwTipo:bClrSelFocus   := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

   oBrwTipo:nMarqueeStyle  := 5
   oBrwTipo:cName          := cDlgName

   oBrwTipo:bChange        := {|| ::oSubTipoExpediente:oDbf:OrdScope( ::oDbf:cCodTip ), ::oSubTipoExpediente:oDbf:GoTop(), oBrwSubTipo:Refresh() }

   oBrwTipo:oSeek          := oGetSearch

   oBrwTipo:bLDblClick     := {|| oDlg:end( IDOK ) }
   oBrwTipo:bRClicked      := {| nRow, nCol, nFlags | oBrwTipo:RButtonDown( nRow, nCol, nFlags ) }

   ::oDbf:SetBrowse( oBrwTipo )

   with object ( oBrwTipo:AddCol() )
      :cHeader       := "Código"
      :nWidth        := 80
      :bEditValue    := {|| ::oDbf:cCodTip }
      :cSortOrder    := "cCodTip"
      :bLClickHeader := {| nMRow, nMCol, nFlags, oCol | oCbxIndex:Set( oCol:cHeader ), oBrwTipo:GoTop() }
   end with

   with object ( oBrwTipo:AddCol() )
      :cHeader       := "Nombre"
      :nWidth        := 180
      :bEditValue    := {|| ::oDbf:cNomTip }
      :cSortOrder    := "cNomTip"
      :bLClickHeader := {| nMRow, nMCol, nFlags, oCol | oCbxIndex:Set( oCol:cHeader ), oBrwTipo:GoTop() }
   end with

   oBrwTipo:CreateFromResource( 103 )

   /*
   Browse de sub tipos---------------------------------------------------------
   */

   oBrwSubTipo                 := IXBrowse():New( oDlg )

   oBrwSubTipo:nMarqueeStyle   := 5
   oBrwSubTipo:cName           := cDlgName
   oBrwSubTipo:bSeek           := {|c| ::oSubTipoExpediente:oDbf:Seek( c ) }

   oBrwSubTipo:oSeek           := oGetSearch

   oBrwSubTipo:bLDblClick      := {|| oDlg:end( IDOK ) }
   oBrwSubTipo:bRClicked       := {| nRow, nCol, nFlags | oBrwSubTipo:RButtonDown( nRow, nCol, nFlags ) }

   ::oSubTipoExpediente:oDbf:SetBrowse( oBrwSubTipo )

   with object ( oBrwSubTipo:AddCol() )
      :cHeader       := "Código"
      :nWidth        := 80
      :bEditValue    := {|| ::oSubTipoExpediente:oDbf:cCodSub }
      :cSortOrder    := "cCodTip"
      :bLClickHeader := {| nMRow, nMCol, nFlags, oCol | oCbxIndex:Set( oCol:cHeader ), oBrwSubTipo:GoTop() }
   end with

   with object ( oBrwSubTipo:AddCol() )
      :cHeader       := "Nombre"
      :nWidth        := 180
      :bEditValue    := {|| ::oSubTipoExpediente:oDbf:cNomSub }
      :cSortOrder    := "cNomTip"
      :bLClickHeader := {| nMRow, nMCol, nFlags, oCol | oCbxIndex:Set( oCol:cHeader ), oBrwSubTipo:GoTop() }
   end with

   oBrwSubTipo:CreateFromResource( 105 )

   /*
   Botones---------------------------------------------------------------------
   */

   TButton():ReDefine( 500, {|| ::Append( oBrwTipo ) }, oDlg, , , .f., {|| !IsReport() } )

   TButton():ReDefine( 501, {|| ::Edit( oBrwTipo ) }, oDlg, , , .f., {|| !IsReport() } )

   TButton():ReDefine( IDOK, {|| oDlg:end( IDOK ) }, oDlg, , , .f. )

   TButton():ReDefine( IDCANCEL, {|| oDlg:end() }, oDlg, , , .f. )

   oDlg:bStart       := {|| oBrwTipo:Load(), oGetSearch:SetFocus() }

   if !IsReport()
      oDlg:AddFastKey( VK_F2, {|| ::Append( oBrwTipo ) } )
      oDlg:AddFastKey( VK_F3, {|| ::Edit( oBrwTipo ) } )
   end if

   oDlg:AddFastKey( VK_F5, {|| oDlg:end( IDOK ) } )

   oDlg:bStart       := {|| ::oSubTipoExpediente:oDbf:OrdScope( ::oDbf:cCodTip ), ::oSubTipoExpediente:oDbf:GoTop(), oBrwSubTipo:Refresh() }

   oDlg:Activate( , , , .t. )

   /*
   Resultadoso-----------------------------------------------------------------
   */

   if oDlg:nResult == IDOK

      if oGetTip != nil .and. !Empty( ::oDbf:cCodTip )
         oGetTip:cText( ::oDbf:cCodTip )
         oGetTip:lValid()
      end if

      if oGetSub != nil .and. !Empty( ::oSubTipoExpediente:oDbf:cCodSub )
         oGetSub:cText( ::oSubTipoExpediente:oDbf:cCodSub )
         oGetSub:lValid()
      end if

   end if

RETURN nil

//---------------------------------------------------------------------------//