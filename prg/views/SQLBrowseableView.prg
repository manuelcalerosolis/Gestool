#include "FiveWin.Ch"
#include "Factu.Ch"

#define dfnTreeViewWidth      250
#define dfnSplitterWidth      1
#define dfnSplitterHeight     76
#define dfnColorTop           rgb( 238, 110, 115 )

//------------------------------------------------------------------------//

CLASS SQLBrowseableView 

   DATA oController

   DATA oMenuTreeView

   DATA oSQLBrowseView

   // Facades -----------------------------------------------------------------

   METHOD getController()                 INLINE ( ::oController )

   METHOD getModel()                      INLINE ( ::oController:getModel() )

   METHOD getModelColumns()               INLINE ( ::getModel():hColumns )
   METHOD getModelExtraColumns()          INLINE ( ::getModel():hExtraColumns )

   METHOD getModelColumnsForBrowse()      INLINE ( ::getModel():getColumnsForBrowse() )
   METHOD getModelHeadersForBrowse()      INLINE ( ::getModel():getHeadersForBrowse() )

   METHOD getModelHeaderFromColumnOrder() INLINE ( ::getModel():getHeaderFromColumnOrder() )

   METHOD getSQLBrowseView()              INLINE ( ::oSQLBrowseView )
   METHOD getBrowse()                     INLINE ( ::oSQLBrowseView:oBrowse )

   METHOD getMenuTreeView()               INLINE ( ::oMenuTreeView )

   METHOD Refresh()                       INLINE ( ::getMenuTreeView():SelectButtonMain(), ::getBrowse():SetFocus() )
   METHOD RefreshRowSet()                 INLINE ( ::getModel():buildRowSet(), ::Refresh() )

   //--------------------------------------------------------------------------

   METHOD onChangeCombo()

ENDCLASS

//----------------------------------------------------------------------------//

METHOD onChangeCombo( oColumn )

   local oComboBox   := ::getComboBoxOrder()

   if empty( oComboBox )
      RETURN ( Self )
   end if 

   if empty( oColumn )
      oColumn        := ::getBrowse():getColumnByHeader( oComboBox:VarGet() )
   end if 

   if empty( oColumn )
      RETURN ( Self )
   end if 

   oComboBox:set( oColumn:cHeader )

   ::getController():changeModelOrderAndOrientation( oColumn:cSortOrder, oColumn:cOrder )

   ::getBrowse():selectColumnOrder( oColumn )

   ::getBrowse():refreshCurrent()

RETURN ( Self )

//---------------------------------------------------------------------------//
