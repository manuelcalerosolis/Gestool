#include "FiveWin.Ch"
#include "Factu.Ch"

#define dfnTreeViewWidth      250
#define dfnSplitterWidth      1
#define dfnSplitterHeight     76
#define dfnColorTop           rgb( 238, 110, 115 )

//------------------------------------------------------------------------//

CLASS SQLBrowseableView 

   DATA oController

   // Facades -----------------------------------------------------------------

   METHOD getController()                 INLINE ( ::oController )

   METHOD getModel()                      INLINE ( ::oController:getModel() )

   METHOD getModelColumns()               INLINE ( if( !empty( ::getModel() ), ::getModel():hColumns, ) )
   METHOD getModelExtraColumns()          INLINE ( if( !empty( ::getModel() ), ::getModel():hExtraColumns, ) )

   METHOD getModelColumnsForNavigator()   INLINE ( if( !empty( ::getModel() ), ::getModel():getColumnsForNavigator(), ) )
   METHOD getModelHeadersForNavigator()   INLINE ( if( !empty( ::getModel() ), ::getModel():getHeadersForNavigator(), ) )

   METHOD getModelHeaderFromColumnOrder() INLINE ( if( !empty( ::getModel() ), ::getModel():getHeaderFromColumnOrder(), ) )

ENDCLASS

//----------------------------------------------------------------------------//

