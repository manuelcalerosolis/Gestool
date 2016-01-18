#include "FiveWin.Ch"
#include "Factu.ch" 
#include "MesDbf.ch"
#include "Report.ch"
#include "XBrowse.ch"

//---------------------------------------------------------------------------//

CLASS TGeneracionAlbaranesClientes FROM TConversionDocumentos 

   DATA oAlmacen

   METHOD Dialog()

   METHOD DialogSelectionCriteria( oDlg )
      METHOD validDialogSelectionCriteria()
      METHOD notValidDialogSelectionCriteria()     INLINE ( !::validDialogSelectionCriteria() )

   METHOD isHeadersConditions()
   METHOD isLineConditions()

   METHOD startDialog()
      METHOD botonSiguiente()
      METHOD botonAnterior()                       INLINE ( ::oFld:goPrev(), ::oBtnAnterior:Hide() )

   METHOD loadLinesDocument()
      METHOD scanStock( oDocumentLine )
      METHOD assignStock( oDocumentLine )
      METHOD assertCodeStock( oDocumentLine )
      METHOD isUnitsStock( oDocumentLine )
      METHOD getUnitsInStock()
      METHOD minusUnitsStock()

   METHOD columnsBrowseLines()

ENDCLASS

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
                  "ASS_CONVERSION_DOCUMENTO_3"

   ::DialogSelectionCriteria( ::oFld:aDialogs[1] )

   ::DialogSelectionLines( ::oFld:aDialogs[2] )
   
   // Botones -----------------------------------------------------------------

   REDEFINE BUTTON ::oBtnAnterior;
      ID          3 ;
      OF          ::oDlg ;
      ACTION      ( ::BotonAnterior() )

   REDEFINE BUTTON ::oBtnSiguiente;
      ID          IDOK ;
      OF          ::oDlg ;
      ACTION      ( ::botonSiguiente() )

   REDEFINE BUTTON ;
      ID          IDCANCEL ;
      OF          ::oDlg ;
      ACTION      ( ::oDlg:End() )

   ::oDlg:bStart  := {|| ::startDialog() }

   ACTIVATE DIALOG ::oDlg CENTER

   ::CloseFiles()

   oBmp:End()

RETURN ( ::oDlg:nResult == IDOK )

//---------------------------------------------------------------------------//

METHOD DialogSelectionCriteria( oDlg )

   ::oPeriodo     := GetPeriodo()
      ::oPeriodo:New( 110, 120, 130 )
      ::oPeriodo:Resource( oDlg )

   ::oCliente     := GetCliente()
      ::oCliente:New( 140, 141, 142 )
      ::oCliente:Resource( oDlg )
      ::oCliente:setView( ::nView )

   ::oArticulo    := GetArticulo()
      ::oArticulo:New( 200, 201, 202 )
      ::oArticulo:Resource( oDlg )
      ::oArticulo:setView( ::nView )

   ::oAlmacen     := GetAlmacen()
      ::oAlmacen:New( 210, 211, 212 )
      ::oAlmacen:Resource( oDlg )
      ::oAlmacen:setView( ::nView )

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD startDialog()

   ::oAlmacen:cText( cDefAlm() )
   ::oAlmacen:Valid()

   ::setDocumentPedidosClientes()

   ::oBrwLines:Load()

   ::oBtnAnterior:Hide()

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD validDialogSelectionCriteria()

   if empty( ::oAlmacen:Varget() )
      msgStop( "Código de almcén no puede estar vacio.")
      Return .f.
   end if 

Return .t.

//---------------------------------------------------------------------------//

METHOD columnsBrowseLines()

   ::Super:columnsBrowseLines()

   with object ( ::oBrwLines:AddCol() )
      :cHeader                      := "Pendientes"
      :Cargo                        := "getUnitsAwaitingProvided"
      :bEditValue                   := {|| ::getLineDocument():getUnitsAwaitingProvided() } 
      :cEditPicture                 := masUnd()
      :nWidth                       := 80
      :nDataStrAlign                := 1
      :nHeadStrAlign                := 1
      :bLClickHeader                := {|nMRow, nMCol, nFlags, oColumn| ::clickOnLineHeader( oColumn ) }         
      :bLDClickData                 := {|| ::toogleSelectLine() }
   end with

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD botonSiguiente()

   if ::notValidDialogSelectionCriteria()
      Return .f.
   end if 

   ::loadLinesDocument()

   ::setbrowseLinesDocument()

   ::oFld:goNext()

   ::oBtnAnterior:Show()

   /*
   if !::oDocumentLines:anySelect()
      msgStop( "No hay líneas seleccionadas." )
   else
      ::oDlg:End( IDOK )
   end if
   */

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

   ::oDocumentLines:Reset()
   ::oStock:Reset()

   ( ::getHeaderAlias() )->( ordsetfocus( "dFecPed" ) )
   ( ::getHeaderAlias() )->( dbGoTop() )

   while ( ::getHeaderAlias() )->dFecPed <= ::oPeriodo:getFechaFin() .and. !::getHeaderEof() // 

      if ::isHeadersConditions() .and. ::seekLineId()

         while ::getHeaderId() == ::getLineId() .and. !( ::getLineAlias() )->( eof() ) 

            if ::isLineConditions()

               oDocumentLine     := ClientDeliveryNoteDocumentLine():newBuildDictionary( self ) 

               if oDocumentLine:getUnitsAwaitingProvided() > 0
                  ::oDocumentLines:addLines( oDocumentLine )
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
      // msgAlert( hb_valtoexp( ::oStock:aStocks ) )
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
/*
   local oStock      := ::scanStock( oDocumentLine )
   local nUnidades   := 0

   if !empty( oStock )
      nUnidades      := oStock:nUnidades
   end if 
*/
   /*
   aeval( ::oStock:aStocks, {|o| if(   rtrim( o:cCodigo ) == rtrim( oDocumentLine:getCode() ) .and.;
                                       rtrim( o:cCodigoAlmacen ) == rtrim( oDocumentLine:getAlmacen() ) .and.;
                                       rtrim( o:cCodigoPropiedad1 ) == rtrim( oDocumentLine:getCodeFirstProperty() ) .and.;
                                       rtrim( o:cCodigoPropiedad2 ) == rtrim( oDocumentLine:getCodeSecondProperty() ) .and.;
                                       rtrim( o:cValorPropiedad1 ) == rtrim( oDocumentLine:getValueFirstProperty() ) .and.;
                                       rtrim( o:cValorPropiedad2 ) == rtrim( oDocumentLine:getValueSecondProperty() ),;
                                       nUnidades += o:nUnidades, ) } )
   */
/*
   if nUnidades != 0
   msgAlert( oDocumentLine:getCode(), "o:cCodigo" )
   msgAlert( oDocumentLine:getAlmacen(), "o:cCodigoAlmacen " )
   msgAlert( oDocumentLine:getValueFirstProperty(), "o:cValorPropiedad1" )
   msgAlert( oDocumentLine:getValueSecondProperty(), "o:cValorPropiedad2" )
   msgAlert( nUnidades, "nUnidades" )
   end if 
   
Return ( nUnidades )
*/
//---------------------------------------------------------------------------//

