#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//----------------------------------------------------------------------------//

CLASS TGrpFacturasAutomaticas FROM TMant

   DATA  cMru                                   INIT "gc_folder_gear_16"

   DATA  cParentSelect                          INIT Space( 4 )

   DATA  oGetCodigo
   DATA  oGetNombre

   DATA  oTreePadre

   DATA  oBrwFacturaAutomatica
   DATA  aData                                  INIT {}

   METHOD New( cPath, oWndParent, oMenuItem )   CONSTRUCTOR
   METHOD Create( cPath )                       CONSTRUCTOR

   METHOD Activate()

   METHOD OpenFiles( lExclusive )
   MESSAGE OpenService( lExclusive )            METHOD OpenFiles( lExclusive )

   METHOD DefineFiles()

   METHOD Resource( nMode )
   METHOD lSaveResource()
   METHOD StartResource( oGet )

   METHOD aChild( cCodGrupo )
   METHOD IsPadreMayor( cCodGrupo, cCodDesde )
   METHOD IsPadreMenor( cCodGrupo, cCodDesde )

   METHOD Tree( oGet )
   METHOD LoadTree( cCodGrupo )
   METHOD ChangeTreeState( oTree, aItems )
   METHOD GetTreeState( oTree, aItems )
   METHOD SetTreeState( oTree, aItems )

   METHOD RedefineBrowse( id, oDlg )
   METHOD LoadBrowse( aGrupos )
   METHOD ClickBrowse()
   METHOD BrowseToChar()

   METHOD RunPlantillaAutomatica( cCodigoGrupo )

END CLASS

//----------------------------------------------------------------------------//

METHOD New( cPath, oWndParent, oMenuItem )

   DEFAULT cPath        := cPatCli()
   DEFAULT oWndParent   := GetWndFrame()
   DEFAULT oMenuItem    := "04018"

   if Empty( ::nLevel )
      ::nLevel          := Auth():Level( oMenuItem )
   end if

   /*
   Cerramos todas las ventanas
   */

   if oWndParent != nil
      oWndParent:CloseAll()
   end if

   ::cPath              := cPath
   ::oWndParent         := oWndParent
   ::oDbf               := nil

   //::lAutoButtons       := .t.
   ::lCreateShell       := .f.
   ::cHtmlHelp          := "Grupos de plantillas automáticas"

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Create( cPath )

   DEFAULT cPath        := cPatCli()

   ::cPath              := cPath
   ::oDbf               := nil

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Activate()

   local oGen

   if nAnd( ::nLevel, 1 ) != 0
      msgStop( "Acceso no permitido." )
      Return ( Self )
   end if

   /*
   Cerramos todas las ventanas-------------------------------------------------
   */

   if ::oWndParent != nil
      ::oWndParent:CloseAll()
   end if

   if Empty( ::oDbf ) .or. !::oDbf:Used()
      ::lOpenFiles      := ::OpenFiles()
   end if

   /*
   Creamos el Shell------------------------------------------------------------
   */

   if ::lOpenFiles

      if !::lCreateShell
         ::CreateShell( ::nLevel )
      end if

      ::oWndBrw:GralButtons( Self )

      if lUsrMaster() .or. oUser():lDocAuto()

         DEFINE BTNSHELL oGen RESOURCE "GC_FLASH_" OF ::oWndBrw ;
            NOBORDER ;
            ACTION   ( ::RunPlantillaAutomatica( ::oDbf:cCodGrp ) ) ;
            TOOLTIP  "(G)enerar ahora";
            HOTKEY   "G"
   
            DEFINE BTNSHELL RESOURCE "GC_FLASH_" OF ::oWndBrw ;
               ACTION   ( ::RunPlantillaAutomatica() );
               TOOLTIP  "Generar todas ahora" ;
               FROM     oGen
   
      end if

      ::oWndBrw:EndButtons( Self )

      if ::cHtmlHelp != nil
         ::oWndBrw:cHtmlHelp  := ::cHtmlHelp
      end if

      ::oWndBrw:Activate( nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, {|| ::CloseFiles() } )

   end if

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD OpenFiles( lExclusive, cPath )

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
      msgStop( ErrorMessage( oError ), "Imposible abrir todas las bases de datos de grupos de plantillas automáticas" )

   END SEQUENCE
   ErrorBlock( oBlock )

   if !lOpen
      ::CloseFiles()
   end if

