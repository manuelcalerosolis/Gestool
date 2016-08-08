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

   METHOD New()

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
      METHOD botonAnterior()                       INLINE ( ::oFld:goPrev(), ::buttonPrior:Hide() )

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
         METHOD appendCurrentClientDeliveryNote()
         METHOD appendBlankClientDeliveryNote()

   METHOD getCustomerOrderLines()                  INLINE ( ::dialogCustomerOrderLines:oDocumentLines )
   METHOD getCustomerOrderLine( nPosition )        INLINE ( ::dialogCustomerOrderLines:getDocumentLine( nPosition ) )

ENDCLASS

//----------------------------------------------------------------------------//

METHOD New()

   ::Super:New()

   ::dialogCustomerOrderLines     := TBrowseLineConversionDocumentos():New( Self )

   ::dialogDeliveryNoteLines     := TBrowseLineConversionDocumentos():New( Self )

RETURN ( Self )

//----------------------------------------------------------------------------//

METHOD Dialog() 

   local oBmp

   DEFINE DIALOG  ::oDlg ;
      RESOURCE    "ASS_CONVERSION_DOCUMENTO"

   REDEFINE BITMAP oBmp ;
      ID          500 ;
      RESOURCE    "hand_point_48" ;
      TRANSPARENT ;
      OF          ::oDlg

   REDEFINE PAGES ::oFld ;
      ID          100 ;
      OF          ::oDlg ;
      DIALOGS     "ASS_CONVERSION_DOCUMENTO_5",;
                  "ASS_CONVERSION_DOCUMENTO_3",;
                  "ASS_CONVERSION_DOCUMENTO_2"

   ::buildDialogSelectionCriteria()

   ::buildDialogCustomerOrderLines()
   
   // ::DialogSelectionDocument( ::oFld:aDialogs[3] )
   
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

   ::CloseFiles()

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

   if empty( ::oAlmacen:Varget() )
      msgStop( "Código de almacén no puede estar vacio.")
      Return .f.
   end if 

Return .t.

//---------------------------------------------------------------------------//

METHOD buildDialogCustomerOrderLines()

   ::dialogCustomerOrderLines:Dialog( ::oFld:aDialogs[ 2 ] )

   with object ( ::dialogCustomerOrderLines:AddCol() )
      :cHeader       := "Pendientes"
      :Cargo         := "getUnitsAwaitingProvided"
      :bEditValue    := {|| ::getCustomerOrderLine():getUnitsAwaitingProvided() } 
      :cEditPicture  := masUnd()
      :nWidth        := 80
      :nDataStrAlign := 1
      :nHeadStrAlign := 1
      :bLClickHeader := {|nMRow, nMCol, nFlags, oColumn| ::clickOnLineHeader( oColumn ) }         
      :bLDClickData  := {|| ::dialogCustomerOrderLines:toogleSelectLine() }
   end with

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD buildDialogDeliveryNoteLines( oDlg )

   ::dialogDeliveryNoteLines:Dialog( ::oFld:aDialogs[ 3 ] )

/*
   with object ( ::dialogDeliveryNoteLines:AddCol() )
      :cHeader       := "Pedido"
      :Cargo         := "getPedidoCliente"
      :bEditValue    := {|| ::getHeaderDocument():getValue( "PedidoCliente" ) }
      :nWidth        := 80
      :bLClickHeader := {| nMRow, nMCol, nFlags, oColumn | ::clickOnDocumentHeader( oColumn ) }   
   end with
*/

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

         if ( ::getCustomerOrderLines():anySelect() )
            
            ::processLines()
            
            ::oFld:goNext()

         else
            
            msgStop( "No hay líneas seleccionadas." )

         end if 

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

   ( ::getHeaderAlias() )->( ordsetfocus( "dFecPed" ) )

   ( ::getHeaderAlias() )->( dbGoTop() )
   while ( ::getHeaderAlias() )->dFecPed <= ::oPeriodo:getFechaFin() .and. !::getHeaderEof() // 

      if ::isHeadersConditions() .and. ::seekLineId()

         while ( ::getHeaderId() == ::getLineId() ) .and. !( ::getLineAlias() )->( eof() ) 

            if ::isLineConditions()

               oDocumentLine     := CustomerOrderDocumentLine():newBuildDictionary( self ) 

               if oDocumentLine:getUnitsAwaitingProvided() > 0
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

   nScan := ascan( ::oStock:aStocks,   {|o|  rtrim( o:cCodigo ) == rtrim( oDocumentLine:getCode() ) .and.;
                                             rtrim( o:cCodigoAlmacen ) == rtrim( oDocumentLine:getAlmacen() ) .and.;
                                             rtrim( o:cCodigoPropiedad1 ) == rtrim( oDocumentLine:getCodeFirstProperty() ) .and.;
                                             rtrim( o:cCodigoPropiedad2 ) == rtrim( oDocumentLine:getCodeSecondProperty() ) .and.;
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

   ::aDocuments         := {}

   for each oLine in ( ::getCustomerOrderLines():getLines() )
      if oLine:isSelectLine()
         ::processLine( oLine )
      end if 
   next

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD processLine( oLine )

   if D():gotoPedidoIdAlbaranesClientes( oLine:getDocumentId(), ::nView )
      ::appendCurrentClientDeliveryNote( oLine )
   else 
      ::appendBlankClientDeliveryNote( oLine )
   end if

   ::oBrwDocuments:Refresh()

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD appendCurrentClientDeliveryNote( oLine )

   local oDocument

   msgalert( valtype( oLine ), "appendCurrentClientDeliveryNote" )
   debug( oLine, "oLine" )

   oDocument         := ClientDeliveryNoteDocumentHeader():newRecordDictionary( self ) 
   oDocument:setValue( "PedidoCliente", ( D():AlbaranesClientes( ::nView ) )->cNumPed )

   ::oDocumentHeaders:addLines( oDocument )

Return ( nil )

//---------------------------------------------------------------------------//

METHOD appendBlankClientDeliveryNote( oLine )

   local oDocument

   msgalert( valtype( oLine ), "valtype")
   debug( oLine:getHeaderClient(), "getHeaderClient" )
   debug( oLine:getHeaderClientName(), "getHeaderClientName" )
   debug( oLine:getHeaderDate(), "getHeaderDate" )

   oDocument         := ClientDeliveryNoteDocumentHeader():newBlankDictionary( self ) 
   oDocument:setValue( "PedidoCliente", space( 13 ) )
   oDocument:setClient( oLine:getHeaderClient() )
   oDocument:setClientName( oLine:getHeaderClientName() )

   ::oDocumentHeaders:addLines( oDocument )

Return ( nil )

//---------------------------------------------------------------------------//

