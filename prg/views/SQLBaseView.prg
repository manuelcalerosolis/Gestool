#include "FiveWin.Ch"
#include "Factu.ch" 
#include "Ads.ch"

//---------------------------------------------------------------------------//

CLASS SQLBaseView
  
   DATA oEvents 

   DATA oTimer

   DATA oFontBold

   DATA oController

   DATA oDialog

   DATA oFolder

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

   DATA oExplorerBar

   DATA cTitle

   METHOD New() CONSTRUCTOR
   METHOD End()      

   METHOD Activate()                   VIRTUAL
   METHOD Activating()                 VIRTUAL
   METHOD Activated()                  VIRTUAL
   METHOD closeActivate()

   METHOD lblTitle()                   INLINE ( iif(  hhaskey( ::hTextMode, ::getController():getMode() ),;
                                                      hget( ::hTextMode, ::getController():getMode() ),;
                                                      "" ) )

   // Facades------------------------------------------------------------------

   METHOD getModel()                   INLINE ( ::getController():oModel )
   METHOD getModelBuffer()             INLINE ( ::getController():oModel:hBuffer ) 
   
   METHOD setGetModelBuffer( uValue, cName ) ;
                                       INLINE ( iif(  hb_isnil( uValue ),;
                                                      hGet( ::getController():oModel:hBuffer, cName ),;
                                                      hSet( ::getController():oModel:hBuffer, cName, uValue ) ) )

   METHOD getController()              INLINE ( ::oController )    
   METHOD getSuperController()         INLINE ( ::getController():getController() )    

   METHOD getComboBoxOrder()           VIRTUAL

   METHOD redefineExplorerBar( idExplorerBar ) 

   METHOD getSelectedRecords()

   // Events-------------------------------------------------------------------

   METHOD showMessage( cMessage )        
   METHOD restoreMessage()

   METHOD setMessage( cMessage )       INLINE ( iif( empty( ::cMessage ), ::cMessage := cMessage, ) )
   METHOD setBitmap( cBitmap )         INLINE ( iif( empty( ::cBitmap ), ::cBitmap := cBitmap, ) )

   METHOD verticalHide( oControl )
   METHOD verticalShow( oControl )

   METHOD getEvents()                  INLINE ( if( empty( ::oEvents ), ::oEvents := Events():New(), ), ::oEvents )

   METHOD setEvent( cEvent, bEvent )   INLINE ( ::getEvents():set( cEvent, bEvent ) )
   METHOD fireEvent( cEvent, uValue )  INLINE ( ::getEvents():fire( cEvent, uValue ) )

   METHOD getControl( nId )                              

   METHOD getTimer()  

   METHOD defaultTitle()                                           

   METHOD setTitle( cTitle )           INLINE ( ::cTitle := cTitle )
   METHOD getTitle()                   INLINE ( iif( empty( ::cTitle ), ::defaultTitle(), ::cTitle ) )          

   METHOD paintedActivate()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oController )

   ::oController                       := oController

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD End()

   if !empty( ::oEvents )
      ::oEvents:End()
   end if 

   if !empty( ::oTimer )
      ::oTimer:End()
   end if 

RETURN ( hb_gcall( .t. ) )

//---------------------------------------------------------------------------//

METHOD closeActivate( oDialogValidate )

   DEFAULT oDialogValidate := ::oDialog

   if ::getController():isZoomMode() 

      ::oDialog:end()
   
      RETURN ( nil )

   end if 

   if validateDialog( oDialogValidate )
      ::oDialog:end( IDOK )
   end if

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD ShowMessage( cMessage )

   if !empty( ::oBitmap )
      ::setBitmap( ::oBitmap:cResName )
      ::oBitmap:setBMP( "gc_sign_warning_48" )
   end if 

   if !empty( ::oMessage )
      ::setMessage( ::oMessage:cCaption )
      ::oMessage:setColor( rgb( 229, 57, 53 ), GetSysColor( COLOR_BTNFACE ) )
      ::oMessage:setText( cMessage )
   end if 

   ::getTimer():Activate()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD getTimer()                                  

   if empty( ::oTimer )
      ::oTimer := TTimer():New( 4000, {|| ::RestoreMessage() } )
   end if 

RETURN ( ::oTimer )

//---------------------------------------------------------------------------//

METHOD RestoreMessage()

   if !empty( ::oBitmap )
      ::oBitmap:setBMP( ::cBitmap )
   end if 

   if !empty( ::oMessage )
      ::oMessage:setColor( rgb( 0, 0, 0 ), GetSysColor( COLOR_BTNFACE ) )
      ::oMessage:setText( ::cMessage )
   end if 

   ::getTimer():deActivate()

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD verticalHide( oControl )

   local nId     
   local nHeight  

   if !( oControl:lVisible )
      RETURN ( .f. )
   end if  

   nId            := oControl:nId
   nHeight        := oControl:nHeight + 1

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
   nHeight        := oControl:nHeight + 1

   oControl:Show()

   aeval( ::oDialog:aControls,;
      {|oControl| if( oControl:nId >= 100 .and. oControl:nId > nId,;
         oControl:move( oControl:nTop + nHeight, oControl:nLeft, oControl:nWidth, oControl:nHeight ), ) } )

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD redefineExplorerBar( idExplorerBar ) 

   DEFAULT idExplorerBar         := 100

   ::oExplorerBar                := TApoloExplorerBar():Redefine( idExplorerBar, ::oDialog )

   ::oExplorerBar:nBottomColor   := rgb( 255, 255, 255 )
   ::oExplorerBar:nTopColor      := rgb( 255, 255, 255 )

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD getSelectedRecords()

   local nLen  

   nLen                    := len( ::getController():getIds() )

   if nLen > 1 
      RETURN ( hb_ntos( nLen ) + " registros seleccionados" )
   end if 

RETURN ( hb_ntos( nLen ) + " registro seleccionado" )

//---------------------------------------------------------------------------//

METHOD defaultTitle()

   local cTitle   

   cTitle         := ::getController():getTitle() + " : "  

   if empty( ::getController():oModel )
      RETURN ( cTitle )
   end if 

   if empty( ::getController():oModel:hBuffer )
      RETURN ( cTitle )
   end if 

   if hhaskey( ::getController():oModel:hBuffer, "codigo" ) 
      cTitle      += alltrim( ::getController():oModel:hBuffer[ "codigo" ] ) + " - "
   end if 

   if hhaskey( ::getController():oModel:hBuffer, "nombre" ) 
      cTitle      += alltrim( ::getController():oModel:hBuffer[ "nombre" ] ) 
   end if 

RETURN ( cTitle )

//---------------------------------------------------------------------------//

METHOD paintedActivate() 

RETURN ( ::fireEvent( 'painted', self ) )

//---------------------------------------------------------------------------//

METHOD getControl( nId, oDialog )

   local nPos

   DEFAULT oDialog   := ::oDialog

   if empty( oDialog ) 
      RETURN ( nil )
   end if 
   
   nPos              := ascan( oDialog:aControls, { | o | o:nId == nId } ) 
   if nPos == 0
      RETURN ( nil )
   end if 

RETURN ( oDialog:aControls[ nPos ] )

//---------------------------------------------------------------------------//
