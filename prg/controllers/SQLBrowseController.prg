#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS SQLBrowseController FROM SQLBaseController

   DATA oBrowseView

   METHOD New()

   METHOD Activate()

   // Rowset-------------------------------------------------------------------

   METHOD getRowSet()                                 INLINE ( ::oRowSet )
   METHOD saveRecNo()                                 INLINE ( ::oRowSet:saveRecNo() )
   METHOD setRecNo()                                  INLINE ( ::oRowSet:setRecNo() )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oSenderController )

   ::Super:New( oSenderController )

   ::oBrowseView                                      := SQLBrowseView():New( self )

   ::oRowSet                                          := SQLRowSet():New( self )

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

