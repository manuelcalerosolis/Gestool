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

   DATA oButtonPrint

   DATA oButtonPreview

   DATA oButtonPdf

   DATA oButtonLabel

   DATA oButtonCounter

   DATA lDocumentButtons                  INIT .f.

   DATA oEvents

   METHOD New( oSender )

   METHOD End()

   METHOD ActivateMDI()
   METHOD ActivateDialog()

   METHOD Default()
   METHOD setImageList()                  INLINE ( ::oTreeView:SetImagelist( ::oImageList ) )
 
   METHOD getController()                 INLINE ( ::oSender:getController() )
   METHOD getBrowse()                     INLINE ( ::oSender:getBrowse() )

   METHOD isControllerDocuments()         INLINE ( ::getController():lDocuments )
   METHOD isControllerLabels()            INLINE ( ::getController():lLabels )
   METHOD isControllerCounter()           INLINE ( ::getController():lCounter )
   METHOD getControllerDocuments()        INLINE ( ::getController():aDocuments )

   METHOD addImage()

   METHOD addButton()

   METHOD addSearchButton()    

   METHOD addAppendButton()    
   
   METHOD addDuplicateButton() 
   
   METHOD addEditButton()      
   
   METHOD addZoomButton()      
   
   METHOD addDeleteButton()    
   
   METHOD addRefreshButton()
   
   METHOD addSelectButton()

   METHOD addExitButton()

   METHOD addGeneralButton()              INLINE ( ::fireEvent( 'addingGeneralButton' ),;
                                                   ::addSearchButton(),;
                                                   ::addRefreshButton(),;
                                                   ::addAppendButton(),;
                                                   ::addDuplicateButton(),;
                                                   ::addEditButton(),;
                                                   ::addZoomButton(),;
                                                   ::addDeleteButton(),;
                                                   ::fireEvent( 'addedGeneralButton' ) )

   METHOD addAutoButtons()                INLINE ( ::fireEvent( 'addingAutoButton' ),;
                                                   ::addGeneralButton(),;
                                                   ::addDocumentsButton(),;
                                                   ::addLabelButton(),;
                                                   ::addCounterButton(),;
                                                   ::addExitButton(),;
                                                   ::oButtonMain:Expand(),;
                                                   ::fireEvent( 'addedAutoButton' ) )

   METHOD addSelectorButtons()            INLINE ( ::fireEvent( 'addingSelectorButton' ),;
                                                   ::addGeneralButton(),;
                                                   ::addSelectButton(),;
                                                   ::addExitButton(),;
                                                   ::oButtonMain:Expand(),;
                                                   ::fireEvent( 'addedSelectorButton' ) )

   METHOD addPrintSerialButton()

   METHOD addPrintButtons()               

   METHOD addPreviewButtons()

   METHOD addPdfButtons()

   METHOD addLabelButton()

   METHOD addCounterButton()

   METHOD addDocumentsButton()           

   METHOD blockPrintDocument( nDevice, cFormato )  

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

   if !empty( ::getController():getImage( "16" ) )
      ::oButtonMain     := ::oTreeView:Add( ::getController():cTitle, ::AddImage( ::getController():getImage( "16" ) ) )
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

METHOD addPrintSerialButton( cWorkArea )

   ::fireEvent( 'addingPrintSerialButton')

   ::oButtonPrint    := ::AddButton( "Imprimir series", "Imp16", {|| ::getController():printSerialDocument() }, nil, ACC_IMPR )

   ::fireEvent( 'addedPrintSerialButton') 

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD addPrintButtons( cWorkArea )

   ::fireEvent( 'addingPrintButton')

   ::oButtonPrint    := ::AddButton( "Imprimir", "Imp16", {|| ::getController():printDocument( IS_PRINTER ) }, "I", ACC_IMPR )

   aeval( ::getControllerDocuments(), {|cFile| ::AddButton( getFileNoExt( cFile ), "Imp16", ::blockPrintDocument( IS_PRINTER, getFileNoExt( cFile ) ), , ACC_IMPR, ::oButtonPrint ) } )

   ::fireEvent( 'addedPrintButton') 

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD addPreviewButtons( cWorkArea )

   ::fireEvent( 'addingPreviewButton')

   ::oButtonPreview  := ::AddButton( "Previsualizar", "Prev116", {|| ::getController():printDocument( IS_SCREEN ) }, "P", ACC_IMPR ) 

      aeval( ::getControllerDocuments(), {|cFile| ::AddButton( getFileNoExt( cFile ), "Prev116", ::blockPrintDocument( IS_SCREEN, getFileNoExt( cFile ) ), , ACC_IMPR, ::oButtonPreview ) } )

   ::fireEvent( 'addedPreviewButton') 

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD addPdfButtons( cWorkArea )

   ::fireEvent( 'addingPdfButton')

   ::oButtonPdf  := ::AddButton( "Pdf", "Doclock16", {|| ::getController():printDocument( IS_PDF ) }, "F", ACC_IMPR ) 

      aeval( ::getControllerDocuments(), {|cFile| ::AddButton( getFileNoExt( cFile ), "Doclock16", ::blockPrintDocument( IS_PDF, getFileNoExt( cFile ) ), , ACC_IMPR, ::oButtonPdf ) } ) 

   ::fireEvent( 'addedPdfButton') 

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD addLabelButton()

   if !( ::isControllerLabels() )
      RETURN ( Self )
   end if 

   ::fireEvent( 'addingLabelButton')

   ::oButtonLabel  := ::AddButton( "Etiquetas", "gc_portable_barcode_scanner_16", {|| ::getController():labelDocument() }, "Q", ACC_IMPR ) 

   ::fireEvent( 'addedLabelButton') 

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD addCounterButton()

   if !( ::isControllerCounter() )
      RETURN ( Self )
   end if 

   ::fireEvent( 'addingCounterButton')

   ::oButtonCounter     := ::AddButton( "Contadores", "gc_document_text_pencil_16", {|| ::getController():setCounter() }, "T", ACC_IMPR ) 

   ::fireEvent( 'addedCounterButton') 

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD blockPrintDocument( nDevice, cFormato )

RETURN ( {|| ::getController():printDocument( nDevice, cFormato ) } ) 

//---------------------------------------------------------------------------//

METHOD addDocumentsButton()

   if !( ::isControllerDocuments() )
      RETURN ( Self )
   end if 

   ::fireEvent( 'addingDocumentButton' )

   ::addPrintSerialButton()

   ::addPrintButtons()
   
   ::addPreviewButtons()
   
   ::addPdfButtons()
   
   ::fireEvent( 'addedDocumentButton' ) 

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

   ::selectButtonMain()

RETURN ( Self )

//----------------------------------------------------------------------------//


