#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

#define  __special_mode__              9

//---------------------------------------------------------------------------//

CLASS Etiquetas FROM SQLBaseView

   DATA     oTree

   DATA     nSelectedNode

   DATA     allSelectedNode

   METHOD   New()

   METHOD   buildSQLShell()

   METHOD   buildSQLBrowse()
  
   METHOD   buildSQLModel()               INLINE ( EtiquetasModel():New() )

   METHOD   getFieldFromBrowse()          INLINE ( ::allSelectedNode )
 
   METHOD   Dialog()
   METHOD      startDialog()
   METHOD      validDialog()

   METHOD   insertAfterAppendButton()

   METHOD   loadTree( oTree, id )
   METHOD      setTree()
   METHOD      changeTree()
   METHOD      changeFindTree( oFind )

   METHOD   AppendChild( oBrowse )

   METHOD   getAllSelectedNode( oTree, aItems )

   METHOD   checkSelectedNode()
   METHOD      getSelectedNode()             INLINE ( ::nSelectedNode )
   METHOD      setSelectedNode( nNode )      INLINE ( ::nSelectedNode := nNode )

   METHOD   checkValidParent()

   METHOD   validBrowse()

   METHOD   LblTitle()

   METHOD   setSelectedItems( aNames, oTree, aItems )
   METHOD      setSelectedItem()

   METHOD   postAppend()                     INLINE ( ::loadTree() )
   METHOD   postEdit()                       INLINE ( ::loadTree() )

END CLASS

//---------------------------------------------------------------------------//

METHOD New()

   ::idUserMap            	:= "01101"

   ::nSelectedNode         := nil

   ::Super:New()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD insertAfterAppendButton()

   DEFINE BTNSHELL RESOURCE "NEW" OF ::oShell ;
      NOBORDER ;
      ACTION   ( ::AppendChild( ::oShell:getBrowse() ) );
      TOOLTIP  "(A)ñadir Hijos";
      BEGIN GROUP;
      HOTKEY   "H";
      LEVEL    ACC_APPD

Return ( Self )

//---------------------------------------------------------------------------//

METHOD buildSQLShell()

   disableAcceso()

   ::oShell                := SQLTShell():New( 2, 10, 18, 70, "Etiquetas", , oWnd(), , , .f., , , ::oModel, , , , , {}, {|| ::Edit() },, {|| ::Delete() },, nil, ::nLevel, "gc_bookmarks_16", ( 104 + ( 0 * 256 ) + ( 63 * 65536 ) ),,, .t. )

      with object ( ::oShell:AddCol() )
         :cHeader          := "ID de etiqueta"
         :cSortOrder       := "id"
         :bEditValue       := {|| ::oModel:getRowSet():fieldGet( "id" ) }
         :nWidth           := 100
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | ::clickOnHeader( oCol, ::oShell:getBrowse(), ::oShell:getCombobox() ) }
      end with

      with object ( ::oShell:AddCol() )
         :cHeader          := "Nombre de la etiqueta"
         :cSortOrder       := "nombre"
         :bEditValue       := {|| ::oModel:getRowSet():fieldGet( "nombre" ) }
         :nWidth           := 400
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | ::clickOnHeader( oCol, ::oShell:getBrowse(), ::oShell:getCombobox() ) }
      end with

      with object ( ::oShell:AddCol() )
         :cHeader          := "Nombre del Padre"
         :cSortOrder       := "nombre_padre"
         :bEditValue       := {|| ::oModel:getRowSet():fieldGet( "nombre_padre" ) }
         :nWidth           := 100
         :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | ::clickOnHeader( oCol, ::oShell:getBrowse(), ::oShell:getCombobox() ) }
      end with

      ::oShell:createXFromCode()

      ::oShell:setDClickData( {|| ::Edit( ::oShell:getBrowse() ) } )

      ::AutoButtons()

   ACTIVATE WINDOW ::oShell

   ::oShell:bValid   := {|| ::saveHistory( ::getHistoryNameShell() , ::oShell:getBrowse() ), .t. }
   ::oShell:bEnd     := {|| ::destroySQLModel() }

   ::oShell:setComboBoxChange( {|| ::changeCombo( ::oShell:getBrowse(), ::oShell:getCombobox() ) } )

   enableAcceso()

Return ( Self )

//----------------------------------------------------------------------------//

