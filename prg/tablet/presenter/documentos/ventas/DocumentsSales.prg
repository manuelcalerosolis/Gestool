#include "FiveWin.Ch"
#include "Factu.ch" 
 
CLASS DocumentsSales FROM Documents

   DATA nMode

   DATA oViewEdit
   DATA oViewEditResumen

   
   DATA nUltimoCliente
   
   DATA hOrdenRutas                 INIT {   "1" => "lVisDom",;
                                             "2" => "lVisLun",;
                                             "3" => "lVisMar",;
                                             "4" => "lVisMie",;
                                             "5" => "lVisJue",;
                                             "6" => "lVisVie",;
                                             "7" => "lVisSab",;
                                             "8" => "Cod" }


   DATA oTotalDocument

   METHOD OpenFiles()
   METHOD CloseFiles()              INLINE ( D():DeleteView( ::nView ) )

   METHOD onViewCancel()
   METHOD onViewSave()
   METHOD isResumenVenta()
   METHOD lValidResumenVenta()

   METHOD getDataBrowse( Name )     INLINE ( hGet( ::oDocumentLineTemporal:hDictionary[ ::oViewEdit:oBrowse:nArrayAt ], Name ) )

   METHOD isChangeSerieTablet( lReadyToSend, getSerie )
   
   METHOD ChangeSerieTablet( getSerie )

   METHOD lValidCliente()

   METHOD lValidDireccion()

   METHOD ChangeRuta()

   METHOD priorClient()
   METHOD nextClient()
   METHOD moveClient()

   METHOD CargaSiguienteCliente()

   METHOD gotoUltimoCliente( oCbxRuta )
   METHOD setUltimoCliente( oCbxRuta )

   METHOD Total()                      INLINE ( ::oDocumentLines:Total() )

   METHOD calculaIVA()                 VIRTUAL

   METHOD AppendGuardaLinea()
   METHOD EditGuardaLinea()

   METHOD SetDocuments()                             VIRTUAL

   METHOD isPrintDocument()
   METHOD printDocument()

END CLASS

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

METHOD lValidCliente( oGet, oGet2, nMode ) CLASS DocumentsSales

   local lValid      := .t.
   local cNewCodCli  := hGet( ::hDictionaryMaster, "Cliente" )

   if Empty( cNewCodCli )
      Return .t.
   else
      cNewCodCli     := Rjust( cNewCodCli, "0", RetNumCodCliEmp() )
   end if

   if ( D():Clientes( ::nView ) )->( dbSeek( cNewCodCli ) )

      hSet( ::hDictionaryMaster, "Cliente", cNewCodCli )
      hSet( ::hDictionaryMaster, "NombreCliente", ( D():Clientes( ::nView ) )->Titulo )
      hSet( ::hDictionaryMaster, "DomicilioCliente", ( D():Clientes( ::nView ) )->Domicilio )
      hSet( ::hDictionaryMaster, "PoblacionCliente", ( D():Clientes( ::nView ) )->Poblacion )
      hSet( ::hDictionaryMaster, "ProvinciaCliente", ( D():Clientes( ::nView ) )->Provincia )
      hSet( ::hDictionaryMaster, "CodigoPostalCliente", ( D():Clientes( ::nView ) )->CodPostal )
      hSet( ::hDictionaryMaster, "TelefonoCliente", ( D():Clientes( ::nView ) )->Telefono )
      hSet( ::hDictionaryMaster, "DniCliente", ( D():Clientes( ::nView ) )->Nif )
      hSet( ::hDictionaryMaster, "GrupoCliente", ( D():Clientes( ::nView ) )->Nif )
      hSet( ::hDictionaryMaster, "ModificarDatOperarPuntoVerdeGrupoCliente", ( D():Clientes( ::nView ) )->lPntVer )

      if nMode == APPD_MODE

         if !Empty( ( D():Clientes( ::nView ) )->Serie )
            hSet( ::hDictionaryMaster, "Serie", ( D():Clientes( ::nView ) )->Serie )
         end if

         hSet( ::hDictionaryMaster, "TipoImpuesto", ( D():Clientes( ::nView ) )->nRegIva )
         hSet( ::hDictionaryMaster, "Almacen", ( D():Clientes( ::nView ) )->cCodAlm )
         hSet( ::hDictionaryMaster, "Tarifa", ( D():Clientes( ::nView ) )->cCodTar )
         hSet( ::hDictionaryMaster, "Pago", ( D():Clientes( ::nView ) )->CodPago )
         hSet( ::hDictionaryMaster, "Agente", ( D():Clientes( ::nView ) )->cAgente )
         hSet( ::hDictionaryMaster, "Ruta", ( D():Clientes( ::nView ) )->cCodRut )
         hSet( ::hDictionaryMaster, "TarifaAplicar", ( D():Clientes( ::nView ) )->nTarifa )
         hSet( ::hDictionaryMaster, "DescuentoTarifa", ( D():Clientes( ::nView ) )->nDtoArt )
         hSet( ::hDictionaryMaster, "Transportista", ( D():Clientes( ::nView ) )->cCodTrn )
         hSet( ::hDictionaryMaster, "DescripcionDescuento1", ( D():Clientes( ::nView ) )->cDtoEsp )
         hSet( ::hDictionaryMaster, "PorcentajeDescuento1", ( D():Clientes( ::nView ) )->nDtoEsp )
         hSet( ::hDictionaryMaster, "DescripcionDescuento2", ( D():Clientes( ::nView ) )->cDpp )
         hSet( ::hDictionaryMaster, "PorcentajeDescuento2", ( D():Clientes( ::nView ) )->nDpp )
         hSet( ::hDictionaryMaster, "DescripcionDescuento3", ( D():Clientes( ::nView ) )->cDtoUno )
         hSet( ::hDictionaryMaster, "PorcentajeDescuento3", ( D():Clientes( ::nView ) )->nDtoCnt )
         hSet( ::hDictionaryMaster, "DescripcionDescuento4", ( D():Clientes( ::nView ) )->cDtoDos )
         hSet( ::hDictionaryMaster, "PorcentajeDescuento4", ( D():Clientes( ::nView ) )->nDtoRap )
         hSet( ::hDictionaryMaster, "DescuentoAtipico", ( D():Clientes( ::nView ) )->nDtoAtp )
         hSet( ::hDictionaryMaster, "LugarAplicarDescuentoAtipico", ( D():Clientes( ::nView ) )->nSbrAtp )

      end if

      if !Empty( oGet )
         oGet:Refresh()
      end if

      if !Empty( oGet2 )
         oGet2:Refresh()
      end if

      lValid      := .t.

   else

      ApoloMsgStop( "Cliente no encontrado" )
      lValid := .f.

   end if

