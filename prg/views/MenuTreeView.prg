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

   DATA oButtonConfig

   DATA oButtonOthers

   DATA lDocumentButtons                  INIT .f.

   DATA oEvents

   METHOD New( oSender )
   METHOD End()

   METHOD Exit()

   METHOD ActivateMDI()
   METHOD ActivateDialog()

   METHOD Default()
   METHOD setImageList()                  INLINE ( ::oTreeView:SetImagelist( ::oImageList ) )
 
   METHOD getController()                 INLINE ( ::oSender:getController() )
   METHOD getBrowse()                     INLINE ( ::oSender:getBrowse() )

   METHOD isControllerDocuments()         INLINE ( ::getController():lDocuments )
   METHOD isControllerLabels()            INLINE ( ::getController():lLabels )
   METHOD isControllerConfig()            INLINE ( ::getController():lConfig )
   METHOD isControllerOthers()            INLINE ( ::getController():lOthers )
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

   METHOD addCloseButton()

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
                                                   ::addOthersButton(),;
                                                   ::addConfigButton(),;
                                                   ::addExitButton(),;
                                                   ::oButtonMain:Expand(),;
                                                   ::fireEvent( 'addedAutoButton' ) )

   METHOD addSelectorButtons()            INLINE ( ::fireEvent( 'addingSelectorButton' ),;
                                                   ::addGeneralButton(),;
                                                   ::addSelectButton(),;
                                                   ::addCloseButton(),;
                                                   ::oButtonMain:Expand(),;
                                                   ::fireEvent( 'addedSelectorButton' ) )

   METHOD addDialogButtons()              INLINE ( ::fireEvent( 'addingSelectorButton' ),;
                                                   ::addGeneralButton(),;
                                                   ::addCloseButton(),;
                                                   ::oButtonMain:Expand(),;
                                                   ::fireEvent( 'addedSelectorButton' ) )

   METHOD addPrintSerialButton()

   METHOD addPrintButtons()               

   METHOD addPreviewButtons()

   METHOD addPdfButtons()

   METHOD addLabelButton()

   METHOD addConfigButton()

   METHOD addOthersButton()

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

   ::oImageList   := TImageList():New( 16, 16 )

   ::oEvents      := Events():New()   

RETURN ( self )

//----------------------------------------------------------------------------//

METHOD End()

   cursorWait()

   if !empty( ::oImageList )
   
      aeval( ::oImageList:aBitmaps, {|oBitmap| oBitmap:End() } )

      ::oImageList:End()

   end if

   ::oEvents:End()
 
   ::oSender      := nil

   ::oEvents      := nil

   ::oImageList   := nil

   self           := nil

   cursorWE()

RETURN ( nil )

//----------------------------------------------------------------------------//


METHOD ActivateMDI( nWidth, nHeight )

   if isFalse( ::fireEvent( 'activatingMDI' ) )
      RETURN ( nil )
   end if 

   ::oTreeView    := TTreeView():New( 0, 0, ::oSender:getWindow(), , , .t., .f., nWidth, nHeight ) 
   
   ::Default()

   ::fireEvent( 'activatedMDI' )

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD ActivateDialog( oDialog, id )

   if isFalse( ::fireEvent( 'activatingDialog' ) )
      RETURN ( nil )
   end if 

   ::oTreeView    := TTreeView():Redefine( id, oDialog ) 

   ::fireEvent( 'activatedDialog' )

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD Default()

   ::SetImagelist()

   ::oTreeView:SetItemHeight( 20 )

   ::oTreeView:bChanged := {|| ::onChange() }

   if !empty( ::getController():getImage( "16" ) )
      ::oButtonMain     := ::oTreeView:Add( ::getController():cTitle, ::addImage( ::getController():getImage( "16" ) ) )
   end if 

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD Exit()

   if empty( ::oSender ) 
      RETURN ( nil )
   end if 

   ::oSender:getWindow():End()

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

   oTreeButton          := oGroup:Add( cText, ::addImage( cResource ), bAction )
   oTreeButton:Cargo    := lAllowExit

   ::getController():addFastKey( uKey, bAction )

