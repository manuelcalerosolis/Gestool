#include "FiveWin.Ch"
#include "Factu.Ch"

#define dfnTreeViewWidth      250
#define dfnSplitterWidth      1
#define dfnSplitterHeight     76
#define dfnColorTop           rgb( 238, 110, 115 )

#define K_ENTER               13   //   Enter, Ctrl-M

//------------------------------------------------------------------------//

CLASS MenuTreeView

   DATA oSender

   DATA oTreeView

   DATA oImageList

   DATA oButtonMain

   DATA oEvents

   METHOD New( oSender )

   METHOD End()

   METHOD ActivateMDI()
   METHOD ActivateDialog()

   METHOD Default()
   METHOD setImageList()                  INLINE ( ::oTreeView:SetImagelist( ::oImageList ) )
 
   METHOD getController()                 INLINE ( ::oSender:getController() )
   METHOD getBrowse()                     INLINE ( ::oSender:getBrowse() )

   METHOD AddImage()

   METHOD AddButton()

   METHOD AddSearchButton()    

   METHOD AddAppendButton()    
   
   METHOD AddDuplicateButton() 
   
   METHOD AddEditButton()      
   
   METHOD AddZoomButton()      
   
   METHOD AddDeleteButton()    
   
   METHOD AddRefreshButton()
   
   METHOD AddSelectButton()

   METHOD AddExitButton()

   METHOD AddGeneralButton()              INLINE ( ::fireEvent( 'addingGeneralButton' ),;
                                                   ::AddSearchButton(),;
                                                   ::AddRefreshButton(),;
                                                   ::AddAppendButton(),;
                                                   ::AddDuplicateButton(),;
                                                   ::AddEditButton(),;
                                                   ::AddZoomButton(),;
                                                   ::AddDeleteButton(),;
                                                   ::fireEvent( 'addedGeneralButton' ) )

   METHOD AddAutoButtons()                INLINE ( ::fireEvent( 'addingAutoButton' ),;
                                                   ::AddGeneralButton(),;
                                                   ::AddExitButton(),;
                                                   ::oButtonMain:Expand(),;
                                                   ::fireEvent( 'addedAutoButton' ) )

   METHOD AddSelectorButtons()            INLINE ( ::fireEvent( 'addingSelectorButton' ),;
                                                   ::AddGeneralButton(),;
                                                   ::AddSelectButton(),;
                                                   ::AddExitButton(),;
                                                   ::oButtonMain:Expand(),;
                                                   ::fireEvent( 'addedSelectorButton' ) )

   METHOD SelectButtonMain()              INLINE ( ::oTreeView:Select( ::oButtonMain ) )

   METHOD onChange()

   // Events-------------------------------------------------------------------

   METHOD setEvent( cEvent, bEvent )      INLINE ( if( !empty( ::oEvents ), ::oEvents:set( cEvent, bEvent ), ) )
   METHOD fireEvent( cEvent )             INLINE ( if( !empty( ::oEvents ), ::oEvents:fire( cEvent ), ) )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( oSender )

   ::oSender      := oSender

   ::oEvents      := Events():New()   

   ::oImageList   := TImageList():New( 16, 16 )

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD ActivateMDI( nWidth, nHeight )

   ::fireEvent( 'activatingMDI' )

   ::oTreeView    := TTreeView():New( 0, 0, ::oSender:getWindow(), , , .t., .f., nWidth, nHeight ) 
   
   ::Default()

   ::fireEvent( 'activatedMDI' )

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD ActivateDialog( id )

   ::fireEvent( 'activatingDialog' )

   ::oTreeView    := TTreeView():Redefine( id, ::oSender:getWindow() ) 

   ::fireEvent( 'activatedDialog' )

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD Default()

   ::SetImagelist()

   ::oTreeView:SetItemHeight( 20 )

   ::oTreeView:bChanged := {|| ::onChange() }

   if !empty( ::getController():cImage )
      ::oButtonMain     := ::oTreeView:Add( ::getController():cTitle, ::AddImage( ::getController():cImage ) )
   end if 

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD End()

   if !empty( ::oImageList )
      ::oImageList:End()
   end if 

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD AddButton( cText, cResource, bAction, uKey, nLevel, oGroup, lAllowExit ) 

   local oTreeButton

   DEFAULT oGroup       := ::oButtonMain
   DEFAULT lAllowExit   := .f.

   // El nombre del boton es necesario-----------------------------------------

   if empty( cText )
      RETURN ( nil )
   end if 

   // Chequeamos los niveles de acceso si es mayor no montamos el boton--------

   if nLevel != nil .and. nAnd( ::getController():nLevel, nLevel ) == 0
      RETURN ( nil )
   end if

   oTreeButton          := oGroup:Add( cText, ::AddImage( cResource ), bAction )
   oTreeButton:Cargo    := lAllowExit

   ::getController():addFastKey( uKey, bAction )

