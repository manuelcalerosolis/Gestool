#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"
#include "Report.ch"
#include "XBrowse.ch"

//---------------------------------------------------------------------------//

CLASS TGeneracionAlbaranesClientes FROM TConversionDocumentos 

   DATA oAlmacen

   DATA aDocuments

   DATA dialogCustomerOrderLines

   DATA dialogDeliveryNoteLines 

   DATA deliveryNoteCustomer

   DATA currentClient
   DATA currentDocument

   DATA oWaitMeter

   METHOD New( nView, oStock )
   METHOD End()

   METHOD Dialog()

   METHOD buildDialogSelectionCriteria( oDlg )
      METHOD validDialogSelectionCriteria()
      METHOD notValidDialogSelectionCriteria()     INLINE ( !::validDialogSelectionCriteria() )

   METHOD buildDialogCustomerOrderLines()
   METHOD buildDialogDeliveryNoteLines()

   METHOD isHeadersConditions()
   METHOD isLineConditions()

   METHOD startDialog()
      METHOD botonSiguiente()
      METHOD botonAnterior()                       INLINE ( ::oFld:goPrev(), if( ::oFld:nOption == 1, ::buttonPrior:Hide(), ) )

   METHOD loadLinesDocument()
      METHOD scanStock( oDocumentLine )
      METHOD assignStock( oDocumentLine )
      METHOD assertCodeStock( oDocumentLine )
      METHOD isUnitsStock( oDocumentLine )
      METHOD getUnitsInStock()
      METHOD minusUnitsStock()

   // METHOD dialogSelectionDocument( oDlg )

   METHOD processLines()
      METHOD processLine()
         METHOD appendDeliveryNoteLines()
         METHOD getValidDeliveryNoteForClient()

   METHOD processDeliveryNoteLines()
      METHOD processDeliveryNoteLine( oLine )

   METHOD getCustomerOrderLines()                  INLINE ( ::dialogCustomerOrderLines:oDocumentLines )
   METHOD getCustomerOrderLine( nPosition )        INLINE ( ::dialogCustomerOrderLines:getDocumentLine( nPosition ) )

   METHOD getDeliveryNoteLines()                   INLINE ( ::dialogDeliveryNoteLines:oDocumentLines )
   METHOD getDeliveryNoteLine( nPosition )         INLINE ( ::dialogDeliveryNoteLines:getDocumentLine( nPosition ) )

   METHOD setCurrentClient( currentClient )        INLINE ( ::currentClient   := currentClient )
   METHOD setCurrentDocument( currentDocument )    INLINE ( ::currentDocument := currentDocument )
   METHOD cleanCurrents()                          INLINE ( ::setCurrentClient(), ::setCurrentDocument() )

   METHOD appendDeliveryNoteCustomer( oLine )
   METHOD addDeliveryNoteCustomer( oLine )
   METHOD saveDeliveryNoteCustomer()

   METHOD addLineDeliveryNoteCustomer( oLine, currentDocument )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New( nView, oStock )

   ::Super:New( nView, oStock )

   ::dialogCustomerOrderLines    := TBrowseLineConversionDocumentos():New( Self )

   ::dialogDeliveryNoteLines     := TBrowseLineConversionDocumentos():New( Self )

   ::deliveryNoteCustomer        := DeliveryNoteCustomer():Build()
   ::deliveryNoteCustomer:setView( ::nView )

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD End()

   ::CloseFiles()

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD Dialog() 

   local oBmp

   DEFINE DIALOG  ::oDlg ;
      RESOURCE    "ASS_CONVERSION_DOCUMENTO"

   REDEFINE BITMAP oBmp ;
      ID          500 ;
      RESOURCE    "gc_hand_touch_48" ;
      TRANSPARENT ;
      OF          ::oDlg

   REDEFINE PAGES ::oFld ;
      ID          100 ;
      OF          ::oDlg ;
      DIALOGS     "ASS_CONVERSION_DOCUMENTO_5",;
                  "ASS_CONVERSION_DOCUMENTO_3",;
                  "ASS_CONVERSION_DOCUMENTO_3"

   ::buildDialogSelectionCriteria()

   ::buildDialogCustomerOrderLines()

   ::buildDialogDeliveryNoteLines()
   
   // Botones -----------------------------------------------------------------

   REDEFINE BUTTON ::buttonPrior;
      ID          3 ;
      OF          ::oDlg ;
      ACTION      ( ::botonAnterior() )

   REDEFINE BUTTON ::buttonNext;
      ID          IDOK ;
      OF          ::oDlg ;
      ACTION      ( ::botonSiguiente() )

   REDEFINE BUTTON ;
      ID          IDCANCEL ;
      OF          ::oDlg ;
      ACTION      ( ::oDlg:End() )

   ::oDlg:bStart  := {|| ::startDialog() }

   ::oDlg:addFastKey( VK_F5, {|| ::botonSiguiente() } )   

   ACTIVATE DIALOG ::oDlg CENTER

   oBmp:End()

