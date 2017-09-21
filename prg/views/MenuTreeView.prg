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
   METHOD AddSalirButton()

   METHOD AddGeneralButton()              INLINE ( ::AddSearchButton(),;
                                                   ::AddRefreshButton(),;
                                                   ::AddAppendButton(),;
                                                   ::AddDuplicateButton(),;
                                                   ::AddEditButton(),;
                                                   ::AddZoomButton(),;
                                                   ::AddDeleteButton() )

   METHOD AddAutoButtons()                INLINE ( ::AddGeneralButton(),;
                                                   ::AddSalirButton(),;
                                                   ::oButtonMain:Expand() )

   METHOD AddSelectorButtons()            INLINE ( ::AddGeneralButton(),;
                                                   ::AddSelectButton(),;
                                                   ::AddSalirButton(),;
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

   ::oTreeView          := TTreeView():New( 0, 0, ::oSender:getWindow(), , , .t., .f., nWidth, nHeight ) 
   
   ::Default()

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD ActivateDialog( id )

   ::oTreeView          := TTreeView():Redefine( id, ::oSender:getWindow() ) 

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

RETURN ( ::AddButton( "Buscar", "Bus16", {|| ::oSender:getGetSearch():setFocus() }, "B" ) )

METHOD AddRefreshButton()

RETURN ( ::AddButton( "Refrescar", "Refresh16", {|| ::oSender:RefreshRowSet() }, "R" ) )

METHOD AddAppendButton()    

RETURN ( ::AddButton( "Añadir", "New16", {|| ::getController():Append(), ::oSender:Refresh() }, "A", ACC_APPD ) )

METHOD AddDuplicateButton() 

RETURN ( ::AddButton( "Duplicar", "Dup16", {|| ::getController():Duplicate(), ::oSender:Refresh() }, "D", ACC_APPD ) )

METHOD AddEditButton()      

RETURN ( ::AddButton( "Modificar", "Edit16", {|| ::getController():Edit(), ::oSender:Refresh() }, "M", ACC_EDIT ) )

METHOD AddZoomButton()      

RETURN ( ::AddButton( "Zoom", "Zoom16", {|| ::getController():Zoom(), ::oSender:Refresh() }, "Z", ACC_ZOOM ) )

METHOD AddDeleteButton()    

RETURN ( ::AddButton( "Eliminar", "Del16", {|| ::getController():Delete( ::getBrowse():aSelected ), ::oSender:Refresh() }, "E", ACC_DELE ) )

METHOD AddSelectButton()    

RETURN ( ::AddButton( "Seleccionar [Enter]", "Select16", {|| ::oSender:Select() }, K_ENTER ) )

METHOD AddSalirButton()

RETURN ( ::AddButton( "Salir [ESC]", "End16", {|| ::oSender:End() }, "S" ) )

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