RETURN ( lOpen )

//----------------------------------------------------------------------------//

METHOD DefineFiles( cPath, cDriver )

   DEFAULT cPath        := ::cPath
   DEFAULT cDriver      := cDriver()

   DEFINE DATABASE ::oDbf FILE "GrpFac.Dbf" CLASS "GrpFac" ALIAS "GrpFac" PATH ( cPath ) VIA ( cDriver ) COMMENT "Grupos de plantillas automáticas"

      FIELD NAME "cCodGrp"  TYPE "C" LEN  4  DEC 0  COMMENT "Código"       COLSIZE 80        OF ::oDbf
      FIELD NAME "cNomGrp"  TYPE "C" LEN 30  DEC 0  COMMENT "Nombre"       COLSIZE 200       OF ::oDbf
      FIELD NAME "cCodPdr"  TYPE "C" LEN  4  DEC 0  COMMENT "Grupo padre"  COLSIZE 80        OF ::oDbf

      INDEX TO "GrpFac.Cdx" TAG "cCodGrp" ON "cCodGrp"   COMMENT "Código"        NODELETED   OF ::oDbf
      INDEX TO "GrpFac.Cdx" TAG "cNomGrp" ON "cNomGrp"   COMMENT "Nombre"        NODELETED   OF ::oDbf
      INDEX TO "GrpFac.Cdx" TAG "cCodPdr" ON "cCodPdr"   COMMENT "Grupo padre"   NODELETED   OF ::oDbf

   END DATABASE ::oDbf

RETURN ( ::oDbf )

//----------------------------------------------------------------------------//

METHOD Resource( nMode )

	local oDlg

   DEFINE DIALOG oDlg RESOURCE "GRPAUT" TITLE LblTitle( nMode ) + "Grupos de plantillas automáticas"

      REDEFINE GET ::oGetCodigo ;
         VAR      ::oDbf:cCodGrp ;
			ID 		100 ;
         WHEN     ( nMode == APPD_MODE .or. nMode == DUPL_MODE ) ;
         VALID    NotValid( ::oGetCodigo, ::oDbf:cAlias, .t., "0" ) ;
			PICTURE 	"@!" ;
			OF 		oDlg

      REDEFINE GET ::oGetNombre ;
         VAR      ::oDbf:cNomGrp ;
			ID 		110 ;
         WHEN     ( nMode != ZOOM_MODE ) ;
			OF 		oDlg

      /*
      Creamos el arbol---------------------------------------------------------
      */

      ::oTreePadre                     := TTreeView():Redefine( 130, oDlg )
      ::oTreePadre:bItemSelectChanged  := {|| ::ChangeTreeState() }

      /*
      Creamos los botones------------------------------------------------------
      */

      REDEFINE BUTTON ;
         ID       IDOK ;
			OF 		oDlg ;
			WHEN 		( nMode != ZOOM_MODE ) ;
         ACTION   ( ::lSaveResource( nMode, oDlg ) )

		REDEFINE BUTTON ;
         ID       IDCANCEL ;
			OF 		oDlg ;
         CANCEL ;
			ACTION 	( oDlg:end() )

   oDlg:AddFastKey( VK_F5, {|| ::lSaveResource( nMode, oDlg ) } )

   oDlg:bStart          := {|| ::StartResource() }

	ACTIVATE DIALOG oDlg	CENTER

RETURN ( oDlg:nResult == IDOK )

//--------------------------------------------------------------------------//