RETURN lValid

//---------------------------------------------------------------------------//

METHOD lValidDireccion( oGet, oGet2, cCodCli ) CLASS DocumentsSales

   local lValid   := .f.
   local xValor   := oGet:VarGet()
   local nOrdAnt

   if Empty( xValor )
      if !Empty( oGet2 )
         oGet2:cText( "" )
      end if
      return .t.
   end if

   if Empty( cCodCli )
      ApoloMsgStop( "Es necesario codificar un cliente" )
      return .t.
   end if

   nOrdAnt        := ( D():ClientesDirecciones( ::nView ) )->( OrdSetFocus( "cCodCli" ) )

   xValor         := Padr( cCodCli, 12 ) + xValor

   if ( D():ClientesDirecciones( ::nView ) )->( dbSeek( xValor ) )

      oGet:cText( ( D():ClientesDirecciones( ::nView ) )->cCodObr )

      if !Empty( oGet2 )
         oGet2:cText( ( D():ClientesDirecciones( ::nView ) )->cNomObr )
      end if

      lValid      := .t.

   else

      ApoloMsgStop( "Dirección no encontrada" )
      
      if !Empty( oGet )
         oGet:SetFocus()
      end if

      if !Empty( oGet2 )
         oGet2:cText( Space( 50 ) )
      end if

   end if

   ( D():ClientesDirecciones( ::nView ) )->( OrdSetFocus( nOrdAnt ) )

Return lValid

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

METHOD AppendGuardaLinea() CLASS DocumentsSales

   ::oDocumentLines:appendLineDetail( ::oDocumentLineTemporal )

   if !Empty( ::oViewEdit:oBrowse )
      ::oViewEdit:oBrowse:Refresh()
   end if

Return ( self )

//---------------------------------------------------------------------------//

METHOD EditGuardaLinea() CLASS DocumentsSales

   ::oDocumentLines:GuardaLineDetail( ::nPosDetail, ::oDocumentLineTemporal )

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

   ::oViewEditResumen:SetTextoTipoDocumento( ::cTextSummaryDocument )

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

METHOD printDocument() CLASS DocumentsSales

   visualizaPedidoCliente( ::getID(), ::cFormatToPrint )

Return ( .t. )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//