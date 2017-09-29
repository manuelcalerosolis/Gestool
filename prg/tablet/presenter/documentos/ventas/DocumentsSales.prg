#include "FiveWin.Ch"
#include "Factu.ch" 
 
CLASS DocumentsSales FROM Documents

   DATA oSender

   DATA oProduct
   DATA oProductStock
   DATA oStore
   DATA oPayment
   DATA oDirections

   DATA oViewEditResumen

   DATA oDocumentLines

   DATA oLinesDocumentsSales

   DATA nUltimoCliente

   DATA hTextDocuments                    INIT  {  "textMain"     => "Facturas de clientes",;
                                                   "textShort"    => "Factura",;
                                                   "textTitle"    => "lineas de facturas",;
                                                   "textSummary"  => "Resumen factura",;
                                                   "textGrid"     => "Grid facturas clientes" }
   
   DATA hOrdenRutas                       INIT  {  "1" => "lVisDom",;
                                                   "2" => "lVisLun",;
                                                   "3" => "lVisMar",;
                                                   "4" => "lVisMie",;
                                                   "5" => "lVisJue",;
                                                   "6" => "lVisVie",;
                                                   "7" => "lVisSab",;
                                                   "8" => "Cod" }

   DATA cTextSummaryDocument              INIT ""
   DATA cTypePrintDocuments               INIT ""                                       
   DATA cCounterDocuments                 INIT "" 

   DATA oTotalDocument

   DATA oldSerie                          INIT ""

   METHOD New( oSender )
   METHOD Build( oSender ) 

   METHOD play() 

   METHOD runNavigator()
      METHOD onPreRunNavigator()

   METHOD hSetMaster( cField, uValue )                      INLINE ( hSet( ::hDictionaryMaster, cField, uValue ) )
   METHOD hGetMaster( cField )                              INLINE ( hGet( ::hDictionaryMaster, cField ) )

   METHOD hSetDetail( cField, uValue )                      INLINE ( hSet( ::oDocumentLineTemporal:hDictionary, cField, uValue ) )
   METHOD hGetDetail( cField )                              INLINE ( hGet( ::oDocumentLineTemporal:hDictionary, cField ) )

   METHOD setTextSummaryDocument( cTextSummaryDocument )    INLINE ( ::cTextSummaryDocument := cTextSummaryDocument )
   METHOD getTextSummaryDocument()                          INLINE ( if( hhaskey( ::hTextDocuments, "textSummary" ), hget( ::hTextDocuments, "textSummary"), ::cTextSummaryDocument ) )

   METHOD getTextGrid()                                     INLINE ( if( hhaskey( ::hTextDocuments, "textGrid" ), hget( ::hTextDocuments, "textGrid"), "" ) )
   METHOD getTextTitle()                                    INLINE ( if( hhaskey( ::hTextDocuments, "textTitle" ), hget( ::hTextDocuments, "textTitle"), "" ) )

   METHOD setTypePrintDocuments( cTypePrintDocuments )      INLINE ( ::cTypePrintDocuments := cTypePrintDocuments )
   METHOD getTypePrintDocuments()                           INLINE ( ::cTypePrintDocuments )

   METHOD setCounterDocuments( cCounterDocuments )          INLINE ( ::cCounterDocuments := cCounterDocuments )
   METHOD getCounterDocuments()                             INLINE ( ::cCounterDocuments )

   METHOD OpenFiles()
   METHOD CloseFiles()

   METHOD getSerie()                                        INLINE ( ::hGetMaster( "Serie" ) )
   METHOD getNumero()                                       INLINE ( ::hGetMaster( "Numero" ) )
   METHOD getStrNumero()                                    INLINE ( str( ::getNumero(), 9 ) )
   METHOD getSufijo()                                       INLINE ( ::hGetMaster( "Sufijo" ) )
   METHOD getStore()                                        INLINE ( ::hGetMaster( "Almacen" ) )

   METHOD getId()                                           INLINE ( ::getSerie() + ::getStrNumero() + ::getSufijo() )

   METHOD isPuntoVerde()                                    INLINE ( ::hGetMaster( "OperarPuntoVerde" ) )
   METHOD isRecargoEquivalencia()                           INLINE ( ::hGetMaster( "lRecargo" ) )

   METHOD resourceDetail( nMode )                           INLINE ( ::oLinesDocumentsSales:resourceDetail( nMode ) )

   METHOD onViewCancel()
   METHOD onViewSave()
   METHOD isResumenVenta()
   METHOD lValidResumenVenta()

   METHOD getDataBrowse( Name )                             INLINE ( hGet( ::oDocumentLineTemporal:hDictionary[ ::oViewEdit:oBrowse:nArrayAt ], Name ) )

   METHOD isChangeSerieTablet( lReadyToSend, getSerie )
   
   METHOD changeSerieTablet( getSerie )

   METHOD runGridCustomer()
   METHOD lValidCliente()

   METHOD runGridDirections()
   METHOD lValidDireccion()

   METHOD runGridPayment()
   METHOD lValidPayment()

   METHOD changeRuta()

   METHOD priorClient()                                     INLINE ( ::moveClient( .t. ) )
   METHOD nextClient()                                      INLINE ( ::moveClient( .f. ) )
   METHOD moveClient()

   METHOD loadNextClient()
      METHOD gotoUltimoCliente()
      METHOD setUltimoCliente()

   METHOD getBruto()                                        INLINE ( ::oDocumentLines:getBruto() )
   METHOD calculaIVA()                                      VIRTUAL

   METHOD saveAppendDetail()
   METHOD saveEditDetail()

   METHOD isPrintDocument()
   METHOD printDocument()                                   VIRTUAL

   METHOD saveEditDocumento()
   METHOD saveAppendDocumento()

   METHOD onPreSaveAppend()
      METHOD onPreSaveAppendDetail() 
      METHOD onPostSaveAppendDetail()

   METHOD onPostGetDocumento()                              INLINE ( ::oldSerie  := ::getSerie() ) 
   METHOD onPreSaveEdit()                                   
   
   METHOD onPreEnd()
      METHOD setClientToDocument()
      METHOD setAgentToDocument()
      METHOD setDatasInDictionaryMaster( NumeroDocumento ) 

   // Lineas-------------------------------------------------------------------

   METHOD addDocumentLine()
      METHOD assignLinesDocument()
      METHOD setLinesDocument()
      METHOD appendDocumentLine( oDocumentLine )            INLINE ( D():appendHashRecord( oDocumentLine:hDictionary, ::getDataTableLine(), ::nView ) )
      METHOD delDocumentLine()                              INLINE ( D():deleteRecord( ::getDataTableLine(), ::nView ) )

   METHOD cComboRecargoValue()

   METHOD onclickClientEdit()                               INLINE ( ::oCliente:EditCustomer( hGet( ::hDictionaryMaster, "Cliente" ) ) )
   METHOD onclickClientSales()                              INLINE ( ::oCliente:SalesCustomer( hGet( ::hDictionaryMaster, "Cliente" ) ) )

   METHOD getEditDetail() 
   
   METHOD setDocuments()
   
   METHOD Resource( nMode )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oSender ) CLASS DocumentsSales

   if !::openFiles()
      RETURN ( self )
   end if 

   ::Build( oSender )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD Build( oSender ) CLASS DocumentsSales

   ::oSender               := oSender

   ::oViewSearchNavigator  := DocumentSalesViewSearchNavigator():New( self )

   ::oViewEdit             := DocumentSalesViewEdit():New( self )

   ::oViewEditResumen      := ViewEditResumen():New( self )

   ::oCliente              := Customer():init( self )  

   ::oProduct              := Product():init( self )

   ::oProductStock         := ProductStock():init( self )

   ::oStore                := Store():init( self )

   ::oPayment              := Payment():init( self )

   ::oDirections           := Directions():init( self )

   ::oDocumentLines        := DocumentLines():New( self )

   ::oLinesDocumentsSales  := LinesDocumentsSales():New( self )

   ::oTotalDocument        := TotalDocument():New( self )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD play() CLASS DocumentsSales

   if ::onPreRunNavigator()
      ::runNavigator()
   end if 

   ::closeFiles()

