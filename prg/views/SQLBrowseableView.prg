#include "FiveWin.Ch"
#include "Factu.Ch"

#define dfnTreeViewWidth      250
#define dfnSplitterWidth      1
#define dfnSplitterHeight     76
#define dfnColorTop           rgb( 238, 110, 115 )

//------------------------------------------------------------------------//

CLASS SQLBrowseableView 

   DATA oController

   DATA oModel 

   DATA oMenuTreeView

   DATA oSQLBrowseView

   // Facades -----------------------------------------------------------------

   METHOD setController( oController )       INLINE ( ::oController := oController )
   METHOD getController()                    INLINE ( ::oController )

   METHOD setModel( oModel )                 INLINE ( ::oModel := oModel  )
   METHOD getModel()                         INLINE ( iif( empty( ::oModel ), ::oController:getModel(), ::oModel ) )

   METHOD getModelColumns()                  INLINE ( ::getModel():hColumns )
   METHOD getModelExtraColumns()             INLINE ( ::getModel():hExtraColumns )

   METHOD getModelColumnsForBrowse()         INLINE ( ::getModel():getColumnsForBrowse() )
   METHOD getModelHeadersForBrowse()         INLINE ( ::getModel():getHeadersForBrowse() )

   METHOD getModelHeaderFromColumnOrder()    INLINE ( ::getModel():getHeaderFromColumnOrder() )

   METHOD getSQLBrowseView()                 INLINE ( ::oSQLBrowseView )
   METHOD getBrowse()                        INLINE ( ::oSQLBrowseView:oBrowse )

   METHOD getColumnByHeader( cHeader )       INLINE ( ::getBrowse():getColumnByHeader( cHeader ) )
   METHOD getColumnOrder( cSortOrder )       INLINE ( ::getBrowse():getColumnOrder( cSortOrder ) )
   METHOD getColumnOrderByHeader( cHeader )  INLINE ( ::getBrowse():getColumnOrderByHeader( cHeader ) )

   METHOD selectColumnOrder( oCol )          INLINE ( ::getBrowse():selectColumnOrder( oCol ) )

   METHOD getMenuTreeView()                  INLINE ( ::oMenuTreeView )

   METHOD Refresh()                          INLINE ( ::getMenuTreeView():SelectButtonMain(), ::getBrowse():SetFocus(), ::getBrowse():refreshCurrent() )
   METHOD RefreshRowSet()                    INLINE ( ::getModel():buildRowSet(), ::Refresh() )

   //--------------------------------------------------------------------------

   METHOD onChangeCombo()
   METHOD onChangeSearch()

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

METHOD onChangeSearch()

   local uValue
   local oSearch        := ::getGetSearch()
   local cOrder         := ::getComboBoxOrder():varGet()
   local cColumnOrder   := ::getBrowse():getColumnOrderByHeader( cOrder )

   if empty( oSearch )
      RETURN ( Self )
   end if 

   if empty( cColumnOrder )
      RETURN ( Self )
   end if 

   uValue               := oSearch:oGet:Buffer()
   uValue               := alltrim( upper( cvaltochar( uValue ) ) )
   uValue               := strtran( uValue, chr( 8 ), "" )
   
   if ::getModel():find( uValue, cColumnOrder )
      oSearch:SetColor( Rgb( 0, 0, 0 ), Rgb( 255, 255, 255 ) )
   else
      oSearch:SetColor( Rgb( 255, 255, 255 ), Rgb( 255, 102, 102 ) )
   end if
   
   ::getBrowse():refreshCurrent()

RETURN ( nil )

//----------------------------------------------------------------------------//


