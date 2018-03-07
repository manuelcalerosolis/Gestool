#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Ads.ch"

//---------------------------------------------------------------------------//

CLASS SQLBaseView
  
   DATA oController

   DATA oEvents 

   DATA oDialog

   DATA oBtnOk

   DATA oBtnOkAndNew

   DATA oOfficeBar

   DATA oOfficeBarFolder

   DATA hTextMode                                     INIT {   __append_mode__      => "Añadiendo ",;
                                                               __edit_mode__        => "Modificando ",;
                                                               __zoom_mode__        => "Visualizando ",;
                                                               __duplicate_mode__   => "Duplicando " }

   METHOD New()
   METHOD End()                                       

   METHOD lblTitle()                                  INLINE ( iif(  hhaskey( ::hTextMode, ::oController:getMode() ),;
                                                                     hget( ::hTextMode, ::oController:getMode() ),;
                                                                     "" ) )

   // Facades------------------------------------------------------------------

   METHOD getModel()                                  INLINE ( ::oController:oModel )
   METHOD getModelBuffer()                            INLINE ( ::oController:oModel:hBuffer ) 
   METHOD setGetModelBuffer( uValue, cName )          INLINE ( iif(  hb_isnil( uValue ),;
                                                                     hGet( ::oController:oModel:hBuffer, cName ),;
                                                                     hSet( ::oController:oModel:hBuffer, cName, uValue ) ) )

   METHOD getController()                             INLINE ( ::oController )    
   METHOD getSenderController()                       INLINE ( ::oController:oSenderController )    

   METHOD getComboBoxOrder()                          VIRTUAL

   // Events-------------------------------------------------------------------

   METHOD setEvent( cEvent, bEvent )                  INLINE ( iif( !empty( ::oEvents ), ::oEvents:set( cEvent, bEvent ), ) )
   METHOD fireEvent( cEvent )                         INLINE ( iif( !empty( ::oEvents ), ::oEvents:fire( cEvent ), ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController )

   ::oController                                      := oController

   ::oEvents                                          := Events():New()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD End()

   if !empty( ::oEvents )
      ::oEvents:End()
   end if 

   ::oEvents   := nil

RETURN ( nil )

//---------------------------------------------------------------------------//