RETURN ( self )

//---------------------------------------------------------------------------//
//
// Filtro para codigos de agente
//

METHOD onPreRunNavigator() CLASS DocumentsSales

   if empty( ::getWorkArea() )
      RETURN .t.
   end if 

   ( ::getWorkArea() )->( ordsetfocus( "dFecDes" ) )
   ( ::getWorkArea() )->( dbgotop() ) 

   if ( accessCode():lFilterByAgent ) .and. !empty( accessCode():cAgente )
      ( ::getWorkArea() )->( adsSetAOF( "cCodAge = " + quoted( accessCode():cAgente ) ) )
      ( ::getWorkArea() )->( dbgotop() )
   end if 
      
RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD runNavigator() CLASS DocumentsSales

   if !empty( ::oViewSearchNavigator )
      ::oViewSearchNavigator:Resource()
   end if

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS DocumentsSales
   
   local oError
   local oBlock
   local lOpenFiles     := .t.

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      ::nView           := D():CreateView()

      D():PedidosClientes( ::nView )

      D():PedidosClientesLineas( ::nView )

      D():AlbaranesClientes( ::nView )

      D():AlbaranesClientesLineas( ::nView )

      //D():FacturasClientes( ::nView )

      D():FacturasClientesLineas( ::nView )

      D():FacturasClientesCobros( ::nView )

      D():TiposIva( ::nView )

      D():Divisas( ::nView )

      D():Clientes( ::nView )

      D():ClientesDirecciones( ::nView )

      D():Articulos( ::nView )

      D():ArticulosCodigosBarras( ::nView )

      D():ProveedorArticulo( ::nView )

      D():Proveedores( ::nView )

      D():Familias( ::nView )

      D():ImpuestosEspeciales( ::nView )

      D():Kit( ::nView )

      D():Contadores( ::nView )

      D():Documentos( ::nView )

      D():FormasPago( ::nView )

      ::oStock            := TStock():Create( cPatEmp() )
      if !::oStock:lOpenFiles()
         lOpenFiles     := .f.
      end if

   RECOVER USING oError

      lOpenFiles        := .f.

      apoloMsgStop( "Imposible abrir todas las bases de datos" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   if !lOpenFiles
      ::closeFiles()
   end if

RETURN ( lOpenFiles )

//---------------------------------------------------------------------------//

METHOD CloseFiles() CLASS DocumentsSales
   
   D():DeleteView( ::nView )

   if !empty( ::oStock )
      ::oStock:end()
   end if

   ::oStock    := nil

RETURN nil

//---------------------------------------------------------------------------//

METHOD isChangeSerieTablet() CLASS DocumentsSales
   
   if GetPvProfString( "Tablet", "BloqueoSerie", ".F.", cIniAplication() ) == ".T."
      RETURN ( self )
   end if

   if ::lZoomMode()
      RETURN ( self )
   end if 

   if hGet( ::hDictionaryMaster, "Envio" )
      ::ChangeSerieTablet( ::oViewEdit:getSerie )
   end if

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD ChangeSerieTablet( getSerie ) CLASS DocumentsSales

   local cSerie   := getSerie:VarGet()

   do case
      case cSerie == "A"
         getSerie:cText( "B" )

      case cSerie == "B"
         getSerie:cText( "C" )

      case cSerie == "C"
         getSerie:cText( "A" )

      otherwise
         getSerie:cText( "A" )

   end case

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD lValidDireccion() CLASS DocumentsSales

   local lValid            := .t.

   /*local nRec
   local nOrdAnt
   local lValid            := .f.
   local codigoCliente     := ::oViewEdit:getCodigoCliente:varGet()     // hGet( ::hDictionaryMaster, "Cliente" )
   local codigoDireccion   := ::oViewEdit:getCodigoDireccion:varGet()

   if empty( codigoCliente )
      RETURN .t.
   end if

   if empty( codigoDireccion )
      RETURN .t.
   end if

   ::oViewEdit:getCodigoDireccion:Disable()

   ::oViewEdit:getNombreDireccion:cText( "" )

   codigoDireccion         := padr( codigoCliente, 12 ) + padr( codigoDireccion, 10 )

   nRec                    := ( D():ClientesDirecciones( ::nView ) )->( recno() )
   nOrdAnt                 := ( D():ClientesDirecciones( ::nView ) )->( ordsetfocus( "cCodCli" ) )

   if ( D():ClientesDirecciones( ::nView ) )->( dbseek( codigoDireccion ) )

      ::oViewEdit:getCodigoDireccion:cText( ( D():ClientesDirecciones( ::nView ) )->cCodObr )
      ::oViewEdit:getNombreDireccion:cText( ( D():ClientesDirecciones( ::nView ) )->cNomObr )

      lValid               := .t.

   else

      apoloMsgStop( "Dirección no encontrada" )
      
   end if

   ( D():ClientesDirecciones( ::nView ) )->( ordsetfocus( nOrdAnt ) )
   ( D():ClientesDirecciones( ::nView ) )->( dbgoto( nRec ) )

   ::oViewEdit:getCodigoDireccion:Enable()*/

RETURN lValid

//---------------------------------------------------------------------------//

METHOD lValidPayment() CLASS DocumentsSales

   local nRec
   local nOrdAnt
   local lValid            := .f.
   local codigoPayment     := hGet( ::hDictionaryMaster, "Pago" )

   if empty( codigoPayment )
      RETURN .f.
   end if

   ::oViewEditResumen:oCodigoFormaPago:Disable()
   ::oViewEditResumen:oNombreFormaPago:cText( "" )
   
   nRec                    := ( D():FormasPago( ::nView ) )->( Recno() )
   nOrdAnt                 := ( D():FormasPago( ::nView ) )->( ordsetfocus( "cCodPago" ) )

   if ( D():FormasPago( ::nView ) )->( dbSeek( codigoPayment ) )

      ::oViewEditResumen:oCodigoFormaPago:cText( ( D():FormasPago( ::nView ) )->cCodPago )
      ::oViewEditResumen:oNombreFormaPago:cText( ( D():FormasPago( ::nView ) )->cDesPago )

      lValid               := .t.

   else

      apoloMsgStop( "Forma de pago no encontrada" )
      
   end if

   ( D():FormasPago( ::nView ) )->( ordsetfocus( nOrdAnt ) )
   ( D():FormasPago( ::nView ) )->( dbgoto( nRec ) )

   ::oViewEditResumen:oCodigoFormaPago:Enable()

RETURN lValid

//---------------------------------------------------------------------------//

METHOD lValidCliente() CLASS DocumentsSales

   local lValid      := .t.
   local cNewCodCli  := hGet( ::hDictionaryMaster, "Cliente" )

   if empty( cNewCodCli )
      RETURN .t.
   else
      cNewCodCli     := Rjust( cNewCodCli, "0", RetNumCodCliEmp() )
   end if

   ::oViewEdit:getCodigoCliente:Disable()

   if !empty( ::oViewEdit:oGetEstablecimiento )
      ::oViewEdit:oGetEstablecimiento:cText( "" )
   end if

   if ::setClientToDocument( cNewCodCli )

      ::setAgentToDocument()

      ::oViewEdit:refreshCliente()
      ::oViewEdit:refreshSerie()

      lValid         := .t.

   else

      ApoloMsgStop( "Cliente no encontrado" )

      lValid         := .f.

   end if

   ::oViewEdit:getCodigoCliente:Enable()

RETURN lValid

//---------------------------------------------------------------------------//

METHOD ChangeRuta() CLASS DocumentsSales

   local cFilter
   local cCliente          := ""

   if !hhaskey( ::hOrdenRutas, alltrim( str( ::oViewEdit:oCbxRuta:nAt ) ) )
      RETURN ( cCliente )
   end if 

   cFilter                 := hget( ::hOrdenRutas, alltrim( str( ::oViewEdit:oCbxRuta:nAt ) ) )

   if ( accessCode():lFilterByAgent ) .and. !empty( accessCode():cAgente )
      cFilter              += " .and. cAgente = " + quoted( accessCode():cAgente )
   end if 

   ( D():Clientes( ::nView ) )->( adsSetAOF( cFilter ) )
   ( D():Clientes( ::nView ) )->( dbgotop() ) 

   if !( D():Clientes( ::nView ) )->( eof() )
      cCliente             := ( D():Clientes( ::nView ) )->Cod
   end if   

   if !empty( ::oViewEdit:getRuta )
      ::oViewEdit:getRuta:cText( alltrim( Str( ( D():Clientes( ::nView ) )->( ADSKeyNo( , , 1 ) ) ) ) + "/" + alltrim( str( ( D():Clientes( ::nView ) )->( ADSKeyCount( , , 1 ) ) ) ) )
      ::oViewEdit:getRuta:Refresh()
   end if

   if !empty( ::oViewEdit:getCodigoCliente )
      ::oViewEdit:getCodigoCliente:cText( cCliente )
      ::oViewEdit:getCodigoCliente:lValid()
   end if 

RETURN cCliente

//---------------------------------------------------------------------------//

METHOD moveClient( lAnterior ) CLASS DocumentsSales

   local lSet           := .f.

   if isTrue( lAnterior )
      ( D():Clientes( ::nView ) )->( dbSkip( -1 ) )
      lSet           := .t.
   end if 

   if isFalse( lAnterior )

      if ( D():Clientes( ::nView ) )->( ADSKeyNo( , , 1 ) ) < ( D():Clientes( ::nView ) )->( ADSKeyCount( , , 1 ) ) 
         ( D():Clientes( ::nView ) )->( dbSkip() )
      end if 
      
      lSet           := .t.

   end if   

   if isNil( lAnterior )
      lSet           := .t.
   end if 

   if !empty( ::oViewEdit:getRuta )
      ::oViewEdit:getRuta:cText( alltrim( str( ( D():Clientes( ::nView ) )->( ADSKeyNo( , , 1 ) ) ) ) + "/" + alltrim( str( ( D():Clientes( ::nView ) )->( ADSKeyCount( , , 1 ) ) ) ) )
      ::oViewEdit:getRuta:Refresh()
   end if

   if lSet

      ::oViewEdit:getCodigoCliente:cText( ( D():Clientes( ::nView ) )->Cod )
      ::oViewEdit:getCodigoCliente:lValid()

      //::oViewEdit:getCodigoDireccion:cText( Space( 10 ) )
      //::oViewEdit:getCodigoDireccion:lValid()

   end if

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD loadNextClient() CLASS DocumentsSales

   ::gotoUltimoCliente()

   if !hb_isnumeric( ::nUltimoCliente )
      RETURN ( self )
   end if 

   if ::nUltimoCliente != 0 
      ::nextClient()
   else
      ::moveClient()
   end if

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD gotoUltimoCliente() CLASS DocumentsSales

   if !empty( ::nUltimoCliente )
      ( D():Clientes( ::nView ) )->( dbgoto( ::nUltimoCliente ) )
   end if 

RETURN .t.

//---------------------------------------------------------------------------//

METHOD setUltimoCliente() CLASS DocumentsSales

   ::nUltimoCliente  := ( D():Clientes( ::nView ) )->( recno() )

RETURN nil

//---------------------------------------------------------------------------//

METHOD saveAppendDetail() CLASS DocumentsSales

   ::oDocumentLines:appendLineDetail( ::oDocumentLineTemporal )

   if !empty( ::oViewEdit:oBrowse )
      ::oViewEdit:oBrowse:Refresh()
   end if

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD saveEditDetail() CLASS DocumentsSales

   ::oDocumentLines:saveLineDetail( ::nPosDetail, ::oDocumentLineTemporal )

   if !empty( ::oViewEdit:oBrowse )
      ::oViewEdit:oBrowse:Refresh()
   end if

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD lValidResumenVenta() CLASS DocumentsSales

   local lReturn  := .t.
   
   // Comprobamos que el cliente no esté vacío-----------------------------------

   if empty( hGet( ::hDictionaryMaster, "Cliente" ) )
      ApoloMsgStop( "Cliente no puede estar vacío.", "¡Atención!" )
      RETURN .f.
   end if

   // Comprobamos que el documento tenga líneas----------------------------------

   if len( ::oDocumentLines:aLines ) <= 0
      ApoloMsgStop( "No puede almacenar un documento sin lineas.", "¡Atención!" )
      RETURN .f.
   end if

RETURN lReturn

//---------------------------------------------------------------------------//

METHOD onViewCancel()

   if ApoloMsgNoYes( "¿Desea terminar el proceso?", "¡Atención!", .t. )
      ::oViewEdit:oDlg:end()
   end if

RETURN ( self )

//---------------------------------------------------------------------------//  

METHOD onViewSave()

   ::oTotalDocument:Calculate()

   if ::isResumenVenta()

      ::setUltimoCliente()

      ::oViewEdit:oDlg:end( IDOK )

   end if 

RETURN ( self )

//---------------------------------------------------------------------------//  

METHOD isResumenVenta() CLASS DocumentsSales

   if !::lValidResumenVenta()
      RETURN .f.
   end if

   if empty( ::oViewEditResumen )
      RETURN .f.
   end if 

   ::oViewEditResumen:setTitleDocumento( ::getTextSummaryDocument() )

RETURN ( ::oViewEditResumen:Resource() )

//---------------------------------------------------------------------------//

METHOD isPrintDocument() CLASS DocumentsSales

   if empty( ::cFormatToPrint ) .or. alltrim( ::cFormatToPrint ) == "No imprimir"
      RETURN .f.
   end if

   ::cFormatToPrint  := left( ::cFormatToPrint, 3 )

   /*
   Refresca el número de indices----------------------------------------------
   */

   ( ::getDataTable() )->( OrdKeyCount() )

   ::printDocument()

   ::resetFormatToPrint()

RETURN( self )

//---------------------------------------------------------------------------//

METHOD saveEditDocumento() CLASS DocumentsSales 

   ::Super:saveEditDocumento()

   ::deleteLinesDocument()

   ::assignLinesDocument()   

   ::setLinesDocument()

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD saveAppendDocumento() CLASS DocumentsSales

   ::Super:saveAppendDocumento()

   ::assignLinesDocument()

   ::setLinesDocument()

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD assignLinesDocument() CLASS DocumentsSales

   local oDocumentLine
   local nNumeroLinea   := 0

   for each oDocumentLine in ::oDocumentLines:aLines
   
      nNumeroLinea++

      oDocumentLine:setNumeroLinea( nNumeroLinea )
      oDocumentLine:setPosicionImpresion( nNumeroLinea )
      
      oDocumentLine:setSerieMaster( ::hDictionaryMaster )
      oDocumentLine:setNumeroMaster( ::hDictionaryMaster )
      oDocumentLine:setSufijoMaster( ::hDictionaryMaster )

      oDocumentLine:setAlmacenMaster( ::hDictionaryMaster )

      oDocumentLine:setFechaMaster( ::hDictionaryMaster )
      oDocumentLine:setHoraMaster( ::hDictionaryMaster )

   next

RETURN( self )

//---------------------------------------------------------------------------//

METHOD setLinesDocument() CLASS DocumentsSales

   local oDocumentLine

   for each oDocumentLine in ::oDocumentLines:aLines

      ::appendDocumentLine( oDocumentLine )

   next

RETURN ( self ) 

//---------------------------------------------------------------------------//

METHOD onPreEnd() CLASS DocumentsSales
   
   ::isPrintDocument()
   
   ::oDocumentLines:reset() 

   ( ::getDataTable() )->( OrdSetFocus( ::nOrdenAnterior ) )

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD cComboRecargoValue() CLASS DocumentsSales

   local cComboRecargoValue

   if !empty( ::oViewEditResumen:aComboRecargo[1] )
      cComboRecargoValue    := ::oViewEditResumen:cComboRecargo[1]
   endif

RETURN ( ::oViewEditResumen:cComboRecargo  := cComboRecargoValue )

//---------------------------------------------------------------------------//

METHOD addDocumentLine() CLASS DocumentsSales

   local oDocumentLine  := ::getDocumentLine()

   if !empty( oDocumentLine )
      ::oDocumentLines:addLines( oDocumentLine )
   end if

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD setDatasInDictionaryMaster( NumeroDocumento ) CLASS DocumentsSales

   if !empty( NumeroDocumento )
      hSet( ::hDictionaryMaster, "Numero", NumeroDocumento )
   end if 

   ::oTotalDocument:Calculate()

   hSet( ::hDictionaryMaster, "Envio", .t. )  

   hSet( ::hDictionaryMaster, "FechaCreacion", date() )  
   hSet( ::hDictionaryMaster, "HoraCreacion", time() )  

   hSet( ::hDictionaryMaster, "TotalDocumento", ::oTotalDocument:getTotalDocument() )
   hSet( ::hDictionaryMaster, "TotalImpuesto", ::oTotalDocument:getImporteIva() )
   hSet( ::hDictionaryMaster, "TotalRecargo", ::oTotalDocument:getImporteRecargo() )
   hSet( ::hDictionaryMaster, "TotalNeto", ::oTotalDocument:getBase() )

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD GetEditDetail() CLASS DocumentsSales

   if !empty( ::nPosDetail )
      ::oDocumentLineTemporal   := ::oDocumentLines:getCloneLineDetail( ::nPosDetail )
   end if

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD setDocuments() CLASS DocumentsSales

   local cFormato
   local nFormato
   local cDocumento     := ""
   local aFormatos      := aDocs( ::getTypePrintDocuments(), D():Documentos( ::nView ), .t. )

   cFormato             := cFormatoDocumento( ::getSerie(), ::getCounterDocuments(), D():Contadores( ::nView ) )

   if empty( cFormato )
      cFormato          := cFirstDoc( ::getTypePrintDocuments(), D():Documentos( ::nView ) )
   end if

   nFormato             := aScan( aFormatos, {|x| Left( x, 3 ) == cFormato } )
   nFormato             := Max( Min( nFormato, len( aFormatos ) ), 1 )

   ::oViewEditResumen:SetImpresoras( aFormatos )
   ::oViewEditResumen:SetImpresoraDefecto( aFormatos[ nFormato ] )

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD Resource( nMode ) CLASS DocumentsSales

   local lResource   := .f.

   if !empty( ::oViewEdit )
      lResource      := ::oViewEdit:Resource( nMode )
   end if

RETURN ( lResource )   

//---------------------------------------------------------------------------//

METHOD onPreSaveAppend() CLASS DocumentsSales

   local numeroDocumento

   numeroDocumento               := nNewDoc( ::getSerie(), ::getWorkArea(), ::getCounterDocuments(), , D():Contadores( ::nView ) )
   
   if empty( numeroDocumento )
      RETURN ( .f. )
   end if 

RETURN ( ::setDatasInDictionaryMaster( numeroDocumento ) )

//---------------------------------------------------------------------------//

METHOD onPreSaveAppendDetail() CLASS DocumentsSales

   local oDocumentLine           := ::getDocumentLine()
   local cDescripcionArticulo    := alltrim( ::hGetDetail( "DescripcionArticulo" ) )

   oDocumentLine:setValue( "DescripcionAmpliada", cDescripcionArticulo )

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD onPostSaveAppendDetail() CLASS DocumentsSales

   ::oLinesDocumentsSales:onPostSaveAppendDetail()

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD onPreSaveEdit() CLASS DocumentsSales

   if ::oldSerie != ::getSerie()
      ::onPreSaveAppend()
   else
      ::setDatasInDictionaryMaster() 
   end if 

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD setAgentToDocument()

   local tabletAgent         := GetPvProfString( "Tablet", "Agente", "", cIniAplication() )

   if !empty( tabletAgent )
      hSet( ::hDictionaryMaster, "Agente", tabletAgent )
   end if 

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD setClientToDocument( CodigoCliente ) CLASS DocumentsSales

   local lRETURN           := .f.

   D():getStatusClientes( ::nView )

   ( D():Clientes( ::nView ) )->( ordsetfocus( 1 ) )
   if ( D():Clientes( ::nView ) )->( dbseek( CodigoCliente ) )

      lRETURN              := .t.

      hSet( ::hDictionaryMaster, "Cliente",              ( D():Clientes( ::nView ) )->Cod )
      hSet( ::hDictionaryMaster, "NombreCliente",        ( D():Clientes( ::nView ) )->Titulo )
      hSet( ::hDictionaryMaster, "DomicilioCliente",     ( D():Clientes( ::nView ) )->Domicilio )
      hSet( ::hDictionaryMaster, "PoblacionCliente",     ( D():Clientes( ::nView ) )->Poblacion )
      hSet( ::hDictionaryMaster, "ProvinciaCliente",     ( D():Clientes( ::nView ) )->Provincia )
      hSet( ::hDictionaryMaster, "CodigoPostalCliente",  ( D():Clientes( ::nView ) )->CodPostal )
      hSet( ::hDictionaryMaster, "TelefonoCliente",      ( D():Clientes( ::nView ) )->Telefono )
      hSet( ::hDictionaryMaster, "DniCliente",           ( D():Clientes( ::nView ) )->Nif )
      hSet( ::hDictionaryMaster, "GrupoCliente",         ( D():Clientes( ::nView ) )->Nif )
      hSet( ::hDictionaryMaster, "OperarPuntoVerde",     ( D():Clientes( ::nView ) )->lPntVer )

      if !empty( ::oViewEdit:oGetEstablecimiento )
         ::oViewEdit:oGetEstablecimiento:cText( ( D():Clientes( ::nView ) )->NbrEst )
         ::oViewEdit:oGetEstablecimiento:Refresh()
      end if

      if ::lAppendMode() 

         if !empty( ( D():Clientes( ::nView ) )->Serie )
            hSet( ::hDictionaryMaster, "Serie", ( D():Clientes( ::nView ) )->Serie )
         end if

         hSet( ::hDictionaryMaster, "Almacen",                       ( if( empty( oUser():cAlmacen() ), ( D():Clientes( ::nView ) )->cCodAlm, oUser():cAlmacen() ) ) )
         hSet( ::hDictionaryMaster, "Pago",                          ( if( empty( ( D():Clientes( ::nView ) )->CodPago ), cDefFpg(), ( D():Clientes( ::nView ) )->CodPago ) ) )

         hSet( ::hDictionaryMaster, "Agente",                        ( D():Clientes( ::nView ) )->cAgente )
         hSet( ::hDictionaryMaster, "TipoImpuesto",                  ( D():Clientes( ::nView ) )->nRegIva )
         hSet( ::hDictionaryMaster, "Tarifa",                        ( D():Clientes( ::nView ) )->cCodTar )
         hSet( ::hDictionaryMaster, "Ruta",                          ( D():Clientes( ::nView ) )->cCodRut )
         hSet( ::hDictionaryMaster, "NumeroTarifa",                  ( D():Clientes( ::nView ) )->nTarifa )
         hSet( ::hDictionaryMaster, "DescuentoTarifa",               ( D():Clientes( ::nView ) )->nDtoArt )
         hSet( ::hDictionaryMaster, "Transportista",                 ( D():Clientes( ::nView ) )->cCodTrn )
         hSet( ::hDictionaryMaster, "DescripcionDescuento1",         ( D():Clientes( ::nView ) )->cDtoEsp )
         hSet( ::hDictionaryMaster, "PorcentajeDescuento1",          ( D():Clientes( ::nView ) )->nDtoEsp )
         hSet( ::hDictionaryMaster, "DescripcionDescuento2",         ( D():Clientes( ::nView ) )->cDpp    )
         hSet( ::hDictionaryMaster, "PorcentajeDescuento2",          ( D():Clientes( ::nView ) )->nDpp    )
         hSet( ::hDictionaryMaster, "DescripcionDescuento3",         ( D():Clientes( ::nView ) )->cDtoUno )
         hSet( ::hDictionaryMaster, "PorcentajeDescuento3",          ( D():Clientes( ::nView ) )->nDtoCnt )
         hSet( ::hDictionaryMaster, "DescripcionDescuento4",         ( D():Clientes( ::nView ) )->cDtoDos )
         hSet( ::hDictionaryMaster, "PorcentajeDescuento4",          ( D():Clientes( ::nView ) )->nDtoRap )
         hSet( ::hDictionaryMaster, "DescuentoAtipico",              ( D():Clientes( ::nView ) )->nDtoAtp )
         hSet( ::hDictionaryMaster, "LugarAplicarDescuentoAtipico",  ( D():Clientes( ::nView ) )->nSbrAtp )
         hSet( ::hDictionaryMaster, "RecargoEquivalencia",           ( D():Clientes( ::nView ) )->lReq    )

      end if

   end if

   D():setStatusClientes( ::nView )

RETURN( lRETURN ) 

//---------------------------------------------------------------------------//

METHOD runGridPayment() CLASS DocumentsSales

   if ::lZoomMode()
      RETURN ( self )
   end if 

   ::oViewEditResumen:oCodigoFormaPago:Disable()

   if !empty( ::oPayment:oGridPayment )

      ::oPayment:oGridPayment:showView()

      if ::oPayment:oGridPayment:isEndOk()
         ::oViewEditResumen:SetGetValue( ( D():FormasPago( ::nView ) )->cCodPago, "Pago" )
      end if

      ::lValidPayment()

   end if

   ::oViewEditResumen:oCodigoFormaPago:Enable()

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD runGridCustomer() CLASS DocumentsSales

   local nOrdenAnterior
   local nRecnoAnterior
   local cFiltroAnterior

   if ::lZoomMode()
      RETURN ( self )
   end if

   nRecnoAnterior    := ( D():Clientes( ::nView ) )->( recno() )
   nOrdenAnterior    := ( D():Clientes( ::nView ) )->( ordsetfocus() )
   cFiltroAnterior   := ( D():Clientes( ::nView ) )->( adsgetaof() )

   ( D():Clientes( ::nView ) )->( adsclearaof() )
   ( D():Clientes( ::nView ) )->( dbgotop() )

   ::oViewEdit:getCodigoCliente:Disable()

   if !empty( ::oCliente:oGridCustomer )

      ::oCliente:oGridCustomer:showView()

      if ::oCliente:oGridCustomer:IsEndOk()
         ::oViewEdit:SetGetValue( ( D():Clientes( ::nView ) )->Cod, "Cliente" )
      end if

      ::lValidCliente()

   end if

   ::oViewEdit:getCodigoCliente:Enable()

   ( D():Clientes( ::nView ) )->( ordsetfocus( nOrdenAnterior ) )
   ( D():Clientes( ::nView ) )->( adssetaof( cFiltroAnterior ) )
   ( D():Clientes( ::nView ) )->( dbgoto( nRecnoAnterior ) )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD runGridDirections() CLASS DocumentsSales

   /*local codigoCliente     

   if ::lZoomMode()
      RETURN ( self )
   end if

   codigoCliente           := hGet( ::hDictionaryMaster, "Cliente" )

   if empty( codigoCliente )
      ApoloMsgStop( "No puede seleccionar una dirección con cliente vacío" )
      RETURN ( self )
   end if

   ::oViewEdit:getCodigoDireccion:Disable()

   if !empty( ::oDirections:oGridDirections )

      ::oDirections:setIdCustomer( codigoCliente )

      ::oDirections:putFilter()

      ::oDirections:oGridDirections:showView()

      if ::oDirections:oGridDirections:IsEndOk()
         ::oViewEdit:SetGetValue( ( D():ClientesDirecciones( ::nView ) )->cCodObr, "Direccion" )
      end if

      ::lValidDireccion()

      ::oDirections:quitFilter()

   end if

   ::oViewEdit:getCodigoDireccion:Enable()*/

RETURN ( self )

//---------------------------------------------------------------------------//