Method lSaveResource( nMode, oDlg )

   local aGrp

   ::oDbf:cCodPdr    := Space( 4 )

   if ( nMode == APPD_MODE .or. nMode == DUPL_MODE )

      if Empty( ::oDbf:cCodGrp )
         MsgStop( "Código de grupo de facturas no puede estar vacío" )
         ::oGetCodigo:SetFocus()
         Return nil
      end if

      if ::oDbf:SeekInOrd( ::oDbf:cCodGrp, "cCodGrp" )
         msgStop( "Código existente" )
         ::oGetCodigo:SetFocus()
         Return nil
      end if

   end if

   if Empty( ::oDbf:cNomGrp )
      MsgStop( "Nombre de grupo de facturas no puede estar vacío" )
      ::oGetNombre:SetFocus()
      Return nil
   end if

   ::GetTreeState( ::oTreePadre )

   if ( ::oDbf:cCodGrp == ::oDbf:cCodPdr )
      MsgStop( "Grupo padre no puede ser el mismo" )
      ::oTreePadre:SetFocus()
      Return nil
   end if

   aGrp  := ::aChild( ::oDbf:cCodGrp )
   if aScan( aGrp, ::oDbf:cCodPdr ) != 0
      MsgStop( "Grupo padre contiene referencia circular" )
      ::oTreePadre:SetFocus()
      Return nil
   end if

Return oDlg:end( IDOK )

//---------------------------------------------------------------------------//

METHOD StartResource()

   ::LoadTree()

   ::SetTreeState()

   ::oGetCodigo:SetFocus()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD aChild( cCodGrupo, aChild )

   local nRec
   local nOrd

   if Empty( aChild )
      aChild   := {}
   end if

   CursorWait()

   nRec        := ( ::oDbf:cAlias )->( Recno() )
   nOrd        := ( ::oDbf:cAlias )->( OrdSetFocus( "cCodPdr" ) )

   if ( ::oDbf:cAlias )->( dbSeek( cCodGrupo ) )

      while ( ( ::oDbf:cAlias )->cCodPdr == cCodGrupo .and. !( ::oDbf:cAlias )->( Eof() ) )

         aAdd( aChild, ( ::oDbf:cAlias )->cCodGrp )

         ::aChild( ( ::oDbf:cAlias )->cCodGrp, aChild )

         ( ::oDbf:cAlias )->( dbSkip() )

      end while

   end if

   ( ::oDbf:cAlias )->( OrdSetFocus( nOrd ) )
   ( ::oDbf:cAlias )->( dbGoTo( nRec ) )

   CursorWE()

Return ( aChild )

//---------------------------------------------------------------------------//

METHOD IsPadreMayor( cCodGrupo, cCodDesde )

   local cPadre
   local aPadre

   if cCodGrupo >= cCodDesde
      Return .t.
   end if

   if !Empty( cCodGrupo )

      aPadre         := ::aChild( cCodGrupo )

      for each cPadre in aPadre
         if cPadre >= cCodDesde
            Return .t.
         end if
      next

   end if

Return ( .f. )

//---------------------------------------------------------------------------//

METHOD IsPadreMenor( cCodGrupo, cCodHasta )

   local cPadre
   local aPadre

   if cCodGrupo <= cCodHasta
      Return .t.
   end if

   if !Empty( cCodGrupo )

      aPadre         := ::aChild( cCodGrupo )

      for each cPadre in aPadre
         if cPadre <= cCodHasta
            Return .t.
         end if
      next

   end if

Return ( .f. )

//---------------------------------------------------------------------------//

