#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS SQLBrowseController FROM SQLBaseController

   DATA oBrowseView

   METHOD New()

   METHOD Activate()

   METHOD onChangeCombo( oColumn )

   METHOD Delete()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oSenderController )

   ::Super:New( oSenderController ) 

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD Activate( oDialog, nId )

   if empty( ::oBrowseView )
      RETURN ( Self )
   end if 

   ::oRowSet:build( ::oModel:getSelectSentence() )

   ::oBrowseView:ActivateDialog( oDialog, nId )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD onChangeCombo( oColumn )

   ::changeModelOrderAndOrientation( oColumn:cSortOrder, oColumn:cOrder )

   ::oBrowseView:getBrowse():selectColumnOrder( oColumn )

   ::oBrowseView:getBrowse():refreshCurrent()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD Delete()

RETURN ( ::Super:Delete( ::oBrowseView:getBrowseSelected() ) )

//----------------------------------------------------------------------------//