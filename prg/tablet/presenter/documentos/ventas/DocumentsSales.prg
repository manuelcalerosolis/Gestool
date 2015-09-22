#include "FiveWin.Ch"
#include "Factu.ch" 
 
CLASS DocumentsSales FROM Documents

   DATA oSender

   DATA oProduct
   DATA oPayment
   DATA oDirections

   DATA oViewEditResumen
   DATA oDocumentLines

   DATA nUltimoCliente

   DATA hTextDocuments                 INIT  {  "textMain"     => "Facturas de clientes",;
                                                "textShort"    => "Factura",;
                                                "textDetail"   => "lineas de facturas",;
                                                "textSummary"  => "Resumen factura" }
   
   DATA hOrdenRutas                    INIT  {  "1" => "lVisDom",;
                                                "2" => "lVisLun",;
                                                "3" => "lVisMar",;
                                                "4" => "lVisMie",;
                                                "5" => "lVisJue",;
                                                "6" => "lVisVie",;
                                                "7" => "lVisSab",;
                                                "8" => "Cod" }

   DATA cTextSummaryDocument           INIT ""
   DATA cTypePrintDocuments            INIT ""                                       
   DATA cCounterDocuments              INIT ""                                       

   DATA oTotalDocument


   METHOD New( oSender )
   METHOD runNavigator()

   METHOD hSetMaster( cField, uValue )    INLINE ( hSet( ::oSender:hDictionaryMaster, cField, uValue ) )
   METHOD hGetMaster( cField )            INLINE ( hGet( ::oSender:hDictionaryMaster, cField ) )

   METHOD hSetDetail( cField, uValue )    INLINE ( hSet( ::oSender:oDocumentLineTemporal:hDictionary, cField, uValue ) )
   METHOD hGetDetail( cField )            INLINE ( hGet( ::oSender:oDocumentLineTemporal:hDictionary, cField ) )

   METHOD setTextSummaryDocument( cTextSummaryDocument )    INLINE ( ::cTextSummaryDocument := cTextSummaryDocument )
   METHOD getTextSummaryDocument()                          INLINE ( if( hhaskey( ::hTextDocuments, "textSummary" ), hget( ::hTextDocuments, "textSummary"), ::cTextSummaryDocument ) )

   METHOD setTypePrintDocuments( cTypePrintDocuments )      INLINE ( ::cTypePrintDocuments := cTypePrintDocuments )
   METHOD getTypePrintDocuments()                           INLINE ( ::cTypePrintDocuments )

   METHOD setCounterDocuments( cCounterDocuments )          INLINE ( ::cCounterDocuments := cCounterDocuments )
   METHOD getCounterDocuments()                             INLINE ( ::cCounterDocuments )

   METHOD OpenFiles()
   METHOD CloseFiles()                 INLINE ( D():DeleteView( ::nView ) )

   METHOD getSerie()                   INLINE ( ::hGetMaster( "Serie" ) )
   METHOD getNumero()                  INLINE ( ::hGetMaster( "Numero" ) )
   METHOD getSufijo()                  INLINE ( ::hGetMaster( "Sufijo" ) )
   METHOD getAlmacen()                 INLINE ( ::hGetMaster( "Almacen" ) )

   METHOD getID()                      INLINE ( ::getSerie() + str( ::getNumero() ) + ::getSufijo() )

   METHOD isPuntoVerde()               INLINE ( ::hGetMaster( "OperarPuntoVerde" ) )
   METHOD isRecargoEquivalencia()      INLINE ( ::hGetMaster( "lRecargo" ) )

   METHOD onViewCancel()
   METHOD onViewSave()
   METHOD isResumenVenta()
   METHOD lValidResumenVenta()

   METHOD getDataBrowse( Name )                 INLINE ( hGet( ::oDocumentLineTemporal:hDictionary[ ::oViewEdit:oBrowse:nArrayAt ], Name ) )

   METHOD isChangeSerieTablet( lReadyToSend, getSerie )
   
   METHOD ChangeSerieTablet( getSerie )

   METHOD runGridCustomer()
   METHOD lValidCliente()

   METHOD runGridDirections()
   METHOD lValidDireccion()

   METHOD runGridPayment()
   METHOD lValidPayment()

   METHOD ChangeRuta()

   METHOD priorClient()
   METHOD nextClient()
   METHOD moveClient()

   METHOD CargaSiguienteCliente()
      METHOD gotoUltimoCliente( oCbxRuta )
      METHOD setUltimoCliente( oCbxRuta )

   METHOD Total()                                  INLINE ( ::oDocumentLines:Total() )
   METHOD calculaIVA()                             VIRTUAL

   METHOD saveAppendDetail()
   METHOD saveEditDetail()

   METHOD isPrintDocument()
   METHOD printDocument()                          VIRTUAL

   METHOD saveEditDocumento()
   METHOD saveAppendDocumento()

   // Lineas-------------------------------------------------------------------

   METHOD addDocumentLine()
      METHOD assignLinesDocument()
      METHOD setLinesDocument()
      METHOD appendDocumentLine( oDocumentLine )   INLINE ( D():appendHashRecord( oDocumentLine:hDictionary, ::getDataTableLine(), ::nView ) )
      METHOD delDocumentLine()                     INLINE ( D():deleteRecord( ::getDataTableLine(), ::nView ) )

   METHOD onPreSaveEdit()                          INLINE ( ::setDatasInDictionaryMaster() )
   METHOD onPreSaveAppend()
   METHOD onPreEnd()
      METHOD setDatasFromClientes()
      METHOD setDatasInDictionaryMaster( NumeroDocumento ) 

   METHOD onPreSaveAppendDetail()                  INLINE ( MSGaLERT( "onPreSaveAppendDetail DocumentsSales" ), .T. )

   METHOD cComboRecargoValue()

   METHOD onClickRotor()                           INLINE ( ::oCliente:EditCustomer( hGet( ::hDictionaryMaster, "Cliente" ) ) )

   METHOD getEditDetail() 
   
   METHOD setDocuments()
   
   METHOD Resource( nMode )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oSender ) CLASS DocumentsSales

   ::oSender               := oSender

   if !::OpenFiles()
      Return ( self )
   end if 

   ::oViewSearchNavigator  := DocumentSalesViewSearchNavigator():New( oSender )

   ::oViewEdit             := DocumentSalesViewEdit():New( oSender )

   ::oCliente              := Customer():init( oSender )  

   ::oProduct              := Product():init( oSender )

   ::oPayment              := Payment():init( oSender )

   ::oDirections           := Directions():init( oSender )

   ::oDocumentLines        := DocumentLines():New( oSender ) 

   ::oTotalDocument        := TotalDocument():New( oSender )