METHOD LoadTree( oTree, cCodGrupo )

   local nRec
   local nOrd
   local oNode

   DEFAULT oTree     := ::oTreePadre

   if Empty( cCodGrupo )
      cCodGrupo      := Space( 4 )
   end if

   CursorWait()

   nRec              := ( ::oDbf:cAlias )->( Recno() )
   nOrd              := ( ::oDbf:cAlias )->( OrdSetFocus( "cCodPdr" ) )

   if ( ::oDbf:cAlias )->( dbSeek( cCodGrupo ) )

      while ( ( ::oDbf:cAlias )->cCodPdr == cCodGrupo .and. !( ::oDbf:cAlias )->( Eof() ) )

         oNode       := oTree:Add( Alltrim( ( ::oDbf:cAlias )->cNomGrp ) )
         oNode:Cargo := ( ::oDbf:cAlias )->cCodGrp

         ::LoadTree( oNode, ( ::oDbf:cAlias )->cCodGrp )

         ( ::oDbf:cAlias )->( dbSkip() )

      end while

   end if

   ( ::oDbf:cAlias )->( OrdSetFocus( nOrd ) )
   ( ::oDbf:cAlias )->( dbGoTo( nRec ) )

   CursorWE()

   oTree:Expand()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD ChangeTreeState( oTree, aItems )

   local oItem

   DEFAULT oTree  := ::oTreePadre

   if Empty( aItems )
      aItems      := oTree:aItems
   end if

   for each oItem in aItems

      SysRefresh()

      // tvSetCheckState( oTree:hWnd, oItem:hItem, .f. )

      oTree:SetCheck( oItem, .f. )

      if len( oItem:aItems ) > 0
         ::ChangeTreeState( oTree, oItem:aItems )
      end if

   next

Return ( Self )

//------------------------------------------------------------------------//

METHOD GetTreeState( oTree, aItems )

   local oItem

   DEFAULT oTree  := ::oTreePadre

   if Empty( aItems )
      aItems      := oTree:aItems
   end if

   for each oItem in aItems

      // if tvGetCheckState( oTree:hWnd, oItem:hItem )
      
      if oTree:GetCheck( oItem )      
         ::oDbf:cCodPdr    := oItem:Cargo
      end if

      if len( oItem:aItems ) > 0
         ::GetTreeState( oTree, oItem:aItems )
      end if

   next

Return ( Self )

//------------------------------------------------------------------------//

METHOD SetTreeState( oTree, aItems )

   local oItem

   DEFAULT oTree  := ::oTreePadre

   if Empty( aItems )
      aItems      := oTree:aItems
   end if

   for each oItem in aItems

      if ( ::oDbf:cCodPdr == oItem:Cargo )

         oTree:Select( oItem )

         // tvSetCheckState( oTree:hWnd, oItem:hItem, .t. )

         oTree:SetCheck( oItem, .t. )

      end if

      if len( oItem:aItems ) > 0
         ::SetTreeState( oTree, oItem:aItems )
      end if

   next

Return ( Self )

//------------------------------------------------------------------------//

METHOD Tree( oGet )

   local oDlg
   local uVal
   local oTree

   uVal                    := oGet:VarGet()

   /*
   Creamos el dialogo----------------------------------------------------------
   */

   oDlg                    := TDialog():New( , , , , "cDlgName", "TreeGruposCliente" )

   oTree                   := TTreeView():Redefine( 100, oDlg  )

   TButton():ReDefine( IDOK, {|| oDlg:end( IDOK ) }, oDlg, , , .f. )

   TButton():ReDefine( IDCANCEL, {|| oDlg:end() }, oDlg, , , .f. )

   oDlg:bStart             := {|| ::StartTree( nil, oTree ) }

   oDlg:AddFastKey( VK_F5, {|| oDlg:end( IDOK ) } )

   oDlg:Activate( , , , .t. )

   /*
   Resultados------------------------------------------------------------------
   */

   if oDlg:nResult == IDOK
      msgStop( "valor" )
   end if

RETURN ( uVal )

//----------------------------------------------------------------------------//