METHOD Dialog( lZoom )

   local oDlg
   local oGetNombre
   local oBmpEtiquetas

   DEFINE DIALOG oDlg RESOURCE "ETIQUETA" TITLE ::lblTitle() + "etiqueta"

   REDEFINE BITMAP oBmpEtiquetas ;
         ID       500 ;
         RESOURCE "gc_bookmarks_48" ;
         TRANSPARENT ;
         OF       oDlg

   REDEFINE GET   oGetNombre ;
      VAR         ::oModel:hBuffer[ "nombre" ] ;
      MEMO ;
      ID          100 ;
      WHEN        ( ! ::isZoomMode() ) ;
      OF          oDlg

   ::oTree                       := TTreeView():Redefine( 110, oDlg )
   ::oTree:bItemSelectChanged    := {|| ::changeTree() }
   ::oTree:bWhen                 := {|| ::getMode() != __special_mode__ .and. !::isZoomMode() }

   REDEFINE BUTTON ;
      ID          IDOK ;
      OF          oDlg ;
      WHEN        ( ! ::isZoomMode() ) ;
      ACTION      ( ::validDialog( oDlg, oGetNombre ) )

   REDEFINE BUTTON ;
      ID          IDCANCEL ;
      OF          oDlg ;
      CANCEL ;
      ACTION      ( oDlg:end() )

   // Teclas rpidas-----------------------------------------------------------

   oDlg:AddFastKey( VK_F5, {|| ::validDialog( oDlg ) } )

   // evento bstart-----------------------------------------------------------

   oDlg:bStart    := {|| ::startDialog(), oGetNombre:setFocus() }

   ACTIVATE DIALOG oDlg CENTER

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

METHOD startDialog()

   ::loadTree()

   ::setTree( ::oModel:hBuffer[ "id_padre" ] )

RETURN ( Self )

//---------------------------------------------------------------------------//  

METHOD validDialog( oDlg, oGetNombre )

   ::setSelectedNode( nil )

   if empty( ::oModel:hBuffer[ "nombre" ] )
      msgStop( "Nombre de la etiqueta no puede estar vacío." )
      oGetNombre:setFocus()
      RETURN ( .f. )
   end if 

   ::checkSelectedNode()

   if ( ::isEditMode() )

      if ::oModel:hBuffer[ "id" ] == ::getSelectedNode()
         msgStop( "Referencia a si mismo. Una etiqueta no puede ser padre de si misma.")
         RETURN ( .f. )
      end if

      if !::checkValidParent()
         msgStop( "Referencia cíclica. Una etiqueta hijo no puede ser padre de su padre")
         RETURN ( .f. )
      endif

   end if 

   ::oModel:hBuffer[ "id_padre" ] := ::getSelectedNode()

RETURN ( oDlg:end( IDOK ) )

//----------------------------------------------------------------------------//

METHOD AppendChild( oBrowse )

   if ::notUserAppend()
      msgStop( "Acceso no permitido." )
      RETURN ( Self )
   end if 

   ::setMode( __special_mode__ )

   ::oModel:setIdForRecno( ::oModel:getKeyFieldOfRecno() )

   ::oModel:loadChildBuffer()

   if ::Dialog()
      ::oModel:insertChildBuffer()
   end if

   if !empty( oBrowse )
      oBrowse:refreshCurrent()
      oBrowse:setFocus()
   end if 

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD loadTree( id, oTree )

   local oNode
   local nRecno
   local nPosition

   default id     := ""
   default oTree  := ::oTree

   id             := cValToStr( id )

   nRecno         := ::oModel:getRowSet():Recno()

   nPosition      := ::oModel:getRowSet():find( id, "id_padre" )

   while ( nPosition != 0 )

      oNode       := oTree:add( ::oModel:getRowSet():fieldGet( "nombre" ) )
      oNode:Cargo := ::oModel:getRowSet():fieldGet( "id" )

      ::loadTree( oNode:Cargo, oNode )

      ::oModel:getRowSet():goto( nPosition )

      nPosition   := ::oModel:getRowSet():findNext( id, "id_padre" )

   end while

   ::oModel:getRowSet():goTo( nRecno )

   oTree:Expand()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD setTree( Id, oTree, aItems )

   local oItem

   default oTree  := ::oTree

   if empty( aItems )
      aItems      := oTree:aItems
   end if

   for each oItem in aItems

      if ( alltrim( cValToStr( id ) ) == alltrim( cValToStr( oItem:Cargo ) ) )

         oTree:Select( oItem )
         oTree:SetCheck( oItem, .t. )

         sysRefresh()

      end if

      if len( oItem:aItems ) > 0
         ::setTree( Id, oTree, oItem:aItems )
      end if

   next

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD checkSelectedNode( oTree, aItems )

   local oItem

   default oTree  := ::oTree

   if empty( aItems )
      aItems      := oTree:aItems
   end if

   for each oItem in aItems

      if oTree:GetCheck( oItem )
         ::setSelectedNode( oItem:Cargo )
      end if

      if len( oItem:aItems ) > 0
         ::checkSelectedNode( oTree, oItem:aItems )
      end if

   next

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD checkValidParent( oTree, nCargo )

   local idTarget    := ::getSelectedNode()

   if empty(idTarget)
      RETURN ( .t. )
   end if 

   while idTarget != 0

      if ::oModel:getRowSet():find( idTarget, "id" ) != 0

         idTarget := val( ::oModel:getRowSet():fieldget( "id_padre" ) )

      end if

      if alltrim( cValtoStr( idTarget ) ) == alltrim( cValtoStr( ::oModel:hBuffer[ "id" ] ) )

         RETURN ( .f. )
          
      endif

   end while

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD changeTree( oTree, aItems )

   local oItem

   default oTree  := ::oTree

   if empty( aItems )
      aItems      := oTree:aItems
   end if

   for each oItem in aItems

      SysRefresh()

      oTree:SetCheck( oItem, .f. )

      if len( oItem:aItems ) > 0
         ::changeTree( oTree, oItem:aItems )
      end if

   next

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD LblTitle()

   if ::getMode() == __special_mode__
      RETURN ( "Añadiendo hijo a " )
   end if 