RETURN ( ::oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

METHOD buildDialogSelectionCriteria()

   ::oPeriodo     := GetPeriodo()
      ::oPeriodo:New( 110, 120, 130 )
      ::oPeriodo:Resource( ::oFld:aDialogs[1] )

   ::oCliente     := GetCliente()
      ::oCliente:New( 140, 141, 142 )
      ::oCliente:Resource( ::oFld:aDialogs[1] )
      ::oCliente:setView( ::nView )

   ::oArticulo    := GetArticulo()
      ::oArticulo:New( 200, 201, 202 )
      ::oArticulo:Resource( ::oFld:aDialogs[1] )
      ::oArticulo:setView( ::nView )

   ::oAlmacen     := GetAlmacen()
      ::oAlmacen:New( 210, 211, 212 )
      ::oAlmacen:Resource( ::oFld:aDialogs[1] )
      ::oAlmacen:setView( ::nView )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD startDialog()

   ::oAlmacen:cText( cDefAlm() )
   ::oAlmacen:Valid()

   ::setDocumentPedidosClientes()

   ::dialogCustomerOrderLines:Load()

   ::dialogDeliveryNoteLines:Load()

   ::buttonPrior:Hide()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD validDialogSelectionCriteria()

   if empty( ::oAlmacen:varget() )
      msgStop( "Código de almacén no puede estar vacio." )
      Return .f.
   end if 

   if empty( ::oCliente:varget() ) .and. empty( ::oArticulo:varget() )
      msgStop( "Código de cliente o código de artículo deben cumplimentarse." )
      Return .f.
   end if 

Return .t.

//---------------------------------------------------------------------------//

METHOD buildDialogCustomerOrderLines()

   ::dialogCustomerOrderLines:setTitle( "Seleccione líneas de pedidos de clientes" )

   ::dialogCustomerOrderLines:Dialog( ::oFld:aDialogs[ 2 ] )

   ::dialogCustomerOrderLines:setName( "CustomerOrderLines" )

   with object ( ::dialogCustomerOrderLines:AddCol() )
      :cHeader       := "Pendientes"
      :Cargo         := "getUnitsAwaitingProvided"
      :bEditValue    := {|| ::getCustomerOrderLine():getUnitsAwaitingProvided() } 
      :cEditPicture  := masUnd()
      :nWidth        := 80
      :nDataStrAlign := 1
      :nHeadStrAlign := 1
      :bLClickHeader := {|nMRow, nMCol, nFlags, oColumn| ::dialogCustomerOrderLines:clickOnHeader( oColumn ) }         
      :bLDClickData  := {|| ::dialogCustomerOrderLines:toogleSelectLine() }
   end with

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD buildDialogDeliveryNoteLines( oDlg )

   ::dialogCustomerOrderLines:setTitle( "Seleccione líneas de albaranes de clientes" )

   ::dialogDeliveryNoteLines:Dialog( ::oFld:aDialogs[ 3 ] )

   ::dialogDeliveryNoteLines:setName( "DeliveryNoteLines" )

   with object ( ::dialogDeliveryNoteLines:InsCol( 1 ) )
      :cHeader       := "Albaran"
      :Cargo         := "getAlbaranCliente"
      :bEditValue    := {||   iif(  empty( ::getDeliveryNoteLine():getValue( "AlbaranCliente" ) ),;
                                    "Nuevo",; 
                                    transIdDocument( ::getDeliveryNoteLine():getValue( "AlbaranCliente" ) ) ) }
      :nWidth        := 80
      :bLDClickData  := {|| ::dialogDeliveryNoteLines:toogleSelectLine() }
   end with

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD botonSiguiente()

   do case
      case ::oFld:nOption == 1

         if ::notValidDialogSelectionCriteria()
            Return .f.
         end if 

         ::loadLinesDocument()

         ::oFld:goNext()

         ::buttonPrior:Show()

      case ::oFld:nOption == 2

         ::getDeliveryNoteLines():Reset()

         if ( ::getCustomerOrderLines():anySelect() )
            
            ::processLines()

            ::oFld:goNext()
            
         else

            msgStop( "No hay líneas seleccionadas." )
            
         end if 

         ::dialogDeliveryNoteLines:setBrowseLinesDocument()

      case ::oFld:nOption == 3

         ::processDeliveryNoteLines()

         ::oDlg:end()

   end case

Return ( Self )

//---------------------------------------------------------------------------//
//
// Convierte las lineas del albaran en objetos
//

METHOD isHeadersConditions()

   if !( ::oPeriodo:inRange( ( ::getHeaderAlias() )->dFecPed ) )
      Return .f.
   end if 

   if ( ( ::getHeaderAlias() )->lCancel )
      Return .f.
   end if 

   if empty( ::oCliente:Value() )
      Return .t.
   end if

Return ( ( ::getHeaderAlias() )->cCodCli == ::oCliente:Value() )

//---------------------------------------------------------------------------//

METHOD isLineConditions()

   if empty( ::oArticulo:Value() )
      Return .t.
   end if

Return ( ::aliasDocumentLine:getCode() == ::oArticulo:Value() )

//---------------------------------------------------------------------------//

METHOD loadLinesDocument() 

   local oDocumentLine

   autoMeterDialog( ::oDlg )

   setTotalAutoMeterDialog( ::getHeaderOrdKeyCount()  )

   ::getCustomerOrderLines():Reset()

   ::oStock:Reset()

   ( ::getHeaderAlias() )->( ordsetfocus( "dFecGen" ) )

   ( ::getHeaderAlias() )->( dbgotop() )
   while ( ::getHeaderAlias() )->dFecPed <= ::oPeriodo:getFechaFin() .and. !::getHeaderEof() // 

      if ::isHeadersConditions() .and. ::seekLineId()

         while ( ::getHeaderId() == ::getLineId() ) .and. !( ::getLineAlias() )->( eof() ) 

            if ::isLineConditions()

               oDocumentLine     := CustomerOrderDocumentLine():new( self ) 

               if oDocumentLine:getUnitsAwaitingReception() > 0
                  ::getCustomerOrderLines():addLines( oDocumentLine )
               end if 

               ::assignStock( oDocumentLine )

            end if 

            ( ::getLineAlias() )->( dbskip() ) 

         end while

      end if 

      setAutoMeterDialog( ::getHeaderOrdKeyNo() )

      ( ::getHeaderAlias() )->( dbSkip() )

   end while

   endAutoMeterDialog( ::oDlg )

   ::dialogCustomerOrderLines:setBrowseLinesDocument()

RETURN ( .t. ) 

//---------------------------------------------------------------------------//

METHOD assignStock( oDocumentLine )

   ::assertCodeStock( oDocumentLine )

   if ::isUnitsStock( oDocumentLine )

      ::minusUnitsStock( oDocumentLine )
   
      oDocumentLine:selectLine()
   
   end if 

RETURN ( .t. ) 

//---------------------------------------------------------------------------//

METHOD assertCodeStock( oDocumentLine )

   local nScan

   nScan := ascan( ::oStock:aStocks, {|o| o:cCodigo == oDocumentLine:getCode() } )
   if nScan == 0
      ::oStock:aStockArticulo( oDocumentLine:getCode() )
   end if 

RETURN ( .t. ) 

//---------------------------------------------------------------------------//

METHOD scanStock( oDocumentLine )

   local nScan
   local oStock

   nScan := ascan( ::oStock:aStocks,   {|o|  rtrim( o:cCodigo ) == rtrim( oDocumentLine:getCode() )                        .and.;
                                             rtrim( o:cCodigoAlmacen ) == rtrim( oDocumentLine:getAlmacen() )              .and.;
                                             rtrim( o:cValorPropiedad1 ) == rtrim( oDocumentLine:getValueFirstProperty() ) .and.;
                                             rtrim( o:cValorPropiedad2 ) == rtrim( oDocumentLine:getValueSecondProperty() ) } )
   if nScan != 0
      oStock   := ::oStock:aStocks[ nScan ]
   end if 

Return ( oStock )

//---------------------------------------------------------------------------//

METHOD getUnitsInStock( oDocumentLine )

   local oStock      := ::scanStock( oDocumentLine )
   local nUnidades   := 0

   if !empty( oStock )
      nUnidades      := oStock:nUnidades
   end if 

Return ( nUnidades )

//---------------------------------------------------------------------------//

METHOD isUnitsStock( oDocumentLine )

Return ( ::getUnitsInStock( oDocumentLine ) >= oDocumentLine:getTotalUnits() )

//---------------------------------------------------------------------------//

METHOD minusUnitsStock( oDocumentLine )

   local oStock         := ::scanStock( oDocumentLine )

   if !empty(oStock)
      oStock:nUnidades  -= oDocumentLine:getTotalUnits()
   end if 

Return ( Self ) 

//---------------------------------------------------------------------------//

METHOD processLines()

   local oLine

   for each oLine in ( ::getCustomerOrderLines():getLines() )
      if oLine:isSelectLine()
         ::processLine( oLine )
      end if 
   next

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD processLine( oLine )

   ::appendDeliveryNoteLines( oLine:getClone(), ::getValidDeliveryNoteForClient( oLine ) )

   ::dialogDeliveryNoteLines:setBrowseLinesDocument()

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD getValidDeliveryNoteForClient( oLine )

   local deliveryNote

   D():getStatusAlbaranesClientes( ::nView )
   D():setFocusAlbaranesClientes( "cNumPed", ::nView )

   if D():gotoPedidoIdAlbaranesClientes( oLine:getDocumentId(), ::nView )
      while ( D():AlbaranesClientes( ::nView ) )->cNumPed == oLine:getDocumentId() .and. !( D():AlbaranesClientes( ::nView ) )->( eof() )
         
         if ( D():AlbaranesClientes( ::nView ) )->lEntregado
            deliveryNote   := D():AlbaranesClientesId( ::nView )
            exit
         end if 

         ( D():AlbaranesClientes( ::nView ) )->( dbskip() )

      end while   
   end if 

   D():setStatusAlbaranesClientes( ::nView )

Return ( deliveryNote )

//---------------------------------------------------------------------------//

METHOD appendDeliveryNoteLines( oLine, cNumeroAlbaran )

   if !empty( cNumeroAlbaran )
      oLine:setValue( "AlbaranCliente", cNumeroAlbaran )
   end if 

   ::getDeliveryNoteLines():addLines( oLine )

Return ( nil )

//---------------------------------------------------------------------------//

METHOD processDeliveryNoteLines()

   local oLine
   local aLines         := ::getDeliveryNoteLines():getLines() 

   ::oWaitMeter         := TWaitMeter():New( "Generando albaranes", "Espere por favor...", len( ::getDeliveryNoteLines():getLines() ) )
   ::oWaitMeter:Run()

   asort( ::getDeliveryNoteLines():getLines(), , , {|x,y| x:getHeaderClient() + x:getValueFirstProperty() + x:getValueSecondProperty() <= y:getHeaderClient() + y:getValueFirstProperty() + y:getValueSecondProperty() } )

   for each oLine in aLines
      if oLine:isSelectLine()
         ::processDeliveryNoteLine( oLine, hb_enumindex() )
      end if 
   next

   ::oWaitMeter:end()

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD processDeliveryNoteLine( oLine, nLine )

   ::oWaitMeter:incMeter()

   if !( empty( oLine:getValue( "AlbaranCliente" ) ) ) 
      ::addLineDeliveryNoteCustomer( oLine, nLine, oLine:getValue( "AlbaranCliente" ) )
      ::cleanCurrents()  
      Return .t.
   end if 

   if empty( oLine:getValue( "AlbaranCliente" ) ) .and. ( !empty( ::currentClient ) .and. ::currentClient == oLine:getHeaderClient() )
      ::addLineDeliveryNoteCustomer( oLine, nLine, ::currentDocument )
      Return .t.
   end if 

   if empty( oLine:getValue( "AlbaranCliente" ) ) 
      ::appendDeliveryNoteCustomer( oLine )
      ::addDeliveryNoteCustomer( oLine, nLine )
      ::saveDeliveryNoteCustomer()
   end if 

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD appendDeliveryNoteCustomer( oLine )

   ::DeliveryNoteCustomer:setAppendMode()

   ::DeliveryNoteCustomer:getAppendDocumento()

   ::DeliveryNoteCustomer:hSetMaster( "Entregado", .t. ) 

   ::DeliveryNoteCustomer:hSetMaster( "NumeroPedido", oLine:getId() )

   ::DeliveryNoteCustomer:setClientToDocument( oLine:getHeaderClient() )

   ::setCurrentClient( oLine:getHeaderClient() )

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD addDeliveryNoteCustomer( oLine, nLine )

   local oDeliveryNoteLine

   ::oWaitMeter:setMessage( "Añadiendo línea " + alltrim( str( nLine ) ) + " a cliente : " + alltrim( oLine:getHeaderClient() ) + space( 1 ) + alltrim( oLine:getHeaderClientName() ) )

   oDeliveryNoteLine    := DeliveryNoteDocumentLine():New( ::DeliveryNoteCustomer ) 
   
   oDeliveryNoteLine:setDictionary( oLine:hDictionary )

   ::DeliveryNoteCustomer:oDocumentLines:addLines( oDeliveryNoteLine )   

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD saveDeliveryNoteCustomer( oLine )

   ::DeliveryNoteCustomer:onPreSaveAppend()

   ::DeliveryNoteCustomer:saveAppendDocumento( oLine )

   ::setCurrentDocument( ::DeliveryNoteCustomer:getId() )

   ::DeliveryNoteCustomer:onPreEnd()

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD addLineDeliveryNoteCustomer( oLine, nLine, currentDocument )

   if !( D():gotoIdAlbaranesClientes( currentDocument, ::nView ) )
      msgStop( "Albarán de cliente " + transIdDocument( currentDocument ) + " no encontrado." )
      Return .f.
   end if 

   ::DeliveryNoteCustomer:getEditDocumento()

   ::addDeliveryNoteCustomer( oLine, nLine )

   ::DeliveryNoteCustomer:setDatasInDictionaryMaster() 

   ::DeliveryNoteCustomer:saveEditDocumento()

   ::DeliveryNoteCustomer:onPreEnd()

Return ( .t. )

//---------------------------------------------------------------------------//


