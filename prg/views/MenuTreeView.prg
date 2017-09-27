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

   DATA bOnAfterAddSearchButton 
   DATA bOnAfterAddAppendButton 
   DATA bOnAfterAddDuplicateButton
   DATA bOnAfterAddEditButton   
   DATA bOnAfterAddZoomButton   
   DATA bOnAfterAddDeleteButton
   DATA bOnAfterAddRefreshButton
   DATA bOnAfterAddSelectButton 
   DATA bOnAfterAddExitButton   

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

   METHOD AddGeneralButton()              INLINE ( ::AddSearchButton(),;
                                                   ::AddRefreshButton(),;
                                                   ::AddAppendButton(),;
                                                   ::AddDuplicateButton(),;
                                                   ::AddEditButton(),;
                                                   ::AddZoomButton(),;
                                                   ::AddDeleteButton() )

   METHOD AddAutoButtons()                INLINE ( ::AddGeneralButton(),;
                                                   ::AddExitButton(),;
                                                   ::oButtonMain:Expand() )

   METHOD AddSelectorButtons()            INLINE ( ::AddGeneralButton(),;
                                                   ::AddSelectButton(),;
                                                   ::AddExitButton(),;
                                                   ::oButtonMain:Expand() )

   METHOD SelectButtonMain()              INLINE ( ::oTreeView:Select( ::oButtonMain ) )

   METHOD onChange()

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( oSender )

   ::oSender      := oSender

   ::oImageList   := TImageList():New( 16, 16 )

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD ActivateMDI( nWidth, nHeight )

   ::oTreeView    := TTreeView():New( 0, 0, ::oSender:getWindow(), , , .t., .f., nWidth, nHeight ) 
   
   ::Default()

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD ActivateDialog( id )

   ::oTreeView    := TTreeView():Redefine( id, ::oSender:getWindow() ) 

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

   oImage            := TBitmap():Define( cImage )
   oImage:cResName   := cImage

   ::oImageList:addMasked( oImage, Rgb( 255, 0, 255 ) )
   
   nImageList        := len( ::oImageList:aBitmaps ) - 1

RETURN ( nImageList )

//----------------------------------------------------------------------------//

METHOD AddSearchButton()    

   ::AddButton( "Buscar", "Bus16", {|| ::oSender:getGetSearch():setFocus() }, "B" ) 

RETURN ( if( hb_isblock( ::bOnAfterAddSearchButton ), eval( ::bOnAfterAddSearchButton ), ) )

//----------------------------------------------------------------------------//

METHOD AddRefreshButton()

   ::AddButton( "Refrescar", "Refresh16", {|| ::oSender:RefreshRowSet() }, "R" ) 

RETURN ( if( hb_isblock( ::bOnAfterAddRefreshButton ), eval( ::bOnAfterAddRefreshButton ), ) )

//----------------------------------------------------------------------------//

METHOD AddAppendButton()    

   ::AddButton( "Añadir", "New16", {|| ::getController():Append(), ::oSender:Refresh() }, "A", ACC_APPD ) 

RETURN ( if( hb_isblock( ::bOnAfterAddAppendButton ), eval( ::bOnAfterAddAppendButton ), ) )

//----------------------------------------------------------------------------//

METHOD AddDuplicateButton() 

   ::AddButton( "Duplicar", "Dup16", {|| ::getController():Duplicate(), ::oSender:Refresh() }, "D", ACC_APPD ) 

RETURN ( if( hb_isblock( ::bOnAfterAddDuplicateButton ), eval( ::bOnAfterAddDuplicateButton ), ) )

//----------------------------------------------------------------------------//

METHOD AddEditButton()      

   ::AddButton( "Modificar", "Edit16", {|| ::getController():Edit(), ::oSender:Refresh() }, "M", ACC_EDIT ) 

RETURN ( if( hb_isblock( ::bOnAfterAddEditButton ), eval( ::bOnAfterAddEditButton ), ) )

//----------------------------------------------------------------------------//
METHOD AddZoomButton()      

   ::AddButton( "Zoom", "Zoom16", {|| ::getController():Zoom(), ::oSender:Refresh() }, "Z", ACC_ZOOM ) 

RETURN ( if( hb_isblock( ::bOnAfterAddZoomButton ), eval( ::bOnAfterAddZoomButton ), ) )

//----------------------------------------------------------------------------//

METHOD AddDeleteButton()    

   ::AddButton( "Eliminar", "Del16", {|| ::getController():Delete( ::getBrowse():aSelected ), ::oSender:Refresh() }, "E", ACC_DELE ) 

RETURN ( if( hb_isblock( ::bOnAfterAddDeleteButton ), eval( ::bOnAfterAddDeleteButton ), ) )

//----------------------------------------------------------------------------//

METHOD AddSelectButton()    

   ::AddButton( "Seleccionar [Enter]", "Select16", {|| ::oSender:Select() }, K_ENTER ) 

RETURN ( if( hb_isblock( ::bOnAfterAddSelectButton ), eval( ::bOnAfterAddSelectButton ), ) )

//----------------------------------------------------------------------------//

METHOD AddExitButton()

   ::AddButton( "Salir [ESC]", "End16", {|| ::oSender:End() }, "S" ) 

RETURN ( if( hb_isblock( ::bOnAfterAddExitButton ), eval( ::bOnAfterAddExitButton ), ) )

//----------------------------------------------------------------------------//

METHOD onChange()

   local oItem       

   oItem          := ::oTreeView:GetSelected()

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


