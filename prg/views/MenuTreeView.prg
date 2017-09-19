#include "FiveWin.Ch"
#include "Factu.Ch"

#define dfnTreeViewWidth      250
#define dfnSplitterWidth      1
#define dfnSplitterHeight     76
#define dfnColorTop           rgb( 238, 110, 115 )

//------------------------------------------------------------------------//

CLASS MenuTreeView

   DATA oSender

   DATA oTreeView

   DATA oImageList

   DATA oButtonMain

   DATA hFastKeyTreeMenu                  INIT  {=>}

   METHOD New( oSender )

   METHOD End()

   METHOD MDIActivate()
 
   METHOD getController()                 INLINE ( ::oSender:getController() )
   METHOD getBrowse()                     INLINE ( ::oSender:getBrowse() )

   METHOD AddImageTreeMenu()

   METHOD AddButtonTreeMenu()

   METHOD AddSearchButtonTreeMenu()    
   METHOD AddAppendButtonTreeMenu()    
   METHOD AddDuplicateButtonTreeMenu() 
   METHOD AddEditButtonTreeMenu()      
   METHOD AddZoomButtonTreeMenu()      
   METHOD AddDeleteButtonTreeMenu()    
   METHOD AddSalirButtonTreeMenu()     

   METHOD AddGeneralButtonTreeMenu()      INLINE ( ::AddSearchButtonTreeMenu(),;
                                                   ::AddAppendButtonTreeMenu(),;
                                                   ::AddDuplicateButtonTreeMenu(),;
                                                   ::AddEditButtonTreeMenu(),;
                                                   ::AddZoomButtonTreeMenu(),;
                                                   ::AddDeleteButtonTreeMenu() )

   METHOD AddAutoButtonTreeMenu()         INLINE ( ::AddGeneralButtonTreeMenu(),;
                                                   ::AddSalirButtonTreeMenu(),;
                                                   ::oButtonMain:Expand() )

   METHOD SelectButtonMain()              INLINE ( ::oTreeView:Select( ::oButtonMain ) )

   METHOD onClickTreeMenu()

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( oSender )

   ::oSender      := oSender

   ::oImageList   := TImageList():New( 16, 16 )

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD MDIActivate( nWidth, nHeight )

   ::oTreeView          := TTreeView():New( 0, 0, ::oSender:oMdiChild, , , .t., .f., nWidth, nHeight ) 
   
   ::oTreeView:SetImagelist( ::oImageList )

   ::oTreeView:SetItemHeight( 20 )

   ::oTreeView:OnClick  := {|| ::onClickTreeMenu() }

   if !empty( ::getController():cImage )
      ::oButtonMain     := ::oTreeView:Add( ::getController():cTitle, ::AddImageTreeMenu( ::getController():cImage ) )
   end if 

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD End()

   if !empty( ::oImageList )
      ::oImageList:End()
   end if 

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD AddButtonTreeMenu( cText, cResource, bAction, cKey, nLevel, oGroup, lAllowExit ) 

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

   oTreeButton          := oGroup:Add( cText, ::AddImageTreeMenu( cResource ), bAction )
   oTreeButton:Cargo    := lAllowExit

   if hb_ischar( cKey )
      hset( ::hFastKeyTreeMenu, cKey, bAction )
   end if

RETURN ( oTreeButton )

//----------------------------------------------------------------------------//

METHOD AddImageTreeMenu( cImage )

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

METHOD AddSearchButtonTreeMenu()    

RETURN ( ::AddButtonTreeMenu( "Buscar", "Bus16", {|| ::oWindowsBar:SetFocusGet() }, "B" ) )

METHOD AddAppendButtonTreeMenu()    

RETURN ( ::AddButtonTreeMenu( "Añadir", "New16", {|| ::getController():Append(), ::oSender:Refresh() }, "A", ACC_APPD ) )

METHOD AddDuplicateButtonTreeMenu() 

RETURN ( ::AddButtonTreeMenu( "Duplicar", "Dup16", {|| ::getController():Duplicate(), ::oSender:Refresh() }, "D", ACC_APPD ) )

METHOD AddEditButtonTreeMenu()      

RETURN ( ::AddButtonTreeMenu( "Modificar", "Edit16", {|| ::getController():Edit(), ::oSender:Refresh() }, "M", ACC_EDIT ) )

METHOD AddZoomButtonTreeMenu()      

RETURN ( ::AddButtonTreeMenu( "Zoom", "Zoom16", {|| ::getController():Zoom(), ::oSender:Refresh() }, "Z", ACC_ZOOM ) )

METHOD AddDeleteButtonTreeMenu()    

RETURN ( ::AddButtonTreeMenu( "Eliminar", "Del16", {|| ::getController():Delete( ::oSender:oBrowse:aSelected ), ::oSender:Refresh() }, "E", ACC_DELE ) )

METHOD AddSalirButtonTreeMenu()

RETURN ( ::AddButtonTreeMenu( "Salir", "End16", {|| ::oSender:End() }, "S" ) )

//----------------------------------------------------------------------------//

METHOD onClickTreeMenu()

   local oItem       := ::oTreeView:GetSelected()

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


