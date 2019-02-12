#include "FiveWin.Ch"
#include "Factu.Ch"

#define dfnTreeViewWidth      250
#define dfnSplitterWidth      1
#define dfnSplitterHeight     76
#define dfnColorTop           rgb( 238, 110, 115 )

//------------------------------------------------------------------------//

CLASS SQLBrowseableView FROM SQLBaseView

   DATA oModel 

   DATA oMenuTreeView

   METHOD New( oController ) CONSTRUCTOR
   METHOD End()

   // Facades -----------------------------------------------------------------

   METHOD setController( oController )       INLINE ( ::oController := oController )
   METHOD getController()                    INLINE ( ::oController )

   // Models-------------------------------------------------------------------

   METHOD setModel( oModel )                 INLINE ( ::oModel := oModel )
   METHOD getModel()                         INLINE ( iif( empty( ::oModel ), ::oController:getModel(), ::oModel ) )

   METHOD getModelColumns()                  INLINE ( ::getModel():hColumns )
   METHOD getModelExtraColumns()             INLINE ( ::getModel():hExtraColumns )

   METHOD getModelColumnsForBrowse()         INLINE ( ::getModel():getColumnsForBrowse() )
   METHOD getModelHeadersForBrowse()         INLINE ( ::getModel():getHeadersForBrowse() )

   METHOD getModelHeaderFromColumnOrder()    INLINE ( ::getModel():getHeaderFromColumnOrder() )

   // Browse-------------------------------------------------------------------

   METHOD getBrowseView()                    INLINE ( iif( !empty( ::oController ), ::oController:getBrowseView(), ) )

   METHOD getBrowse()                        INLINE ( ::getBrowseView():oBrowse )

   METHOD getColumnByHeader( cHeader )       INLINE ( ::getBrowse():getColumnByHeader( cHeader ) )
   METHOD getColumnOrder( cSortOrder )       INLINE ( ::getBrowse():getColumnOrder( cSortOrder ) )
   METHOD getColumnOrderByHeader( cHeader )  INLINE ( ::getBrowse():getColumnOrderByHeader( cHeader ) )

   METHOD selectColumnOrder( oCol )          INLINE ( ::getBrowse():selectColumnOrder( oCol ) )

   METHOD Refresh()                          INLINE ( ::getBrowse():Refresh(), ::getBrowse():setFocus() )
   METHOD RefreshRowSet()                    INLINE ( iif(  !empty( ::oController ) .and. !empty( ::oController:oRowSet ),;
                                                            ::oController:oRowSet:Refresh(),;
                                                            ::Refresh() ) )

   METHOD onChangeCombo()
   
   METHOD onChangeSearch()

   METHOD getMenuTreeView()                  INLINE ( if( empty( ::oMenuTreeView ), ::oMenuTreeView := MenuTreeView():New( Self ), ), ::oMenuTreeView )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( oController )

   ::Super:New( oController )

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD End()

   if !empty( ::oMenuTreeView )
      ::oMenuTreeView:end()
   end if 

RETURN ( ::Super:End() )

//----------------------------------------------------------------------------//

METHOD onChangeCombo( oColumn )

   if empty( oColumn )
      msgInfo( "La columna esta vacia" )
      RETURN ( nil )
   end if 

   ::getController():changeModelOrderAndOrientation( oColumn:cSortOrder, oColumn:cOrder )

   ::getBrowse():selectColumnOrder( oColumn )

   ::getBrowse():Refresh()

   ::getBrowse():setFocus()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD onChangeSearch()

   local uValue
   local nRecCount
   local oSearch        := ::getGetSearch()
   local aColumns       := ::getBrowseView():getVisibleColumnsSortOrder()

   if empty( oSearch )
      RETURN ( nil )
   end if 

   if empty( aColumns )
      msgInfo( "La columna seleccionada no permite busquedas" ) 
      RETURN ( nil )
   end if 

   uValue               := oSearch:oGet:Buffer()
   uValue               := alltrim( upper( cvaltochar( uValue ) ) )
   uValue               := strtran( uValue, chr( 8 ), "" )
   
   nRecCount            := ::getController():findInModel( uValue, aColumns )

   if hb_isnumeric( nRecCount )
      if nRecCount >= 0
         oSearch:SetColor( Rgb( 0, 0, 0 ), Rgb( 255, 255, 255 ) )
      else
         oSearch:SetColor( Rgb( 255, 255, 255 ), Rgb( 255, 102, 102 ) )
      end if
   end if 

   ::getBrowse():Refresh()

RETURN ( nil )

//----------------------------------------------------------------------------//



