#include "FiveWin.Ch"
#include "Factu.ch"

CLASS OrderCustomer FROM DocumentsSales  

   DATA oViewEdit

   DATA oCliente

   DATA oDocumentLines

   DATA oIva

   DATA cTextoResumenVenta             INIT "Resumen pedido"

   METHOD New()

   METHOD setEnviroment()              INLINE ( ::setDataTable( "PedCliT" ), ( ::getWorkArea() )->( OrdSetFocus( "dFecDes" ) ) )

   METHOD setNavigator()

   METHOD Resource( nMode )

   METHOD ResourceDetail( nMode )

   METHOD GetAppendDocumento()

   METHOD GetEditDocumento()

   METHOD GetAppendDetail()
   
   METHOD GetEditDetail()

   METHOD StartResourceDetail()

   METHOD onClickRotor()                  INLINE ( ::oCliente:edit() )

   METHOD getLinesDocument()

   METHOD getDocumentLine()

   METHOD addDocumentLine()

   METHOD getLines()                      INLINE ( ::oDocumentLines:getLines() )

   METHOD getLineDetail()                 INLINE ( ::oDocumentLines:getLineDetail( ::nPosDetail ) )

   METHOD CalculaIva()

   METHOD SetDocuments()

END CLASS

//---------------------------------------------------------------------------//

METHOD New() CLASS OrderCustomer

   if !::OpenFiles()
      Return ( self )
   end if 

   ::oViewSearchNavigator  := OrderCustomerViewSearchNavigator():New( self )

   ::oViewEdit             := OrderCustomerViewEdit():New( self )

   ::oCliente              := Customer():Init( self )  

   ::oDocumentLines        := DocumentLines():New( self ) 

   ::oIva                  := Iva():new( self )

   ::setEnviroment()

   ::setNavigator()

   ::CloseFiles()

return ( self )

//---------------------------------------------------------------------------//

METHOD setNavigator() CLASS OrderCustomer

   if !Empty( ::oViewSearchNavigator )
      ::oViewSearchNavigator:Resource()
   end if

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

METHOD ResourceDetail( nMode ) CLASS OrderCustomer

   local lResult     := .f.

   ::nMode           := nMode

   ::oViewEditDetail := ViewDetail():New( self )

   if !Empty( ::oViewEditDetail )

      ::oViewEditDetail:SetTextoTipoDocumento( LblTitle( nMode ) + "linea de pedido" )

      lResult        := ::oViewEditDetail:Resource( nMode )

   end if

Return ( lResult )   

//---------------------------------------------------------------------------//

METHOD StartResourceDetail() CLASS OrderCustomer

   ::CargaArticulo()

   ::recalcularTotal()

Return ( self )

//---------------------------------------------------------------------------//

METHOD GetAppendDocumento() CLASS OrderCustomer

   ::hDictionaryMaster      := D():GetPedidoClienteDefaultValue( ::nView )
   ::hDictionaryDetail      := {}

Return ( self )

//---------------------------------------------------------------------------//

METHOD GetEditDocumento() CLASS OrderCustomer

   local id                := D():PedidosClientesId( ::nView )

   ::hDictionaryMaster     := D():GetPedidoClienteById( id, ::nView )

   ::getLinesDocument( id )

RETURN ( self ) 

//---------------------------------------------------------------------------//

METHOD getLinesDocument( id )

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

METHOD addDocumentLine() 

   local oDocumentLine  := ::getDocumentLine()

   if !empty( oDocumentLine )
      ::oDocumentLines:addLines( oDocumentLine )
   end if

Return ( self )

//---------------------------------------------------------------------------//

METHOD getDocumentLine()

   local hLine    := D():GetPedidoClienteLineasHash( ::nView )

   if empty( hLine )
      Return ( nil )
   end if 

Return ( DocumentLine():New( hLine, self ) )

//---------------------------------------------------------------------------//

METHOD getAppendDetail() 

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

METHOD CalculaIva() CLASS OrderCustomer

   Local oDocumentLine

   ::oIva:Reset()

   for each oDocumentLine in ::oDocumentLines:aLines
      ::oIva:add( oDocumentLine )
   next

Return ( Self )

//---------------------------------------------------------------------------//

METHOD SetDocuments() CLASS OrderCustomer

   local cSerie         := hGet( ::hDictionaryMaster, "Serie" )
   local cDocumento     := ""
   local cFormato
   local nFormato
   local aFormatos      := aDocs( "PC", D():Documentos( ::nView ), .t. )

   cFormato             := cFormatoDocumento( cSerie, "nPedCli", D():Contadores( ::nView ) )

   if Empty( cFormato )
      cFormato          := cFirstDoc( "PC", D():Documentos( ::nView ) )
   end if

   nFormato             := aScan( aFormatos, {|x| Left( x, 3 ) == cFormato } )
   nFormato             := Max( Min( nFormato, len( aFormatos ) ), 1 )

   ::oViewEditResumen:SetImpresoras( aFormatos )
   ::oViewEditResumen:SetImpresoraDefecto( aFormatos[ nFormato ] )

return ( .t. )