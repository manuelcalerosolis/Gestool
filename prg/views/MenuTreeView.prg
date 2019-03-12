#include "FiveWin.Ch"
#include "Factu.Ch"

#define dfnTreeViewWidth      250
#define dfnSplitterWidth      1
#define dfnSplitterHeight     76
#define dfnColorTop           rgb( 238, 110, 115 )

#define K_ENTER               13   //   Enter, Ctrl-M

//------------------------------------------------------------------------//

CLASS MenuTreeView

   DATA oController

   DATA oTreeView

   DATA oImageList

   DATA oButtonMain

   DATA oButtonPrint

   DATA oButtonPreview

   DATA oButtonPdf

   DATA oButtonMail

   DATA oButtonLabel

   DATA oButtonConfig

   DATA oButtonOthers

   DATA oButtonShowDelete

   DATA oButtonCanceled

   DATA oEvents

   METHOD New( oController )
   METHOD End()

   METHOD Exit()

   METHOD ActivateMDI()
   METHOD ActivateDialog()

   METHOD Default()
   METHOD setImageList()                  INLINE ( ::oTreeView:SetImagelist( ::oImageList ) )
 
   METHOD isCreatorControllerZoomMode()

   METHOD getSuperController()            INLINE ( ::oController:getController() )
   METHOD getBrowse()                     INLINE ( ::oController:getBrowse() )

   METHOD isControllerDocuments()         INLINE ( ::getSuperController():lDocuments )
   METHOD isControllerLabels()            INLINE ( ::getSuperController():lLabels )
   METHOD isControllerConfig()            INLINE ( ::getSuperController():lConfig )
   METHOD isMailConfig()                  INLINE ( ::getSuperController():lMail )
   METHOD isControllerOthers()            INLINE ( ::getSuperController():lOthers )
   METHOD isControllerCanceled()          INLINE ( ::getSuperController():lCanceled )
   METHOD getControllerDocuments()        INLINE ( ::getSuperController():loadDocuments() )

   METHOD addImage()

   METHOD addButton()

   METHOD addSearchButton()    

   METHOD addAppendButton() 

   METHOD addInsertButton()   
   
   METHOD addDuplicateButton() 
   
   METHOD addEditButton()      
   
   METHOD addZoomButton()      
   
   METHOD addDeleteButton() 

   METHOD addCanceledButton() 

   METHOD addShowDeleteButton() 

   METHOD addRefreshButton()
   
   METHOD addSelectButton()

   METHOD addExitButton()

   METHOD addCloseButton()

   METHOD addAppendOrInsertButton()       INLINE ( iif(  ::getSuperController():lInsertable,;
                                                         ::addInsertButton(),;
                                                         ::addAppendButton() ) )

   METHOD addGeneralButton()              

   METHOD addAutoButtons()                INLINE ( ::fireEvent( 'addingAutoButton' ),;
                                                   ::addGeneralButton(),;
                                                   ::addDocumentsButton(),;
                                                   ::addLabelButton(),;
                                                   ::addOthersButton(),;
                                                   ::addConfigButton(),;
                                                   ::addExitButton(),;
                                                   ::oButtonMain:Expand(),;
                                                   ::fireEvent( 'addedAutoButton' ) )

   METHOD addSelectorButtons()  

   METHOD addDialogButtons()              INLINE ( ::fireEvent( 'addingSelectorButton' ),;
                                                   ::addGeneralButton(),;
                                                   ::addCloseButton(),;
                                                   ::oButtonMain:Expand(),;
                                                   ::fireEvent( 'addedSelectorButton' ) )

   METHOD addPrintSerialButton()

   METHOD addPrintButtons()               

   METHOD addPreviewButtons()

   METHOD addPdfButtons()

   METHOD addMailButtons()

   METHOD addLabelButton()

   METHOD addConfigButton()

   METHOD addOthersButton()

   METHOD addDocumentsButton()           

   METHOD blockPrintDocument( nDevice, cFormato )  

   METHOD SelectButtonMain()                 INLINE ( ::oTreeView:Select( ::oButtonMain ) )

   METHOD onChange()

   METHOD Refresh()                          INLINE ( ::oTreeView:Refresh() ) 

   METHOD setButtonShowDeleteText( cText )   INLINE ( iif( !empty( ::oButtonShowDelete ), ::oButtonShowDelete:setText( cText ), ) )

   // Events-------------------------------------------------------------------
   
   METHOD getEvents()                        INLINE ( iif( empty( ::oEvents ), ::oEvents := Events():New(), ), ::oEvents )

   METHOD setEvent( cEvent, bEvent )         INLINE ( ::getEvents():set( cEvent, bEvent ) )
   METHOD setEvents( cEvent, bEvent )        INLINE ( ::getEvents():setEvents( cEvent, bEvent ) )
   METHOD fireEvent( cEvent, uValue )        INLINE ( ::getEvents():fire( cEvent, uValue ) )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( oController )

   ::oController  := oController

   ::oImageList   := TImageList():New( 16, 16 )

