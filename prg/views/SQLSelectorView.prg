#include "FiveWin.Ch"
#include "Factu.Ch"

#define dfnTreeViewWidth      250
#define dfnSplitterWidth      1
#define dfnSplitterHeight     76
#define dfnColorTop           rgb( 238, 110, 115 )

//------------------------------------------------------------------------//

CLASS SQLSelectorView FROM SQLBrowseableView 

   METHOD New( oController )

   METHOD Activate()

   METHOD End()

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( oController )

   ::oController           := oController

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD Activate()

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD End()

RETURN ( nil )

//----------------------------------------------------------------------------//

