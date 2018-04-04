#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Ads.ch"

//---------------------------------------------------------------------------//

CLASS SQLBaseView
  
   DATA oController

   DATA oEvents 

   DATA oTimer

   DATA oDialog

   DATA oMessage

   DATA cMessage

   DATA oBitmap
   
   DATA cBitmap

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

   METHOD Activate()                                  VIRTUAL

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

   METHOD ShowMessage( cMessage )        
   METHOD RestoreMessage()

   METHOD verticalHide( oControl )
   METHOD verticalShow( oControl )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController )

   ::oController                                      := oController

   ::oEvents                                          := Events():New()

   ::oTimer                                           := TTimer():New( 4000, {|| ::RestoreMessage() } )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD End()

   if !empty( ::oEvents )
      ::oEvents:End()
      ::oEvents   := nil
   end if 

   if !empty( ::oTimer )
      ::oTimer:End()
      ::oTimer   := nil
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD ShowMessage( cMessage )

   if !empty( ::oBitmap )
      ::cBitmap   := ::oBitmap:cResName
      ::oBitmap:setBMP( "gc_sign_warning_48" )
   end if 

   if !empty( ::oMessage )
      ::cMessage  := ::oMessage:cCaption
      ::oMessage:setColor( rgb( 229, 57, 53 ), GetSysColor( COLOR_BTNFACE ) )
      ::oMessage:setText( cMessage )
   end if 

   if !empty( ::oTimer )
      ::oTimer:Activate()
   end if 

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD RestoreMessage()

   if !empty( ::oBitmap )
      ::oBitmap:setBMP( ::cBitmap )
   end if 

   if !empty( ::oMessage )
      ::oMessage:setColor( rgb( 0, 0, 0 ), GetSysColor( COLOR_BTNFACE ) )
      ::oMessage:setText( ::cMessage )
   end if 

   if !empty( ::oTimer )
      ::oTimer:DeActivate()
   end if 

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD verticalHide( oControl )

   local nId     
   local nHeight  

   if !( oControl:lVisible )
      RETURN ( .f. )
   end if  

   nId            := oControl:nId
   nHeight        := oControl:nHeight + 2

   oControl:Hide()

   aeval( ::oDialog:aControls,;
      {|oControl| if( oControl:nId >= 100 .and. oControl:nId > nId,;
         oControl:move( oControl:nTop - nHeight, oControl:nLeft, oControl:nWidth, oControl:nHeight ), ) } )

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD verticalShow( oControl )

   local nId     
   local nHeight 

   if oControl:lVisible
      RETURN ( .f. )
   end if  

   nId            := oControl:nId
   nHeight        := oControl:nHeight + 2

   oControl:Show()

   aeval( ::oDialog:aControls,;
      {|oControl| if( oControl:nId >= 100 .and. oControl:nId > nId,;
         oControl:move( oControl:nTop + nHeight, oControl:nLeft, oControl:nWidth, oControl:nHeight ), ) } )

RETURN ( .t. )

//---------------------------------------------------------------------------//