RETURN ( self )

//----------------------------------------------------------------------------//

METHOD End()

   if !empty( ::oImageList )
      aeval( ::oImageList:aBitmaps, {|oBitmap| oBitmap:End() } )
      ::oImageList:End()
   end if

   if !empty( ::oEvents )
      ::oEvents:End()
   end if

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD addGeneralButton()

   ::fireEvent( 'addingGeneralButton' )

   ::addSearchButton()

   ::addRefreshButton()

   if !::isCreatorControllerZoomMode() 

      ::addAppendOrInsertButton()

      ::addDuplicateButton()

      ::addEditButton()

   end if 

   ::addZoomButton()

   if !::isCreatorControllerZoomMode()

      ::addDeleteButton()

      ::addShowDeleteButton()

   end if

   ::addCanceledButton()

   ::oButtonMain:Expand()

   ::fireEvent( 'addedGeneralButton' ) 

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD addSelectorButtons()    

   ::fireEvent( 'addingSelectorButton' )

   ::addGeneralButton()

   if !::isCreatorControllerZoomMode()
      ::addSelectButton()
   end if

   ::addCloseButton()

   ::oButtonMain:Expand()
   
   ::fireEvent( 'addedSelectorButton' ) 

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD ActivateMDI( nWidth, nHeight )

   if isFalse( ::fireEvent( 'activatingMDI' ) )
      RETURN ( nil )
   end if 

   ::oTreeView    := TTreeView():New( 0, 0, ::oController:getWindow(), , , .t., .f., nWidth, nHeight ) 
   
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

   

   if !empty( ::getSuperController():getImage( "16" ) )
      ::oButtonMain     := ::oTreeView:Add( ::getSuperController():cTitle, ::addImage( ::getSuperController():getImage( "16" ) ) )
   end if 

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD Exit()

   if empty( ::oController ) 
      RETURN ( nil )
   end if 

   ::oController:getWindow():End()
   
RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD isCreatorControllerZoomMode()

   if empty( ::getSuperController():getController() )  
      RETURN ( .f. )
   end if 

RETURN ( ::getSuperController():getController():isZoomMode() )   

//----------------------------------------------------------------------------//