METHOD RedefineBrowse( id, oDlg )

   /*
   Browse de los Factura Automaticas-------------------------------------------
   */

   ::oBrwFacturaAutomatica                   := IXBrowse():New( oDlg )
   
   ::oBrwFacturaAutomatica:bClrSel           := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
   ::oBrwFacturaAutomatica:bClrSelFocus      := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }
   
   ::oBrwFacturaAutomatica:SetArray( ::aData, , , .f. )
   
   ::oBrwFacturaAutomatica:lHScroll          := .f.
   ::oBrwFacturaAutomatica:lVScroll          := .f.
   
   ::oBrwFacturaAutomatica:nMarqueeStyle     := 5
   
   ::oBrwFacturaAutomatica:lRecordSelector   := .f.
   
   ::oBrwFacturaAutomatica:bLDblClick        := {|| ::ClickBrowse() }

   ::oBrwFacturaAutomatica:CreateFromResource( id )

   with object ( ::oBrwFacturaAutomatica:AddCol() )
      :cHeader       := "Sel."
      :bEditValue    := {|| ::aData[ ::oBrwFacturaAutomatica:nArrayAt, 1 ] }
      :nWidth        := 25
      :SetCheck( { "gc_check_16", "Nil16" } )
   end with

   with object ( ::oBrwFacturaAutomatica:AddCol() )
      :cHeader       := "Código"
      :bEditValue    := {|| ::aData[ ::oBrwFacturaAutomatica:nArrayAt, 2 ] }
      :nWidth        := 60
   end with

   with object ( ::oBrwFacturaAutomatica:AddCol() )
      :cHeader       := "Nombre"
      :bEditValue    := {|| ::aData[ ::oBrwFacturaAutomatica:nArrayAt, 3 ] }
      :nWidth        := 200
   end with

Return ( Self )

//------------------------------------------------------------------------//

METHOD LoadBrowse( cGrupos )

   local aGrupos     := hb_ATokens( cGrupos, "," )

   ::aData           := {}

   ::oDbf:GoTop()
   do while !::oDbf:Eof()
      aAdd( ::aData, { aScan( aGrupos, Alltrim( ::oDbf:cCodGrp ) ) != 0, ::oDbf:cCodGrp, ::oDbf:cNomGrp } )
      ::oDbf:Skip()
   end while

   ::oBrwFacturaAutomatica:SetArray( ::aData, , , .f. )

Return ( Self )

//------------------------------------------------------------------------//

METHOD ClickBrowse()

   ::aData[ ::oBrwFacturaAutomatica:nArrayAt, 1 ]  := !::aData[ ::oBrwFacturaAutomatica:nArrayAt, 1 ]

   ::oBrwFacturaAutomatica:Refresh()

Return ( Self )

//------------------------------------------------------------------------//

METHOD BrowseToChar()

   local cMemo := ""

   aEval( ::aData, {|aItem| if( aItem[ 1 ], cMemo += Rtrim( aItem[ 2 ] ) + ",", ) } )

Return ( cMemo )

//------------------------------------------------------------------------//

METHOD RunPlantillaAutomatica( cCodigoGrupo )

   with object ( TCreaFacAutomaticas():New() )

      if :OpenFiles()

         :cCodigoGrupo  := cCodigoGrupo
         
         if :lSelectCodigoPlantilla()
            :Run()
         end if
         
         :CloseFiles()
         
      end if 
      
   end with

Return ( Self )

//-------------------------------------------------------------------------//

Function cCodigoFacturasAutomaticas( cCodigoFacturasAutomaticas, oDbf )

   local cCodigo  := ""

   if oDbf:Seek( cCodigoFacturasAutomaticas )
      cCodigo     := oDbf:cCodGrp
   end if

Return( cCodigo )

//---------------------------------------------------------------------------//

Function cNombreFacturasAutomaticas( cCodigoFacturasAutomaticas, oDbf )

   local cNombre  := ""

   if oDbf:Seek( cCodigoFacturasAutomaticas )
      cNombre     := oDbf:Nombre
   end if

Return( cNombre )

//---------------------------------------------------------------------------//