RETURN ( oTreeButton )

//----------------------------------------------------------------------------//

METHOD addImage( cImage )

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

   if isFalse( ::fireEvent( 'addingSearchButton' ) )
      RETURN ( nil )
   end if 

   ::AddButton( "Buscar", "Bus16", {|| ::oSender:getGetSearch():setFocus() }, "B" ) 

   ::fireEvent( 'addedSearchButton' )

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD AddRefreshButton()

   if isFalse( ::fireEvent( 'addingRefreshButton' ) )
      RETURN ( nil )
   end if 

   ::AddButton( "Refrescar", "Refresh16", {|| ::oSender:RefreshRowSet() }, "R" ) 

   ::fireEvent( 'addedRefreshButton' )

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD AddAppendButton()    

   if isFalse( ::fireEvent( 'addingAppendButton' ) )
      RETURN ( nil )
   end if 

   ::AddButton( "Añadir", "New16", {|| ::getController():Append(), ::oSender:Refresh() }, "A", ACC_APPD ) 
   
   ::fireEvent( 'addedAppendButton' )

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD AddDuplicateButton() 

   if isFalse( ::fireEvent( 'addingDuplicateButton' ) )
      RETURN ( nil )
   end if 

   ::AddButton( "Duplicar", "Dup16", {|| ::getController():Duplicate(), ::oSender:Refresh() }, "D", ACC_APPD ) 

   ::fireEvent( 'addedDuplicateButton' )

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD AddEditButton()      

   if isFalse( ::fireEvent( 'addingEditButton' ) )
      RETURN ( nil )
   end if 

   ::AddButton( "Modificar", "Edit16", {|| ::getController():Edit(), ::oSender:Refresh() }, "M", ACC_EDIT ) 

   ::fireEvent( 'addedEditButton' )

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD AddZoomButton()      

   if isFalse( ::fireEvent( 'addingZoomButton' ) )
      RETURN ( nil )
   end if 

   ::AddButton( "Zoom", "Zoom16", {|| ::getController():Zoom(), ::oSender:Refresh() }, "Z", ACC_ZOOM ) 

   ::fireEvent( 'addedZoomButton' )

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD AddDeleteButton()    

   if isFalse( ::fireEvent( 'addingDeleteButton' ) )
      RETURN ( nil )
   end if 

   ::AddButton( "Eliminar", "Del16", {|| ::getController():Delete( ::getBrowse():aSelected ), ::oSender:Refresh() }, "E", ACC_DELE ) 

   ::fireEvent( 'addedDeleteButton' )

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD AddSelectButton()    

   if isFalse( ::fireEvent( 'addingSelectButton' ) )
      RETURN ( nil )
   end if 

   ::AddButton( "Seleccionar [Enter]", "Select16", {|| ::oSender:Select() }, K_ENTER ) 

   ::fireEvent( 'addedSelectButton' )

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD AddExitButton()

   if isFalse( ::fireEvent( 'addingExitButton' ) )
      RETURN ( nil )
   end if 

   ::AddButton( "Salir [ESC]", "End16", {|| ::Exit() }, "S" ) 

   ::fireEvent( 'addedExitButton' )

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD AddCloseButton()

   if isFalse( ::fireEvent( 'addingCloseButton' ) )
      RETURN ( nil )
   end if 

   ::AddButton( "Salir [ESC]", "End16", {|| ::oSender:End() }, "S" ) 

   ::fireEvent( 'addedCloseButton' )

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD addPrintSerialButton( cWorkArea )

   if isFalse( ::fireEvent( 'addingPrintSerialButton' ) )
      RETURN ( nil )
   end if 

   ::oButtonPrint    := ::AddButton( "Imprimir series", "Imp16", {|| ::getController():printSerialDocument() }, nil, ACC_IMPR )

   ::fireEvent( 'addedPrintSerialButton') 

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD addPrintButtons( cWorkArea )

   if isFalse( ::fireEvent( 'addingPrintButton' ) )
      RETURN ( nil )
   end if 

   ::oButtonPrint    := ::AddButton( "Imprimir", "Imp16", {|| ::getController():printDocument( IS_PRINTER ) }, "I", ACC_IMPR )

   aeval( ::getControllerDocuments(), {|cFile| ::AddButton( getFileNoExt( cFile ), "Imp16", ::blockPrintDocument( IS_PRINTER, getFileNoExt( cFile ) ), , ACC_IMPR, ::oButtonPrint ) } )

   ::fireEvent( 'addedPrintButton') 

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD addPreviewButtons( cWorkArea )

   if isFalse( ::fireEvent( 'addingPreviewButton' ) )
      RETURN ( nil )
   end if 

   ::oButtonPreview  := ::AddButton( "Previsualizar", "Prev116", {|| ::getController():printDocument( IS_SCREEN ) }, "P", ACC_IMPR ) 

      aeval( ::getControllerDocuments(), {|cFile| ::AddButton( getFileNoExt( cFile ), "Prev116", ::blockPrintDocument( IS_SCREEN, getFileNoExt( cFile ) ), , ACC_IMPR, ::oButtonPreview ) } )

   ::fireEvent( 'addedPreviewButton') 

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD addPdfButtons( cWorkArea )

   if isFalse( ::fireEvent( 'addingPdfButton' ) )
      RETURN ( nil )
   end if 

   ::oButtonPdf  := ::AddButton( "Pdf", "Doclock16", {|| ::getController():printDocument( IS_PDF ) }, "F", ACC_IMPR ) 

   aeval( ::getControllerDocuments(), {|cFile| ::AddButton( getFileNoExt( cFile ), "Doclock16", ::blockPrintDocument( IS_PDF, getFileNoExt( cFile ) ), , ACC_IMPR, ::oButtonPdf ) } ) 

   ::fireEvent( 'addedPdfButton') 

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD addLabelButton()

   if !( ::isControllerLabels() )
      RETURN ( nil )
   end if 

   if isFalse( ::fireEvent( 'addingLabelButton' ) )
      RETURN ( nil )
   end if 

   ::oButtonLabel  := ::AddButton( "Etiquetas", "gc_portable_barcode_scanner_16", {|| ::getController():labelDocument() }, "Q", ACC_IMPR ) 

   ::fireEvent( 'addedLabelButton') 

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD addConfigButton()

   if !( ::isControllerConfig() )
      RETURN ( nil )
   end if 

   if isFalse( ::fireEvent( 'addingConfigButton' ) )
      RETURN ( nil )
   end if 

   ::oButtonConfig   := ::AddButton( "Configuraciones", "gc_wrench_16", {|| ::getController():setConfig() }, "N", ACC_IMPR ) 

   ::fireEvent( 'addedConfigButton') 

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD addOthersButton()

   if !( ::isControllerOthers() )
      RETURN ( nil )
   end if 

   if isFalse( ::fireEvent( 'addingOthersButton' ) )
      RETURN ( nil )
   end if 

   ::oButtonOthers   := ::AddButton( "Otros", "gc_more_16", {|| ::oButtonOthers:Toggle() }, "O", ACC_IMPR ) 

   ::fireEvent( 'addedOthersButton') 

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD blockPrintDocument( nDevice, cFormato )

RETURN ( {|| ::getController():printDocument( nDevice, cFormato ) } ) 

//---------------------------------------------------------------------------//

METHOD addDocumentsButton()

   if !( ::isControllerDocuments() )
      RETURN ( nil )
   end if 

   if isFalse( ::fireEvent( 'addingDocumentButton' ) )
      RETURN ( nil )
   end if 

   ::addPrintSerialButton()

   ::addPrintButtons()
   
   ::addPreviewButtons()
   
   ::addPdfButtons()
   
   ::fireEvent( 'addedDocumentButton' ) 

RETURN ( nil )

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

RETURN ( nil )

//----------------------------------------------------------------------------//