return ( self )

//---------------------------------------------------------------------------//

METHOD runNavigator() CLASS DocumentsSales

   if !empty( ::oViewSearchNavigator )
      ::oViewSearchNavigator:Resource()
   end if

   ::CloseFiles()

return ( self )

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

      D():FacturasClientes( ::nView )

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

      D():TiposIncidencias( ::nView )

   RECOVER USING oError

      lOpenFiles     := .f.

      ApoloMsgStop( "Imposible abrir todas las bases de datos" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   if !lOpenFiles
      ::CloseFiles( "" )
   end if

Return ( lOpenFiles )

//---------------------------------------------------------------------------//

METHOD isChangeSerieTablet( getSerie ) CLASS DocumentsSales
   
   if hGet( ::hDictionaryMaster, "Envio" )
      ::ChangeSerieTablet( getSerie )
   end if

Return ( self )

//---------------------------------------------------------------------------//

METHOD ChangeSerieTablet( getSerie ) CLASS DocumentsSales

   local cSerie   := getSerie:VarGet()

   do case
      case cSerie == "A"
         getSerie:cText( "B" )

      case cSerie == "B"
         getSerie:cText( "A" )

      otherwise
         getSerie:cText( "A" )

   end case

Return ( self )

//---------------------------------------------------------------------------//

METHOD lValidDireccion() CLASS DocumentsSales

   local nRec
   local nOrdAnt
   local lValid            := .f.
   local codigoCliente     := hGet( ::hDictionaryMaster, "Cliente" )
   local codigoDireccion   := ::oViewEdit:getCodigoDireccion:varGet()

   if Empty( codigoCliente )
      return .t.
   end if

   if empty( codigoDireccion )
      return .t.
   end if

   ::oViewEdit:getCodigoDireccion:Disable()

   ::oViewEdit:getNombreDireccion:cText( "" )

   codigoDireccion         := padr( codigoCliente, 12 ) + padr( codigoDireccion, 10 )

   nRec                    := ( D():ClientesDirecciones( ::nView ) )->( Recno() )
   nOrdAnt                 := ( D():ClientesDirecciones( ::nView ) )->( OrdSetFocus( "cCodCli" ) )

   if ( D():ClientesDirecciones( ::nView ) )->( dbSeek( codigoDireccion ) )

      ::oViewEdit:getCodigoDireccion:cText( ( D():ClientesDirecciones( ::nView ) )->cCodObr )
      ::oViewEdit:getNombreDireccion:cText( ( D():ClientesDirecciones( ::nView ) )->cNomObr )

      lValid               := .t.

   else

      apoloMsgStop( "Dirección no encontrada" )
      
   end if

   ( D():ClientesDirecciones( ::nView ) )->( OrdSetFocus( nOrdAnt ) )
   ( D():ClientesDirecciones( ::nView ) )->( dbGoTo( nRec ) )

   ::oViewEdit:getCodigoDireccion:Enable()

Return lValid

//---------------------------------------------------------------------------//

METHOD lValidPayment() CLASS DocumentsSales

   local nRec
   local nOrdAnt
   local lValid            := .f.
   local codigoPayment     := hGet( ::hDictionaryMaster, "Pago" )

   if Empty( codigoPayment )
      return .f.
   end if

   ::oViewEditResumen:oCodigoFormaPago:Disable()

   ::oViewEditResumen:oNombreFormaPago:cText( "" )
   
   nRec                    := ( D():FormasPago( ::nView ) )->( Recno() )
   nOrdAnt                 := ( D():FormasPago( ::nView ) )->( OrdSetFocus( "cCodPago" ) )

   if ( D():FormasPago( ::nView ) )->( dbSeek( codigoPayment ) )

      ::oViewEditResumen:oCodigoFormaPago:cText( ( D():FormasPago( ::nView ) )->cCodPago )
      ::oViewEditResumen:oNombreFormaPago:cText( ( D():FormasPago( ::nView ) )->cDesPago )

      lValid               := .t.

   else

      apoloMsgStop( "Forma de pago no encontrada" )
      
   end if

   ( D():FormasPago( ::nView ) )->( OrdSetFocus( nOrdAnt ) )
   ( D():FormasPago( ::nView ) )->( dbGoTo( nRec ) )

   ::oViewEditResumen:oCodigoFormaPago:Enable()

Return lValid

//---------------------------------------------------------------------------//

METHOD lValidCliente() CLASS DocumentsSales

   local lValid      := .t.
   local cNewCodCli  := hGet( ::hDictionaryMaster, "Cliente" )

   if Empty( cNewCodCli )
      Return .t.
   else
      cNewCodCli     := Rjust( cNewCodCli, "0", RetNumCodCliEmp() )
   end if

   ::oViewEdit:oGetCliente:Disable()

   if !Empty( ::oViewEdit:getCodigoDireccion )
      ::oViewEdit:getCodigoDireccion:cText( "" )
   end if

   if !Empty( ::oViewEdit:getNombreDireccion )
      ::oViewEdit:getNombreDireccion:cText( "" )
   end if

   if ::setDatasFromClientes( cNewCodCli )

      ::oViewEdit:refreshCliente()
      ::oViewEdit:refreshSerie()

      lValid         := .t.

   else

      ApoloMsgStop( "Cliente no encontrado" )

      lValid         := .f.

   end if

   ::oViewEdit:oGetCliente:Enable()

RETURN lValid

//---------------------------------------------------------------------------//

METHOD ChangeRuta( oCbxRuta, oGetCliente, oGetDireccion, oSayTextRuta ) CLASS DocumentsSales

   local cCliente          := ""
   local nOrdAnt           := ( D():Clientes( ::nView ) )->( OrdSetFocus() )

   if hhaskey( ::hOrdenRutas, AllTrim( Str( oCbxRuta:nAt ) ) )

      nOrdAnt              := ( D():Clientes( ::nView ) )->( OrdSetFocus( ::hOrdenRutas[ AllTrim( Str( oCbxRuta:nAt ) ) ] ) )

      if ( D():Clientes( ::nView ) )->( OrdKeyCount() ) != 0 
         
         ( D():Clientes( ::nView ) )->( dbGoTop() )
         if !( D():Clientes( ::nView ) )->( Eof() )
            cCliente       := ( D():Clientes( ::nView ) )->Cod
         end if   

         if !Empty( oSayTextRuta )
            oSayTextRuta:cText( AllTrim( Str( ( D():Clientes( ::nView ) )->( OrdKeyNo() ) ) ) + "/" + AllTrim( Str( ( D():Clientes( ::nView ) )->( OrdKeyCount() ) ) ) )
            oSayTextRuta:Refresh()
         end if

      else

         ( D():Clientes( ::nView ) )->( OrdSetFocus( "Cod" ) )
         ( D():Clientes( ::nView ) )->( dbGoTop() )

         cCliente             := ( D():Clientes( ::nView ) )->Cod

         if !Empty( oSayTextRuta )
            oSayTextRuta:cText( "1/1" )
            oSayTextRuta:Refresh()
         end if
      
      end if   

      ( D():Clientes( ::nView ) )->( OrdSetFocus( nOrdAnt ) )

   end if

   if !Empty( oGetCliente )
      oGetCliente:cText( cCliente )
      oGetCliente:Refresh()
      oGetCliente:lValid()
   end if 

   if !Empty( oGetDireccion )
      oGetDireccion:cText( Space( 10 ) )
      oGetDireccion:Refresh()
      oGetDireccion:lValid()
   end if   

return cCliente

//---------------------------------------------------------------------------//

METHOD priorClient( oCbxRuta, oSayTextRuta, oGetCliente, oGetDireccion ) CLASS DocumentsSales

return ( ::moveClient( oCbxRuta, oSayTextRuta, oGetCliente, oGetDireccion, .t. ) )

//---------------------------------------------------------------------------//

METHOD nextClient( oCbxRuta, oSayTextRuta, oGetCliente, oGetDireccion ) CLASS DocumentsSales

return ( ::moveClient( oCbxRuta, oSayTextRuta, oGetCliente, oGetDireccion, .f. ) )

//---------------------------------------------------------------------------//

METHOD moveClient( oCbxRuta, oSayTextRuta, oGetCliente, oGetDireccion, lAnterior ) CLASS DocumentsSales

   local lSet              := .f.
   local nOrdAnt

   if hhaskey( ::hOrdenRutas, AllTrim( Str( oCbxRuta:nAt ) ) )
      
      nOrdAnt              := ( D():Clientes( ::nView ) )->( OrdSetFocus( ::hOrdenRutas[ AllTrim( Str( oCbxRuta:nAt ) ) ] ) )

      if isTrue( lAnterior )

         if ( D():Clientes( ::nView ) )->( OrdKeyNo() ) != 1
            ( D():Clientes( ::nView ) )->( dbSkip( -1 ) )
            lSet           := .t.
         end if

      end if 

      if isFalse( lAnterior )

         if ( D():Clientes( ::nView ) )->( OrdKeyNo() ) != ( D():Clientes( ::nView ) )->( OrdKeyCount() )
            ( D():Clientes( ::nView ) )->( dbSkip() )
            lSet           := .t.
         end if

      end if   

      if isNil( lAnterior )
         lSet              := .t.
      end if 

      if !empty( oSayTextRuta )
         oSayTextRuta:cText( alltrim( str( ( D():Clientes( ::nView ) )->( OrdKeyNo() ) ) ) + "/" + alltrim( str( ( D():Clientes( ::nView ) )->( OrdKeyCount() ) ) ) )
         oSayTextRuta:Refresh()
      end if

      ( D():Clientes( ::nView ) )->( OrdSetFocus( nOrdAnt ) )   

      if lSet

         oGetCliente:cText( ( D():Clientes( ::nView ) )->Cod )
         oGetCliente:lValid()

         hSet( ::hDictionaryMaster, "Direccion", Space( 10 ) )
         oGetDireccion:lValid()

      end if

   end if

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD CargaSiguienteCliente( oCbxRuta, oSayTextRuta, oGetCliente, oGetDireccion, nMode ) CLASS DocumentsSales

   ::gotoUltimoCliente( oCbxRuta )

   if ( nMode == APPD_MODE ) .and. ( ::nUltimoCliente != 0 )
      ::nextClient( oCbxRuta, oSayTextRuta, oGetCliente, oGetDireccion )
   else
      ::moveClient( oCbxRuta, oSayTextRuta, oGetCliente, oGetDireccion )
   end if

Return ( self )

//---------------------------------------------------------------------------//

METHOD gotoUltimoCliente( oCbxRuta ) CLASS DocumentsSales

   local nOrdAnt     := ( D():Clientes( ::nView ) )->( OrdSetFocus( ::hOrdenRutas[ AllTrim( Str( oCbxRuta:nAt ) ) ] ) )

   if empty( ::nUltimoCliente )
      ( D():Clientes( ::nView ) )->( dbGoTop() )
   else
      ( D():Clientes( ::nView ) )->( OrdKeyGoto( ::nUltimoCliente ) )
   end if 

   ( D():Clientes( ::nView ) )->( OrdSetFocus( nOrdAnt ) ) 
         
Return .t.

//---------------------------------------------------------------------------//

METHOD setUltimoCliente( oCbxRuta ) CLASS DocumentsSales

   local nOrdAnt     := ( D():Clientes( ::nView ) )->( OrdSetFocus( ::hOrdenRutas[ AllTrim( Str( oCbxRuta:nAt ) ) ] ) )

   ::nUltimoCliente  := ( D():Clientes( ::nView ) )->( OrdKeyNo() )

   ( D():Clientes( ::nView ) )->( OrdSetFocus( nOrdAnt ) ) 

Return nil

//---------------------------------------------------------------------------//

METHOD saveAppendDetail() CLASS DocumentsSales

   ::oDocumentLines:appendLineDetail( ::oDocumentLineTemporal )

   if !Empty( ::oViewEdit:oBrowse )
      ::oViewEdit:oBrowse:Refresh()
   end if

Return ( self )

//---------------------------------------------------------------------------//

METHOD saveEditDetail() CLASS DocumentsSales

   ::oDocumentLines:saveLineDetail( ::nPosDetail, ::oDocumentLineTemporal )

   if !Empty( ::oViewEdit:oBrowse )
      ::oViewEdit:oBrowse:Refresh()
   end if

Return ( self )

//---------------------------------------------------------------------------//

METHOD lValidResumenVenta() CLASS DocumentsSales

   local lReturn  := .t.
   
   /*
   Comprobamos que el cliente no esté vacío-----------------------------------
   */

   if Empty( hGet( ::hDictionaryMaster, "Cliente" ) )
      ApoloMsgStop( "Cliente no puede estar vacío.", "¡Atención!" )
      return .f.
   end if

   /*
   Comprobamos que el documento tenga líneas----------------------------------
   */

   if len( ::oDocumentLines:aLines ) <= 0
      ApoloMsgStop( "No puede almacenar un documento sin lineas.", "¡Atención!" )
      return .f.
   end if

Return lReturn

//---------------------------------------------------------------------------//

METHOD onViewCancel()

   ::oViewEdit:oDlg:end( )

Return ( self )

//---------------------------------------------------------------------------//  

METHOD onViewSave()

   ::oTotalDocument:Calculate()

   if ::isResumenVenta()

      ::setUltimoCliente( ::oViewEdit:oCbxRuta )

      ::oViewEdit:oDlg:end( IDOK )

   end if 

Return ( self )

//---------------------------------------------------------------------------//  

METHOD isResumenVenta() CLASS DocumentsSales

   if !::lValidResumenVenta()
      Return .f.
   end if

   ::oViewEditResumen            := ViewEditResumen():New( self )

   if Empty( ::oViewEditResumen )
      Return .f.
   end if 

   ::oViewEditResumen:setTitle( ::getTextSummaryDocument() )

Return ( ::oViewEditResumen:Resource() )

//---------------------------------------------------------------------------//

METHOD isPrintDocument() CLASS DocumentsSales

   if empty( ::cFormatToPrint ) .or. alltrim( ::cFormatToPrint ) == "No imprimir"
      Return .f.
   end if

   ::cFormatToPrint  := left( ::cFormatToPrint, 3 )

   ::printDocument()

   ::resetFormatToPrint()

Return( self )

//---------------------------------------------------------------------------//

/*METHOD printDocument() CLASS DocumentsSales

   ?"entro en printDocument"

   visualizaPedidoCliente( ::getID(), ::cFormatToPrint )

Return ( .t. )*/

//---------------------------------------------------------------------------//


METHOD saveEditDocumento() CLASS DocumentsSales            

   ::Super:saveEditDocumento()

   ::deleteLinesDocument()

   ::assignLinesDocument()   

   ::setLinesDocument()

return ( .t. )

//---------------------------------------------------------------------------//

METHOD saveAppendDocumento() CLASS DocumentsSales

   ::Super:saveAppendDocumento()

   ::assignLinesDocument()

   ::setLinesDocument()

return ( .t. )

//---------------------------------------------------------------------------//

METHOD assignLinesDocument() CLASS DocumentsSales

   local oDocumentLine
   Local nNumeroLinea   := 0

   for each oDocumentLine in ::oDocumentLines:aLines
      oDocumentLine:setNumeroLinea( ++nNumeroLinea )
      oDocumentLine:setSerieMaster()
      oDocumentLine:setNumeroMaster()
      oDocumentLine:setSufijoMaster()
      oDocumentLine:setAlmacenMaster()
   next

Return( self )

//---------------------------------------------------------------------------//

METHOD setLinesDocument() CLASS DocumentsSales

   local oDocumentLine

   for each oDocumentLine in ::oDocumentLines:aLines
      ::appendDocumentLine( oDocumentLine )
   next

RETURN ( self ) 

//---------------------------------------------------------------------------//

METHOD onPreEnd() CLASS DocumentsSales
   
   Local lPostSaveEditDocumento  := .t.

   ::oDocumentLines:reset() 

   ::isPrintDocument()

Return( lPostSaveEditDocumento )

//---------------------------------------------------------------------------//

METHOD cComboRecargoValue() CLASS DocumentsSales

   Local cComboRecargoValue

   // hGet( ::oSender:hDictionaryMaster, "Pago" )

   if !empty( ::oViewEditResumen:aComboRecargo[1] )
      cComboRecargoValue    := ::oViewEditResumen:cComboRecargo[1]
   endif

Return( ::oViewEditResumen:cComboRecargo  := cComboRecargoValue )

//---------------------------------------------------------------------------//

METHOD addDocumentLine() CLASS DocumentsSales

   local oDocumentLine  := ::getDocumentLine()

   if !empty( oDocumentLine )
      ::oDocumentLines:addLines( oDocumentLine )
   end if

Return ( self )

//---------------------------------------------------------------------------//

METHOD setDatasInDictionaryMaster( NumeroDocumento ) CLASS DocumentsSales

   if !empty( NumeroDocumento )
      hSet( ::hDictionaryMaster, "Numero", NumeroDocumento )
   end if 

   hSet( ::hDictionaryMaster, "TotalDocumento", ::oTotalDocument:getTotalDocument() )

   hSet( ::hDictionaryMaster, "TotalImpuesto", ::oTotalDocument:getImporteIva() )

   hSet( ::hDictionaryMaster, "TotalRecargo", ::oTotalDocument:getImporteRecargo() )

   hSet( ::hDictionaryMaster, "TotalNeto", ::oTotalDocument:getBase() )

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD GetEditDetail() CLASS DocumentsSales

   if !Empty( ::nPosDetail )
      ::oDocumentLineTemporal   := ::oDocumentLines:getCloneLineDetail( ::nPosDetail )
   end if

Return ( self )

//---------------------------------------------------------------------------//

METHOD setDocuments() CLASS DocumentsSales

   local cDocumento     := ""
   local cFormato
   local nFormato
   local aFormatos      := aDocs( ::getTypePrintDocuments(), D():Documentos( ::nView ), .t. )

   cFormato             := cFormatoDocumento( ::getSerie(), ::getCounterDocuments(), D():Contadores( ::nView ) )

   if Empty( cFormato )
      cFormato          := cFirstDoc( ::getTypePrintDocuments(), D():Documentos( ::nView ) )
   end if

   nFormato             := aScan( aFormatos, {|x| Left( x, 3 ) == cFormato } )
   nFormato             := Max( Min( nFormato, len( aFormatos ) ), 1 )

   ::oViewEditResumen:SetImpresoras( aFormatos )
   ::oViewEditResumen:SetImpresoraDefecto( aFormatos[ nFormato ] )

return ( .t. )

//---------------------------------------------------------------------------//

METHOD Resource( nMode ) CLASS DocumentsSales

   local lResource   := .f.

   if !Empty( ::oViewEdit )
      lResource      := ::oViewEdit:Resource( nMode )
   end if

Return ( lResource )   

//---------------------------------------------------------------------------//

METHOD onPreSaveAppend() CLASS DocumentsSales

   Local NumeroDocumento   := nNewDoc( ::getSerie(), ::getWorkArea(), ::getCounterDocuments(), , D():Contadores( ::nView ) )
   
   if empty( NumeroDocumento )
      Return ( .f. )
   end if 

Return ( ::setDatasInDictionaryMaster( NumeroDocumento ) )

//---------------------------------------------------------------------------//

METHOD setDatasFromClientes( CodigoCliente ) CLASS DocumentsSales

   Local lReturn           := .f.
   local AgenteIni         := GetPvProfString( "Tablet", "Agente", "", FullCurDir() + "GstApolo.Ini" )

   D():getStatusClientes( ::nView )

   ( D():Clientes( ::nView ) )->( ordSetFocus( 1 ) )

   if ( D():Clientes( ::nView ) )->( dbseek( CodigoCliente ) )

      lReturn              := .t.

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

      if ::lAppendMode() 

         if !empty( ( D():Clientes( ::nView ) )->Serie )
            hSet( ::hDictionaryMaster, "Serie", ( D():Clientes( ::nView ) )->Serie )
         end if

         hSet( ::hDictionaryMaster, "TipoImpuesto",                  ( D():Clientes( ::nView ) )->nRegIva )
         hSet( ::hDictionaryMaster, "Almacen",                       ( D():Clientes( ::nView ) )->cCodAlm )
         hSet( ::hDictionaryMaster, "Tarifa",                        ( D():Clientes( ::nView ) )->cCodTar )
         hSet( ::hDictionaryMaster, "Pago",                          ( if( empty( ( D():Clientes( ::nView ) )->CodPago ), cDefFpg(), ( D():Clientes( ::nView ) )->CodPago ) ) )
         hSet( ::hDictionaryMaster, "Agente",                        ( if( empty( AgenteIni ), ( D():Clientes( ::nView ) )->cAgente, AgenteIni ) ) )
         hSet( ::hDictionaryMaster, "Ruta",                          ( D():Clientes( ::nView ) )->cCodRut )
         hSet( ::hDictionaryMaster, "NumeroTarifa",                  ( D():Clientes( ::nView ) )->nTarifa )
         hSet( ::hDictionaryMaster, "DescuentoTarifa",               ( D():Clientes( ::nView ) )->nDtoArt )
         hSet( ::hDictionaryMaster, "Transportista",                 ( D():Clientes( ::nView ) )->cCodTrn )
         hSet( ::hDictionaryMaster, "DescripcionDescuento1",         ( D():Clientes( ::nView ) )->cDtoEsp )
         hSet( ::hDictionaryMaster, "PorcentajeDescuento1",          ( D():Clientes( ::nView ) )->nDtoEsp )
         hSet( ::hDictionaryMaster, "DescripcionDescuento2",         ( D():Clientes( ::nView ) )->cDpp )
         hSet( ::hDictionaryMaster, "PorcentajeDescuento2",          ( D():Clientes( ::nView ) )->nDpp )
         hSet( ::hDictionaryMaster, "DescripcionDescuento3",         ( D():Clientes( ::nView ) )->cDtoUno )
         hSet( ::hDictionaryMaster, "PorcentajeDescuento3",          ( D():Clientes( ::nView ) )->nDtoCnt )
         hSet( ::hDictionaryMaster, "DescripcionDescuento4",         ( D():Clientes( ::nView ) )->cDtoDos )
         hSet( ::hDictionaryMaster, "PorcentajeDescuento4",          ( D():Clientes( ::nView ) )->nDtoRap )
         hSet( ::hDictionaryMaster, "DescuentoAtipico",              ( D():Clientes( ::nView ) )->nDtoAtp )
         hSet( ::hDictionaryMaster, "LugarAplicarDescuentoAtipico",  ( D():Clientes( ::nView ) )->nSbrAtp )
         hSet( ::hDictionaryMaster, "RecargoEquivalencia",           ( D():Clientes( ::nView ) )->lReq )

      end if

   end if

   D():setStatusClientes( ::nView )

Return( lReturn ) 

//---------------------------------------------------------------------------//

METHOD runGridPayment() CLASS DocumentsSales

   ::oViewEditResumen:oCodigoFormaPago:Disable()

   if !Empty( ::oPayment:oGridPayment )

      ::oPayment:oGridPayment:showView()

      if ::oPayment:oGridPayment:isEndOk()
         ::oViewEditResumen:SetGetValue( ( D():FormasPago( ::nView ) )->cCodPago, "Pago" )
      end if

      ::lValidPayment()

   end if

   ::oViewEditResumen:oCodigoFormaPago:Enable()

Return ( self )

//---------------------------------------------------------------------------//

METHOD runGridCustomer() CLASS DocumentsSales

   ::oViewEdit:oGetCliente:Disable()

   if !Empty( ::oCliente:oGridCustomer )

      ::oCliente:oGridCustomer:showView()

      if ::oCliente:oGridCustomer:IsEndOk()
         ::oViewEdit:SetGetValue( ( D():Clientes( ::nView ) )->Cod, "Cliente" )
      end if

      ::lValidCliente()

   end if

   ::oViewEdit:oGetCliente:Enable()

Return ( self )

//---------------------------------------------------------------------------//

METHOD runGridDirections() CLASS DocumentsSales

   local codigoCliente     := hGet( ::hDictionaryMaster, "Cliente" )

   if Empty( codigoCliente )
      ApoloMsgStop( "No puede seleccionar una dirección con cliente vacío" )
      Return ( self )
   end if

   ::oViewEdit:getCodigoDireccion:Disable()

   if !Empty( ::oDirections:oGridDirections )

      ::oDirections:setIdCustomer( codigoCliente )

      ::oDirections:putFilter()

      ::oDirections:oGridDirections:showView()

      if ::oDirections:oGridDirections:IsEndOk()
         ::oViewEdit:SetGetValue( ( D():ClientesDirecciones( ::nView ) )->cCodObr, "Direccion" )
      end if

      ::lValidDireccion()

      ::oDirections:quitFilter()

   end if

   ::oViewEdit:getCodigoDireccion:Enable()

Return ( self )

//---------------------------------------------------------------------------//