RETURN ( oTreeButton )

//----------------------------------------------------------------------------//

METHOD AddImage( cImage )

   local oImage
   local nImageList  := 0

   if empty( cImage )
      RETURN ( nImageList )
   end if 

   ::fireEvent( 'addingImage' )

   oImage            := TBitmap():Define( cImage )
   oImage:cResName   := cImage

   ::oImageList:addMasked( oImage, Rgb( 255, 0, 255 ) )
   
   nImageList        := len( ::oImageList:aBitmaps ) - 1

   ::fireEvent( 'addedImage' )

RETURN ( nImageList )

//----------------------------------------------------------------------------//

METHOD AddSearchButton()    

   ::fireEvent( 'addingSearchButton' )

   ::AddButton( "Buscar", "Bus16", {|| ::oSender:getGetSearch():setFocus() }, "B" ) 

   ::fireEvent( 'addedSearchButton' )

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD AddRefreshButton()

   ::fireEvent( 'addingRefreshButton' )

   ::AddButton( "Refrescar", "Refresh16", {|| ::oSender:RefreshRowSet() }, "R" ) 

   ::fireEvent( 'addedRefreshButton' )

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD AddAppendButton()    

   ::fireEvent( 'addingAppendButton' )

   ::AddButton( "Añadir", "New16", {|| ::getController():Append(), ::oSender:Refresh() }, "A", ACC_APPD ) 
   
   ::fireEvent( 'addedAppendButton' )

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD AddDuplicateButton() 

   ::fireEvent( 'addingAppendButton' )

   ::AddButton( "Duplicar", "Dup16", {|| ::getController():Duplicate(), ::oSender:Refresh() }, "D", ACC_APPD ) 

   ::fireEvent( 'addedAppendButton' )

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD AddEditButton()      

   ::fireEvent( 'addingEditButton' )

   ::AddButton( "Modificar", "Edit16", {|| ::getController():Edit(), ::oSender:Refresh() }, "M", ACC_EDIT ) 

   ::fireEvent( 'addedEditButton' )

RETURN ( Self )

//----------------------------------------------------------------------------//
METHOD AddZoomButton()      

   ::fireEvent( 'addingZoomButton' )

   ::AddButton( "Zoom", "Zoom16", {|| ::getController():Zoom(), ::oSender:Refresh() }, "Z", ACC_ZOOM ) 

   ::fireEvent( 'addedZoomButton' )

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD AddDeleteButton()    

   ::fireEvent( 'addingDeleteButton' )

   ::AddButton( "Eliminar", "Del16", {|| ::getController():Delete( ::getBrowse():aSelected ), ::oSender:Refresh() }, "E", ACC_DELE ) 

   ::fireEvent( 'addedDeleteButton' )

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD AddSelectButton()    

   ::fireEvent( 'addingSelectButton' )

   ::AddButton( "Seleccionar [Enter]", "Select16", {|| ::oSender:Select() }, K_ENTER ) 

   ::fireEvent( 'addedSelectButton' )

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD AddExitButton()

   ::fireEvent( 'addingExitButton' )

   ::AddButton( "Salir [ESC]", "End16", {|| ::oSender:End() }, "S" ) 

   ::fireEvent( 'addedExitButton' )

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD onChange()

   local oItem    := ::oTreeView:GetSelected()

   if empty( oItem )
      RETURN ( nil )
   end if 

   if ( oItem:ClassName() != "TTVITEM" ) 
      RETURN ( nil )
   end if 

   if ( !hb_isblock( oItem:bAction ) )
      RETURN ( nil )
   end if 

   eval( oItem:bAction )

RETURN ( Self )

//----------------------------------------------------------------------------//