METHOD AddButton( cText, cResource, bAction, uKey, nLevel, oGroup ) 

   local oTreeButton

   DEFAULT oGroup       := ::oButtonMain

   // El nombre del boton es necesario-----------------------------------------

   if empty( cText )
      RETURN ( nil )
   end if 

   // Chequeamos los niveles de acceso si es mayor no montamos el boton--------

   if nLevel != nil .and. nAnd( ::getSuperController():nLevel, nLevel ) == 0
      RETURN ( nil )
   end if

   oTreeButton          := oGroup:Add( cText, ::addImage( cResource ), bAction )

   ::getSuperController():addFastKey( uKey, bAction )

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

   ::AddButton( "Buscar", "Bus16", {|| ::oController:getGetSearch():setFocus() }, "B" ) 

   ::fireEvent( 'addedSearchButton' )

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD AddRefreshButton()

   if isFalse( ::fireEvent( 'addingRefreshButton' ) )
      RETURN ( nil )
   end if 

   ::AddButton( "Refrescar", "Refresh16", {|| ::oController:refreshRowSet() }, "R" ) 

   ::fireEvent( 'addedRefreshButton' )

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD addAppendButton()     

   if isFalse( ::fireEvent( 'addingAppendButton' ) )
      RETURN ( nil )
   end if 

   ::AddButton( "A�adir", "New16", {|| ::getSuperController():Append(), ::oController:Refresh() }, "A", ACC_APPD ) 
   
   ::fireEvent( 'addedAppendButton' )

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD addInsertButton()    

   if isFalse( ::fireEvent( 'addingAppendButton' ) )
      RETURN ( nil )
   end if 

   ::AddButton( "A�adir", "New16", {|| ::getSuperController():Insert(), ::oController:Refresh() }, "A", ACC_APPD ) 
   
   ::fireEvent( 'addedAppendButton' )

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD addDuplicateButton() 

   if ::isCreatorControllerZoomMode() 
      RETURN ( nil )
   end if 

   if isFalse( ::fireEvent( 'addingDuplicateButton' ) )
      RETURN ( nil )
   end if 

   ::addButton( "Duplicar", "Dup16", {|| ::getSuperController():Duplicate(), ::oController:Refresh() }, "D", ACC_APPD ) 

   ::fireEvent( 'addedDuplicateButton' )

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD addEditButton()      

   if isFalse( ::fireEvent( 'addingEditButton' ) )
      RETURN ( nil )
   end if 

   ::AddButton( "Modificar", "Edit16", {|| ::getSuperController():Edit(), ::oController:Refresh() }, "M", ACC_EDIT ) 

   ::fireEvent( 'addedEditButton' )

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD AddZoomButton()      

   if isFalse( ::fireEvent( 'addingZoomButton' ) )
      RETURN ( nil )
   end if 

   ::AddButton( "Zoom", "Zoom16", {|| ::getSuperController():Zoom(), ::oController:Refresh() }, "Z", ACC_ZOOM ) 

   ::fireEvent( 'addedZoomButton' )

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD AddDeleteButton()    

   if isFalse( ::fireEvent( 'addingDeleteButton' ) )
      RETURN ( nil )
   end if 

   ::AddButton( "Eliminar", "Del16", {|| ::getSuperController():Delete( ::getBrowse():aSelected ), ::oController:Refresh() }, "E", ACC_DELE ) 

   ::fireEvent( 'addedDeleteButton' )

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD addShowDeleteButton()    

   if isFalse( ::fireEvent( 'addingShowDeleteButton' ) )
      RETURN ( nil )
   end if 
   
   if !::getSuperController():getModel():isDeletedAtColumn()
      RETURN ( nil )
   end if
   
   ::oButtonShowDelete  := ::AddButton( "Mostrar eliminados", "gc_deleted_16", {|| ::getSuperController():setShowDeleted() }, "E", ACC_DELE ) 

   ::fireEvent( 'addedShowDeleteButton' )

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD AddSelectButton()    

   if isFalse( ::fireEvent( 'addingSelectButton' ) )
      RETURN ( nil )
   end if 

   ::AddButton( "Seleccionar [Enter]", "Select16", {|| ::oController:Select() }, K_ENTER ) 

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

   ::AddButton( "Salir [ESC]", "End16", {|| if( !empty( ::oController ) .and. !empty( ::oController:oDialog ), ::oController:oDialog:End(), ) }, "S" ) 

   ::fireEvent( 'addedCloseButton' )

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD addPrintSerialButton()

   if isFalse( ::fireEvent( 'addingPrintSerialButton' ) )
      RETURN ( nil )
   end if 

   ::oButtonPrint    := ::AddButton( "Imprimir series", "Imp16", {|| ::getSuperController():getImprimirSeriesController():dialogViewActivate() }, nil, ACC_IMPR )

   ::fireEvent( 'addedPrintSerialButton') 

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD addCanceledButton()

   if !( ::isControllerCanceled() )
      RETURN ( nil )
   end if 

   if isFalse( ::fireEvent( 'addingCanceledButton' ) )
      RETURN ( nil )
   end if 

   ::oButtonCanceled   := ::AddButton( "Cancelar", "del16", {|| ::getSuperController():Cancel( ::getBrowse():aSelected ), ::oController:Refresh() }, "E", ACC_DELE ) 

   ::fireEvent( 'addedCanceledButton') 

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD addPrintButtons()

   if isFalse( ::fireEvent( 'addingPrintButton' ) )
      RETURN ( nil )
   end if 

   ::oButtonPrint    := ::AddButton( "Imprimir", "Imp16", {|| ::getSuperController():getImprimirSeriesController():printDocument() }, "I", ACC_IMPR )

   aeval( ::getControllerDocuments(), {|cFile| ::AddButton( getFileNoExt( cFile ), "Imp16", ::blockPrintDocument( IS_PRINTER, getFileNoExt( cFile ) ), , ACC_IMPR, ::oButtonPrint ) } )

   ::fireEvent( 'addedPrintButton') 

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD addPreviewButtons()

   if isFalse( ::fireEvent( 'addingPreviewButton' ) )
      RETURN ( nil )
   end if 

   ::oButtonPreview  := ::AddButton( "Previsualizar", "Prev116", {|| ::getSuperController():getImprimirSeriesController():screenDocument() }, "P", ACC_IMPR ) 

   aeval( ::getControllerDocuments(), {|cFile| ::AddButton( getFileNoExt( cFile ), "Prev116", ::blockPrintDocument( IS_SCREEN, getFileNoExt( cFile ) ), , ACC_IMPR, ::oButtonPreview ) } )

   ::fireEvent( 'addedPreviewButton') 

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD addPdfButtons()

   if isFalse( ::fireEvent( 'addingPdfButton' ) )
      RETURN ( nil )
   end if 

   ::oButtonPdf  := ::AddButton( "Pdf", "Doclock16", {|| ::getSuperController():getImprimirSeriesController():pdfDocument() }, "F", ACC_IMPR ) 

   aeval( ::getControllerDocuments(), {|cFile| ::AddButton( getFileNoExt( cFile ), "Doclock16", ::blockPrintDocument( IS_PDF, getFileNoExt( cFile ) ), , ACC_IMPR, ::oButtonPdf ) } ) 

   ::fireEvent( 'addedPdfButton') 

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD addMailButtons()

   if !( Auth():canSendMail() )
      RETURN ( nil )
   end if 

   if isFalse( ::fireEvent( 'addingMailButton' ) )
      RETURN ( nil )
   end if 

   ::oButtonMail  := ::AddButton( "Correo electr�nico", "Mail16", {|| ::getSuperController():getMailController():dialogViewActivate() }, "L", ACC_IMPR ) 

   ::fireEvent( 'addedMailButton') 

RETURN ( nil )

//----------------------------------------------------------------------------//

METHOD addLabelButton()

   if !( ::isControllerLabels() )
      RETURN ( nil )
   end if 

   if isFalse( ::fireEvent( 'addingLabelButton' ) )
      RETURN ( nil )
   end if 

   ::oButtonLabel  := ::AddButton( "Etiquetas", "gc_portable_barcode_scanner_16", {|| ::getSuperController():labelDocument() }, "Q", ACC_IMPR ) 

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

   ::oButtonConfig   := ::AddButton( "Configuraciones", "gc_wrench_16", {|| ::getSuperController():editConfig() }, "N", ACC_IMPR ) 

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

RETURN ( {|| ::getSuperController():getImprimirSeriesController():showDocument( nDevice, cFormato ) } ) 

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

   ::addMailButtons()
   
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

   if ( !hb_isblock( oItem:Cargo ) )
      RETURN ( nil )
   end if 

   eval( oItem:Cargo )

   ::selectButtonMain()

RETURN ( nil )

//----------------------------------------------------------------------------//


