#include "FiveWin.Ch"
#include "Factu.Ch"

//------------------------------------------------------------------------//

CLASS SQLDialogView FROM SQLBrowseableView 

   DATA oEvents

   DATA oDialog

   DATA cTitle

   DATA oMessage                               

   DATA oOfficeBar

   DATA oGetSearch
   DATA cGetSearch                              INIT space( 200 )

   DATA bInitActivate

   METHOD New( oController )
   METHOD End()

   METHOD Activate( bInitActivate )
      METHOD ActivateMoved()                    INLINE ( ::Activate( .f. ) )
      METHOD initActivate()                     INLINE ( .t. )

   METHOD isActive()                            INLINE ( ::oDialog != nil )

   METHOD Start()

   METHOD getGetSearch()                        INLINE ( ::oGetSearch )
   METHOD getWindow()                           INLINE ( ::oDialog )

   METHOD getSelectedBuffer()                   INLINE ( ::hSelectedBuffer )

   METHOD setTitle( cTitle )                    INLINE ( ::cTitle := cTitle )
   METHOD getTitle()                            INLINE ( iif( empty( ::cTitle ), ::defaultTitle(), ::cTitle ) )

   METHOD defaultTitle()                  

   METHOD Select()                              INLINE ( nil )

   METHOD Append()  

   METHOD setEvents( aEvents, bEvent )                
   METHOD setEvent( cEvent, bEvent )            INLINE ( if( !empty( ::oEvents ), ::oEvents:set( cEvent, bEvent ), ) )
   METHOD fireEvent( cEvent, uValue )           INLINE ( if( !empty( ::oEvents ), ::oEvents:fire( cEvent, uValue ), ) )                            

//Construcciones tardias--------------------------------------------------------

   METHOD getMenutreeView()                     INLINE ( if( empty( ::oMenuTreeView ), ::oMenuTreeView := MenuTreeView():New( Self ), ), ::oMenuTreeView )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( oController )

   ::oController           := oController

   ::oEvents               := Events():New()

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD End()

   if !empty( ::oDialog )
      ::oDialog:End()
   end if 

   if !empty( ::oMenuTreeView )
      ::oMenuTreeView:End()
   end if 

   if !empty( ::oEvents )
      ::oEvents:End()
   end if 

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD Activate()

   if isFalse( ::fireEvent( 'activating' ) )
      RETURN ( .f. )
   end if

   DEFINE DIALOG     ::oDialog ;
      RESOURCE       "SELECTOR_DIALOG_SQL" ;
      TITLE          ::oController:getTitle()

   REDEFINE BITMAP   ::oBitmap ;
      ID             900 ;
      RESOURCE       ::oController:getImage( "48" ) ;
      TRANSPARENT ;
      OF             ::oDialog

   REDEFINE SAY      ::oMessage ;
      PROMPT         ::getTitle() ;
      ID             800 ;
      FONT           oFontBold() ;
      OF             ::oDialog

   REDEFINE GET      ::oGetSearch ;
      VAR            ::cGetSearch ; 
      ID             100 ;
      PICTURE        "@!" ;
      BITMAP         "Find" ;
      OF             ::oDialog

   // Menu-------------------------------------------------------------------

   ::getMenuTreeView():ActivateDialog( ::oDialog, 120 )

   // Browse-----------------------------------------------------------------

   ::getBrowseView():ActivateDialog( ::oDialog, 130 )

   // Eventos---------------------------------------------------------------

   ::oDialog:bStart              := {|| ::Start() }

   ::getGetSearch():bChange      := {|| ::onChangeSearch() }

   ACTIVATE DIALOG ::oDialog CENTER

   ::fireEvent( 'activated' ) 

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD Append()

   if isFalse( ::fireEvent( 'appending' ) )
      RETURN ( .f. )
   end if

   ::oController:Append()

   ::fireEvent( 'appended' )

   ::Refresh()

RETURN ( .t. )

//----------------------------------------------------------------------------//

METHOD setEvents( aEvents, bEvent )

RETURN ( aeval( aEvents, {|cEvent| ::setEvent( cEvent, bEvent ) } ) )

//----------------------------------------------------------------------------//

METHOD Start()

   ::oMenuTreeView:Default()

   ::oMenuTreeView:AddSelectorButtons()
   
RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD defaultTitle()

   local cTitle   

   cTitle         := ::oController:getTitle() + " : "  

   if empty( ::oController:oController:oModel )
      RETURN ( cTitle )
   end if 

   if empty( ::oController:oController:oModel:hBuffer )
      RETURN ( cTitle )
   end if 

   if hhaskey( ::oController:oController:oModel:hBuffer, "codigo" ) 
      cTitle      += alltrim( ::oController:oController:oModel:hBuffer[ "codigo" ] ) + " - "
   end if 

   if hhaskey( ::oController:oController:oModel:hBuffer, "nombre" ) 
      cTitle      += alltrim( ::oController:oController:oModel:hBuffer[ "nombre" ] ) 
   end if 

RETURN ( cTitle )

//----------------------------------------------------------------------------//
