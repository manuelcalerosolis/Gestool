#include "FiveWin.Ch"
#include "Factu.ch" 

//---------------------------------------------------------------------------//

CLASS AjustableController FROM SQLBaseController

   METHOD New()

   METHOD End()

   METHOD getModel()       INLINE ( ::oModel := SQLAjustableModel():New( self ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController )

   ::Super:New( oController )

   ::oDialogView           := AjustableView():New( self )

   ::oDialogView:setEvent( 'startingActivate', {|| oController:startingActivate() } )

   ::getModel()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End()

   if !empty( ::oModel )
      ::oModel:End()
   end if 

   if !empty( ::oDialogView )
      ::oDialogView:End()
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

