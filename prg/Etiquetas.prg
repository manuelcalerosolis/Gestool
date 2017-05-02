#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS Etiquetas FROM SQLBaseView

   DATA     oTree

   METHOD   New()

   METHOD   buildSQLShell()
  
   METHOD   buildSQLModel()               INLINE ( EtiquetasModel():New() )

   METHOD   getFieldFromBrowse()          INLINE ( ::oModel:getRowSet():fieldGet( "nombre" ) )
 
   METHOD   Dialog()
   METHOD      startDialog()
   METHOD      validDialog()

   METHOD   loadTree( oTree, id )
   METHOD      setTree()
   METHOD      getTree()
   METHOD      changeTree()

END CLASS

//---------------------------------------------------------------------------//

METHOD New()

   ::idUserMap            	:= "01101"	

   ::Super:New()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD buildSQLShell()

   disableAcceso()

   ::oShell                := SQLTShell():New( 2, 10, 18, 70, "Etiquetas", , oWnd(), , , .f., , , ::oModel, , , , , {}, {|| ::Edit() },, {|| ::Delete() },, nil, ::nLevel, "gc_printer2_16", ( 104 + ( 0 * 256 ) + ( 63 * 65536 ) ),,, .t. )

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
         :cHeader          := "Padre"
         :cSortOrder       := "id_padre"
         :bEditValue       := {|| ::oModel:getRowSet():fieldGet( "id_padre" ) }
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

   DEFINE DIALOG oDlg RESOURCE "ETIQUETA" TITLE lblTitle( ::getMode() ) + "etiquetas"

   REDEFINE GET   oGetNombre ;
      VAR         ::oModel:hBuffer[ "nombre" ] ;
      MEMO ;
      ID          100 ;
      WHEN        ( ! ::isZoomMode() ) ;
      OF          oDlg

   ::oTree                     := TTreeView():Redefine( 110, oDlg )
   ::oTree:bItemSelectChanged  := {|| ::changeTree() }

   REDEFINE BUTTON ;
      ID          IDOK ;
      OF          oDlg ;
      WHEN        ( ! ::isZoomMode() ) ;
      ACTION      ( ::validDialog( oDlg ) )

   REDEFINE BUTTON ;
      ID          IDCANCEL ;
      OF          oDlg ;
      CANCEL ;
      ACTION      ( oDlg:end() )

   // Teclas rpidas-----------------------------------------------------------

   oDlg:AddFastKey( VK_F5, {|| ::validDialog( oDlg ) } )

   // evento bstart-----------------------------------------------------------

   oDlg:bStart    := {|| ::startDialog() }

   ACTIVATE DIALOG oDlg CENTER

RETURN ( oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

METHOD startDialog()

   ::loadTree()

RETURN ( Self )

//---------------------------------------------------------------------------//  

METHOD validDialog( oDlg )

   local idPadre                       := ::getTree() 

   if !empty( idPadre )
      ::oModel:hBuffer[ "id_padre" ]   := idPadre
   end if 

RETURN ( oDlg:end( IDOK ) )

//---------------------------------------------------------------------------//

METHOD loadTree( oTree, id )

   local oNode
   local nRecno
   local nPosition

   default oTree  := ::oTree
   default id     := ""

   id             := cValToStr( id )

   nRecno         := ::oModel:getRowSet():Recno()

   nPosition      := ::oModel:getRowSet():find( id, "id_padre" )

   while ( nPosition != 0 )

      oNode       := oTree:add( ::oModel:getRowSet():fieldGet( "nombre" ) )
      oNode:Cargo := ::oModel:getRowSet():fieldGet( "id" )

      ::loadTree( oNode, oNode:Cargo )

      ::oModel:getRowSet():goto( nPosition )

      nPosition   := ::oModel:getRowSet():findNext( id, "id_padre" )

   end while

   ::oModel:getRowSet():goTo( nRecno )

   oTree:Expand()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD setTree( oTree, aItems, id )

   local oItem

   default oTree  := ::oTree

   if empty( aItems )
      aItems      := oTree:aItems
   end if

   for each oItem in aItems

      if ( id == oItem:Cargo )

         oTree:Select( oItem )
         oTree:SetCheck( oItem, .t. )

         sysRefresh()

      end if

      if len( oItem:aItems ) > 0
         ::setTreeState( oTree, oItem:aItems, id )
      end if

   next

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD getTree( oTree, aItems )

   local oItem

   default oTree  := ::oTree

   if empty( aItems )
      aItems      := oTree:aItems
   end if

   for each oItem in aItems

      if oTree:GetCheck( oItem )
         RETURN ( oItem:Cargo )
      end if

      if len( oItem:aItems ) > 0
         ::getTree( oTree, oItem:aItems )
      end if

   next

RETURN ( nil )

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

   



