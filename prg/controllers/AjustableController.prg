#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS AjustableController FROM SQLBaseController

   METHOD New() CONSTRUCTOR

   METHOD End()

   //Construcciones tardias----------------------------------------------------

   METHOD getModel()             INLINE ( iif( empty( ::oModel ), ::oModel := SQLAjustableModel():New( self ), ), ::oModel )

   METHOD getDialogView()        INLINE ( iif( empty( ::oDialogView ), ::oDialogView := AjustableView():New( self ), ), ::oDialogView )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController )

   ::Super:New( oController )

   ::getDialogView():setEvent( 'startingActivate', {|| ::oController:startingActivate() } )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End()

   if !empty( ::oModel )
      ::oModel:End()
   end if 

   if !empty( ::oDialogView )
      ::oDialogView:End()
   end if 

RETURN ( ::Super:End() )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

