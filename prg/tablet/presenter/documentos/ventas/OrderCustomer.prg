#include "FiveWin.Ch"
#include "Factu.ch"

CLASS OrderCustomer FROM DocumentsSales  

   DATA oLinesOrderCustomer

   DATA cTextSummaryDocument             INIT "Resumen pedido"

   METHOD New()

   METHOD setEnviroment()              INLINE ( ::setDataTable( "PedCliT" ),;
                                                ::setDataTableLine( "PedCliL" ),;
                                                ( ::getWorkArea() )->( OrdSetFocus( "dFecDes" ) ), ( ::getWorkArea() )->( dbgotop() ) )

   METHOD Resource( nMode )

   METHOD ResourceDetail( nMode )      INLINE ( ::oLinesOrderCustomer:ResourceDetail( nMode ) )

   METHOD GetAppendDocumento()
   METHOD GetEditDocumento()
   METHOD GetAppendDetail()
   METHOD GetEditDetail()

   METHOD getLinesDocument()
   METHOD getDocumentLine()

   METHOD addDocumentLine()

   METHOD getLines()                      INLINE ( ::oDocumentLines:getLines() )
   METHOD getLineDetail()                 INLINE ( ::oDocumentLines:getLineDetail( ::nPosDetail ) )

   METHOD SetDocuments()
  
   METHOD deleteLinesDocument() 
   METHOD onPreSaveAppendDocumento()

END CLASS

//---------------------------------------------------------------------------//

METHOD New() CLASS OrderCustomer

   ::super:New( self )
   
   ::oViewSearchNavigator:setTextoTipoDocumento( "Pedidos de clientes" )

   ::oLinesOrderCustomer   := LinesOrderCustomer():New( self )

return ( self )

//---------------------------------------------------------------------------//

METHOD Resource( nMode ) CLASS OrderCustomer

   local lResource   := .f.

   if !Empty( ::oViewEdit )

      ::oViewEdit:SetTextoTipoDocumento( LblTitle( nMode ) + "pedido" )
      
      lResource      := ::oViewEdit:Resource( nMode )

   end if

Return ( lResource )   

//---------------------------------------------------------------------------//

METHOD GetAppendDocumento() CLASS OrderCustomer

   ::hDictionaryMaster      := D():GetPedidoClienteDefaultValue( ::nView )

Return ( self )

//---------------------------------------------------------------------------//

METHOD GetEditDocumento() CLASS OrderCustomer

   local id                := D():PedidosClientesId( ::nView )

   ::hDictionaryMaster     := D():GetPedidoCliente( ::nView )

   ::getLinesDocument( id )

RETURN ( self ) 

//---------------------------------------------------------------------------//
//
// Convierte las lineas del pedido en objetos
//

METHOD getLinesDocument( id ) CLASS OrderCustomer

   ::oDocumentLines:reset()

   D():getStatusPedidosClientesLineas( ::nView )

   ( D():PedidosClientesLineas( ::nView ) )->( ordSetFocus( 1 ) )

   if ( D():PedidosClientesLineas( ::nView ) )->( dbSeek( id ) )  

      while ( D():PedidosClientesLineasId( ::nView ) == id ) .and. !( D():PedidosClientesLineas( ::nView ) )->( eof() ) 

         ::addDocumentLine()
      
         ( D():PedidosClientesLineas( ::nView ) )->( dbSkip() ) 
      
      end while

   end if 
   
   D():setStatusPedidosClientesLineas( ::nView ) 

RETURN ( self ) 

//---------------------------------------------------------------------------//

METHOD addDocumentLine() CLASS OrderCustomer

   local oDocumentLine  := ::getDocumentLine()

   if !empty( oDocumentLine )
      ::oDocumentLines:addLines( oDocumentLine )
   end if

Return ( self )

//---------------------------------------------------------------------------//

METHOD getDocumentLine() CLASS OrderCustomer

   local hLine    := D():GetPedidoClienteLineasHash( ::nView )

   if empty( hLine )
      Return ( nil )
   end if 

Return ( DocumentLine():New( hLine, self ) )

//---------------------------------------------------------------------------//

METHOD getAppendDetail() CLASS OrderCustomer

   local hLine             := D():GetPedidoClienteLineaBlank( ::nView )
   ::oDocumentLineTemporal := DocumentLine():New( hLine, self )

Return ( self )

//---------------------------------------------------------------------------//

METHOD GetEditDetail() CLASS OrderCustomer

   if !Empty( ::nPosDetail )
      ::oDocumentLineTemporal   := ::oDocumentLines:getCloneLineDetail( ::nPosDetail )
   end if

Return ( self )

//---------------------------------------------------------------------------//

METHOD SetDocuments() CLASS OrderCustomer

   local cDocumento     := ""
   local cFormato
   local nFormato
   local aFormatos      := aDocs( "PC", D():Documentos( ::nView ), .t. )

   cFormato             := cFormatoDocumento( ::getSerie(), "nPedCli", D():Contadores( ::nView ) )

   if Empty( cFormato )
      cFormato          := cFirstDoc( "PC", D():Documentos( ::nView ) )
   end if

   nFormato             := aScan( aFormatos, {|x| Left( x, 3 ) == cFormato } )
   nFormato             := Max( Min( nFormato, len( aFormatos ) ), 1 )

   ::oViewEditResumen:SetImpresoras( aFormatos )
   ::oViewEditResumen:SetImpresoraDefecto( aFormatos[ nFormato ] )

return ( .t. )

//---------------------------------------------------------------------------//

METHOD deleteLinesDocument() CLASS OrderCustomer

   D():getStatusPedidosClientesLineas( ::nView )

   ( D():PedidosClientesLineas( ::nView ) )->( ordSetFocus( 1 ) )

   while ( D():PedidosClientesLineas( ::nView ) )->( dbSeek( ::getID() ) ) 
      ::delDocumentLine()
   end while

   D():setStatusPedidosClientesLineas( ::nView ) 

Return ( Self )

//---------------------------------------------------------------------------//

METHOD onPreSaveAppendDocumento() CLASS OrderCustomer

   local lPreSaveDocument  := .f.
   local NumeroDocumento   := nNewDoc( ::getSerie(), D():PedidosClientes( ::nView ), "nPedCli", , D():Contadores( ::nView ) )
   local nTotPed           := ::oTotalDocument:getTotalDocument()
   local nTotIVA           := ::oTotalDocument:getImporteIva()
   local nTotReq           := ::oTotalDocument:getImporteRecargo()
   local nTotNeto          := ::oTotalDocument:getBase()

   if !empty( NumeroDocumento )
      hSet( ::hDictionaryMaster, "Numero", NumeroDocumento )
      lPreSaveDocument     := .t.
   end if 

   if !empty( nTotPed )
      hSet( ::hDictionaryMaster, "TotalDocumento", nTotPed )
      lPreSaveDocument        := .t.
   end if

   if !empty( nTotIVA )
      hSet( ::hDictionaryMaster, "TotalImpuesto", nTotIVA )
      lPreSaveDocument     := .t.
   end if

   if !empty( nTotReq )
      hSet( ::hDictionaryMaster, "TotalRecargo", nTotReq )
      lPreSaveDocument     := .t.
   end if

   if !empty( nTotNeto )
      hSet( ::hDictionaryMaster, "TotalNeto", nTotNeto )
      lPreSaveDocument     := .t.
   end if

Return ( lPreSaveDocument )

//---------------------------------------------------------------------------//