RETURN( ::Super:lblTitle() )

//---------------------------------------------------------------------------//

METHOD buildSQLBrowse( aSelectedItems )

   local oDlg
   local oFind
   local cFind       := space( 200 )

   ::allSelectedNode := {}

   DEFINE DIALOG oDlg RESOURCE "HELP_ETIQUETAS" TITLE "Seleccionar etiquetas"

      REDEFINE GET   oFind ; 
         VAR         cFind ;
         ID          104 ;
         BITMAP      "FIND" ;
         OF          oDlg

      oFind:bChange  := {|| ::changeFindTree( oFind ) }

      ::oTree        := TTreeView():Redefine( 110, oDlg )

      REDEFINE BUTTON ;
         ID          IDOK ;
         OF          oDlg ;
         ACTION      ( ::validBrowse( oDlg ) )

      REDEFINE BUTTON ;
         ID          IDCANCEL ;
         OF          oDlg ;
         CANCEL ;
         ACTION      ( oDlg:end() )

      REDEFINE BUTTON ;
         ID          500 ;
         OF          oDlg ;
         ACTION      ( ::Append() )

      REDEFINE BUTTON ;
         ID          501 ;
         OF          oDlg ;
         ACTION      ( ::Edit() )

      oDlg:AddFastKey( VK_RETURN,   {|| ::validBrowse( oDlg ) } )
      oDlg:AddFastKey( VK_F5,       {|| ::validBrowse( oDlg ) } )
      oDlg:AddFastKey( VK_F2,       {|| ::Append() } )
      oDlg:AddFastKey( VK_F3,       {|| ::Edit() } )

      oDlg:bStart    := {|| ::loadTree(), ::setSelectedItems( aSelectedItems ) }

   oDlg:Activate( , , , .t., )

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//


//---------------------------------------------------------------------------//

METHOD changeFindTree( oFind )

   local oItem
   local cFind    := alltrim( oFind:cText )

   if !empty(cFind)
      oItem       := ::oTree:Scan( { | o | cFind $ o:cPrompt } )
   end if 

   if !empty(oItem)
      ::oTree:Select( oItem )
   end if 

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD validBrowse( oDlg )

   ::getAllSelectedNode()
   
RETURN ( oDlg:end( IDOK ) )

//---------------------------------------------------------------------------//

METHOD getAllSelectedNode( oTree, aItems )

   local oItem

   default oTree  := ::oTree

   if empty( aItems )
      aItems      := oTree:aItems
   end if

   for each oItem in aItems

      if oTree:GetCheck( oItem )
         aadd( ::allSelectedNode, ( oItem:cPrompt ) )  
      end if

      if len( oItem:aItems ) > 0
         ::getAllSelectedNode( oTree, oItem:aItems )
      end if

   next

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD setSelectedItems( aNames )

   if empty( aNames )
      RETURN nil
   end if

RETURN ( aeval( aNames, {|cName| ::setSelectedItem( cName ) } ) )

//---------------------------------------------------------------------------//

METHOD setSelectedItem( cName, oTree, aItems )

   local oItem

   default oTree  := ::oTree

   if empty( aItems )
      aItems      := oTree:aItems
   end if

   for each oItem in aItems

      if ( alltrim( cValToStr( cName ) ) == alltrim( cValToStr( oItem:cPrompt ) ) )

         oTree:Select( oItem )
         oTree:SetCheck( oItem, .t. )

         sysRefresh()

      end if

      if len( oItem:aItems ) > 0
         ::setSelectedItem( cName, oTree, oItem:aItems )
      end if

   next

RETURN ( Self )

//---------------------------------------------------------------------------//
